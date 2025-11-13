/*-----------------------------------------------------------------------------------------
 FILE: electrical_examples
-----------------------------------------------------------------------------------------*/
-- Libraries
USE MATH 
USE ELECTRICAL 

COMPONENT Amplifier
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.Amplifier
		-----------------------------------------------------------
	ELECTRICAL.VoltageSine V (Vpeak = 1,Voffset = 0,freqHz = 0.25,phase = 0,startTime = 0) 
	ELECTRICAL.Ground G
	ELECTRICAL.IdealOpAmp A (G = 1000000) 
	ELECTRICAL.Resistor RI (R = 100) 
	ELECTRICAL.Resistor RF (R = 400) 
	ELECTRICAL.Resistor Ra (R = 0.1) 

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.Amplifier
		-----------------------------------------------------------
	CONNECT G.e_p TO V.e_n
	CONNECT A.e_p1 TO V.e_p
	CONNECT A.e_n2 TO G.e_p
	CONNECT RF.e_n TO RI.e_p
	CONNECT A.e_n1 TO RI.e_p
	CONNECT G.e_p TO RI.e_n
	CONNECT A.e_p2 TO RF.e_p
	CONNECT A.e_p2 TO Ra.e_p
	CONNECT G.e_p TO Ra.e_n
END COMPONENT

