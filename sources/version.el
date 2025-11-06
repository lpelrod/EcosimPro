-- Define the version, date, author and comments associated to this library
#LIBRARY_INFO
  #VERSION = "5.0.4" --MAS Edit: number of version to be defined. Corresponding changes described below (version 5.0.X)
  #DATE = "02/11/23"
  #AUTHOR= "EAI" 
  #COMMENTS= "Some components were added: timers, counters, signal treatment components,edge detection triggers, bistable elements, comparisson components, divisor and MOVE component. Standard units.\
  					version 4.0.0: palette of symbos updated. Components modified to detect properly the events (DISCRETE block instead SEQUENTIAL): \
					               SR_Bistable, RS_Bistable, EQ, NEQ, LE, LT, GE, LT, GE, GT, Move, Trigger_RE, Trigger_FE, Timer_TON, Timer_TOFF, Timer_TP.\
					version 4.0.1: Updated Custom Editor of the AnalogSource component\
					version 4.0.2: Updated library dependencies\
					version 4.0.3: Added file categories. Modified Hysteresis component and symbol\
					version 4.0.4: Added new DATA in Derivative component to initialize the dynamic variable.\
					version 4.0.5: Changed STRING type by FILEPATH in SourceDataFile component.\
					version 4.0.6: AnalogSource component to include amplitude as a parameter.\
					version 4.0.7: Source files saved with UTF-8 format.\
										Added principal variable labels in symbols.\
					version 5.0.0: The capability of array of ports is used in Demux, Mux, AdditionMulti and Product Multi \
										PI and PID controller with external tracking added\
										Actuator and RateLimiter components added\
					version 5.0.1: Fixed bug (2631): Variable signal must be out of the EXPAND_BLOCK to avoid redudancy of equations\
					version 5.0.3: Minor changes in Derivative variable name (spr1754)\
					version 5.0.4: Minor changes in Actuator component (spr2949)"
END #LIBRARY_INFO
