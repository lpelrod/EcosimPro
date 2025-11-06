--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompBistables.el
--    FILE TYPE:  Common elements of the library
--    DESCRIPTION:  Defines SR and RS bistables
--    AUTHOR:  EAI
--    CREATION DATE:  Oct-2011
--------------------------------------------------------------------------------
USE MATH 
--------------------------------------------------------------------------------
-- Component SR bistable
--------------------------------------------------------------------------------
-- Purpose:To define an SR bistable
--   based in IEC 61131-3 International Standard  
--------------------------------------------------------------------------------
COMPONENT SR_Bistable IS_A bMI2MOs "SR bistable"
	
DATA
	BOOLEAN init_val = FALSE

INIT
	s_out.signal[1] = init_val 
	
DISCRETE
	WHEN(s_in_2.signal[1] == TRUE OR (s_out.signal[1] == TRUE AND s_in_1.signal[1] == FALSE)) THEN
				s_out.signal[1] = TRUE
	END WHEN		
	
	WHEN(s_in_2.signal[1] == FALSE AND s_in_1.signal[1] == FALSE ) THEN
				s_out.signal[1] = FALSE
	END WHEN		

	WHEN(s_in_2.signal[1] == FALSE AND s_out.signal[1] == FALSE ) THEN
				s_out.signal[1] = FALSE
	END WHEN

END COMPONENT

--------------------------------------------------------------------------------
-- Component RS bistable
--------------------------------------------------------------------------------
-- Purpose: To define a RS bistable
--  based in IEC 61131-3 International Standard
--------------------------------------------------------------------------------

COMPONENT RS_Bistable IS_A bMI2MOs "RS bistable"
	
DATA
	BOOLEAN init_val = FALSE

INIT
	s_out.signal[1] = init_val 
	
DISCRETE
	WHEN((s_in_1.signal[1] == TRUE OR s_out.signal[1] == TRUE) AND s_in_2.signal[1] == FALSE) THEN
				s_out.signal[1] = TRUE
	END WHEN		
	
	WHEN(s_in_1.signal[1] == FALSE AND s_out.signal[1] == FALSE AND s_in_2.signal[1] == FALSE) THEN
				s_out.signal[1] = FALSE
	END WHEN		

	WHEN (s_in_2.signal[1] == TRUE) THEN
			s_out.signal[1] = FALSE
	END WHEN
END COMPONENT
