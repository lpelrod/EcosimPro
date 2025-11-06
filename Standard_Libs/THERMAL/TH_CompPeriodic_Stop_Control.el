--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompPeriodic_Stop_Control.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a component to determine cyclic temperature
--							dynamics in nodes for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramón Pérez Vara
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 


-- Components
--------------------------------------------------------------------------------
-- Component Periodic_Stop_Control
--------------------------------------------------------------------------------
-- Purpose:
--    Component that can be attached to a particular node to know when the node
--    temperature dynamics is periodic.
--------------------------------------------------------------------------------
COMPONENT Periodic_Stop_Control
	(
		INTEGER n = 1           UNITS no_units      "Number of nodes",
		INTEGER node = 1        UNITS no_units      "Number of the node to sample"
	)
	"Device allowing stopping the simulation when the dynamic response of the measured temperature becomes periodic"
	PORTS
		IN thermal (n = n) tp_in  CARDINALITY 1	"Thermal inlet port"

   DATA
		REAL To = 290.				UNITS u_K		"Initial temperature of node"
		REAL T_error = 0.001		UNITS u_K		"Average temperature error to consider cycling"

	DECLS
		BOOLEAN Cycled = FALSE			UNITS no_units		"Cycling status flag"
		BOOLEAN Check_Error = TRUE		UNITS no_units		"Auxiliar variable to check error at the end of each period"

		REAL T_After_Period				UNITS u_K		"Temperature delayed by one period"

		DISCR REAL ErrorLimit			UNITS u_Ks		"Maximum integrated absolute error allowed to consider cyclic behaviour" 
		REAL ErrorPeriod					UNITS u_Ks		"Integrated absolute error between one period and previous one"

	INIT
		ErrorPeriod = 1.

		T_After_Period = To

		ASSERT (n > 0) FATAL "Periodic_Stop_Control component: Number of nodes must be at least 1"

	DISCRETE
		-- Calculate the error after each period. Orbit_Period is the period and
		-- its value has to be defined in the boundary section of the experiment
		WHEN (Check_Error) THEN
			Check_Error = FALSE
			Check_Error = TRUE AFTER Orbit_Period

			ErrorLimit = abs(T_error) * Orbit_Period

			-- Solution is calculated during 5 additional orbits for checking
			IF ((ErrorPeriod < ErrorLimit) AND (TIME > 5 * Orbit_Period) AND (NOT Cycled)) THEN
				Cycled = TRUE

				-- The simulation is stopped the next period once the cyclic dynamics
				-- has been detected
				TSTOP = TIME + Orbit_Period

				PRINT("Periodic_Stop_Control component: Cyclic temperature dynamics")

			END IF

			-- Reinitialises total error during one orbit for next orbit
			ErrorPeriod = 0.

		END WHEN

	CONTINUOUS
		T_After_Period = delay(tp_in.Tk[node], Orbit_Period)

		ErrorPeriod' = abs(tp_in.Tk[node] - T_After_Period)

		-- There is no heat transfer between this component and the node
		EXPAND (i IN 1, n)
			tp_in.q[i] = 0

END COMPONENT

