--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompRadiator.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a radiator component for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara & Borja Garcia Gutierrez
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 



--Components
--------------------------------------------------------------------------------
-- Component Radiator
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a radiator component.
--------------------------------------------------------------------------------
COMPONENT Radiator
	(
		INTEGER nx = 5 			UNITS no_units		"Number of nodes in cross direction", 
		INTEGER ny = 5				UNITS no_units		"Number of nodes in tube direction"
	)
	"2D thermal model of a radiator"

	PORTS
		IN  thermal (n = ny) tp_in		"Radiator array of thermal inlets ports"

		OUT thermal (n = 1)  tp_1		"Thermal port to sink 1"
		OUT thermal (n = 1)  tp_2		"Thermal port to sink 2"

	DATA
		ENUM Material mat = None		UNITS no_units		"Material used for radiator"

		REAL rho = 1000.					UNITS u_kg_m3		"Radiator density if material is None"
		REAL cp = 500.						UNITS u_J_kgK		"Radiator specific heat if material is None"
      REAL k = 0.1						UNITS u_W_mK		"Radiator conductivity if material is None"
      BOOLEAN TemperatureDependance = TRUE

      INTEGER n_fin = 1 	UNITS no_units		RANGE 1, 2	"Number of fins"

		REAL Lx = 0.2						UNITS u_m		"Length of the fin"
		REAL Ly = 5.						UNITS u_m		"Width of the fin"
		REAL e = 0.012						UNITS u_m		"Thickness of the fin"

		REAL emiss1 = 0.85				UNITS no_units		"Emissivity of side 1 of the fin"
		REAL alpha1 = 0.25				UNITS no_units		"Solar absorptance of side 1 of the fin"
      REAL F1 = 0.9						UNITS no_units		"Average view factor of sink node 1 from side 1"
      REAL beta1 = 0.					UNITS u_deg			"Incidence angle of the sun in side 1"

		REAL emiss2 = 0.85				UNITS no_units		"Emissivity of side 2 of the fin"
		REAL alpha2 = 0.25				UNITS no_units		"Solar absorptance of side 2 of the fin"
		REAL F2 = 0.						UNITS no_units		"Average view factor of sink node 2 from side 2"
		REAL beta2 = 0.					UNITS u_deg			"Incidence angle of the sun in side 2"

		REAL To = 290.						UNITS u_K			"Initial temperature"

	DECLS
		REAL rho_var						UNITS u_kg_m3		"Density of radiator material"
		REAL A								UNITS u_m2			"Fin area"
		REAL dx								UNITS u_m			"Node length in cross direction"
		REAL dy								UNITS u_m			"Node length in tube direcction"

		REAL Tsink1							UNITS u_K			"Equivalent sink temperature for side 1"
		REAL Tsink2							UNITS u_K			"Equivalent sink temperature for side 2"

		REAL q_tot_sun						UNITS u_W			"Total solar heat flow received by radiator"

		REAL qx[nx+1,ny]					UNITS u_W			"Cross direction heat flow through nodes"
		REAL qy[nx,ny+1]					UNITS u_W			"Tube direction heat flow through nodes"

		REAL C_x[nx+1,ny]					UNITS u_W_K			"Equivalent conductance in the cross direction between the thermal nodes"
		REAL C_y[nx,ny+1]					UNITS u_W_K			"Equivalent conductance in the tube direction between the thermal nodes"

		REAL q_rad_1[nx,ny]				UNITS u_W			"Heat flow radiated by each node in side 1"
		REAL q_rad_2[nx,ny]				UNITS u_W			"Heat flow radiated by each node in side 2"

		REAL cp_var[nx,ny]				UNITS u_J_kgK		"Specific heat of nodes"
		REAL k_var[nx,ny]					UNITS u_W_mK		"Thermal conductivities of nodes"
		REAL T[nx,ny]						UNITS u_K			"Nodal temperatures"
		INTEGER icpk[nx,ny]				"Last pointer to speed up nodal interpolations"
		INTEGER it0							"Pointer to To"
      
		REAL q_tot_rad_1					UNITS u_W			"Total heat flow radiated by side 1"
		REAL q_tot_rad_2					UNITS u_W			"Total heat flow radiated by side 2"

		REAL q_tot_fluid					UNITS u_W			"Total heat flow received from fluid by radiator"

		REAL Ax								UNITS u_m2			"OX - Cross Area"
		REAL Ay								UNITS u_m2			"OY - Cross Area"
      
	INIT
		FOR (i IN 1,nx)
			FOR (j IN 1,ny)
				T[i,j] = To
			END FOR
		END FOR


	CONTINUOUS
		-- Properties of radiator material
		rho_var = FunConstSolidProp(mat, Density, rho)

		-- Area of each fin
		A = Lx * Ly

		-- Node length calculation
		dx = Lx / nx
		dy = Ly / ny

		Ax = e * dy
		Ay = e * dx

		-- Equivalent sink temperature for side 1
		Tsink1 = tp_1.Tk[1]  * (1. + (alpha1 * SOLAR_CONSTANT * sin(max(beta1, 0.) * PI / 180.)) / \
			(max(emiss1 * F1, 1.e-8) * STEFAN * tp_1.Tk[1]**4))**0.25

		-- Equivalent sink temperature for side 2
		Tsink2 = tp_2.Tk[1] * (1. + (alpha2 * SOLAR_CONSTANT * sin(max(beta2, 0.) * PI / 180.)) / \
			(max(emiss2 * F2, 1.e-8) * STEFAN * tp_2.Tk[1]**4))**0.25

		-- Total solar heat flow received by radiator
		q_tot_sun = alpha1 * SOLAR_CONSTANT * A * sin(max(beta1, 0.) * PI / 180.) + \
			alpha2 * SOLAR_CONSTANT * A * sin(max(beta2, 0.) * PI / 180.)


		---------------------------------------------------------------------------------------- 
		--Compute Equivalent Conductances -------------------------------------------------------       
		-- OY -------------------------------------------------------------------------------
		EXPAND_BLOCK (i IN 1, nx)
			--first section
			C_y[i,1] = 0.0
			--core
			EXPAND (j IN 2, ny)
				C_y[i,j] =(k_var[i,j-1]*k_var[i,j])/(k_var[i,j]*0.5*dy + k_var[i,j-1]*0.5*dy)* Ay
			--last section
			C_y[i,ny+1] = 0.0
		END EXPAND_BLOCK

		-- OY -------------------------------------------------------------------------------
		EXPAND_BLOCK (j IN 1, ny)
			--first section
			C_x[1,j] = (2*k_var[1,j]/dx)*Ax --Equivalent Conductance for F-->0 
			--core
			EXPAND (i IN 2, nx)
				C_x[i,j] =(k_var[i-1,j]*k_var[i,j])/(k_var[i,j]*0.5*dx + k_var[i-1,j]*0.5*dx)* Ax
			--last section
			C_x[nx+1,j] = 0.0
		END EXPAND_BLOCK


		-- Cross direction heat flows through nodes
		EXPAND_BLOCK (j IN 1,ny)

			qx[1,j] =  C_x[1, j] * (tp_in.Tk[j] - T[1,j])

			EXPAND (i IN 2,nx)
				qx[i,j] =  C_x[i,j] *  (T[i-1,j] - T[i,j])

			qx[nx+1,j] = 0.

			tp_in.q[j] = qx[1,j]

		END EXPAND_BLOCK

		-- Tube direction heat flows through nodes
		EXPAND_BLOCK (i IN 1,nx)
			qy[i,1] = 0.

		EXPAND (j IN 2,ny)
			qy[i,j] = C_y[i,j] *  (T[i,j-1] - T[i,j])

			qy[i,ny+1] = 0.

		END EXPAND_BLOCK

		EXPAND_BLOCK (i IN 1, nx)
			EXPAND_BLOCK (j IN 1, ny)
				-- Heat flow radiated by each node in side 1
				q_rad_1[i,j] = emiss1 * STEFAN * F1 * (dx * dy) * \
					(T[i,j]**4 - tp_1.Tk[1]**4)

				-- Heat flow radiated by each node in side 2
				q_rad_2[i,j] = emiss2 * STEFAN * F2 * (dx * dy) * \
					(T[i,j]**4 - tp_2.Tk[1]**4)
               
				k_var[i,j]  =	ZONE (TemperatureDependance)	FunVarSolidProp(mat, Conductivity, T[i,j], k, icpk[i,j])
									OTHERS								FunVarSolidProp(mat, Conductivity, To, k, it0)
                          
				cp_var[i,j] =	ZONE (TemperatureDependance)	FunVarSolidProp(mat, SpecificHeat, T[i,j], cp, icpk[i,j])
									OTHERS								FunVarSolidProp(mat, SpecificHeat, To, cp, it0)
                          
				-- Energy equation at each node due to all heat flows
				cp_var[i,j] * rho_var * dx * dy * e * T[i,j]' = qx[i,j] - qx[i+1,j] + qy[i,j] - qy[i,j+1] + \
				q_tot_sun / (nx * ny) - q_rad_1[i,j] - q_rad_2[i,j]

			END EXPAND_BLOCK
		END EXPAND_BLOCK

		-- Total heat flow radiated by side 1
		q_tot_rad_1 = n_fin * sum2D(nx, ny, q_rad_1)

		-- Total heat flow radiated by side 2
		q_tot_rad_2 = n_fin * sum2D(nx, ny, q_rad_2)

		-- Total heat flow received from connection by radiator
		q_tot_fluid = n_fin * sum2D(1, ny, qx)

		-- Ports connections
		tp_1.q[1] = q_tot_rad_1
		tp_2.q[1] = q_tot_rad_2

END COMPONENT

