--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompTimers.el
--    FILE TYPE:  Common elements of the library
--    DESCRIPTION:  Defines different types of timers 
--    AUTHOR:  EAI
--    CREATION DATE:  Oct-2011
--------------------------------------------------------------------------------
USE MATH 
USE PORTS_LIB 

--------------------------------------------------------------------------------
-- Component CLK
--------------------------------------------------------------------------------
-- Purpose:
--    Generates clock of the system
--------------------------------------------------------------------------------

COMPONENT CLK "Component to generate pulsed signal of type BOOLEAN"
   DATA
	
	REAL Period = 10			UNITS u_s	"Period of pulse"
   REAL pulseWidth = 5		UNITS u_s	"Pulse width"
	REAL Tstart = 0			UNITS u_s	"Starting time of signal generation"
   
   DECLS
	BOOLEAN State				UNITS no_units	"Auxiliar Boolean variable"
   
   INIT
	
	State = FALSE
	Clock_signal = FALSE
	

   DISCRETE

	WHEN(TIME > Tstart) THEN
	   State = TRUE
		Clock_signal = TRUE
	END WHEN

	WHEN(State) THEN
	   State = FALSE AFTER pulseWidth
		Clock_signal = FALSE AFTER pulseWidth
	END WHEN

	WHEN(State==FALSE AND TIME > Tstart) THEN
	   State = TRUE AFTER (Period - pulseWidth)
		Clock_signal = TRUE AFTER (Period - pulseWidth)
	
	END WHEN

END COMPONENT
--------------------------------------------------------------------------------
-- Component Timer_TON
--------------------------------------------------------------------------------
-- Purpose:
--    To generate a boolean delayed by a period of time 

--------------------------------------------------------------------------------

COMPONENT Timer_TON IS_A bSISO "Timer to delay a signal on activation"
	
	PORTS

		OUT 	analog_signal(n=1)   ET
	
	DATA
		REAL PT = 2		UNITS u_s	"Time"

	DECLS
		DISCR REAL TSTART		UNITS u_s	
		BOOLEAN count
	
	
	INIT
		TSTART = 0
		count = FALSE
		ET.signal[1] = 0
		
	DISCRETE
		--Start counting
		WHEN (s_in.signal[1] == TRUE AND count == FALSE) THEN 
			TSTART = TIME
			count = TRUE
		END WHEN
		
		--Stop counting
		WHEN (s_in.signal[1] == FALSE AND count == TRUE) THEN
			s_out.signal[1] = FALSE
			count = FALSE	
		END WHEN
		
		--Finish counting
		WHEN(ET.signal[1] >= PT AND count == TRUE) THEN
			s_out.signal[1] = TRUE
		END WHEN	

	CONTINUOUS
							--Finish counting
		ET.signal[1] = ZONE (ET.signal[1] >= PT AND count == TRUE)
							PT
							--Counting
							ZONE (count == TRUE)
							TIME - TSTART
							OTHERS
							0	
END COMPONENT

--------------------------------------------------------------------------------
-- Component Timer_TOFF
--------------------------------------------------------------------------------
-- Purpose:
--    To generate a boolean delayed by a period of time on deactivation

--------------------------------------------------------------------------------

COMPONENT Timer_TOFF IS_A bSISO "Timer to delay a signal on deactivation"
	
	PORTS

		OUT 	analog_signal(n=1)   ET
	
	DATA
		REAL PT = 2		UNITS u_s	"Time"

	DECLS
		DISCR REAL TSTART		UNITS u_s
		BOOLEAN count
	
	
	INIT
		TSTART = 0		
		count = FALSE
		ET.signal[1] = 0
	
	DISCRETE
		WHEN (s_in.signal[1] == TRUE AND count == FALSE) THEN
				s_out.signal[1]=TRUE
		END WHEN
		
		--Start counting
		WHEN (s_in.signal[1] == FALSE AND count == FALSE) THEN
				TSTART = TIME
				count = TRUE
				s_out.signal[1]=TRUE
		END WHEN
		
			--Stop counting
		WHEN (s_in.signal[1] == TRUE AND count == TRUE) THEN
			s_out.signal[1] = FALSE
			count = FALSE	
		END WHEN
		
		--Finish counting
		WHEN(ET.signal[1] >= PT AND count == TRUE) THEN
			s_out.signal[1] = FALSE
		END WHEN

	CONTINUOUS
							--Finish counting
		ET.signal[1] = ZONE (ET.signal[1] >= PT AND count == TRUE)
							PT
							--Counting
							ZONE (count == TRUE)
							TIME - TSTART
							OTHERS
							0	
	
END COMPONENT
--------------------------------------------------------------------------------
-- Component Timer_TP
--------------------------------------------------------------------------------
-- Purpose:
--    To generate a boolean delayed by a period of time on deactivation

--------------------------------------------------------------------------------

COMPONENT Timer_TP IS_A bSISO "Timer to delay a signal on deactivation"
	
	PORTS

		OUT 	analog_signal(n=1)   ET
	
	DATA
		REAL PT = 2			UNITS u_s	"Time"

	DECLS
		DISCR REAL TSTART			UNITS u_s
		BOOLEAN count
	
	
	INIT
		TSTART = 0
		count = FALSE
		ET.signal[1] = 0
		
	DISCRETE
			--Start counting
		WHEN (s_in.signal[1] == TRUE AND count == FALSE) THEN
				TSTART = TIME
				count = TRUE
				s_out.signal[1]=TRUE
		END WHEN
		
			--Stop counting
		WHEN (s_in.signal[1] == FALSE AND count == TRUE AND ET.signal[1] == PT) THEN
			count = FALSE
		END WHEN
		
			--Finish counting
		WHEN(ET.signal[1] >= PT AND count == TRUE) THEN
			s_out.signal[1] = FALSE
		END WHEN

	CONTINUOUS
							--Finish counting
		ET.signal[1] = ZONE (ET.signal[1] >= PT AND count == TRUE)
							PT
							--Counting
							ZONE (count == TRUE)
							TIME - TSTART
							OTHERS
							0	
	
END COMPONENT