COMPONENT CapacitorAndInductiveLoad
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.CapacitorAndInductiveLoad
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_1 (source = Source_Sine,Amp = 220,Tstart = 0,Offset = 0,Phase = 0,Period = 0.02,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	ELECTRICAL.Capacitor Capacitor_1 (C = 2.3e-06) 
	ELECTRICAL.Ground Ground_1
	ELECTRICAL.InductivePhasor Ind_component_1 (Real_component = 10,Imaginary_component = 15,Frequency = 50) 
	ELECTRICAL.InductivePhasor Ind_component_2 (Real_component = 100,Imaginary_component = 100,Frequency = 50) 
	ELECTRICAL.VoltageSignal VoltageSignal_1

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.CapacitorAndInductiveLoad
		-----------------------------------------------------------
	CONNECT AnalogSource_1.s_out TO VoltageSignal_1.s_in
	CONNECT Capacitor_1.e_n TO Ground_1.e_p
	CONNECT Capacitor_1.e_p TO Ind_component_2.pos
	CONNECT Ind_component_1.neg TO Capacitor_1.e_p
	CONNECT Ind_component_2.neg TO Ground_1.e_p
	CONNECT VoltageSignal_1.e_n TO Ground_1.e_p
	CONNECT VoltageSignal_1.e_p TO Ind_component_1.pos
END COMPONENT

COMPONENT CommonEmitterAmplifier
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.CommonEmitterAmplifier
		-----------------------------------------------------------
	ELECTRICAL.Capacitor Cin (C = 1e-05) 
	ELECTRICAL.Capacitor Cout (C = 0.0001) 
	ELECTRICAL.VoltageConstant VoltageConstant_1 (V = 10) 
	ELECTRICAL.Resistor Rc (R = 5000) 
	ELECTRICAL.Resistor Re (R = 500) 
	ELECTRICAL.Ground Ground_1
	ELECTRICAL.VoltageSine VoltageSine_1 (Vpeak = 0.25,Voffset = 0,freqHz = 200,phase = 0,startTime = 0) 
	ELECTRICAL.Resistor R1 (R = 9000) 
	ELECTRICAL.Resistor R2 (R = 1000) 
	ELECTRICAL.Resistor Rload (R = 50000) 
	ELECTRICAL.NPN NPN_1 (Bf = 50,Br = 0.1,Is = 1e-16,Vak = 0.02,Tauf = 1.2e-10,Taur = 5e-09,Ccs = 1e-12,Cje = 4e-13,Cjc = 5e-13,Phie = 0.8,Me = 0.4,Phic = 0.8,Mc = 0.333,Gbc = 1e-15,Gbe = 1e-15,Vt = 0.02585) 
	ELECTRICAL.Resistor R0 (R = 0.01) 

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.CommonEmitterAmplifier
		-----------------------------------------------------------
	CONNECT Rc.e_p TO VoltageConstant_1.e_p
	CONNECT Ground_1.e_p TO Re.e_n
	CONNECT Ground_1.e_p TO VoltageSine_1.e_n
	CONNECT R1.e_p TO Rc.e_p
	CONNECT Ground_1.e_p TO R2.e_n
	CONNECT Ground_1.e_p TO VoltageConstant_1.e_n
	CONNECT Cin.e_p TO VoltageSine_1.e_p
	CONNECT Cout.e_n TO Rload.e_p
	CONNECT Ground_1.e_p TO Rload.e_n
	CONNECT NPN_1.e_C TO Rc.e_n
	CONNECT Cout.e_p TO NPN_1.e_C
	CONNECT NPN_1.e_B TO R1.e_n
	CONNECT NPN_1.e_B TO R2.e_p
	CONNECT NPN_1.e_E TO Re.e_p
	CONNECT Cin.e_n TO R0.e_p
	CONNECT R0.e_n TO NPN_1.e_B
END COMPONENT

COMPONENT DiodeAndInductiveLoad
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.DiodeAndInductiveLoad
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_1 (source = Source_Sine,Amp = 220,Tstart = 0,Offset = 0,Phase = 0,Period = 0.02,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	ELECTRICAL.Diode Diode_1 (Ids = 1e-06,Vt = 0.04,R = 100000000) 
	ELECTRICAL.Ground Ground_1
	ELECTRICAL.Ground Ground_2
	ELECTRICAL.IdealTransformer IdealTransformer_1 (n = 0.25) 
	ELECTRICAL.InductivePhasor Ind_component_2 (Real_component = 1,Imaginary_component = 1,Frequency = 50) 
	ELECTRICAL.VoltageSignal VoltageSignal_1

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.DiodeAndInductiveLoad
		-----------------------------------------------------------
	CONNECT AnalogSource_1.s_out TO VoltageSignal_1.s_in
	CONNECT Diode_1.e_n TO Ind_component_2.pos
	CONNECT IdealTransformer_1.e_p2 TO Diode_1.e_p
	CONNECT IdealTransformer_1.e_n1 TO Ground_1.e_p
	CONNECT IdealTransformer_1.e_n2 TO Ground_2.e_p
	CONNECT Ind_component_2.neg TO Ground_2.e_p
	CONNECT VoltageSignal_1.e_n TO Ground_1.e_p
	CONNECT VoltageSignal_1.e_p TO IdealTransformer_1.e_p1
END COMPONENT

COMPONENT ElectronicMultiplexer
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.ElectronicMultiplexer
		-----------------------------------------------------------
	ELECTRICAL.VoltageSine VoltageSine_1 (Vpeak = 5,Voffset = 0,freqHz = 0.5,phase = 0,startTime = 0) 
	ELECTRICAL.VoltageSine VoltageSine_2 (Vpeak = 5,Voffset = 0,freqHz = 1,phase = 0,startTime = 0) 
	ELECTRICAL.VoltageSine VoltageSine_3 (Vpeak = 5,Voffset = 0,freqHz = 1.5,phase = 0,startTime = 0) 
	ELECTRICAL.VoltageSine VoltageSine_4 (Vpeak = 5,Voffset = 0,freqHz = 2,phase = 0,startTime = 0) 
	ELECTRICAL.Multiplexer electronic_mux_4_1
	ELECTRICAL.Resistor Resistor (R = 1) 
	ELECTRICAL.Ground Ground

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.ElectronicMultiplexer
		-----------------------------------------------------------
	CONNECT electronic_mux_4_1.out TO Resistor.e_p
	CONNECT VoltageSine_2.e_p TO electronic_mux_4_1.in_2
	CONNECT VoltageSine_3.e_p TO electronic_mux_4_1.in_3
	CONNECT VoltageSine_4.e_p TO electronic_mux_4_1.in_4
	CONNECT Resistor.e_n TO Ground.e_p
	CONNECT VoltageSine_4.e_n TO Ground.e_p
	CONNECT VoltageSine_3.e_n TO Ground.e_p
	CONNECT VoltageSine_2.e_n TO Ground.e_p
	CONNECT VoltageSine_1.e_n TO Ground.e_p
	CONNECT VoltageSine_1.e_p TO electronic_mux_4_1.in_1
END COMPONENT

COMPONENT FilterExamples
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.FilterExamples
		-----------------------------------------------------------
	CONTROL.Addition  (n = 1) Addition_1
	CONTROL.Addition  (n = 1) Addition_2
	CONTROL.AnalogSource  (n_out = 1) High_freq (source = Source_Sine,Amp = 5,Tstart = 0,Offset = 0,Phase = 0,Period = 0.02,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Low_freq (source = Source_Sine,Amp = 5,Tstart = 0,Offset = 0,Phase = 0,Period = 2,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Mid_freq (source = Source_Sine,Amp = 5,Tstart = 0,Offset = 0,Phase = 0,Period = 0.2,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	ELECTRICAL.Capacitor Capacitor_1 (C = 4e-06) 
	ELECTRICAL.Capacitor Capacitor_1_1 (C = 1e-07) 
	ELECTRICAL.Capacitor Capacitor_1_1_1 (C = 1e-07) 
	ELECTRICAL.Capacitor Capacitor_1_2 (C = 1e-09) 
	ELECTRICAL.Ground Ground_1
	ELECTRICAL.Ground Ground_1_1
	ELECTRICAL.Ground Ground_1_1_1
	ELECTRICAL.Resistor Resistor_1 (R = 1000) 
	ELECTRICAL.Resistor Resistor_1_1 (R = 3062224.4) 
	ELECTRICAL.Resistor Resistor_1_1_1 (R = 19904459) 
	ELECTRICAL.Resistor Resistor_1_2 (R = 530786) 
	ELECTRICAL.Resistor Resistor_2 (R = 1) 
	ELECTRICAL.Resistor Resistor_2_1 (R = 1) 
	ELECTRICAL.Resistor Resistor_3 (R = 1) 
	ELECTRICAL.VoltageSignal VoltageSignal_1
	ELECTRICAL.VoltageSignal VoltageSignal_1_1
	ELECTRICAL.VoltageSignal VoltageSignal_1_1_1

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.FilterExamples
		-----------------------------------------------------------
	CONNECT Addition_1.s_out TO Addition_2.s_in_1
	CONNECT Addition_2.s_out TO VoltageSignal_1.s_in
	CONNECT Addition_2.s_out TO VoltageSignal_1_1.s_in
	CONNECT Addition_2.s_out TO VoltageSignal_1_1_1.s_in
	CONNECT High_freq.s_out TO Addition_1.s_in_2
	CONNECT Low_freq.s_out TO Addition_2.s_in_2
	CONNECT Mid_freq.s_out TO Addition_1.s_in_1
	CONNECT Capacitor_1.e_n TO Resistor_1.e_p
	CONNECT Capacitor_1.e_n TO Resistor_2.e_p
	CONNECT Capacitor_1_1.e_n TO Ground_1_1.e_p
	CONNECT Capacitor_1_1_1.e_n TO Ground_1_1_1.e_p
	CONNECT Capacitor_1_2.e_n TO Resistor_1_1_1.e_p
	CONNECT Capacitor_1_2.e_n TO Resistor_1_2.e_p
	CONNECT Resistor_1.e_n TO Ground_1.e_p
	CONNECT Resistor_1_1.e_n TO Capacitor_1_1.e_p
	CONNECT Resistor_1_1.e_n TO Resistor_2_1.e_p
	CONNECT Resistor_1_1_1.e_n TO Capacitor_1_1_1.e_p
	CONNECT Resistor_1_1_1.e_n TO Resistor_3.e_p
	CONNECT Resistor_1_2.e_n TO Ground_1_1_1.e_p
	CONNECT Resistor_2.e_n TO Ground_1.e_p
	CONNECT Resistor_2_1.e_n TO Ground_1_1.e_p
	CONNECT Resistor_3.e_n TO Ground_1_1_1.e_p
	CONNECT VoltageSignal_1.e_p TO Capacitor_1.e_p
	CONNECT VoltageSignal_1.e_n TO Ground_1.e_p
	CONNECT VoltageSignal_1_1.e_n TO Ground_1_1.e_p
	CONNECT VoltageSignal_1_1.e_p TO Resistor_1_1.e_p
	CONNECT VoltageSignal_1_1_1.e_p TO Capacitor_1_2.e_p
	CONNECT VoltageSignal_1_1_1.e_n TO Ground_1_1_1.e_p
INIT

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.FilterExamples
		-----------------------------------------------------------
	Capacitor_1.v = 0
	Capacitor_1_1.v = 0
END COMPONENT

COMPONENT InductiveAndCapacitive
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.InductiveAndCapacitive
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_1 (source = Source_Sine,Amp = 220,Tstart = 0,Offset = 0,Phase = 0,Period = 0.02,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	ELECTRICAL.CapacitivePhasor cap_component_1 (Real_component = 1,Imaginary_component = 1,Frequency = 50) 
	ELECTRICAL.Ground Ground_1
	ELECTRICAL.InductivePhasor Ind_component_1 (Real_component = 1,Imaginary_component = 1,Frequency = 50) 
	ELECTRICAL.VoltageSignal VoltageSignal_1

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.InductiveAndCapacitive
		-----------------------------------------------------------
	CONNECT AnalogSource_1.s_out TO VoltageSignal_1.s_in
	CONNECT cap_component_1.neg TO Ground_1.e_p
	CONNECT Ind_component_1.neg TO cap_component_1.pos
	CONNECT VoltageSignal_1.e_n TO Ground_1.e_p
	CONNECT VoltageSignal_1.e_p TO Ind_component_1.pos
END COMPONENT

COMPONENT P_ideal_amp
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.P_ideal_amp
		-----------------------------------------------------------
	ELECTRICAL.VoltageSine V (Vpeak = 1,Voffset = 0,freqHz = 0.25,phase = 0,startTime = 0) 
	ELECTRICAL.Ground G
	ELECTRICAL.Resistor RI (R = 1) 
	ELECTRICAL.Resistor RF (R = 1) 
	ELECTRICAL.Resistor Ra (R = 100000000) 
	ELECTRICAL.IdealOpAmp A (G = 1000000) 

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.P_ideal_amp
		-----------------------------------------------------------
	CONNECT G.e_p TO RI.e_n
	CONNECT G.e_p TO V.e_n
	CONNECT RF.e_n TO RI.e_p
	CONNECT G.e_p TO Ra.e_n
	CONNECT A.e_p2 TO Ra.e_p
	CONNECT A.e_n2 TO RF.e_p
	CONNECT A.e_n1 TO RI.e_p
	CONNECT A.e_p1 TO V.e_p
END COMPONENT

COMPONENT Thyristors
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.Thyristors
		-----------------------------------------------------------
	CONTROL.SourcebPulse  (n_out = 1) Switch (Period = 15,pulseWidth = 1,Tstart = 1) 
	CONTROL.SourcebPulse  (n_out = 1) Switch_1 (Period = 15,pulseWidth = 1,Tstart = 1) 
	ELECTRICAL.Ground Ground
	ELECTRICAL.Ground Ground_1
	ELECTRICAL.IdealGTOThyristor GTO_Thyristor (Roff = 1e-05,Gon = 1e-05) 
	ELECTRICAL.IdealThyristor Thyristor (Roff = 1e-05,Gon = 1e-05) 
	ELECTRICAL.Resistor Resistor (R = 1) 
	ELECTRICAL.Resistor Resistor_1 (R = 1) 
	ELECTRICAL.VoltageSine AC_Current (Vpeak = 220,Voffset = 0,freqHz = 10,phase = 0,startTime = 0) 
	ELECTRICAL.VoltageSine AC_Current_1 (Vpeak = 220,Voffset = 0,freqHz = 10,phase = 0,startTime = 0) 

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.Thyristors
		-----------------------------------------------------------
	CONNECT Switch.s_out TO Thyristor.b_fire
	CONNECT Switch_1.s_out TO GTO_Thyristor.b_fire
	CONNECT GTO_Thyristor.e_n TO Resistor_1.e_p
	CONNECT Thyristor.e_n TO Resistor.e_p
	CONNECT Resistor.e_n TO Ground.e_p
	CONNECT Resistor_1.e_n TO Ground_1.e_p
	CONNECT AC_Current.e_n TO Ground.e_p
	CONNECT AC_Current.e_p TO Thyristor.e_p
	CONNECT AC_Current_1.e_n TO Ground_1.e_p
	CONNECT AC_Current_1.e_p TO GTO_Thyristor.e_p
END COMPONENT

COMPONENT Transformer
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.Transformer
		-----------------------------------------------------------
	ELECTRICAL.VoltageSignal VoltageSignal_1
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_1 (source = Source_Sine,Amp = 220,Tstart = 0,Offset = 0,Phase = 0,Period = 0.02,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	ELECTRICAL.Ground Ground_1
	ELECTRICAL.IdealTransformer IdealTransformer_1 (n = 0.25) 
	ELECTRICAL.Ground Ground_2
	ELECTRICAL.InductivePhasor Ind_component_1 (Real_component = 1,Imaginary_component = 1,Frequency = 50) 
	ELECTRICAL.InductivePhasor Ind_component_2 (Real_component = 1,Imaginary_component = 1,Frequency = 50) 

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.Transformer
		-----------------------------------------------------------
	CONNECT AnalogSource_1.s_out TO VoltageSignal_1.s_in
	CONNECT VoltageSignal_1.e_n TO Ground_1.e_p
	CONNECT IdealTransformer_1.e_n1 TO Ground_1.e_p
	CONNECT IdealTransformer_1.e_n2 TO Ground_2.e_p
	CONNECT VoltageSignal_1.e_p TO Ind_component_1.pos
	CONNECT Ind_component_1.neg TO IdealTransformer_1.e_p1
	CONNECT IdealTransformer_1.e_p2 TO Ind_component_2.pos
	CONNECT Ind_component_2.neg TO Ground_2.e_p
END COMPONENT

COMPONENT Transistor
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.Transistor
		-----------------------------------------------------------
	ELECTRICAL.Ground Ground_1
	ELECTRICAL.NPN NPN_1 (Bf = 50,Br = 0.1,Is = 1e-16,Vak = 0.02,Tauf = 1.2e-10,Taur = 5e-09,Ccs = 1e-12,Cje = 4e-13,Cjc = 5e-13,Phie = 0.8,Me = 0.4,Phic = 0.8,Mc = 0.333,Gbc = 1e-15,Gbe = 1e-15,Vt = 0.02585) 
	ELECTRICAL.Resistor Resistor_1 (R = 100) 
	ELECTRICAL.Resistor Resistor_2 (R = 1000) 
	ELECTRICAL.VoltageConstant DC_Source (V = 3.3) 
	ELECTRICAL.VoltageConstant VoltageConstant_1 (V = 220) 

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.Transistor
		-----------------------------------------------------------
	CONNECT NPN_1.e_E TO Resistor_2.e_p
	CONNECT NPN_1.e_C TO VoltageConstant_1.e_n
	CONNECT Resistor_1.e_n TO NPN_1.e_B
	CONNECT Resistor_2.e_n TO Ground_1.e_p
	CONNECT DC_Source.e_n TO Ground_1.e_p
	CONNECT DC_Source.e_p TO Resistor_1.e_p
	CONNECT VoltageConstant_1.e_p TO Ground_1.e_p
END COMPONENT

COMPONENT basicCircuit
PORTS

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.basicCircuit
		-----------------------------------------------------------
	IN PORTS_LIB.elec Elec1 CARDINALITY 0,2147483647 
	IN PORTS_LIB.elec Elec2 CARDINALITY 0,2147483647 
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.basicCircuit
		-----------------------------------------------------------
	ELECTRICAL.VoltageSine VAC1 (Vpeak = 10,Voffset = 0,freqHz = 50,phase = 0,startTime = 0) 
	ELECTRICAL.Capacitor C1 (C = 5e-05) 
	ELECTRICAL.Resistor R1 (R = 5500) 
	ELECTRICAL.Ground G1

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.basicCircuit
		-----------------------------------------------------------
	CONNECT VAC1.e_p TO C1.e_p
	CONNECT C1.e_n TO R1.e_p
	CONNECT R1.e_n TO VAC1.e_n
	CONNECT VAC1.e_n TO G1.e_p
	CONNECT Elec2 TO C1.e_n
	CONNECT Elec1 TO C1.e_p
END COMPONENT

COMPONENT diodeBridge
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.diodeBridge
		-----------------------------------------------------------
	ELECTRICAL.Ground Ground1
	ELECTRICAL.IdealDiode D4 (Roff = 0.1,Gon = 1e-06) 
	ELECTRICAL.IdealDiode D3 (Roff = 0.1,Gon = 1e-06) 
	ELECTRICAL.IdealDiode D2 (Roff = 0.1,Gon = 1e-06) 
	ELECTRICAL.IdealDiode D1 (Roff = 0.1,Gon = 1e-06) 
	ELECTRICAL.VoltageSine VAC1 (Vpeak = 10,Voffset = 0,freqHz = 50,phase = 0,startTime = 0) 
	ELECTRICAL.Resistor R1 (R = 1000) 
	ELECTRICAL.Capacitor C1 (C = 0.0001) 

		-----------------------------------------------------------
		-- Coded in ELECTRICAL_EXAMPLES.diodeBridge
		-----------------------------------------------------------
	CONNECT C1.e_n TO R1.e_n
	CONNECT D4.e_n TO Ground1.e_p
	CONNECT D3.e_p TO D4.e_n
	CONNECT D1.e_p TO D2.e_n
	CONNECT D4.e_n TO VAC1.e_n
	CONNECT D1.e_n TO R1.e_p
	CONNECT D1.e_n TO D3.e_n
	CONNECT C1.e_p TO D1.e_n
	CONNECT C1.e_n TO D2.e_p
	CONNECT C1.e_n TO D4.e_p
	CONNECT D1.e_p TO VAC1.e_p
END COMPONENT
