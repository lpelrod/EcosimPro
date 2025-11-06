--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompBasics.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines basic components for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH VERSION "3.1"
USE PORTS_LIB VERSION "1.1"


-- Components
--------------------------------------------------------------------------------
-- Component BNode
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a boundary thermal node with temperature depending on TIME.
--------------------------------------------------------------------------------
COMPONENT BNode IS_A Node
	"Time dependant boundary condition in temperature (signal input)"
	PORTS
		IN analog_signal (n = n) s_temperature	"Input signal port for temperature values"
	DISCRETE
		WHEN (PRINT_TEMP) THEN
			WRITE("\n")
			FOR(i IN 1, n)
				WRITE("Node: %s - Temperature %d: %g\n", Label, i, tp_in.Tk[i])
			END FOR
			WRITE("\n")
			PRINT_TEMP = FALSE AFTER 0.
		END WHEN
	CONTINUOUS
		EXPAND (i IN 1, n)
			tp_in.Tk[i] = s_temperature.signal[i]

END COMPONENT 

--------------------------------------------------------------------------------
-- Component DNode
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a diffusive thermal node with constant capacity.
--------------------------------------------------------------------------------
COMPONENT DNode IS_A ADNode 
	"Diffusive thermal node"

	DATA	
		REAL C = 1.e-3			UNITS u_J_K		"Heat capacity"

	CONTINUOUS
		VC = C

END COMPONENT

--------------------------------------------------------------------------------
-- Component DNodeMat
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a diffusive thermal node having a mass of a given material
--
--------------------------------------------------------------------------------
COMPONENT DNodeMat IS_A ADNode
	"Diffusive thermal node with variable properties"
	DATA
		ENUM Material mat = None	UNITS no_units		"Material"
		REAL mass = 1					UNITS u_kg			"Mass of the thermal node"
		REAL cp = 500.					UNITS u_J_kgK		"Specific heat if material is None"
	DECLS
		REAL cp_var						UNITS u_J_kgK		"Specific heat of wall material"
		INTEGER ipt = 0            						"Pointer to last table position"
	CONTINUOUS
		cp_var = FunVarSolidProp(mat, SpecificHeat, T, cp, ipt)

		VC = mass * cp_var
END COMPONENT

-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Component DNodeMat_vec
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Purpose:
--    Defines a vectorized diffusive thermal node calculating n different temperatures with no heat exchange between them having a mass of a given material
--
-----------------------------------------------------------------------------------------------------------------------------------------------------------
COMPONENT DNodeMat_vec 	
		(
		INTEGER n = 1		UNITS no_units			"Dimension of thermal port"
		)	"Diffusive thermal node with variable properties"
	PORTS
		IN thermal (n = n) tp_in  CARDINALITY 1, 10000	"Thermal inlet port"
	DATA
		BOOLEAN Boundary = FALSE		UNITS no_units		"Flag used to set boundary mode"
		ENUM Material mat = None		UNITS no_units		"Material"
		REAL mass = 1						UNITS u_kg			"Total mass"
		REAL cp = 500.						UNITS u_J_kgK		"Specific heat if material is None"
		REAL To = 290.						UNITS u_K			"Initial temperature"
	DECLS
		REAL T[n]							UNITS u_K			"Node temperature"
		REAL VC[n]							UNITS u_J_K			"Variable heat capacity"
		REAL q[n]							UNITS u_W			"Heat into node"
		REAL cp_var[n]						UNITS u_J_kgK		"Specific heat of wall material"
		INTEGER ipt = 0            	UNITS no_units		"Pointer to last table position"
	INIT
		FOR (i IN 1, n)
			T[i] = To
		END FOR
	CONTINUOUS
		EXPAND_BLOCK (i IN 1, n)
			T[i]' =	ZONE (Boundary)0.	OTHERS q[i] / VC[i]
			tp_in.Tk[i] = T[i]	
			tp_in.q[i]=q[i]			
			cp_var[i] = FunVarSolidProp(mat, SpecificHeat, T[i], cp, ipt)
			VC[i] = mass/n * cp_var[i]
		END EXPAND_BLOCK
END COMPONENT

--------------------------------------------------------------------------------
-- Component DNodeRoom
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a diffusive thermal node which represents a Room with a Volume V
--    Default fluid is Air
--------------------------------------------------------------------------------
COMPONENT DNodeRoom IS_A ADNode
	"Diffusive thermal node which represents a room with a volume V"
	DATA
		REAL V = 100.				UNITS u_m3		"Volume of the room node"
		REAL P = 101325			UNITS u_Pa		"Pressure in the room"
		ENUM ThFluids thermal_fluid = Air		UNITS no_units		"Fluid in the Room"

    DECLS
        REAL cp					UNITS u_J_kgK			"Specific heat of fluid in room"
        REAL rho					UNITS u_kg_m3			"Density of fluid in room"
		  INTEGER ier				UNITS no_units			"Function error identifier"
		  REAL vis     			UNITS u_kg_sm			"Viscosity"
		  REAL K       			UNITS u_W_mK			"Thermal conductivity"
        INTEGER itab           "Index in table"

    CONTINUOUS
      Fluid_prop_vs_pT(thermal_fluid, P, T, cp, vis, rho, K, itab)

		VC = V * cp * rho
