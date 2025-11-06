--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompTube.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a tube component that represents a thin-walled tube
--							containing a certain amount of fluid as well as a quantity
--							of gas for control purposes for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara & Borja Garcia Gutierrez
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 


-- Components
--------------------------------------------------------------------------------
-- Component Tube
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a unidimensional wall component, divided into a number of
--    slabs (nodes).
--------------------------------------------------------------------------------
COMPONENT Tube
	(
   	INTEGER n = 5        UNITS no_units          "Number of nodes in tube"
	)
	"Unidimensional wall component"

	PORTS
		IN  thermal (n = 1) tp_1			"Tube axial thermal inlet port"
		OUT thermal (n = 1) tp_N			"Tube axial thermal outlet port"

		IN  thermal (n = 1) tp_vapour		"Vapour-tube radial thermal inlet port"
		OUT thermal (n = n) tp_wall		"Tube radial thermal outlet port"

		IN  analog_signal s_p				"Total pressure input port"

		IN  analog_signal s_ngas_in		"Number of moles of gas inlet port"
		OUT analog_signal s_ngas_out		"Number of moles of gas outlet port"

		OUT analog_signal s_lvap			"Vapour length output port"

	DATA
		ENUM Material mat = None		UNITS no_units		"Material used for tube"
		REAL rho = 1000.					UNITS u_kg_m3	"Wall density if material is None"
		REAL cp = 500.						UNITS u_J_kgK	"Wall specific heat if material is None"
		REAL k = 0.1						UNITS u_W_mK	"Wall conductivity if material is None"
		BOOLEAN TemperatureDependance = TRUE	"Option to consider or not the temperature depence on the material properties"  
         
		REAL h = 1000.						UNITS u_W_m2K	"Vapour-tube heat transfer coefficient"

		REAL l = 1.							UNITS u_m	"Length of tube"      
		REAL D_o = 0.020					UNITS u_m	"Outer diameter of tube"
		REAL D_i = 0.018					UNITS u_m	"Inner diameter of tube"
		REAL A_vap = 1.e-4				UNITS u_m2	"Fluid cross section area in tube"
      
		REAL To = 290.						UNITS u_K	"Initial temperature of nodes"

	DECLS
		REAL rho_var						UNITS u_kg_m3	"Density of wall material"

		REAL dx								UNITS u_m	"Node length"
		REAL P_outer						UNITS u_m	"Perimeter of outer section"
		REAL P_inner						UNITS u_m	"Perimeter of inner section"
		REAL A								UNITS u_m2	"Cross sectional area of tube wall"
		REAL A_i								UNITS u_m2	"Cross sectional inner area of tube"

		REAL k_1								UNITS u_W_mK	"Thermal conductivity in tp_1"
		INTEGER ik_1										"Pointer to last interval of interpolation"
		REAL k_N								UNITS u_W_mK	"Thermal conductivity in tp_N"
		INTEGER ik_N										"Pointer to last interval of interpolation"
          
		REAL q[n+1]							UNITS u_W	"Axial heat flow through nodes"
		REAL q_vapour[n]					UNITS u_W	"Heat flow from vapour to each node"

		REAL T[n]							UNITS u_K		"Temperature of nodes"
		REAL cp_var[n]						UNITS u_J_kgK	"Specific heat of nodes"
		REAL k_var[n]						UNITS u_W_mK	"Thermal conductivity of nodes"
		INTEGER icpk[n]										"Pointer to last interval of interpolation"
      
		REAL chi[n]							UNITS no_units		"Vapour-gas moles ratio at each node section"

		REAL l_vap							UNITS u_m		"Vapour length measured from start of the tube (m)"

		INTEGER it0								"Pointer to To"

	INIT
		ASSERT (n > 0) FATAL "Tube component: Number of nodes must be at least 1"
		FOR (i IN 1,n)
			T[i] = To
		END FOR
	DISCRETE
		ASSERT (A_vap <= A_i) FATAL "Tube component: Fluid cross section greater than inner area of tube"

	CONTINUOUS
		-- Properties of tube material
		rho_var = FunConstSolidProp(mat, Density, rho)

		-- Node length calculation
      dx = l / n

		-- Perimeters and area of tube (circular cross-section)
		P_outer = PI * D_o
		P_inner = PI * D_i
      
		A = 0.25 * PI * (D_o**2 - D_i**2)
		A_i = 0.25 * PI * D_i**2		

		-- Axial heat flow
		k_1 =	ZONE (TemperatureDependance)	FunVarSolidProp(mat, Conductivity, tp_1.Tk[1], k, ik_1)
				OTHERS								FunVarSolidProp(mat, Conductivity, To, k, it0)
             
--		q[1] = 0.5 * (k_1 + k_var[1]) * 2 * A * (tp_1.Tk[1] - T[1]) / dx
--		q[1] = 2 * (k_1 * k_var[1])/(k_1 + k_var[1]) * 2 * A * (tp_1.Tk[1] - T[1]) / dx
		q[1] = k_var[1] * 2 * A * (tp_1.Tk[1] - T[1]) / dx


		EXPAND (i IN 2, n)
			q[i] = 2 * (k_var[i-1]*k_var[i])/(k_var[i-1]+k_var[i]) * A * (T[i-1] - T[i]) / dx
--			q[i] = 0.5 * (k_var[i-1]+k_var[i]) * A * (T[i-1] - T[i]) / dx

		k_N =	ZONE (TemperatureDependance)	FunVarSolidProp(mat, Conductivity, tp_N.Tk[1], k, ik_N)
				OTHERS								FunVarSolidProp(mat, Conductivity, To, k, it0)
            
--		q[n + 1] = 0.5 * (k_var[n] + k_N) * 2 * A * (T[n] - tp_N.Tk[1]) / dx
--		q[n + 1] = 2 * (k_var[n]*k_N)/(k_var[n] + k_N) * 2 * A * (T[n] - tp_N.Tk[1]) / dx
		q[n + 1] = k_var[n] * 2 * A * (T[n] - tp_N.Tk[1]) / dx

		EXPAND_BLOCK (i IN 1, n)
			-- Radial heat flow due only to vapour
			q_vapour[i] = h * chi[i] * P_inner * dx * (tp_vapour.Tk[1] - T[i])
         
			cp_var[i] = ZONE (TemperatureDependance)	FunVarSolidProp(mat, SpecificHeat, T[i], cp, icpk[i])
							OTHERS								FunVarSolidProp(mat, SpecificHeat, To, cp, it0)
         
			k_var[i] =	ZONE (TemperatureDependance)	FunVarSolidProp(mat, Conductivity, T[i], k, icpk[i])
							OTHERS								FunVarSolidProp(mat, Conductivity, To, k, it0)
                                  
			-- Energy equation at each node due to all heat flows
			cp_var[i] * rho_var * A * dx * T[i]' = (q[i] - q[i+1]) + (q_vapour[i] - tp_wall.q[i])

			-- Port connections
			tp_wall.Tk[i] = T[i]

		END EXPAND_BLOCK

		-- Port connections
		tp_1.q[1] = q[1]
		tp_N.q[1] = q[n + 1]

		-- Total heat flow from vapour (ports connection)
		tp_vapour.q[1] = SUM(i IN 1, n; q_vapour[i])

		-- Vapour length measured from the beginning of tube
		l_vap = Lvap(n, l, A_vap, s_ngas_in.signal[1], s_p.signal[1], T, chi, s_ngas_out.signal[1])

		-- Vapour length (ports connection)
		s_lvap.signal[1] = l_vap

END COMPONENT
