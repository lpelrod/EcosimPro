--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompAbstract.el
--		FILE TYPE:		Common Elements of the THERMAL library
--		DESCRIPTION:	Defines abstract components for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH VERSION "3.1"
USE PORTS_LIB VERSION "1.1"


-- Abstract Components

--------------------------------------------------------------------------------
-- Component Node
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of thermal nodes with labels, which
--    includes the calculation of the minimum and the maximum 
--    temperatures reached.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT Node
	(
		INTEGER n = 1		UNITS no_units			"Dimension of thermal port"
	)
	"Abstract class for definition of thermal node"
	PORTS
		IN thermal (n = n) tp_in  CARDINALITY 1, 10000	"Thermal inlet port"

	DATA
		STRING Label = "Node Label"	UNITS no_units		"Node label"
		REAL qi = 0.						UNITS u_W			"Impressed heat"

	DECLS
		DISCR REAL Tmin					UNITS u_K		"Minimum temperature reached"
		DISCR REAL Tmax					UNITS u_K		"Maximum temperature reached"
		REAL q								UNITS u_W		"Total heat into node"

	TOPOLOGY
		PATH tp_in TO tp_in

	INIT
		-- Positive value bigger than expected minimum temperature
		Tmin = TMAX

		-- Negative value smaller than expected maximum temperature
		Tmax = 0

	DISCRETE
		-- Used for calling "Bmax" and updating "Tmax" value each step
		-- without discrete event execution
		WHEN (Bmax(Tmax, tp_in.Tk[1]) != 0.) THEN
		END WHEN

		-- Used for calling "Bmin" and updating "Tmin" value each step
		-- without discrete event execution
		WHEN (Bmin(Tmin, tp_in.Tk[1]) != 0.) THEN
		END WHEN

	CONTINUOUS

<q1>		q = qi + SUM(i IN 1, n; tp_in.q[i])

END COMPONENT

--------------------------------------------------------------------------------
-- Component ADNode
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of diffusive thermal nodes. This node
--    has the option of being used as a boundary node which is at constant
--    temperature.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT ADNode IS_A Node 
	"Abstract class for definition of diffusive thermal node"
	DATA
		BOOLEAN Boundary = FALSE		UNITS no_units		"Flag used to set boundary mode"
		REAL To = 290.						UNITS u_K			"Initial temperature"

	DECLS
		REAL T								UNITS u_K		"Temperature"
		REAL VC								UNITS u_J_K		"Variable heat capacity"

	INIT
		T = To

	DISCRETE
		WHEN (PRINT_TEMP) THEN
			PRINT ("Node: $Label - Temperature: $T")
			PRINT_TEMP = FALSE AFTER 0.
		END WHEN

	CONTINUOUS 
		T' =	ZONE (Boundary)	0.
				OTHERS				q / VC

		EXPAND (i IN 1, n)
			tp_in.Tk[i] = T

END COMPONENT

--------------------------------------------------------------------------------
-- Component Conductor
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of thermal conductors.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT Conductor
	(
		INTEGER n = 1			UNITS no_units		"Dimension of thermal port"
	)
	"Abstract class for definition of thermal conductor"
	PORTS
		IN  thermal (n = n) tp_in  CARDINALITY 0, 1	"Thermal inlet port"
		OUT thermal (n = n) tp_out CARDINALITY 0, 1	"Thermal outlet port"

	DECLS
		REAL q[n]             UNITS u_W      "Heat flow"

	TOPOLOGY
		PATH tp_in TO tp_out


	CONTINUOUS
		EXPAND_BLOCK (i IN 1, n)
			tp_in.q[i] = q[i]
			tp_out.q[i] = q[i]
		END EXPAND_BLOCK

END COMPONENT

--------------------------------------------------------------------------------
-- Component AGL
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of linear conductors.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT AGL IS_A Conductor 
	"Abstract class for definition of linear conductor"
	DECLS
		REAL Vcond[n]			UNITS u_W_K		"Variable thermal conductance per node"

	CONTINUOUS
		EXPAND (i IN 1, n)
			q[i] = Vcond[i] * (tp_in.Tk[i] - tp_out.Tk[i])

END COMPONENT

--------------------------------------------------------------------------------
-- Component AGR
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of radiative conductors.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT AGR IS_A Conductor
"Abstract class for definition of radiative conductor"
	DECLS
		REAL VREF[n]			UNITS u_m2		"Variable radiative exchange factor"

	CONTINUOUS
		EXPAND (i IN 1, n)
			q[i] = STEFAN *  VREF [i] *  (tp_in.Tk[i]**2 + tp_out.Tk[i]**2) * \
					(abs(tp_in.Tk[i]) + abs(tp_out.Tk[i])) *  (tp_in.Tk[i] - tp_out.Tk[i])

END COMPONENT