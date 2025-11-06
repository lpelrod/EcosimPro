--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_NonLinear.el
--    FILE TYPE:  New Non linear components of the CONTROL library
--    DESCRIPTION:  Defines components that describe standard nonlinear functions
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 

--------------------------------------------------------------------------------
-- Component Relay
--------------------------------------------------------------------------------
-- Purpose:
--    To switch output signals between two constants depending on the value of
--	the input signals.
--------------------------------------------------------------------------------
COMPONENT Relay IS_A Controller \
"To switch output signals between two constants depending on the value of the input signals. ON/OFF controller with hysteresis"
   DATA
      REAL e_off[n] = -1.         UNITS no_units	"Error for switching to OFF state"
      REAL e_on[n] = 1.           UNITS no_units	"Error for switching to ON state"

      REAL u_off[n] = 0.          UNITS no_units	"Value of controller output when OFF"
      REAL u_on[n] = 1.           UNITS no_units	"Value of controller output when ON"

   DECLS
      ENUM state_type state[n]    "State of controller [ON/OFF]"
   DISCRETE
	EXPAND_BLOCK(i IN 1, n)
		WHEN (e[i] > e_on[i]) THEN
			state[i] = ON
			u[i] = u_on[i]			
		END WHEN

		WHEN (e[i] < e_off[i]) THEN
			state[i] = OFF
			u[i] = u_off[i]						
		END WHEN
	END EXPAND_BLOCK

   CONTINUOUS
	EXPAND(i IN 1, n)
      	u[i] = ZONE (state[i] == ON) u_on[i]
			 OTHERS                u_off[i]

END COMPONENT


--------------------------------------------------------------------------------
-- Component Delay
--------------------------------------------------------------------------------
-- Purpose:
--    To delay an input signal by a given period of time.
--------------------------------------------------------------------------------
COMPONENT Delay IS_A MIMOs "To delay an input signal by a given period of time"
   DATA
      REAL tdelay[n] = 1.     UNITS u_s   "Delay time"

   CONTINUOUS

      EXPAND (i IN 1, n)
         s_out.signal[i] = delay(s_in.signal[i], max(tdelay[i],1.0e-12))

END COMPONENT


--------------------------------------------------------------------------------
-- Component VarDelay
--------------------------------------------------------------------------------
-- Purpose:
--    To delay an input signal by a variable period of time.
--------------------------------------------------------------------------------
COMPONENT VarDelay IS_A MIMOs "To delay an input signal by a variable period of time"
   PORTS
      IN  analog_signal (n = n) s_TimeDelay		"Time delay port"
   DATA
      REAL tdelay_max[n] = 1.				UNITS u_s			"Maximum delay time"

   CONTINUOUS
      EXPAND (i IN 1, n)
         s_out.signal[i] = delay(s_in.signal[i], \
		bound(s_TimeDelay.signal[i], 1.0e-12, tdelay_max[i]))

END COMPONENT


--------------------------------------------------------------------------------
-- Component Saturation
--------------------------------------------------------------------------------
-- Purpose:
--    To limit the range of a signal.
--------------------------------------------------------------------------------
COMPONENT Saturation IS_A MIMOs "To limit the range of a signal"
   DATA
	REAL output_max[n] = 1		"Upper limit of input signal"
	REAL output_min[n] = -1		"Lower limit of input signal"
   CONTINUOUS
	EXPAND (i IN 1,n)
         s_out.signal[i] = ZONE (s_in.signal[i] > output_max[i]) output_max[i]
                              ZONE (s_in.signal[i] < output_min[i]) output_min[i]
					OTHERS s_in.signal[i] 
END COMPONENT


--------------------------------------------------------------------------------
-- Component DeadZone
--------------------------------------------------------------------------------
-- Purpose:
--    To Generate zero output within a specified region called its dead zone
--------------------------------------------------------------------------------
COMPONENT DeadZone IS_A MIMOs "zero output within a specified region called dead zone"
   DATA
	REAL output_max[n] = 1		"Upper limit of the dead zone"
	REAL output_min[n] = -1		"Lower limit of the dead zone"
   CONTINUOUS
	EXPAND (i IN 1,n)
         s_out.signal[i] = ZONE (s_in.signal[i] > output_max[i]) s_in.signal[i] - output_max[i]
                           ZONE (s_in.signal[i] < output_min[i]) s_in.signal[i] - output_min[i]
				   OTHERS 0.0

