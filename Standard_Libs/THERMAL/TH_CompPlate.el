--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompPlate.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a metallic plate for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Jose Moral Moral
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 


-- Components
--------------------------------------------------------------------------------
-- Component Plate
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a plate component, divided into a number of longitudinal and
--    transversal slabs (nodes). Heat flow is considered at each end of the
--    plate (positive for increasing value of node index), and assuming
--    the other sides are isolated.
--------------------------------------------------------------------------------
COMPONENT Plate
	(
		INTEGER nx = 2			UNITS no_units		"OX - Number of nodes for plate",
		INTEGER ny = 3			UNITS no_units		"OY - Number of nodes for plate"
   )
	"2D thermal model of a rectangular plate"

	PORTS
		IN  thermal (n = ny) tpx_in	"OX - Thermal inlet port"
		OUT thermal (n = ny) tpx_out	"OX - Thermal outlet port"

		IN  thermal (n = nx) tpy_in	"OY - Thermal inlet port"
		OUT thermal (n = nx) tpy_out	"OY - Thermal outlet port"

	DATA
		--Geometry	
		REAL L = 1.							UNITS u_m	"OX - Plate length"
		REAL W = 1.							UNITS u_m	"OY - Plate width"
		REAL e = 0.003						UNITS u_m	"OZ - Plate thickness"
		--Material properties
		ENUM Material mat = None		UNITS no_units		"Material"
		REAL rho = 1000.					UNITS u_kg_m3		"Plate density if material is None"
		REAL cp = 500.						UNITS u_J_kgK		"Plate specific heat if material is None"
		REAL k = 0.1						UNITS u_W_mK		"Plate conductivity if material is None"
		BOOLEAN TemperatureDependance = TRUE	"Option to consider or not the temperature depence on the material properties"
		--Initial Temperature Distribution
		ENUM WALL_INIT_MODE init_mode = Constant_Temp 	"Option for the initiliazation of the nodal temperatures"
		REAL To = 290.						UNITS u_K			"Initial temperature of nodes"
		REAL To_linear[2] = {290., 290.}			UNITS u_K		"Initial temperatures at both side if init_mode = Linear_Temp "
		TABLE_1D To_table = { {  0.,   1.},  
									{290., 290.}}	"Table with initial wall temperature versus \
														non-dimensional position if init_mode = Table_Temp (K)"

	DECLS
		REAL rho_var						UNITS u_kg_m3		"Density of plate material"
		REAL dx								UNITS u_m			"OX - Node width or nodal distance"
		REAL dy								UNITS u_m			"OY - Node width or nodal distance"
      REAL cp_var[nx,ny]				UNITS u_J_kgK		"Specific heat of nodes"
		REAL cp_tpx[2,ny]					UNITS u_J_kgK		"OX - Nodal specific heat of first-last section skin"
		REAL cp_tpy[nx,2]					UNITS u_J_kgK		"OY - Nodal specific heat of first-last section skin"
      REAL k_var[nx,ny]					UNITS u_W_mK		"Thermal conductivities of nodes"
		
		REAL C_x[nx+1,ny]					UNITS u_W_K			"OX - Equivalent conductance between the thermal nodes"
		REAL C_y[nx,ny+1]					UNITS u_W_K			"OY - Equivalent conductance between the thermal nodes"
				
		REAL T[nx,ny]						UNITS u_K			"Nodal temperature"
		INTEGER icpk[nx,ny]										"Last pointer to speed up nodal interpolations"
      
		REAL qx[nx+1,ny]					UNITS u_W			"OX - Heat flow between nodes"
		REAL qy[nx,ny+1]					UNITS u_W			"OY - Heat flow between nodes" 


		INTEGER icpk_tpx[2,ny]			"OX - Pointer to last interpolation interval for each port node"
		INTEGER icpk_tpy[nx,2]			"OY - Pointer to last interpolation interval for each port node"
      
		INTEGER it0							"Pointer to To"
		CONST REAL F = 0.0001			UNITS no_units		"Thermal capacity ratio assigned to the surface"

		REAL V								UNITS u_m3			"Node volume"
		REAL Ax								UNITS u_m2			"OX - Cross Area"
		REAL Ay								UNITS u_m2			"OY - Cross Area"

	INIT

		--Initialization of nodal temperatures depending on the option
   
		IF (init_mode == Constant_Temp) THEN
			FOR (j IN 1, ny)
				tpx_in.Tk[j] = To
				tpx_out.Tk[j] = To
				FOR (i IN 1, nx)
					T[i,j] = To
				END FOR 
			END FOR
			FOR (i IN 1, nx)
				tpy_in.Tk[i] = To
				tpy_out.Tk[i] = To
			END FOR    
		ELSEIF (init_mode == Linear_Temp) THEN
			FOR (j IN 1, ny)
				tpx_in.Tk[j] = To_linear[1]
				tpx_out.Tk[j] = To_linear[2]
				FOR (i IN 1, nx)
					T[i,j] = To_linear[1] + ((i-0.5)/nx)*(To_linear[2] - To_linear[1])
				END FOR
			END FOR 
			FOR (i IN 1, nx)
				tpy_in.Tk[i] = To_linear[1] + ((i-0.5)/nx)*(To_linear[2] - To_linear[1])
				tpy_out.Tk[i] = To_linear[1] + ((i-0.5)/nx)*(To_linear[2] - To_linear[1])
			END FOR    
		ELSEIF (init_mode == Table_Temp) THEN   
			FOR (j IN 1, ny)
				tpx_in.Tk[j]  = linearInterp1D(To_table, 0.)
				tpx_out.Tk[j] = linearInterp1D(To_table, 1.) 
				FOR (i IN 1, nx) 
					T[i,j] =linearInterp1D(To_table, (i-0.5)/nx)
				END FOR
			END FOR
			FOR (i IN 1, nx)
				tpy_in.Tk[i] = linearInterp1D(To_table, (i-0.5)/nx)
				tpy_out.Tk[i] = linearInterp1D(To_table, (i-0.5)/nx)
			END FOR
		END IF

	CONTINUOUS
		rho_var = FunConstSolidProp(mat, Density, rho)

		-- Plate geometry
		dx = L / nx
		dy = W / ny

		Ax = e * dy
		Ay = e * dx
		
		V = dx * dy * e

		EXPAND_BLOCK (i IN 1,nx)
			EXPAND_BLOCK (j IN 1,ny)
				k_var[i,j]  =	ZONE (TemperatureDependance) FunVarSolidProp(mat, Conductivity, T[i,j], k, icpk[i,j])
									OTHERS                       FunVarSolidProp(mat, Conductivity, To, k, icpk[i,j])
                          
				cp_var[i,j] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, T[i,j], cp, icpk[i,j])
									OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, icpk[i,j])
			END EXPAND_BLOCK
		END EXPAND_BLOCK		

		-- Skin volumes --> Radial sides, affected by F
		EXPAND_BLOCK(j IN 1,ny)
			cp_tpx[1,j] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, tpx_in.Tk[j], cp, icpk_tpx[1,j])
								OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, it0)
			cp_tpx[2,j] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, tpx_out.Tk[j], cp, icpk_tpx[2,j])
								OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, it0) 
		END EXPAND_BLOCK
		-- Skin volumes --> Axial sides, affected by F
		EXPAND_BLOCK(i IN 1,nx)
			cp_tpy[i,1] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, tpy_in.Tk[i], cp, icpk_tpy[i,1])
								OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, it0)
			cp_tpy[i,2] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, tpy_out.Tk[i], cp, icpk_tpy[i,2])
								OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, it0)         
		END EXPAND_BLOCK 


		
		---------------------------------------------------------------------------------------- 
		--Compute Equivalent Conductances -------------------------------------------------------       
		-- OY -------------------------------------------------------------------------------
		EXPAND_BLOCK (i IN 1, nx)
			--first section
			C_y[i,1] = (2*k_var[i,1]/dy)*Ay --Equivalent Conductance for F-->0 
			--core
			EXPAND (j IN 2, ny)
				C_y[i,j] =(k_var[i,j-1]*k_var[i,j])/(k_var[i,j]*0.5*dy + k_var[i,j-1]*0.5*dy)* Ay
			--last section
			C_y[i,ny+1] = (2*k_var[i,ny]/dy)*Ay --here it's used formula for F-->0 
		END EXPAND_BLOCK

		-- OY -------------------------------------------------------------------------------
		EXPAND_BLOCK (j IN 1, ny)
			--first section
			C_x[1,j] = (2*k_var[1,j]/dx)*Ax --Equivalent Conductance for F-->0 
			--core
			EXPAND (i IN 2, nx)
				C_x[i,j] =(k_var[i-1,j]*k_var[i,j])/(k_var[i,j]*0.5*dx + k_var[i-1,j]*0.5*dx)* Ax
			--last section
			C_x[nx+1,j] = (2*k_var[nx,j]/dx)* Ax --here it's used formula for F-->0 
		END EXPAND_BLOCK

		---------------------------------------------------------------------------------------------
		--Compute Internal Heat Flows ---------------------------------------------------------------     
		--OY -------------------------------------------------------------------------------------  
		EXPAND_BLOCK (i IN 1, nx)
			qy[i,1] = C_y[i,1] * (tpy_in.Tk[i] - T[i,1])
			qy[i,ny+1] = C_y[i,ny+1] * (T[i,ny] - tpy_out.Tk[i]) 
			EXPAND (j IN 2, ny)
				qy[i,j] = C_y[i,j] * (T[i, j-1] - T[i, j])
		END EXPAND_BLOCK

		--OX -------------------------------------------------------------------------------------  
		EXPAND_BLOCK (j IN 1, ny)
			qx[1,j] = C_x[1,j] * (tpx_in.Tk[j] - T[1,j])
			qx[nx+1,j] = C_x[nx+1,j] * (T[nx,j] - tpx_out.Tk[j])
			EXPAND (i IN 2, nx)
				qx[i,j] = C_x[i,j] * (T[i-1, j] - T[i, j])
		END EXPAND_BLOCK


		EXPAND_BLOCK (i IN 1,nx)
			EXPAND_BLOCK (j IN 1,ny)
				rho_var * cp_var[i,j] * V *(1-F/(nx*ny)) * T[i,j]' = (qx[i,j] - qx[i+1,j]) + (qy[i,j] - qy[i,j+1])
			END EXPAND_BLOCK
		END EXPAND_BLOCK

		-- Boundary conditions for OX thermal flow
		EXPAND_BLOCK (j IN 1,ny)
			rho_var * cp_tpx[1,j] * V * (F/(2*(nx+ny))) * tpx_in.Tk[j]' = \
					tpx_in.q[j] - qx[1,j]
			rho_var * cp_tpx[2,j] * V * (F/(2*(nx+ny))) * tpx_out.Tk[j]'= \
					qx[nx+1,j] - tpx_out.q[j]
      END EXPAND_BLOCK

		-- Boundary conditions for OY thermal flow
		EXPAND_BLOCK (i IN 1,nx)
			rho_var * cp_tpy[i,1] * V * (F/(2*(nx+ny))) * tpy_in.Tk[i]' = \
					tpy_in.q[i] - qy[i,1]
			rho_var * cp_tpy[i,2] * V * (F/(2*(nx+ny))) * tpy_out.Tk[i]'= \
					qy[i,ny+1] - tpy_out.q[i] 
      END EXPAND_BLOCK


END COMPONENT

