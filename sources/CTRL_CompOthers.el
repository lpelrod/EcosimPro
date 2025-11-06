--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompOthers.el
--    FILE TYPE:  Components of the CONTROL library
--    DESCRIPTION:  Defines extra components 
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  EAI
--    CREATION DATE:  October 2011
--------------------------------------------------------------------------------
USE MATH 
USE PORTS_LIB 
--------------------------------------------------------------------------------
-- Component Move
--------------------------------------------------------------------------------
-- Purpose:
--    It defines a the standard arithmetic operation MOVE (IEC1131-3)
--------------------------------------------------------------------------------
COMPONENT Move IS_A SISO "Move standard operation"


PORTS

	IN 	bool_signal(n=1)  	EN		"Enable signal"
		

INIT

	s_in.signal[1] = s_out.signal[1] 
	
CONTINUOUS 

SEQUENTIAL
	
	IF(EN.signal[1] == TRUE) THEN
		s_out.signal[1] = s_in.signal[1]
	END IF
	
END SEQUENTIAL
	
END COMPONENT