END COMPONENT

COMPONENT RateLimiter "Rate limiter"
    PORTS
        IN analog_signal (n=1) s_in     "Input signal (-)"
        OUT analog_signal (n=1) s_out   "output signal (-)"
    DATA
        REAL Tc = 0.1  UNITS u_s 				"Filter time to calculate the derivative"
        REAL v_up_max	=  1. RANGE  0., Inf "Specifies the upper limit of the rate of change of the signal [-/s]"
        REAL v_down_max	= -1. RANGE -Inf, 0. "Specifies the lower limit of the rate of change of the signal [-/s]"    
		  REAL y_o = 0.								"Initial value of the output signal"
    DECLS
        REAL v_bound         "Bounded rate [-/s]" 
        REAL v_unbound       "Unbounded rate [-/s]"
        REAL y               "Ouput signal"
        BOOLEAN init_event = FALSE   "Event to execute the DISCRETE block at the beginning of the simulation to initialize the actuator position"
    INIT	 	
        y = y_o
		  init_event = TRUE AFTER 0	
    DISCRETE
        WHEN (init_event) THEN
           y = s_in.signal[1]
			  s_out.signal[1] = s_in.signal[1]
--			  WRITE("\nRateLimiter y = %g", y)
           init_event = FALSE 
        END WHEN
           
    CONTINUOUS                                   
      
        v_unbound = (s_in.signal[1] - y) /Tc
                
        v_bound = IF     (v_unbound > v_up_max) v_up_max
                  ELSEIF (v_unbound < v_down_max) v_down_max
                  ELSE    v_unbound


        y' = v_bound
        
        s_out.signal[1] = y        
END COMPONENT      
   
COMPONENT Actuator 
"Actuator with a limitation of the position and with a speed limiter"
    PORTS
        IN analog_signal (n=1) s_pos_dem  "Demanded position"
        OUT analog_signal (n=1) s_pos_actual     "Actual position"
    DATA
        REAL Tc = 5.              UNITS u_s		"Actuator time constant"
        REAL v_up_max  =  4.    RANGE 0, 1e6  	"Speed limiter when the actuator position is increasing [pos/s]"
        REAL v_down_max = -4.    RANGE -1e6, 0  "Speed limiter when the actuator position is lowering , < 0 [pos/s)"
        REAL Y_min =    0.								"Minimum allowed actuator position" 
        REAL Y_max =  100.								"Maximum allowed actuator position" 
		  BOOLEAN init_flag = FALSE	 				"If TRUE, initial actuator position is Y_o. If FALSE, initial position is bounded demand position"
        REAL Y_o = 50.									"Initial actuator position"
    DECLS
        REAL v_bound       "Bounded position rate [pos/s]" 
        REAL v_unbound     "Unbounded position rate [pos/s]"
        REAL Y_dem_bound   "Bounded demand position [pos/s]" 
        REAL Y             "Actuator position"
        BOOLEAN init_event	"Event to execute the DISCRETE block at the beginning of the simulation to initialize the actuator position"
    INIT 
        init_event = TRUE 	
        Y = Y_o
   DISCRETE 
        WHEN(init_event == TRUE AND init_flag == FALSE) THEN
		  		 init_event = FALSE
				 
             IF     (s_pos_dem.signal[1] > Y_max) THEN
				      Y = Y_max
             ELSEIF (s_pos_dem.signal[1] < Y_min) THEN
				      Y = Y_min
             ELSE                                
				 	   Y = s_pos_dem.signal[1]
				 END IF 
        END WHEN      
    CONTINUOUS
        Y_dem_bound = IF     (s_pos_dem.signal[1] > Y_max) Y_max
                      ELSEIF (s_pos_dem.signal[1] < Y_min) Y_min
                      ELSE                                 s_pos_dem.signal[1]
                                    
         
        v_unbound = (Y_dem_bound - Y) /Tc
                
        v_bound = IF     (v_unbound > v_up_max)  v_up_max
                  ELSEIF (v_unbound < v_down_max) v_down_max 
                  ELSE    v_unbound


        Y' = v_bound
        s_pos_actual.signal[1] = Y
        
END COMPONENT  
