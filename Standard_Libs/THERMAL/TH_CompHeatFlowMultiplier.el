--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompHeatFlowMultiplier.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a heat flow multiplying component for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramón Pérez Vara
--		CREATION DATE:	17-Dec-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 


COMPONENT HeatFlowMultiplier (INTEGER n=1) 
	"Heat flow multiplying component"
	PORTS
		IN  thermal (n=n) tp_in
		OUT thermal (n=n)tp_out
	DATA
		REAL k = 1 	UNITS no_units		 "Heat flow multiplier, i.e. outlet heat / input heat"       

	CONTINUOUS

		EXPAND_BLOCK (i IN 1, n) 
			tp_out.q[i] = k * tp_in.q[i]
			tp_out.Tk[i] = tp_in.Tk[i]
		END EXPAND_BLOCK
END COMPONENT