END COMPONENT


--------------------------------------------------------------------------------
-- Component GL
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a linear conductor with constant conductance.
--------------------------------------------------------------------------------
COMPONENT GL IS_A AGL  
	"Linear thermal conductance"
	DATA
		REAL cond = 0.			UNITS u_W_K		"Total thermal conductance"

	CONTINUOUS
		-- Conductance is distributed along the port connections
		EXPAND (i IN 1, n)
			Vcond[i] = cond / n

END COMPONENT
--------------------------------------------------------------------------------
-- Component GL_mat
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a linear conductor of a given material.
--------------------------------------------------------------------------------
COMPONENT GL_mat IS_A AGL
	"Linear thermal conductance with variable properties"
	DATA
		ENUM Material mat = None	UNITS no_units		"Material"
		REAL F = 0.1					UNITS u_m			"Area to thermal path ratio"
		REAL k = 0.1					UNITS u_W_mK		"Thermal conductivity if material is None" 
    DECLS
		REAL k_var[n]					UNITS u_W_mK		"Thermal conductivity" 
		INTEGER ipt[n] = 0									"Pointer to last table position"
	CONTINUOUS

		-- Conductance is distributed along the port connections
		EXPAND_BLOCK (i IN 1, n)    
			k_var[i] = FunVarSolidProp(mat, Conductivity, 0.5 * (tp_in.Tk[i] + tp_out.Tk[i]), k, ipt[i])
                   
			Vcond[i] = (F/n) * k_var[i]
		END EXPAND_BLOCK
END COMPONENT
--------------------------------------------------------------------------------
-- Component TD_GL
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a linear conductor with variable conductance.
--------------------------------------------------------------------------------
COMPONENT TD_GL IS_A AGL
"Linear thermal conductance with table properties"
	DATA
		REAL F = 0.				UNITS u_m		"Area to thermal path ratio"
		TABLE_1D k_table =	{
									{0, 1000.},
									{1.,   1.}
									}		"Thermal conductivity versus average temperature (W/m*K vs K)"
	DECLS
		REAL k_var[n]			UNITS u_W_mK		"Thermal conductivity"        
	CONTINUOUS
		EXPAND_BLOCK (i IN 1, n)
			Vcond[i] = (F/n) * k_var[i]
			-- Conductance is distributed along the port connections
			k_var[i] = linearInterp1D(k_table, 0.5 * (tp_in.Tk[i] + tp_out.Tk[i])) 
		END EXPAND_BLOCK
END COMPONENT

--------------------------------------------------------------------------------
-- Component GR
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a radiative conductor with constant REF.
--------------------------------------------------------------------------------
COMPONENT GR IS_A AGR
	"Radiative thermal conductance with constant REF "
	DATA
		REAL REF = 0.				UNITS u_m2		"Radiative exchange factor"

	CONTINUOUS
		-- REF is distributed along the port connections
		EXPAND (i IN 1, n)
			VREF[i] = REF / n

END COMPONENT

--------------------------------------------------------------------------------
-- Component Heater
--------------------------------------------------------------------------------
-- Purpose:
--    Defines an electrical heater (local or linear). Power dissipation value
--    is given by the external signal.
--------------------------------------------------------------------------------
COMPONENT Heater
	(
		INTEGER n = 1				UNITS no_units		"Number of nodes"
	)
	"Electrical heater (local or linear). Power dissipation value is given by the external signal"
	PORTS
		IN  analog_signal s_power	"Input power signal"
		OUT thermal (n = n) tp_out  CARDINALITY 1	"Thermal outlet port"

	INIT
		ASSERT (n > 0) FATAL "Heater component: Number of nodes must be at least 1"

	CONTINUOUS
		EXPAND (i IN 1, n)
			tp_out.q[i] =  s_power.signal[1] / n

END COMPONENT

--------------------------------------------------------------------------------
-- Component Insulation
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of thermal insulators
--------------------------------------------------------------------------------
COMPONENT Insulation
	(
		INTEGER n = 1			UNITS no_units		"Dimension of thermal port"
	)
	"Thermal insulation"
	PORTS
		IN  thermal (n = n) tp  CARDINALITY 1  "Thermal port"

	INIT
		ASSERT (n > 0) FATAL "Insulation component: Size of thermal array must be at least 1"

	CONTINUOUS
		EXPAND_BLOCK (i IN 1, n)
			tp.q[i] = 0
		END EXPAND_BLOCK

END COMPONENT

