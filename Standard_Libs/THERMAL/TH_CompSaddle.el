--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompSaddle.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a complete saddle component used to fasten heat
--							pipes to a surface for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara & Borja Garcia Gutierrez
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 


-- Components
COMPONENT Saddle
	(
		INTEGER n = 5			UNITS no_units			"Number of nodes"
	)
	"Thermal model of a saddle component used to fasten heat pipes to a surface "

	PORTS
		IN  thermal (n = n) tp_in		"Saddle array of thermal inlet ports"
		OUT thermal (n = n) tp_out		"Saddle array of thermal outlet ports"

   DATA
      --Material Properties
		ENUM Material mat = None		UNITS no_units		"Material used for saddle"
		REAL rho = 1000.					UNITS u_kg_m3		"Saddle density if material is None"
		REAL cp = 500.						UNITS u_J_kgK		"Saddle specific heat if material is None"
		REAL k = 0.1						UNITS u_W_mK		"Saddle conductivity if material is None"
		BOOLEAN TemperatureDependance = TRUE	\
												"Option to consider or not the temperature depence on the material properties"
		--Conductance
		REAL G = 50.						UNITS u_W_mK			"Conductance of saddle per unit length"
      --Geometry
		REAL l = 1.							UNITS u_m			"Length of saddle"
		REAL A = 1.e-3						UNITS u_m2			"Cross sectional area of saddle"
		--Initial Temperature
		REAL To = 290.						UNITS u_K			"Initial temperature of nodes"
		
	DECLS 
		REAL rho_var						UNITS u_kg_m3		"Density of saddle material"
		REAL dx								UNITS u_m			"Node length"
		REAL q[n+1]							UNITS u_W			"Axial heat flow through nodes"
		REAL cp_var[n]						UNITS u_J_kgK		"Specific heat of nodes"
		REAL k_var[n]						UNITS u_W_mK		"Thermal conductivities of nodes"
		REAL T[n]							UNITS u_K			"Temperature of nodes"
		INTEGER icpk[n]					"Last pointer to speed up nodal interpolations"
		INTEGER it0							"Pointer to To"		

	INIT
		ASSERT (n > 0) FATAL "Saddle component: Number of nodes must be at least 1"
		FOR (i IN 1,n)
			T[i] = To
		END FOR
	CONTINUOUS
		-- Properties of saddle material
		rho_var = FunConstSolidProp(mat, Density, rho)

		-- Node length calculation
		dx = l / n

		-- Axial heat flow
		q[1] = 0.

		EXPAND (i IN 2, n)
			q[i] = 2 * (k_var[i-1]*k_var[i]) /(k_var[i-1] + k_var[i]) * A * (T[i-1] - T[i]) / dx

		q[n+1] = 0.

		EXPAND_BLOCK (i IN 1, n)
			cp_var[i] = ZONE (TemperatureDependance)	FunVarSolidProp(mat, SpecificHeat, T[i], cp, icpk[i])
							OTHERS								FunVarSolidProp(mat, SpecificHeat, To, cp, it0)
                       
			k_var[i] = 	ZONE (TemperatureDependance)	FunVarSolidProp(mat, Conductivity, T[i], k, icpk[i])
							OTHERS								FunVarSolidProp(mat, Conductivity, To, k, it0)
                      
			-- Radially heat flow due to saddle-tube contact
			tp_in.q[i] = 2 * G * dx * (tp_in.Tk[i] - T[i])
			tp_out.q[i] = 2 * G * dx * (T[i] - tp_out.Tk[i])

			-- Energy equation at each node due to all heat flows
			rho_var * cp_var[i] * A * dx * T[i]' = (q[i] - q[i+1]) + (tp_in.q[i] - tp_out.q[i])

		END EXPAND_BLOCK

END COMPONENT

