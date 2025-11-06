--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompSensors.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a temperature and heat flow sensors
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara & Borja Garcia Gutierrez
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB
USE CONTROL 


--------------------------------------------------------------------------------
-- Purpose:
--    Defines a temperature sensor
--------------------------------------------------------------------------------
COMPONENT T_sensor IS_A ASensor
	(
		INTEGER n =  1		UNITS no_units		"Size of the thermal port array",
		INTEGER in = 1		UNITS no_units		"Index of the item in temperature array to meassure"
	)
	"Temperature sensor model"

	PORTS
		IN thermal (n = n) tp_in  CARDINALITY 1   "Thermal inlet port"

	CONTINUOUS
		-- Inlet zero heat flow
		EXPAND (i IN 1, n)
			tp_in.q[i] = 0.

		-- Measured variable
		var[1] = tp_in.Tk[in]

END COMPONENT

--------------------------------------------------------------------------------
-- Component Q_sensor
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a heat flow sensor.
--------------------------------------------------------------------------------
COMPONENT Q_sensor IS_A Conductor, ASensor
	(
		INTEGER in = 1			"Number of node to meassure [0 for all nodes]"
	)
	"Heat flow sensor model"
	DECLS
       CLOSE n_out = 1
	CONTINUOUS
		-- Zero temperature difference
		EXPAND (i IN 1, n)
			tp_in.Tk[i] = tp_out.Tk[i]

		-- Measured variable: 0 for all channels & node for single channel
		IF (in == 0) INSERT  var[1] = SUM(i IN 1, n; tp_in.q[i])
    	ELSE    var[1] = tp_in.q[in]
    	END IF

END COMPONENT
