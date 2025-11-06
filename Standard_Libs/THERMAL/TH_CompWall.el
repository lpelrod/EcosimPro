--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompWall.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a wall component with a number of thermal nodes
--							that can be parameterised for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE PORTS_LIB 
USE MATH 


-- Components
--------------------------------------------------------------------------------
-- Component Wall
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a unidimensional wall component, divided in a number of
--    slabs (nodes).
--------------------------------------------------------------------------------
ENUM WALL_INIT_MODE = {Constant_Temp, Linear_Temp, Table_Temp}

----------------------------------------------------------------------------------------------
FUNCTION REAL Ty_integ
	(
		IN REAL T1, 
		IN REAL T2, 
		IN REAL y1, 
		IN REAL y2
	)
	--Function to calculate the integral of y * T(y) between y1 and y2
	--assuming T(y) has a linear behavior between (y1,T1) and y2, T2
	-- T(y) = ((T2-T1)/(y2-y1))*(y-y1) + T1
	-- y*T(y) = ((T2-T1)/(y2-y1))*y**2 + (T1- ((T2-T1)/(y2-y1))*y1)*y
	-- y*T(y) = alpha*y**2 + (T1-alpha*y1)*y
	-- Integral (y*T(y)) = alpha*y**3/2 + (T1- alpha*y1)*y**2/2
	--
	DECLS
		REAL alpha
		REAL integ 
	BODY

		alpha = (T2-T1)/(y2-y1)
		integ = T1*(y2**2-y1**2)/2. + alpha*(y2**3/3. - y2**2*y1/2. + y1**3/6.)
		RETURN integ
END FUNCTION


FUNCTION NO_TYPE fun_Wall_Thermal_Gradients
	(
		IN INTEGER nodes		"Number of nodes",
		IN REAL T[nodes]		UNITS u_K		"Nodal temperatures",
		IN REAL e				UNITS u_m		"Wall thickness", 
		OUT REAL T_ave			UNITS u_K		"Average temperature",
--		OUT REAL T_ave_1 ,
		OUT REAL DT1			UNITS u_K		"Linear thermal gradient",
		OUT REAL DT2			UNITS u_K		"Linear thermal gradient"  
	)

	BODY  
		T_ave = 0.25*T[1] + 0.25*T[2]  + 0.25*T[nodes+1] + 0.25*T[nodes+2]
         
		FOR (i IN 2, nodes)
			T_ave = T_ave + 0.5*(T[i]+T[i+1])
		END FOR
         
		T_ave = T_ave/nodes
               
		DT1 = Ty_integ(T[1], T[2], -0.5*nodes, -0.5*nodes+0.5) + Ty_integ(T[nodes+1], T[nodes+2], 0.5*nodes-0.5, 0.5*nodes)
         
		FOR (i IN 2, nodes)
			DT1 = DT1 + Ty_integ(T[i], T[i+1], (-0.5*nodes+i-1.5), (-0.5*nodes+i-0.5))
		END FOR
         
		DT1 = 12 * DT1 / nodes**2 
        
		DT2 =  max(max(abs(T[nodes+2] - T_ave) - 0.5 * abs(DT1), abs(T[1] - T_ave) - 0.5 * abs(DT1)), 0)
         
		RETURN
END FUNCTION 

COMPONENT Wall
	(
		INTEGER n = 1					UNITS no_units		"Dimension of thermal port",
		INTEGER nodes =  10			UNITS no_units		"Number of nodes of wall discretization"
	)
	"1D thermal model of a wall"

	PORTS
		IN  thermal (n = n) tp_in		"Inlet port"
		OUT thermal (n = n) tp_out		"Outlet port"

	DATA
		--Material Properties
		ENUM Material mat = None		UNITS no_units		"Material"
		REAL rho = 1000.					UNITS u_kg_m3		"Wall density if material is None"
		REAL cp = 500.						UNITS u_J_kgK		"Wall Specific heat if material is None"
		REAL k = 0.1						UNITS u_W_mK		"Wall conductivity if material is None"
		BOOLEAN TemperatureDependance = TRUE "Flag to consider temperature dependance of the material properties" 
		--Geometry
		REAL A = 1.							UNITS u_m2		"Area of the wall"
		REAL e = 0.1						UNITS u_m		"Wall thickness"
		--Initial Temperature
		ENUM WALL_INIT_MODE init_mode  = Constant_Temp 	"Option for the initiliazation of the nodal temperatures"
		REAL To = 290.								UNITS u_K		"Constant initial temperature of nodes if init_mode = Constant_Temp"
		REAL To_linear[2] = {290., 290.}		UNITS u_K		"Initial temperatures at both side if init_mode = Linear_Temp"
		TABLE_1D To_table     = { {  0.,   1.},  
		  						   	    {290., 290.}} \
		  						   	    		"Table with initial wall temperature versus \
		  						   	         non-dimensional position if init_mode = Table_Temp (K)"

	DECLS
		REAL Asme_DT1				UNITS u_K		"Linear gradient temperature"
		REAL Asme_DT2				UNITS u_K		"Non linear gradient temperature"
		REAL Asme_T_ave			UNITS u_K		"Average temperature"
		REAL dx						UNITS u_m		"Node width or nodal distance"
		REAL rho_var				UNITS u_kg_m3	"Density of wall material"
        --
		REAL cp_var[nodes+2]		UNITS u_J_kgK		"Specific heat of nodes"
		REAL k_var[nodes+2]		UNITS u_W_mK		"Thermal conductivities of the nodes"
		REAL k_eq[nodes+1]		UNITS u_W_mK		"Equivalent Thermal Condictivities between nodes"
		REAL T[nodes+2]			UNITS u_K			"Nodal temperature"
		REAL q[nodes+1]			UNITS u_W			"Heat flow through nodes"
		INTEGER icpk[nodes+2]							"Last table position in cp calculation"
		INTEGER ito											"Pointer to time interval for To in Property Tables"		
		CONST REAL F = 0.0001	UNITS no_units		"Thermal capacity ratio assigned to the surface"
