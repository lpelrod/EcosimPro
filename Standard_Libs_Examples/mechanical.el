/*-----------------------------------------------------------------------------------------
 FILE: mechanical
-----------------------------------------------------------------------------------------*/

-- Libraries
USE MATH 
USE MECHANICAL 

COMPONENT Example_2DegreeOfFreedomSystem
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_2DegreeOfFreedomSystem
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) Force_val (source = Source_Constant,Amp = 20,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.T_ActuatorForce Force
	MECHANICAL.T_FixedPosition Wall (s0 = 0) 
	MECHANICAL.T_SlidingMass Mass_1 (m = 1,s0 = 1,v0 = 0) 
	MECHANICAL.T_SlidingMass Mass_2 (m = 1,s0 = 2,v0 = 0) 
	MECHANICAL.T_Spring Spring (k = 1,s_rel0 = 1) 
	MECHANICAL.T_SpringDamper SpringDamper (d = 1,k = 1,s_rel0 = 1) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_2DegreeOfFreedomSystem
		-----------------------------------------------------------
	CONNECT Force_val.s_out TO Force.s_in
	CONNECT Force.m_out TO Mass_2.m_in
	CONNECT Wall.m_out TO SpringDamper.m_in
	CONNECT Mass_1.m_out TO Spring.m_in
	CONNECT Spring.m_out TO Mass_2.m_in
	CONNECT SpringDamper.m_out TO Mass_1.m_in
END COMPONENT

COMPONENT Example_Brake
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Brake
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_1 (source = Source_Step,Amp = 20,Tstart = 10,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.R_ActuatorTorque Rand_Torque
	MECHANICAL.R_Brake Brake (mue_pos = { { 0,1} ,{ 0.5,0.5} } ,peak = 1.1,cgeo = 1,fn_max = 20,w_i = 0) 
	MECHANICAL.R_FixedVelocity R_FixedVelocity_1 (w0 = 0) 
	MECHANICAL.R_GearIdeal R_GearIdeal_1 (ratio = 1) 
	MECHANICAL.R_Inertia R_Inertia_1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_2 (I = 3,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_3 (I = 1,w0 = 0) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Brake
		-----------------------------------------------------------
	CONNECT AnalogSource_1.s_out TO Brake.inPort
	CONNECT Rand_Torque.m_out TO R_Inertia_1.m_in
	CONNECT R_FixedVelocity_1.m_out TO R_Inertia_3.m_in
	CONNECT R_GearIdeal_1.m_out TO R_Inertia_2.m_in
	CONNECT R_Inertia_1.m_out TO R_GearIdeal_1.m_in
	CONNECT R_Inertia_2.m_out TO Brake.m_in
	CONNECT R_Inertia_3.m_out TO Brake.m_out
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Brake
		-----------------------------------------------------------
	Rand_Torque.s_in.signal[1] = 150
END COMPONENT

COMPONENT Example_Clutch
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Clutch
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_1 (source = Source_Step,Amp = 20,Tstart = 10,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.R_ActuatorTorque Rand_Torque
	MECHANICAL.R_Clutch R_Clutch_1 (phi_rel_i = 0,mue_pos = { { 0,1} ,{ 0.5,0.5} } ,peak = 1.1,cgeo = 1,fn_max = 20,w_rel_i = 1) 
	MECHANICAL.R_GearIdeal R_GearIdeal_1 (ratio = 2) 
	MECHANICAL.R_Inertia R_Inertia_1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_2 (I = 3,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_3 (I = 1,w0 = 0) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Clutch
		-----------------------------------------------------------
	CONNECT AnalogSource_1.s_out TO R_Clutch_1.inPort
	CONNECT Rand_Torque.m_out TO R_Inertia_1.m_in
	CONNECT R_Clutch_1.m_out TO R_Inertia_3.m_out
	CONNECT R_GearIdeal_1.m_out TO R_Inertia_2.m_in
	CONNECT R_Inertia_1.m_out TO R_GearIdeal_1.m_in
	CONNECT R_Inertia_2.m_out TO R_Clutch_1.m_in
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Clutch
		-----------------------------------------------------------
	Rand_Torque.s_in.signal[1] = 20
END COMPONENT

COMPONENT Example_CoupledClutches
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_CoupledClutches
		-----------------------------------------------------------
	MECHANICAL.R_Inertia J1 (I = 1,w0 = 10) 
	MECHANICAL.R_Clutch clutch1 (phi_rel_i = 0,mue_pos = { { 0,1} ,{ 0.5,0.5} } ,peak = 1.1,cgeo = 1,fn_max = 20,w_rel_i = 1) 
	CONTROL.AnalogSource  (n_out = 1) signal_clutch3 (source = Source_Step,Amp = 1,Tstart = 0.9,Offset = 0,Phase = 0,Period = 0,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) signal_clutch2 (source = Source_Step,Amp = 1,Tstart = 0.4,Offset = 0,Phase = 0,Period = 0,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) signal_clutch1 (source = Source_Sine,Amp = 1,Tstart = 0,Offset = 0,Phase = 1.57,Period = 5,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) torqueZero (source = Source_Constant,Amp = 0,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) sineSignal (source = Source_Sine,Amp = 10,Tstart = 0,Offset = 0,Phase = 0,Period = 0.2,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.R_ActuatorTorque torque2
	MECHANICAL.R_ActuatorTorque torque1
	MECHANICAL.R_Inertia J2 (I = 1,w0 = 0) 
	MECHANICAL.R_Clutch clutch2 (phi_rel_i = 0,mue_pos = { { 0,1} ,{ 0.5,0.5} } ,peak = 1.1,cgeo = 1,fn_max = 20,w_rel_i = 1) 
	MECHANICAL.R_Inertia J3 (I = 1,w0 = 0) 
	MECHANICAL.R_Clutch clutch3 (phi_rel_i = 0,mue_pos = { { 0,1} ,{ 0.5,0.5} } ,peak = 1.1,cgeo = 1,fn_max = 20,w_rel_i = 1) 
	MECHANICAL.R_Inertia J4 (I = 1,w0 = 0) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_CoupledClutches
		-----------------------------------------------------------
	CONNECT signal_clutch3.s_out TO clutch3.inPort
	CONNECT signal_clutch2.s_out TO clutch2.inPort
	CONNECT signal_clutch1.s_out TO clutch1.inPort
	CONNECT J4.m_out TO torque2.m_out
	CONNECT torqueZero.s_out TO torque2.s_in
	CONNECT sineSignal.s_out TO torque1.s_in
	CONNECT torque1.m_out TO J1.m_in
	CONNECT clutch3.m_out TO J4.m_in
	CONNECT J3.m_out TO clutch3.m_in
	CONNECT clutch2.m_out TO J3.m_in
	CONNECT J2.m_out TO clutch2.m_in
	CONNECT clutch1.m_out TO J2.m_in
	CONNECT J1.m_out TO clutch1.m_in
END COMPONENT

COMPONENT Example_Damper
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Damper
		-----------------------------------------------------------
	MECHANICAL.T_SpringDamper damper2 (d = 25,k = 1,s_rel0 = 1) 
	MECHANICAL.T_SlidingMass mass2 (m = 1,s0 = 3.5,v0 = 10) 
	CONTROL.AnalogSource  (n_out = 1) ForceNull (source = Source_Constant,Amp = 0,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.T_SlidingMass mass1 (m = 1,s0 = 3.5,v0 = 10) 
	MECHANICAL.T_Damper damper1 (d = 25) 
	MECHANICAL.T_SlidingMass mass3 (m = 1,s0 = 3.5,v0 = 10) 
	MECHANICAL.T_ActuatorForce force2
	MECHANICAL.T_ActuatorForce force3
	MECHANICAL.T_ActuatorForce force1
	MECHANICAL.T_Spring spring (k = 1,s_rel0 = 1) 
	MECHANICAL.T_FixedPosition Fixed2 (s0 = 4.5) 
	MECHANICAL.T_FixedPosition Fixed1 (s0 = 4.5) 
	MECHANICAL.T_FixedPosition Fixed3 (s0 = 4.5) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Damper
		-----------------------------------------------------------
	CONNECT Fixed2.m_out TO damper2.m_out
	CONNECT Fixed1.m_out TO damper1.m_out
	CONNECT mass1.m_out TO damper1.m_in
	CONNECT mass2.m_out TO damper2.m_in
	CONNECT force2.m_out TO mass2.m_in
	CONNECT force1.m_out TO mass1.m_in
	CONNECT force3.m_out TO mass3.m_in
	CONNECT ForceNull.s_out TO force2.s_in
	CONNECT ForceNull.s_out TO force1.s_in
	CONNECT ForceNull.s_out TO force3.s_in
	CONNECT Fixed3.m_out TO spring.m_out
	CONNECT mass3.m_out TO spring.m_in
END COMPONENT

COMPONENT Example_DriveTrain
DATA

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_DriveTrain
		-----------------------------------------------------------
	REAL startTime = 0.5 "Start time of step"
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_DriveTrain
		-----------------------------------------------------------
	MECHANICAL.R_Inertia inertia3 (I = 1,w0 = 100) 
	MECHANICAL.R_Clutch clutch (phi_rel_i = 0,mue_pos = { { 0,1} ,{ 0.5,0.5} } ,peak = 1,cgeo = 1,fn_max = 160,w_rel_i = -10) 
	CONTROL.AnalogSource  (n_out = 1) sineSignal (source = Source_Sine,Amp = 200,Tstart = 0,Offset = 0,Phase = 0,Period = PI / 50,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) startSignal (source = Source_Constant,Amp = -1,Tstart = startTime,Offset = 1,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) torqueZero (source = Source_Constant,Amp = 0,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) clutchSignal (source = Source_Constant,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) brakeSignal (source = Source_Step,Amp = 1,Tstart = startTime,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.R_Inertia inertia2 (I = 0.05,w0 = 90) 
	MECHANICAL.R_ActuatorTorque torque2
	MECHANICAL.R_ActuatorTorque torque1
	MECHANICAL.R_SpringDamper spring (phi_rel_i = 0,d = 1,c = 160,phi_rel0 = 0) 
	MECHANICAL.R_Brake brake (mue_pos = { { 0,1} ,{ 0.5,0.5} } ,peak = 1,cgeo = 1,fn_max = 1600,w_i = 90) 
	MECHANICAL.R_Inertia inertia1 (I = 1,w0 = 90) 
	CONTROL.Product  (n = 1) productSignal

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_DriveTrain
		-----------------------------------------------------------
	CONNECT spring.m_out TO brake.m_in
	CONNECT brake.m_out TO inertia1.m_in
	CONNECT inertia3.m_out TO clutch.m_in
	CONNECT clutch.m_out TO inertia2.m_in
	CONNECT inertia2.m_out TO spring.m_in
	CONNECT torque1.m_out TO inertia3.m_in
	CONNECT inertia1.m_out TO torque2.m_out
	CONNECT torqueZero.s_out TO torque2.s_in
	CONNECT clutchSignal.s_out TO clutch.inPort
	CONNECT brakeSignal.s_out TO brake.inPort
	CONNECT sineSignal.s_out TO productSignal.s_in_1
	CONNECT startSignal.s_out TO productSignal.s_in_2
	CONNECT productSignal.s_out TO torque1.s_in
END COMPONENT

COMPONENT Example_FixedVelocity
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_FixedVelocity
		-----------------------------------------------------------
	MECHANICAL.R_ActuatorTorque Rand_Torque
	MECHANICAL.R_FixedVelocity R_FixedVelocity_1 (w0 = 0) 
	MECHANICAL.R_GearIdeal R_GearIdeal_1 (ratio = 2) 
	MECHANICAL.R_Inertia R_Inertia_1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_2 (I = 3,w0 = 0) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_FixedVelocity
		-----------------------------------------------------------
	CONNECT Rand_Torque.m_out TO R_Inertia_1.m_in
	CONNECT R_GearIdeal_1.m_out TO R_Inertia_2.m_in
	CONNECT R_Inertia_1.m_out TO R_GearIdeal_1.m_in
	CONNECT R_Inertia_2.m_out TO R_FixedVelocity_1.m_out
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_FixedVelocity
		-----------------------------------------------------------
	Rand_Torque.s_in.signal[1] = 150
END COMPONENT

COMPONENT Example_GearChange
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_GearChange
		-----------------------------------------------------------
	MECHANICAL.R_ActuatorTorque Rand_Torque
	MECHANICAL.R_Inertia R_Inertia_1 (I = 1,w0 = 0) 
	MECHANICAL.R_GearIdeal R_GearIdeal_1 (ratio = 1) 
	MECHANICAL.R_Inertia R_Inertia_2 (I = 3,w0 = 0) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_GearChange
		-----------------------------------------------------------
	CONNECT Rand_Torque.m_out TO R_Inertia_1.m_in
	CONNECT R_Inertia_1.m_out TO R_GearIdeal_1.m_in
	CONNECT R_GearIdeal_1.m_out TO R_Inertia_2.m_in
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_GearChange
		-----------------------------------------------------------
	Rand_Torque.s_in.signal[1] = 150
END COMPONENT

COMPONENT Example_GearFriction1
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_GearFriction1
		-----------------------------------------------------------
	MECHANICAL.R_GearFriction gear (trans_ratio = 2,tab_eta_mf1 = { { 0,1} ,{ 0.5,0.5} } ,tab_eta_mf2 = { { 0,1} ,{ 0.5,0.5} } ,tab_tau_bf1 = { { 0,1} ,{ 0,0} } ,tab_tau_bf2 = { { 0,1} ,{ 0,0} } ,ideal =  FALSE ) 
	MECHANICAL.R_Inertia inertia1 (I = 1,w0 = 0) 
	CONTROL.AnalogSource  (n_out = 1) driveSine (source = Source_Sine,Amp = 10,Tstart = 0,Offset = 0,Phase = 0,Period = 1,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) load (source = Source_Ramp,Amp = 5,Tstart = 0,Offset = -10,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 2,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.R_Inertia inertia2 (I = 1.5,w0 = 0) 
	MECHANICAL.R_ActuatorTorque torque1
	MECHANICAL.R_ActuatorTorque torque2

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_GearFriction1
		-----------------------------------------------------------
	CONNECT inertia1.m_out TO gear.m_in
	CONNECT gear.m_out TO inertia2.m_in
	CONNECT inertia2.m_out TO torque2.m_out
	CONNECT driveSine.s_out TO torque1.s_in
	CONNECT load.s_out TO torque2.s_in
	CONNECT torque1.m_out TO inertia1.m_in
END COMPONENT

COMPONENT Example_GearFriction2
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_GearFriction2
		-----------------------------------------------------------
	MECHANICAL.R_BearingFriction bearingFriction (tau_pos = { { 0,1} ,{ 0.5,1} } ,peak = 1) 
	MECHANICAL.R_GearFriction gear (trans_ratio = 2,tab_eta_mf1 = { { 0,1} ,{ 0.5,0.5} } ,tab_eta_mf2 = { { 0,1} ,{ 0.5,0.5} } ,tab_tau_bf1 = { { 0,1} ,{ 0,0} } ,tab_tau_bf2 = { { 0,1} ,{ 0,0} } ,ideal =  FALSE ) 
	CONTROL.AnalogSource  (n_out = 1) driveSine (source = Source_Sine,Amp = 10,Tstart = 0,Offset = 0,Phase = 0,Period = 1,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) load (source = Source_Ramp,Amp = 5,Tstart = 0,Offset = -10,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 2,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.R_Inertia inertia1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia inertia2 (I = 1.5,w0 = 0) 
	MECHANICAL.R_ActuatorTorque torque1
	MECHANICAL.R_ActuatorTorque torque2

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_GearFriction2
		-----------------------------------------------------------
	CONNECT bearingFriction.m_out TO inertia1.m_in
	CONNECT inertia1.m_out TO gear.m_in
	CONNECT gear.m_out TO inertia2.m_in
	CONNECT torque1.m_out TO bearingFriction.m_in
	CONNECT inertia2.m_out TO torque2.m_out
	CONNECT driveSine.s_out TO torque1.s_in
	CONNECT load.s_out TO torque2.s_in
END COMPONENT

COMPONENT Example_PIControlled2DOFSystem
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_PIControlled2DOFSystem
		-----------------------------------------------------------
	CONTROL.Cntrl_PID  (n = 1) PID_Cntrl (k = 10,u_min = 0,u_max = 50,end_pos = end_I,Ti = 0.1,gamma = 0.1,beta = 1,Td = 1,alpha = 0.1) 
	MECHANICAL.T_AbsoluteSensorPosition  (n_out = 1) PositionSensor (gain = 1,bias = 0) 
	MECHANICAL.T_ActuatorForce Force
	MECHANICAL.T_FixedPosition Wall (s0 = 0) 
	MECHANICAL.T_SlidingMass Mass_1 (m = 1,s0 = 1,v0 = 0) 
	MECHANICAL.T_SlidingMass Mass_2 (m = 1,s0 = 2,v0 = 0) 
	MECHANICAL.T_Spring Spring (k = 1,s_rel0 = 1) 
	MECHANICAL.T_SpringDamper SpringDamper (d = 1,k = 1,s_rel0 = 1) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_PIControlled2DOFSystem
		-----------------------------------------------------------
	CONNECT PID_Cntrl.s_out TO Force.s_in
	CONNECT PositionSensor.s_out TO PID_Cntrl.s_var
	CONNECT Force.m_out TO Mass_2.m_in
	CONNECT Wall.m_out TO SpringDamper.m_in
	CONNECT Mass_1.m_out TO Spring.m_in
	CONNECT Mass_2.m_in TO PositionSensor.m_in
	CONNECT Spring.m_out TO Mass_2.m_in
	CONNECT SpringDamper.m_out TO Mass_1.m_in
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_PIControlled2DOFSystem
		-----------------------------------------------------------
	PID_Cntrl.s_set.signal[1] = 10
END COMPONENT

COMPONENT Example_PIControlledClutch
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_PIControlledClutch
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_2 (source = Source_Step,Amp = 20,Tstart = 10,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Torque_signal (source = Source_Square,Amp = 50,Tstart = 0,Offset = 25,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.Cntrl_PI  (n = 1) PI_cntrl (k = 3,u_min = -150,u_max = 150,end_pos = end_I,Ti = 0.05,gamma = 0.1,beta = 1) 
	MECHANICAL.R_AbsoluteSensorVelocity  (n_out = 1) Velocity (gain = 1,bias = 0) 
	MECHANICAL.R_ActuatorTorque Rand_Torque
	MECHANICAL.R_ActuatorTorque Torque
	MECHANICAL.R_Clutch Clutch (phi_rel_i = 0,mue_pos = { { 0,1} ,{ 0.5,0.5} } ,peak = 1.1,cgeo = 1,fn_max = 20,w_rel_i = 1) 
	MECHANICAL.R_Inertia R_Inertia_1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_2 (I = 3,w0 = 0) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_PIControlledClutch
		-----------------------------------------------------------
	CONNECT AnalogSource_2.s_out TO Clutch.inPort
	CONNECT Torque_signal.s_out TO Rand_Torque.s_in
	CONNECT PI_cntrl.s_out TO Torque.s_in
	CONNECT Velocity.s_out TO PI_cntrl.s_var
	CONNECT Velocity.m_in TO R_Inertia_1.m_in
	CONNECT Rand_Torque.m_out TO R_Inertia_2.m_out
	CONNECT Torque.m_out TO R_Inertia_1.m_in
	CONNECT Clutch.m_out TO R_Inertia_2.m_in
	CONNECT R_Inertia_1.m_out TO Clutch.m_in
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_PIControlledClutch
		-----------------------------------------------------------
	PI_cntrl.s_set.signal[1] = 75
END COMPONENT

COMPONENT Example_PIControlledMechanicalSystem
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_PIControlledMechanicalSystem
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) AnalogSource_1 (source = Source_Square,Amp = 50,Tstart = 0,Offset = 25,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.Cntrl_PI  (n = 1) PI_cntrl (k = 3,u_min = -150,u_max = 150,end_pos = end_I,Ti = 0.1,gamma = 0.1,beta = 1) 
	MECHANICAL.R_AbsoluteSensorVelocity  (n_out = 1) Velocity (gain = 1,bias = 0) 
	MECHANICAL.R_ActuatorTorque Rand_Torque
	MECHANICAL.R_ActuatorTorque Torque
	MECHANICAL.R_GearIdeal R_GearIdeal_1 (ratio = 3) 
	MECHANICAL.R_Inertia R_Inertia_1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_2 (I = 3,w0 = 0) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_PIControlledMechanicalSystem
		-----------------------------------------------------------
	CONNECT AnalogSource_1.s_out TO Rand_Torque.s_in
	CONNECT PI_cntrl.s_out TO Torque.s_in
	CONNECT Velocity.s_out TO PI_cntrl.s_var
	CONNECT Rand_Torque.m_out TO R_Inertia_2.m_out
	CONNECT Torque.m_out TO R_Inertia_1.m_in
	CONNECT R_GearIdeal_1.m_out TO R_Inertia_2.m_in
	CONNECT R_Inertia_1.m_out TO R_GearIdeal_1.m_in
	CONNECT R_Inertia_2.m_out TO Velocity.m_in
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_PIControlledMechanicalSystem
		-----------------------------------------------------------
	PI_cntrl.s_set.signal[1] = 75
END COMPONENT

COMPONENT Example_RotationalSpringAndDamper
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_RotationalSpringAndDamper
		-----------------------------------------------------------
	MECHANICAL.R_ActuatorTorque Rand_Torque
	MECHANICAL.R_ActuatorTorque Rand_Torque_1
	MECHANICAL.R_ActuatorTorque Rand_Torque_2
	MECHANICAL.R_Damper Damper (phi_rel_i = 0,d = 0.02) 
	MECHANICAL.R_GearIdeal R_GearIdeal_1 (ratio = 1) 
	MECHANICAL.R_GearIdeal R_GearIdeal_1_1 (ratio = 1) 
	MECHANICAL.R_GearIdeal R_GearIdeal_1_2 (ratio = 1) 
	MECHANICAL.R_Inertia R_Inertia_1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_1_1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_1_2 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_2 (I = 3,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_2_1 (I = 3,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_2_2 (I = 3,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_3 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_3_1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia R_Inertia_3_2 (I = 1,w0 = 0) 
	MECHANICAL.R_Spring R_Spring_1 (phi_rel_i = 0,c = 50,phi_rel0 = 0) 
	MECHANICAL.R_SpringDamper SpringDamper (phi_rel_i = 0,d = 0.02,c = 50,phi_rel0 = 0) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_RotationalSpringAndDamper
		-----------------------------------------------------------
	CONNECT Rand_Torque.m_out TO R_Inertia_1.m_in
	CONNECT Rand_Torque_1.m_out TO R_Inertia_1_1.m_in
	CONNECT Rand_Torque_2.m_out TO R_Inertia_1_2.m_in
	CONNECT Damper.m_out TO R_Inertia_3.m_in
	CONNECT R_GearIdeal_1.m_out TO R_Inertia_2.m_in
	CONNECT R_GearIdeal_1_1.m_out TO R_Inertia_2_1.m_in
	CONNECT R_GearIdeal_1_2.m_out TO R_Inertia_2_2.m_in
	CONNECT R_Inertia_1.m_out TO R_GearIdeal_1.m_in
	CONNECT R_Inertia_1_1.m_out TO R_GearIdeal_1_1.m_in
	CONNECT R_Inertia_1_2.m_out TO R_GearIdeal_1_2.m_in
	CONNECT R_Inertia_2.m_out TO Damper.m_in
	CONNECT R_Inertia_2_1.m_out TO R_Spring_1.m_in
	CONNECT R_Inertia_2_2.m_out TO SpringDamper.m_in
	CONNECT R_Spring_1.m_out TO R_Inertia_3_1.m_in
	CONNECT SpringDamper.m_out TO R_Inertia_3_2.m_in
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_RotationalSpringAndDamper
		-----------------------------------------------------------
	Rand_Torque.s_in.signal[1] = 150
	Rand_Torque_1.s_in.signal[1] = 150
	Rand_Torque_2.s_in.signal[1] = 150
END COMPONENT

COMPONENT Example_Spring
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Spring
		-----------------------------------------------------------
	MECHANICAL.T_Spring spring (k = 1,s_rel0 = 1) 
	MECHANICAL.T_SlidingMass mass2 (m = 1,s0 = 0.5,v0 = 0) 
	CONTROL.AnalogSource  (n_out = 1) ForceNull (source = Source_Constant,Amp = 0,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.T_SlidingMass mass1 (m = 1,s0 = 0,v0 = 0) 
	MECHANICAL.T_ActuatorForce force1
	MECHANICAL.T_ActuatorForce force2

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_Spring
		-----------------------------------------------------------
	CONNECT mass1.m_out TO spring.m_in
	CONNECT spring.m_out TO mass2.m_in
	CONNECT force1.m_out TO mass1.m_in
	CONNECT force2.m_out TO mass2.m_out
	CONNECT ForceNull.s_out TO force2.s_in
	CONNECT ForceNull.s_out TO force1.s_in
END COMPONENT

COMPONENT Example_T_Stop
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_T_Stop
		-----------------------------------------------------------
	MECHANICAL.T_Stop T_Stop (m = 1,smax = 0.9,smin = -0.9,F_prop = 1,F_Coulomb = 3,F_Stribeck = 5,fexp = 2,sini = 0) 
	MECHANICAL.T_Spring spring (k = 500,s_rel0 = 1) 
	CONTROL.AnalogSource  (n_out = 1) SignalPosition (source = Source_Constant,Amp = -1.75,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) ForceNull (source = Source_Constant,Amp = 0,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.T_ActuatorForce force
	MECHANICAL.T_ActuatorPosition position

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_T_Stop
		-----------------------------------------------------------
	CONNECT spring.m_out TO T_Stop.m_in
	CONNECT T_Stop.m_out TO force.m_out
	CONNECT position.m_out TO spring.m_in
	CONNECT SignalPosition.s_out TO position.s_in
	CONNECT ForceNull.s_out TO force.s_in
END COMPONENT

COMPONENT Example_TranslationalSpringAndDamper
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_TranslationalSpringAndDamper
		-----------------------------------------------------------
	MECHANICAL.T_Wall Wall_1 (ws = -1,wp = 0,cl = 0) 
	MECHANICAL.T_Wall Wall_2 (ws = -1,wp = 0,cl = 0) 
	MECHANICAL.T_Wall Wall_3 (ws = -1,wp = 0,cl = 0) 
	MECHANICAL.T_Spring Spring (k = 1,s_rel0 = 0) 
	MECHANICAL.T_SlidingMass Mass_1 (m = 1,s0 = 0,v0 = 0) 
	MECHANICAL.T_SlidingMass Mass_2 (m = 1,s0 = 0,v0 = 0) 
	MECHANICAL.T_SlidingMass Mass_3 (m = 1,s0 = 0,v0 = 0) 
	MECHANICAL.T_Damper Damper (d = 0.1) 
	MECHANICAL.T_ActuatorForce Force_1
	MECHANICAL.T_ActuatorForce Force_2
	MECHANICAL.T_ActuatorForce Force_3
	CONTROL.AnalogSource  (n_out = 1) Force_val (source = Source_Pulse,Amp = 5,Tstart = 5,Offset = 0,Phase = 0,Period = 500,pulseWidth = 0.1,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.T_SpringDamper SpringDamper (d = 0.1,k = 1,s_rel0 = 0) 

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Example_TranslationalSpringAndDamper
		-----------------------------------------------------------
	CONNECT Wall_1.m_out TO Spring.m_in
	CONNECT Spring.m_out TO Mass_1.m_in
	CONNECT Wall_3.m_out TO Damper.m_in
	CONNECT Damper.m_out TO Mass_3.m_in
	CONNECT Force_1.m_out TO Mass_1.m_out
	CONNECT Force_2.m_out TO Mass_2.m_out
	CONNECT Force_3.m_out TO Mass_3.m_out
	CONNECT Force_val.s_out TO Force_1.s_in
	CONNECT Force_val.s_out TO Force_2.s_in
	CONNECT Force_val.s_out TO Force_3.s_in
	CONNECT Wall_2.m_out TO SpringDamper.m_in
	CONNECT SpringDamper.m_out TO Mass_2.m_in
END COMPONENT

COMPONENT Examples_Piston
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Examples_Piston
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) Air_val (source = Source_SawTooth,Amp = 5000,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) Fext (source = Source_Constant,Amp = 100,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	MECHANICAL.R_Damper Damper (phi_rel_i = 0,d = 1) 
	MECHANICAL.R_GearIdealR2T Rot_to_Trans (ratio = -5) 
	MECHANICAL.R_Inertia J_1 (I = 1,w0 = 0) 
	MECHANICAL.R_Inertia J_2 (I = 1,w0 = 0) 
	MECHANICAL.R_SpringDamper SpringDamper (phi_rel_i = 0,d = 0.4,c = 0.4,phi_rel0 = 0) 
	MECHANICAL.T_ActuatorForce Pressurized_air
	MECHANICAL.T_Piston Piston (Mp = 1,xini = 0,xmin = 0,xmax = 0.05,K_spr = 100000,Fpl = 100,cv = 20,fc1 = 0,fc2 = 0) 
	MECHANICAL.T_Rod Rod

		-----------------------------------------------------------
		-- Coded in MECHANICAL_EXAMPLES.Examples_Piston
		-----------------------------------------------------------
	CONNECT Air_val.s_out TO Pressurized_air.s_in
	CONNECT Fext.s_out TO Piston.s_Fext
	CONNECT Damper.m_out TO J_2.m_in
	CONNECT Rot_to_Trans.R_m_in TO SpringDamper.m_in
	CONNECT J_1.m_out TO Damper.m_in
	CONNECT SpringDamper.m_out TO J_1.m_in
	CONNECT Pressurized_air.m_out TO Piston.m_in
	CONNECT Piston.m_out TO Rod.m_in
	CONNECT Rod.m_out TO Rot_to_Trans.T_m_out
END COMPONENT
