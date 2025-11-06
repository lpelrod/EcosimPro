--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompSignalTreatment.el
--    FILE TYPE:  Components of the CONTROL library
--    DESCRIPTION:  Defines components to manage signals
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  EAI
--    CREATION DATE:  October 2011
--------------------------------------------------------------------------------
USE MATH 
USE PORTS_LIB 

--------------------------------------------------------------------------------
-- Component Hysteresis
--------------------------------------------------------------------------------
-- Purpose:
--    It defines a component that behaves with hysteresis
--------------------------------------------------------------------------------
COMPONENT Hysteresis IS_A SI2bSO "This function block implements Boolean hysteresis on the difference of REAL inputs."
	PORTS
		IN 	analog_signal(n=1)	eps 	
 	
		DISCRETE
			WHEN (s_in_1.signal[1]< s_in_2.signal[1] - eps.signal[1] ) THEN
					s_out.signal[1] = FALSE 
			END WHEN
			WHEN (s_in_1.signal[1]> s_in_2.signal[1] + eps.signal[1] ) THEN		
					s_out.signal[1] = TRUE 
			END WHEN
			
			
END COMPONENT


--------------------------------------------------------------------------------
-- Component Scaling
--------------------------------------------------------------------------------
-- Purpose:
--    It defines a component that scales the signal
--------------------------------------------------------------------------------
COMPONENT Scaling IS_A SISO "This component implements Boolean hysteresis on the difference of REAL inputs."
	DATA
		REAL in_min = 0		UNITS no_units
		REAL in_max = 100		UNITS no_units 
		REAL out_min = 0		UNITS no_units	
		REAL out_max = 100	UNITS no_units
		
CONTINUOUS

	s_out.signal[1] = (s_in.signal[1]-in_min)*(out_max-out_min)/(in_max-in_min) + out_min
				
			
END COMPONENT

--------------------------------------------------------------------------------
-- Component Trigger_RE
--------------------------------------------------------------------------------
-- Purpose:It defines a component that detects rising edges in signals
-- based in IEC 61131-3 International Standard 
--------------------------------------------------------------------------------
COMPONENT Trigger_RE IS_A bSISO "This component implements rising edge detection."
	
	DECLS
		BOOLEAN CLK_OLD
		REAL frac
		DISCR REAL start	

	INIT
		CLK_OLD = FALSE
		s_out.signal[1] = FALSE

	DISCRETE
		WHEN(frac >= 1. AND s_in.signal[1] == TRUE AND CLK_OLD == FALSE) THEN
			s_out.signal[1] = 	TRUE
		END WHEN
		WHEN(frac >= 1. AND s_in.signal[1] == TRUE AND CLK_OLD == TRUE) THEN
			s_out.signal[1] = 	FALSE
		END WHEN	

		WHEN(frac > 1.) THEN
		       WRITE("ejecutando el IF \n")
		CLK_OLD = s_in.signal[1]	
		start = start + CINT
		END WHEN
		
	CONTINUOUS

		frac = (TIME - start) / CINT
			
END COMPONENT
			


--------------------------------------------------------------------------------
-- Component Trigger_FE
--------------------------------------------------------------------------------
-- Purpose:It defines a component that detects falling edges of a boolean signal 
-- based in IEC 61131-3 International Standard 
--------------------------------------------------------------------------------
COMPONENT Trigger_FE IS_A bSISO "This component implements falling edge detection."
	
	DECLS
		BOOLEAN CLK_OLD
		REAL frac
		REAL start	

	INIT
		CLK_OLD = FALSE
		s_out.signal[1] = FALSE

	DISCRETE
		WHEN(frac >= 1. AND s_in.signal[1] == FALSE AND CLK_OLD == TRUE) THEN
			s_out.signal[1] = 	TRUE
		END WHEN
		WHEN(frac >= 1. AND s_in.signal[1] == FALSE AND CLK_OLD == FALSE) THEN
			s_out.signal[1] = 	FALSE
		END WHEN	

		WHEN(frac > 1.) THEN
			CLK_OLD = s_in.signal[1]	
			start = start + CINT
		END WHEN

	CONTINUOUS

		frac = (TIME - start) / CINT			
			
END COMPONENT