--		REAL T_ave					UNITS u_K			"Average temperature"
	INIT
		ASSERT ((n > 0) AND (nodes > 0)) FATAL "Wall component: Number of nodes must be at least 1"
		-- Wall geometry
		dx = e / nodes
        
		--Initialization of nodal temperatures depending on the option
		FOR (i IN 1,nodes+2)
			IF (init_mode == Constant_Temp) THEN
				T[i] = To
			ELSEIF (init_mode == Linear_Temp) THEN
				T[i] = To_linear[1] + ((i-1)/(nodes+1))*(To_linear[2] - To_linear[1])    
			ELSEIF (init_mode == Table_Temp) THEN   
				T[i] =linearInterp1D(To_table,((i-1)*1.0)/((nodes+1)*1.0))
			END IF
		END FOR   		      	  
		      	  
	CONTINUOUS 
    
		-- To_mean = SUM(i IN 1, nodes+2; T[i])/(nodes+2)
		-- Material properties
		rho_var = FunConstSolidProp(mat, Density, rho)

		-- Wall geometry
		dx = e / nodes

		--Thermal conductivities
		EXPAND_BLOCK (i IN 1,nodes+2) 
			k_var[i] =	ZONE (TemperatureDependance)	FunVarSolidProp(mat, Conductivity, T[i], k, icpk[i])
							OTHERS								FunVarSolidProp(mat, Conductivity, To, k, ito)
		END EXPAND_BLOCK 
        
		--Equivalent Thermal Conductivities 
		k_eq[1] = k_var[2]

		EXPAND_BLOCK (i IN 2,nodes) 
			k_eq[i] = 2 * (k_var[i]*k_var[i+1]) /(k_var[i] + k_var[i+1])
		END EXPAND_BLOCK 

		k_eq[nodes+1] = k_var[nodes+1]

		-- Heat flow across the wall
		q[1] = k_eq[1] * A * (T[1] - T[2]) / (dx/2)

		EXPAND (i IN 2,nodes) 
			q[i] = k_eq[i] * A * (T[i] - T[i+1]) / dx

		q[nodes+1] = k_eq[nodes+1] * A * (T[nodes+1] - T[nodes+2]) / (dx/2)

		-- Heat storage of nodes
        
		EXPAND(i IN 1,nodes+2) 
			cp_var[i] =	ZONE (TemperatureDependance)	FunVarSolidProp(mat, SpecificHeat, T[i], cp, icpk[i])
							OTHERS								FunVarSolidProp(mat, SpecificHeat, To, cp, ito)

		EXPAND(i IN 2,nodes+1) 
			rho_var * cp_var[i] * A * dx * (1-F/nodes) * T[i]' = q[i-1] - q[i]
        
		--Temperature of surface in tp_in side
		rho_var * cp_var[1] * A * dx * (F/2) * T[1]' = SUM (i IN 1, n; tp_in.q[i]) - q[1]

		--Temperature of surface in tp_out side        
		rho_var * cp_var[nodes+2] * A * dx * (F/2) * T[nodes+2]' = q[nodes+1] - SUM (i IN 1, n; tp_out.q[i])

		-- Boundary conditions at wall surfaces
		EXPAND_BLOCK (i IN 1, n)
			tp_in.Tk[i] = T[1]
			tp_out.Tk[i] = T[nodes+2]
		END EXPAND_BLOCK

		--
		fun_Wall_Thermal_Gradients(nodes, T, e, Asme_T_ave, Asme_DT1, Asme_DT2)
END COMPONENT

