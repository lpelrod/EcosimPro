/*-----------------------------------------------------------------------------------------
 FILE: control_examples
-----------------------------------------------------------------------------------------*/
USE MATH 
USE CONTROL 
COMPONENT Example_Conditionals
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Conditionals
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) Signal_1 (source = Source_Sine,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal_2 (source = Source_Sine,Amp = 1,Tstart = 2,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.EQ Equal
	CONTROL.GE Greater_or_equal
	CONTROL.GT Greater
	CONTROL.LE Less_or_equal
	CONTROL.LT Less

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Conditionals
		-----------------------------------------------------------
	CONNECT Signal_1.s_out TO Equal.s_in_1
	CONNECT Signal_1.s_out TO Greater_or_equal.s_in_1
	CONNECT Signal_1.s_out TO Greater.s_in_1
	CONNECT Signal_1.s_out TO Less_or_equal.s_in_1
	CONNECT Signal_1.s_out TO Less.s_in_1
	CONNECT Signal_2.s_out TO Equal.s_in_2
	CONNECT Signal_2.s_out TO Greater_or_equal.s_in_2
	CONNECT Signal_2.s_out TO Greater.s_in_2
	CONNECT Signal_2.s_out TO Less_or_equal.s_in_2
	CONNECT Signal_2.s_out TO Less.s_in_2
END COMPONENT

COMPONENT Example_Controllers
DECLS

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Controllers
		-----------------------------------------------------------
	REAL error_p
	REAL error_pi
	REAL error_pid
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Controllers
		-----------------------------------------------------------
	CONTROL.Addition  (n = 1) Addition_1
	CONTROL.Addition  (n = 1) Addition_2
	CONTROL.Addition  (n = 1) Addition_3
	CONTROL.AnalogSource  (n_out = 1) Set_point (source = Source_Step,Amp = 1,Tstart = 5,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal (source = Source_Pulse,Amp = 2,Tstart = 8,Offset = 0,Phase = 0,Period = 1000,pulseWidth = 1,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.Cntrl_P  (n = 1) P_Cntrl (k = 10,u_min = -100,u_max = 100) 
	CONTROL.Cntrl_PI  (n = 1) PI_Cntrl (k = 10,u_min = -100,u_max = 100,end_pos = end_I,Ti = 10,gamma = 0.1,beta = 1) 
	CONTROL.Cntrl_PID  (n = 1) PID_Cntrl (k = 10,u_min = -100,u_max = 100,end_pos = end_I,Ti = 10,gamma = 0.1,beta = 1,Td = 1,alpha = 0.1) 
	CONTROL.TF_2ndOrder  (n = 1) Plant (frec = 2,damp = 0.25,gain = 0.25,output_o = 0) 
	CONTROL.TF_2ndOrder  (n = 1) Plant_1 (frec = 2,damp = 0.25,gain = 0.25,output_o = 0) 
	CONTROL.TF_2ndOrder  (n = 1) Plant_2 (frec = 2,damp = 0.25,gain = 0.25,output_o = 0) 

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Controllers
		-----------------------------------------------------------
	CONNECT Addition_1.s_out TO Plant.s_in
	CONNECT Addition_2.s_out TO Plant_1.s_in
	CONNECT Addition_3.s_out TO Plant_2.s_in
	CONNECT Set_point.s_out TO P_Cntrl.s_set
	CONNECT Set_point.s_out TO PI_Cntrl.s_set
	CONNECT Set_point.s_out TO PID_Cntrl.s_set
	CONNECT Signal.s_out TO Addition_1.s_in_1
	CONNECT Signal.s_out TO Addition_2.s_in_1
	CONNECT Signal.s_out TO Addition_3.s_in_1
	CONNECT P_Cntrl.s_out TO Addition_3.s_in_2
	CONNECT PI_Cntrl.s_out TO Addition_1.s_in_2
	CONNECT PID_Cntrl.s_out TO Addition_2.s_in_2
	CONNECT Plant.s_out TO PI_Cntrl.s_var
	CONNECT Plant_1.s_out TO PID_Cntrl.s_var
	CONNECT Plant_2.s_out TO P_Cntrl.s_var
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Controllers
		-----------------------------------------------------------
	error_p = abs(Plant_2.s_out.signal[1] - Set_point.s_out.signal[1])
	error_pi = abs(Plant.s_out.signal[1] - Set_point.s_out.signal[1])
	error_pid = abs(Plant_1.s_out.signal[1] - Set_point.s_out.signal[1])
END COMPONENT


COMPONENT Example_Counters
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Counters
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) PV_Up (source = Source_Constant,Amp = 5,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.BooleanToReal  (n = 1) BooleanToReal (ValueTrue = 1,ValueFalse = 0) 
	CONTROL.CLK CLK_1 (Period = 1,pulseWidth = 0.5,Tstart = 0) 
	CONTROL.Counter_DOWN Counter_DOWN (PVmin = 0) 
	CONTROL.Counter_UP Counter_UP (PVmax = 100) 
	CONTROL.Counter_UP_DOWN Counter_UP_DOWN (PVmax = 100,PVmin = 0) 
	CONTROL.Delay  (n = 1) Delay (tdelay = 5) 
	CONTROL.RealToBoolean  (n = 1) RealToBoolean (ValueTrue = 0.5,ValueFalse = 0.5) 
	CONTROL.SourcebConstant  (n_out = 1) SourcebConstant_1 (k =  TRUE ) 
	CONTROL.SourcebPulse  (n_out = 1) OnOff_signal (Period = 10,pulseWidth = 5,Tstart = 0) 

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Counters
		-----------------------------------------------------------
	CONNECT PV_Up.s_out TO Counter_DOWN.s_in
	CONNECT PV_Up.s_out TO Counter_UP.s_in
	CONNECT PV_Up.s_out TO Counter_UP_DOWN.s_in
	CONNECT BooleanToReal.s_out TO Delay.s_in
	CONNECT Counter_DOWN.Q TO Counter_DOWN.LD
	CONNECT Counter_UP.Q TO Counter_UP.RESET
	CONNECT Delay.s_out TO RealToBoolean.s_in
	CONNECT RealToBoolean.s_out TO Counter_UP_DOWN.CD
	CONNECT SourcebConstant_1.s_out TO Counter_DOWN.CD
	CONNECT SourcebConstant_1.s_out TO Counter_UP.CU
	CONNECT OnOff_signal.s_out TO BooleanToReal.s_in
	CONNECT OnOff_signal.s_out TO Counter_UP_DOWN.CU
END COMPONENT


COMPONENT Example_LogicGates
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_LogicGates
		-----------------------------------------------------------
	CONTROL.Gate_AND AND_1
	CONTROL.Gate_NOT NOT_1
	CONTROL.Gate_OR OR_1
	CONTROL.Gate_XOR XOR
	CONTROL.SourcebPulse  (n_out = 1) SourcebPulse_1 (Period = 10,pulseWidth = 5,Tstart = 5) 
	CONTROL.SourcebPulse  (n_out = 1) SourcebPulse_2 (Period = 5,pulseWidth = 2.5,Tstart = 2.5) 

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_LogicGates
		-----------------------------------------------------------
	CONNECT SourcebPulse_1.s_out TO AND_1.s_in_1
	CONNECT SourcebPulse_1.s_out TO OR_1.s_in_1
	CONNECT SourcebPulse_1.s_out TO XOR.s_in_1
	CONNECT SourcebPulse_2.s_out TO AND_1.s_in_2
	CONNECT SourcebPulse_2.s_out TO NOT_1.s_in
	CONNECT SourcebPulse_2.s_out TO OR_1.s_in_2
	CONNECT SourcebPulse_2.s_out TO XOR.s_in_2
END COMPONENT

COMPONENT Example_Switches
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Switches
		-----------------------------------------------------------
	CONTROL.LogicalSwitch  (n = 1) LogicalSwitch_1
	CONTROL.SourceChirp  (n_out = 1) SourceChirp (Amp = 1,frec_o = 0.1,Phase = 0,Tstart = 0,Offset = 0,frec_slope = 0.1) 
	CONTROL.SourceExp  (n_out = 1) SourceExp (outMax = 1,riseTime = 5,riseTimeConst = 5,fallTimeConst = 5,Tstart = 0.5,Offset = 0) 
	CONTROL.SourcebPulse  (n_out = 1) SourcebPulse (Period = 4,pulseWidth = 2,Tstart = 1) 
	CONTROL.SourcebSampleTrigger  (n_out = 1) SourcebSampleTrigger_1 (Period = 1,Tstart = 1) 
	CONTROL.SourcebStep  (n_out = 1) SourcebStep_1 (Tstart = 1) 
	CONTROL.Switch  (n = 1) Switch_1
	CONTROL.Timer_TP Timer_TP (PT = 2) 

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Switches
		-----------------------------------------------------------
	CONNECT LogicalSwitch_1.s_out TO Timer_TP.s_in
	CONNECT SourceChirp.s_out TO Switch_1.s_in[1]
	CONNECT SourceExp.s_out TO Switch_1.s_in[2]
	CONNECT SourcebPulse.s_out TO LogicalSwitch_1.s_in[2]
	CONNECT SourcebPulse.s_out TO Switch_1.s_b_in
	CONNECT SourcebSampleTrigger_1.s_out TO LogicalSwitch_1.s_in[3]
	CONNECT SourcebStep_1.s_out TO LogicalSwitch_1.s_in[1]
END COMPONENT

COMPONENT Example_Timers
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Timers
		-----------------------------------------------------------
	CONTROL.SourcebPulse  (n_out = 1) SourcebPulse_1 (Period = 7,pulseWidth = 3,Tstart = 1) 
	CONTROL.Timer_TOFF Timer_TOFF_1 (PT = 2) 
	CONTROL.Timer_TON Timer_TON_1 (PT = 2) 
	CONTROL.Timer_TP Timer_TP_1 (PT = 2) 

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Example_Timers
		-----------------------------------------------------------
	CONNECT SourcebPulse_1.s_out TO Timer_TOFF_1.s_in
	CONNECT SourcebPulse_1.s_out TO Timer_TON_1.s_in
	CONNECT SourcebPulse_1.s_out TO Timer_TP_1.s_in
END COMPONENT

COMPONENT LinearSystem
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.LinearSystem
		-----------------------------------------------------------
	CONTROL.Addition  (n = 1) summer_1
	CONTROL.Addition  (n = 1) summer_2
	CONTROL.Subtraction  (n = 1) comparator
	CONTROL.Gain  (n = 1) amplifier (k = { 1438} ) 
	CONTROL.TransferFunction  (n_num = 2,n_den = 2) compensator (p = { 1,2,1} ,q = { 1,28,160} ,output_o = 0) 
	CONTROL.TransferFunction  (n_num = 0,n_den = 3) process_plant (p = { 1} ,q = { 1,3.2,3.56,0} ,output_o = 0) 

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.LinearSystem
		-----------------------------------------------------------
	CONNECT comparator.s_out TO amplifier.s_in
	CONNECT amplifier.s_out TO summer_1.s_in_1
	CONNECT summer_1.s_out TO compensator.s_in
	CONNECT compensator.s_out TO summer_2.s_in_1
	CONNECT summer_2.s_out TO process_plant.s_in
	CONNECT process_plant.s_out TO comparator.s_in_2
END COMPONENT

COMPONENT Multiplexers
DECLS

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Multiplexers
		-----------------------------------------------------------
	REAL Period UNITS "s"
	REAL Period_2 UNITS "s"
	INTEGER i = 1
	INTEGER j = 1
	INTEGER start_time = 0
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Multiplexers
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_1 (source = Source_Constant,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = 1,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_2 (source = Source_Constant,Amp = 2,Tstart = 0,Offset = 0,Phase = 0,Period = 2,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_3 (source = Source_Constant,Amp = 3,Tstart = 0,Offset = 0,Phase = 0,Period = 3,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_4 (source = Source_Constant,Amp = 4,Tstart = 0,Offset = 0,Phase = 0,Period = 4,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_5 (source = Source_Constant,Amp = 5,Tstart = 0,Offset = 0,Phase = 0,Period = 5,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Output_signal (source = Source_Sine,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = Period,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Output_signal_2 (source = Source_Sine,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = Period_2,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal_1 (source = Source_Constant,Amp = 4,Tstart = 0,Offset = 0,Phase = 0,Period = 1,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal_1_1 (source = Source_Constant,Amp = 5,Tstart = 0,Offset = 0,Phase = 0,Period = 2,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal_1_2 (source = Source_Constant,Amp = 6,Tstart = 0,Offset = 0,Phase = 0,Period = 3,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal_1_3 (source = Source_Constant,Amp = 7,Tstart = 0,Offset = 0,Phase = 0,Period = 4,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal_1_4 (source = Source_Constant,Amp = 8,Tstart = 0,Offset = 0,Phase = 0,Period = 5,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal_1_5 (source = Source_Constant,Amp = 9,Tstart = 0,Offset = 0,Phase = 0,Period = 6,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal_1_6 (source = Source_Constant,Amp = 10,Tstart = 0,Offset = 0,Phase = 0,Period = 7,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Signal_1_7 (source = Source_Constant,Amp = 11,Tstart = 0,Offset = 0,Phase = 0,Period = 8,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.Mux  (n_in = 5,dim_in = 1) Mux
	CONTROL.Mux8  (dim_in = 1) Mux8_1

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Multiplexers
		-----------------------------------------------------------
	CONNECT AnalogSource_1.s_out TO Mux.s_in[3]
	CONNECT AnalogSource_2.s_out TO Mux.s_in[2]
	CONNECT AnalogSource_3.s_out TO Mux.s_in[1]
	CONNECT AnalogSource_4.s_out TO Mux.s_in[4]
	CONNECT AnalogSource_5.s_out TO Mux.s_in[5]
	CONNECT Signal_1.s_out TO Mux8_1.s_in[1]
	CONNECT Signal_1_1.s_out TO Mux8_1.s_in[2]
	CONNECT Signal_1_2.s_out TO Mux8_1.s_in[3]
	CONNECT Signal_1_3.s_out TO Mux8_1.s_in[4]
	CONNECT Signal_1_4.s_out TO Mux8_1.s_in[5]
	CONNECT Signal_1_5.s_out TO Mux8_1.s_in[6]
	CONNECT Signal_1_6.s_out TO Mux8_1.s_in[7]
	CONNECT Signal_1_7.s_out TO Mux8_1.s_in[8]
DISCRETE

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Multiplexers
		-----------------------------------------------------------
	WHEN (TIME > start_time)  THEN
	Period = Mux8_1.s_out.signal[i]
	Period_2 = Mux.s_out.signal[j]
	i = i + 1
	j = j + 1
	start_time = start_time + 5
	END WHEN
	WHEN (i > 8)  THEN
	i = 1
	END WHEN
	WHEN (j > 5)  THEN
	j = 1
	END WHEN
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Multiplexers
		-----------------------------------------------------------
	Output_signal.Period = Period
	Output_signal_2.Period = Period_2
END COMPONENT

COMPONENT Random_generation
DECLS

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Random_generation
		-----------------------------------------------------------
	REAL x UNITS "-"
	REAL y UNITS "-"
	REAL z UNITS "-"
	REAL u UNITS "-"
	REAL v UNITS "-"
	REAL w UNITS "-"
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Random_generation
		-----------------------------------------------------------
	RandomSource  (random = Uniform,iseed = 1500) Unif (a = 0,b = 1) 
	RandomSource  (random = Gaussian,iseed = 1500) Gauss (mu = 0,sigma = 1) 
	RandomSource  (random = Exponential,iseed = 1500) Expon (lambda = 1) 
	RandomSource  (random = Poisson,iseed = 1500) Pois (xm = 1) 
	RandomSource  (random = Gamma,iseed = 1500) Gamm (order = 3) 
	RandomSource  (random = Binomial,iseed = 1500) Binom (n = 10,p = 0.5) 
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.Random_generation
		-----------------------------------------------------------
	x = Unif.s_out.signal[1]
	y = Gauss.s_out.signal[1]
	z = Pois.s_out.signal[1]
	u = Expon.s_out.signal[1]
	v = Gamm.s_out.signal[1]
	w = Binom.s_out.signal[1]
END COMPONENT

COMPONENT WindUp_Example
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.WindUp_Example
		-----------------------------------------------------------
	CONTROL.Cntrl_PI  (n = 1) PI (k = { 1} ,u_min = { -0.1} ,u_max = { 0.1} ,end_pos = end_PI,Ti = { 1} ,gamma = { 100000000} ,beta = { 1} ) 
	CONTROL.Integrator  (n = 1) Integrator (output_o = { 0} ) 

		-----------------------------------------------------------
		-- Coded in CONTROL_EXAMPLES.WindUp_Example
		-----------------------------------------------------------
	CONNECT Integrator.s_out TO PI.s_var
	CONNECT PI.s_out TO Integrator.s_in
END COMPONENT
