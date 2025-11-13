/*-----------------------------------------------------------------------------------------
 FILE: thermal_examples
-----------------------------------------------------------------------------------------*/

-- Libraries
USE MATH 
USE THERMAL 
USE PORTS_LIB
USE CONTROL

COMPONENT ControlledWallHeating
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.ControlledWallHeating
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) T_amb (source = Source_Constant,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.AnalogSource  (n_out = 1) T_set (source = Source_Constant,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	CONTROL.Cntrl_PID  (n = 1) PID (k = 100,u_min = 0,u_max = 50000,end_pos = end_I,Ti = 100,gamma = 0.1,beta = 1,Td = 0.01,alpha = 0.1) 
	THERMAL.BNode  (n = 1) Ambient (Label = "Node Label",qi = 0) 
	THERMAL.FreeConvec_Plate  (n = 1,position = wall,thermal_fluid = Air) Convection (A = 30,Lc = 0.1,P = 101325,Grav = 9.80665) 
	THERMAL.GR  (n = 1) Radiation (REF = 30) 
	THERMAL.Heater  (n = 1) Heater
	THERMAL.T_sensor  (n_out = 1,n = 1,in = 1) T_sens (gain = 1,bias = 0) 
	THERMAL.Wall  (n = 1,nodes = 1) Inner_wall (mat = Aluminum,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 30,e = 0.1,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.Wall  (n = 1,nodes = 1) Middle_wall (mat = Titanium,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 30,e = 0.2,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.Wall  (n = 1,nodes = 1) Outer_wall (mat = Aluminum,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 30,e = 0.1,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.ControlledWallHeating
		-----------------------------------------------------------
	CONNECT T_amb.s_out TO Ambient.s_temperature
	CONNECT T_set.s_out TO PID.s_set
	CONNECT PID.s_out TO Heater.s_power
	CONNECT Convection.tp_fluid TO Ambient.tp_in
	CONNECT Radiation.tp_out TO Ambient.tp_in
	CONNECT Heater.tp_out TO Inner_wall.tp_in
	CONNECT T_sens.s_out TO PID.s_var
	CONNECT T_sens.tp_in TO Inner_wall.tp_in
	CONNECT Inner_wall.tp_out TO Middle_wall.tp_in
	CONNECT Middle_wall.tp_out TO Outer_wall.tp_in
	CONNECT Outer_wall.tp_out TO Convection.tp_surface
	CONNECT Outer_wall.tp_out TO Radiation.tp_in
END COMPONENT

COMPONENT CylinderHeatTransfer
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.CylinderHeatTransfer
		-----------------------------------------------------------
	THERMAL.Cylinder  (nz = 1,nr = 1) Cylinder (L = 3,Di = 0.2,Do = 0.22,num = 1,mat = Aluminum,k = 0.1,rho = 1000,cp = 500,TemperatureDependance =  TRUE ,init_mode = Constant_Temp,To = 100,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.Insulation  (n = 1) Insulation_l
	THERMAL.Insulation  (n = 1) Insulation_r
	THERMAL.Insulation  (n = 1) Insulation_radial
	THERMAL.Wall  (n = 1,nodes = 10) Wall_l (mat = None,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 1,e = 0.1,init_mode = Constant_Temp,To = 100,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.Wall  (n = 1,nodes = 10) Wall_r (mat = None,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 1,e = 0.1,init_mode = Constant_Temp,To = 100,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.CylinderHeatTransfer
		-----------------------------------------------------------
	CONNECT Cylinder.tpr_out TO Insulation_radial.tp
	CONNECT Cylinder.tpz_out TO Wall_r.tp_in
	CONNECT Insulation_l.tp TO Wall_l.tp_in
	CONNECT Wall_l.tp_out TO Cylinder.tpz_in
	CONNECT Wall_r.tp_out TO Insulation_r.tp
END COMPONENT

COMPONENT FreeFall
"Model of the free fall of an object"
DATA

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.FreeFall
		-----------------------------------------------------------
	REAL h = 1000 UNITS "m" "Initial height"
	REAL k = 0.01 "Air resistance factor"
DECLS

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.FreeFall
		-----------------------------------------------------------
	CONST REAL g = 9.81 UNITS "m/s2" "Acceleration of gravity"
	REAL y UNITS "m" "Object height (numerical soluction)"
	REAL v UNITS "m/s" "Object velocity (numerical soluction)"
INIT

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.FreeFall
		-----------------------------------------------------------
	y = h
	v = 0
DISCRETE

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.FreeFall
		-----------------------------------------------------------
	WHEN (y <= 1e-06)  THEN
	TSTOP = TIME
	END WHEN
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.FreeFall
		-----------------------------------------------------------
	v = y'
	v' = k * (v) ** 2 - g
END COMPONENT

COMPONENT Peltier
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Peltier
		-----------------------------------------------------------
	ELECTRICAL.CurrentConstant CurrentConstant (I = 1) 
	ELECTRICAL.Ground Ground
	THERMAL.Peltier  (n = 1) Peltier (NTE = 127,G = 0.00072,a_coef = { 2.2224e-05,9.306e-07,-9.905e-10} ,r_coef = { 5.112e-07,1.634e-08,6.279e-11} ,k_coef = { 6.2605,-0.02777,4.131e-05} ) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Peltier
		-----------------------------------------------------------
	CONNECT CurrentConstant.e_p TO Ground.e_p
	CONNECT CurrentConstant.e_n TO Peltier.e_p
	CONNECT Peltier.e_n TO Ground.e_p
END COMPONENT

COMPONENT PipeFins
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.PipeFins
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) Input_T (source = Source_Sine,Amp = 120,Tstart = 0,Offset = 273.15,Phase = 0,Period = 92.68 * 60,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	THERMAL.BNode  (n = 1) Environment (Label = "Node Label",qi = 0) 
	THERMAL.Cylinder_AI  (nz = 1,nr = 1) Pipe (L = 2,Di = 0.2,Do = 0.22,num = 1,mat = Titanium,k = 0.1,rho = 1000,cp = 500,TemperatureDependance =  TRUE ,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.HeatFlowMultiplier  (n = 1) Multiplier (k = 1 / 10) 
	THERMAL.Radiator  (nx = 5,ny = 1) Fin (mat = Copper,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,n_fin = 1,Lx = 0.3,Ly = 2,e = 0.003,emiss1 = 0.85,alpha1 = 0.25,F1 = 0.9,beta1 = 0,emiss2 = 0.85,alpha2 = 0.25,F2 = 0,beta2 = 0,To = 290) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.PipeFins
		-----------------------------------------------------------
	CONNECT Input_T.s_out TO Environment.s_temperature
	CONNECT Pipe.tpr_out TO Multiplier.tp_in
	CONNECT Multiplier.tp_out TO Fin.tp_in
	CONNECT Fin.tp_2 TO Environment.tp_in
	CONNECT Fin.tp_1 TO Environment.tp_in
END COMPONENT

COMPONENT PlateBC
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.PlateBC
		-----------------------------------------------------------
	THERMAL.Insulation  (n = 10) Insulation
	THERMAL.Plate  (nx = 10,ny = 10) Plate (L = 1,W = 1,e = 0.001,mat = Copper,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.PlateBC
		-----------------------------------------------------------
	CONNECT Insulation.tp TO Plate.tpx_in
END COMPONENT

COMPONENT RadiationNodes
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.RadiationNodes
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) T_amb (source = Source_Constant,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	THERMAL.BNode  (n = 1) Amb (Label = "Node Label",qi = 0) 
	THERMAL.BNode  (n = 1) Amb_mat (Label = "Node Label",qi = 0) 
	THERMAL.BNode  (n = 1) Amb_phases (Label = "Node Label",qi = 0) 
	THERMAL.BNode  (n = 1) Amb_room (Label = "Node Label",qi = 0) 
	THERMAL.DNode  (n = 1) DNode (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 30000) 
	THERMAL.DNodeMat  (n = 1) DNodeMat (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,mat = Aluminum,mass = 100,cp = 500) 
	THERMAL.DNodeRoom  (n = 1) DNodeRoom (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,V = 200,P = 101325,thermal_fluid = Air) 
	THERMAL.DNphases  (n = 1) DNphases (Label = "Node Label",qi = 0,Mass = 100,To = 290,CP_l = 4186,CP_s = 2039,CP_v = 1805,Hfus = 334000,Hvap = 2501000,T_fusion = 273.15,T_boiling = 373.15) 
	THERMAL.GR  (n = 1) Rad (REF = 30) 
	THERMAL.GR  (n = 1) Rad_mat (REF = 30) 
	THERMAL.GR  (n = 1) Rad_phases (REF = 30) 
	THERMAL.GR  (n = 1) Rad_room (REF = 30) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.RadiationNodes
		-----------------------------------------------------------
	CONNECT T_amb.s_out TO Amb.s_temperature
	CONNECT T_amb.s_out TO Amb_mat.s_temperature
	CONNECT T_amb.s_out TO Amb_phases.s_temperature
	CONNECT T_amb.s_out TO Amb_room.s_temperature
	CONNECT Rad.tp_out TO Amb.tp_in
	CONNECT Rad.tp_in TO DNode.tp_in
	CONNECT Rad_mat.tp_out TO Amb_mat.tp_in
	CONNECT Rad_mat.tp_in TO DNodeMat.tp_in
	CONNECT Rad_phases.tp_out TO Amb_phases.tp_in
	CONNECT Rad_phases.tp_in TO DNphases.tp_in
	CONNECT Rad_room.tp_out TO Amb_room.tp_in
	CONNECT Rad_room.tp_in TO DNodeRoom.tp_in
END COMPONENT

COMPONENT Rebound
"Component to simulate the rebound of an object between two walls"
DATA

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Rebound
		-----------------------------------------------------------
	REAL x0 = 0 UNITS "m"
	REAL x1 = 5 UNITS "m"
	REAL v0 = 2 UNITS "m/s"
DECLS

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Rebound
		-----------------------------------------------------------
	REAL x UNITS "m"
	DISCR REAL v UNITS "m/s"
INIT

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Rebound
		-----------------------------------------------------------
	x = x0
	v = v0
DISCRETE

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Rebound
		-----------------------------------------------------------
	WHEN (x < x0 OR x > x1)  THEN
	v = -v
	END WHEN
CONTINUOUS

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Rebound
		-----------------------------------------------------------
	x' = v
END COMPONENT

COMPONENT Thruster
	PORTS
		OUT thermal Space
		OUT thermal tp_N13
      DECLS
          TABLE_1D Cond_Tab = { {-273.15,  0. , 400. , 2000.  },  
                             {   9.5 ,  9.5,  16.6,   16.6 }}

	TOPOLOGY		
		DNode N1 (C = 4.60, qi = 0)

		DNode N2 (C = 25., qi= 0., To = 473.15)
		
		DNode N3 ( C = 8., qi= 0.)
		
		DNode N4 ( C = 3.5, qi = 0.)
		
		DNode N5 (  C = 1.9, qi= 0.)
		
		DNode N6 ( C = 1.9, qi= 0.)
		
		DNode N7 ( C = 1.9, qi= 0.)
		
		DNode N8 ( C = 0.176, qi = 0.)
		
		DNode N9 ( C = 0.68, qi= 0.)
		
		DNode N10 ( C = 0.065, qi= 0.)
		
		DNode N11 ( C = 7.28, qi= 0.) 

		DNode N12 (  C = 1.2720e+01, qi= 0.)
		
		DNode N13 (  C = 1.46e+01, qi= 0.)
		
		DNode N14 (  C = 1.0350e+01, qi= 0.)
		
		DNode N15 (  C = 54.83, qi= 0.)
	
		--Boundary Nodes
	
		BNode N105
	
		--Modified Linear Conductances
	
		TD_GL TD_GL1 (F = 0.0015, k_table = Cond_Tab)
		CONNECT  N1  TO  TD_GL1  TO N2 
		
		TD_GL TD_GL2 (F = 0.0053, k_table = Cond_Tab)
		CONNECT  N2  TO TD_GL2 TO N4
		
		TD_GL TD_GL3 (F = 4.32e-3, k_table = Cond_Tab)
		CONNECT  N4 TO TD_GL3 TO N5
		
		TD_GL TD_GL4 (F = 8.23e-4, k_table = Cond_Tab)
		CONNECT  N5 TO TD_GL4 TO N6
		
		TD_GL TD_GL5 (F = 8.23e-4, k_table = Cond_Tab)
		CONNECT  N6 TO TD_GL5 TO N7
		
		TD_GL TD_GL6 (F = 4.32e-3, k_table = Cond_Tab)
		CONNECT  N7 TO TD_GL6 TO N13
		
		TD_GL TD_GL7 (F = 7.e-3, k_table = Cond_Tab)
		CONNECT  N13 TO TD_GL7 TO N14
		
		TD_GL TD_GL8 (F = 2.361e-4, k_table = Cond_Tab)
		CONNECT  N2 TO TD_GL8 TO N8 	
			
		TD_GL TD_GL9 (F = 5.059e-5, k_table = Cond_Tab)
		CONNECT  N8 TO TD_GL9 TO N9

		TD_GL TD_GL10 (F = 4.086e-5, k_table = Cond_Tab )
		CONNECT  N9 TO TD_GL10 TO N10
		
		TD_GL TD_GL11 (F = 1.518e-4, k_table = Cond_Tab)
		CONNECT  N10 TO TD_GL11 TO N13
		
		--Linear Conductances 
		
		GL GL1 (cond =  0.0085)
		CONNECT N2 TO GL1 TO N3

		GL GL2 (cond =  0.15)
		CONNECT N14 TO GL2 TO N15

		GL GL3 (cond =  0.0041)
		CONNECT	N2 TO GL3 TO N11
	
		GL GL4 (cond =  0.0041) 
		CONNECT N11 TO GL4 TO N12
		
		GL GL5 (cond =  0.0024)
		CONNECT N12 TO GL5 TO N15
		
		GL GL6 (cond =  0.069)
		CONNECT N14 TO GL6 TO N105
	
		--Radiative Exchange Factors 
	
		GR GR1 (REF =  2.1324e-04)
		CONNECT N1 TO GR1 TO Space
		
		GR GR2 (REF =  6.1080e-04)
		CONNECT N3 TO GR2 TO Space
		
		GR GR3 (REF =  7.20e-05)
		CONNECT N4 TO GR3 TO Space
		
		GR GR4 (REF =  3.90e-05)
		CONNECT N5 TO GR4 TO Space
		
		GR GR5 (REF =  3.90e-05)
		CONNECT N6 TO GR5 TO Space
		
		GR GR6 (REF =  6.e-06)
		CONNECT N8 TO GR6 TO Space
		
		GR GR7 (REF =  2.32e-05)
		CONNECT N9 TO GR7 TO Space
		
		GR GR8 (REF =  2.06e-04)
		CONNECT N11 TO GR8 TO Space 

		--Connection to External Port
	
		CONNECT N13 TO tp_N13
END COMPONENT

COMPONENT ThrusterSchematic
PORTS

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.ThrusterSchematic
		-----------------------------------------------------------
	IN PORTS_LIB.thermal  (n = 1) Space CARDINALITY 0,2147483647 
	IN PORTS_LIB.thermal  (n = 1) tp_N13 CARDINALITY 0,2147483647 
DECLS

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.ThrusterSchematic
		-----------------------------------------------------------
	TABLE_1D Cond_Tab = { { -273.15,0,400,2000} ,{ 9.5,9.5,16.6,16.6} } 
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.ThrusterSchematic
		-----------------------------------------------------------
	THERMAL.BNode  (n = 1) BNode_N105 (Label = "Node Label",qi = 0) 
	THERMAL.DNode  (n = 1) DNode_N1 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 4.6) 
	THERMAL.DNode  (n = 1) DNode_N10 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 0.065) 
	THERMAL.DNode  (n = 1) DNode_N11 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 7.28) 
	THERMAL.DNode  (n = 1) DNode_N12 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 12.72) 
	THERMAL.DNode  (n = 1) DNode_N13 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 14.6) 
	THERMAL.DNode  (n = 1) DNode_N14 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 10.35) 
	THERMAL.DNode  (n = 1) DNode_N15 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 54.83) 
	THERMAL.DNode  (n = 1) DNode_N2 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 473.15,C = 0.001) 
	THERMAL.DNode  (n = 1) DNode_N3 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 8) 
	THERMAL.DNode  (n = 1) DNode_N4 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 3.5) 
	THERMAL.DNode  (n = 1) DNode_N5 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 1.9) 
	THERMAL.DNode  (n = 1) DNode_N6 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 1.9) 
	THERMAL.DNode  (n = 1) DNode_N7 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 1.9) 
	THERMAL.DNode  (n = 1) DNode_N8 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 0.176) 
	THERMAL.DNode  (n = 1) DNode_N9 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 0.68) 
	THERMAL.GL  (n = 1) GL_1 (cond = 0.0085) 
	THERMAL.GL  (n = 1) GL_2 (cond = 0.15) 
	THERMAL.GL  (n = 1) GL_3 (cond = 0.0041) 
	THERMAL.GL  (n = 1) GL_4 (cond = 0.0041) 
	THERMAL.GL  (n = 1) GL_5 (cond = 0.0024) 
	THERMAL.GL  (n = 1) GL_6 (cond = 0.069) 
	THERMAL.GR  (n = 1) GR_1 (REF = 0.00021324) 
	THERMAL.GR  (n = 1) GR_2 (REF = 0.0006108) 
	THERMAL.GR  (n = 1) GR_3 (REF = 7.2e-05) 
	THERMAL.GR  (n = 1) GR_4 (REF = 3.9e-05) 
	THERMAL.GR  (n = 1) GR_5 (REF = 3.9e-05) 
	THERMAL.GR  (n = 1) GR_6 (REF = 6e-06) 
	THERMAL.GR  (n = 1) GR_7 (REF = 2.32e-05) 
	THERMAL.GR  (n = 1) GR_8 (REF = 0.000206) 
	THERMAL.TD_GL  (n = 1) TD_GL1 (F = 0.0015,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_10 (F = 4.086e-05,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_11 (F = 0.0001518,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_2 (F = 0.0053,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_3 (F = 0.00432,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_4 (F = 0.000823,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_5 (F = 0.000823,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_6 (F = 0.00432,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_7 (F = 0.007,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_8 (F = 0.0002361,k_table = Cond_Tab) 
	THERMAL.TD_GL  (n = 1) TD_GL_9 (F = 5.059e-05,k_table = Cond_Tab) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.ThrusterSchematic
		-----------------------------------------------------------
	CONNECT DNode_N1.tp_in TO TD_GL1.tp_in
	CONNECT DNode_N13.tp_in TO tp_N13
	CONNECT DNode_N9.tp_in TO GR_7.tp_in
	CONNECT GL_1.tp_in TO DNode_N2.tp_in
	CONNECT GL_1.tp_out TO DNode_N3.tp_in
	CONNECT GL_2.tp_in TO DNode_N14.tp_in
	CONNECT GL_2.tp_out TO DNode_N15.tp_in
	CONNECT GL_3.tp_out TO DNode_N11.tp_in
	CONNECT GL_3.tp_in TO DNode_N2.tp_in
	CONNECT GL_4.tp_in TO DNode_N11.tp_in
	CONNECT GL_4.tp_out TO DNode_N12.tp_in
	CONNECT GL_5.tp_in TO DNode_N12.tp_in
	CONNECT GL_5.tp_out TO DNode_N15.tp_in
	CONNECT GL_6.tp_out TO BNode_N105.tp_in
	CONNECT GL_6.tp_in TO DNode_N14.tp_in
	CONNECT GR_1.tp_out TO Space
	CONNECT GR_1.tp_in TO DNode_N1.tp_in
	CONNECT GR_2.tp_out TO Space
	CONNECT GR_2.tp_in TO DNode_N3.tp_in
	CONNECT GR_3.tp_out TO Space
	CONNECT GR_3.tp_in TO DNode_N4.tp_in
	CONNECT GR_4.tp_out TO Space
	CONNECT GR_4.tp_in TO DNode_N5.tp_in
	CONNECT GR_5.tp_out TO Space
	CONNECT GR_5.tp_in TO DNode_N6.tp_in
	CONNECT GR_6.tp_out TO Space
	CONNECT GR_6.tp_in TO DNode_N8.tp_in
	CONNECT GR_7.tp_out TO Space
	CONNECT GR_8.tp_out TO Space
	CONNECT GR_8.tp_in TO DNode_N11.tp_in
	CONNECT TD_GL1.tp_out TO DNode_N2.tp_in
	CONNECT TD_GL_10.tp_out TO DNode_N10.tp_in
	CONNECT TD_GL_10.tp_in TO DNode_N9.tp_in
	CONNECT TD_GL_11.tp_out TO tp_N13
	CONNECT TD_GL_11.tp_in TO DNode_N10.tp_in
	CONNECT TD_GL_2.tp_in TO DNode_N2.tp_in
	CONNECT TD_GL_2.tp_out TO DNode_N4.tp_in
	CONNECT TD_GL_3.tp_in TO DNode_N4.tp_in
	CONNECT TD_GL_3.tp_out TO DNode_N5.tp_in
	CONNECT TD_GL_4.tp_in TO DNode_N5.tp_in
	CONNECT TD_GL_4.tp_out TO DNode_N6.tp_in
	CONNECT TD_GL_5.tp_in TO DNode_N6.tp_in
	CONNECT TD_GL_5.tp_out TO DNode_N7.tp_in
	CONNECT TD_GL_6.tp_out TO DNode_N13.tp_in
	CONNECT TD_GL_6.tp_in TO DNode_N7.tp_in
	CONNECT TD_GL_7.tp_in TO DNode_N13.tp_in
	CONNECT TD_GL_7.tp_out TO DNode_N14.tp_in
	CONNECT TD_GL_8.tp_in TO DNode_N2.tp_in
	CONNECT TD_GL_8.tp_out TO DNode_N8.tp_in
	CONNECT TD_GL_9.tp_in TO DNode_N8.tp_in
	CONNECT TD_GL_9.tp_out TO DNode_N9.tp_in
END COMPONENT

COMPONENT Two_thrusters_edu
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Two_thrusters_edu
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) Input_T (source = Source_Constant,Amp = 105,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	THERMAL.BNode  (n = 1) Space (Label = "Node Label",qi = 0) 
	THERMAL.GR  (n = 1) GR_1 (REF = 5e-05) 
	THERMAL_EXAMPLES.ThrusterSchematic ThrusterSchematic_1
	THERMAL_EXAMPLES.ThrusterSchematic ThrusterSchematic_2

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Two_thrusters_edu
		-----------------------------------------------------------
	CONNECT Input_T.s_out TO Space.s_temperature
	CONNECT GR_1.tp_out TO ThrusterSchematic_2.tp_N13
	CONNECT ThrusterSchematic_1.Space TO Space.tp_in
	CONNECT ThrusterSchematic_1.tp_N13 TO GR_1.tp_in
	CONNECT ThrusterSchematic_2.Space TO Space.tp_in
END COMPONENT

COMPONENT View_Factors_Model
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.View_Factors_Model
		-----------------------------------------------------------
	THERMAL.BNode  (n = 1) N1 (Label = "Node Label",qi = 0) 
	THERMAL.BNode  (n = 1) N2 (Label = "Node Label",qi = 0) 
	THERMAL.BNode  (n = 1) N3 (Label = "Node Label",qi = 0) 
	THERMAL.DNode  (n = 1) N4 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 0.001) 
	THERMAL.DNode  (n = 1) N5 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 0.001) 
	THERMAL.DNode  (n = 1) N6 (Label = "Node Label",qi = 0,Boundary =  FALSE ,To = 290,C = 0.001) 
	THERMAL.View_Factors  (nports = 6) view_factors (VF = { { 0,0.33371,0.08365,0.08365,0.33371,0.16527} ,{ 0.16686,0,0.07865,0.07865,0.50899,0.16686} ,{ 0.16731,0.3146,0,0.03618,0.3146,0.16731} ,{ 0.16731,0.3146,0.03618,0,0.3146,0.16731} ,{ 0.16686,0.50899,0.07865,0.07865,0,0.16686} ,{ 0.16527,0.33371,0.08365,0.08365,0.33371,0} } ,e = { 0.9,0.75,0.8,0.0001,0.0001,0.0001} ,A = { 4,8,2,2,8,4} ) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.View_Factors_Model
		-----------------------------------------------------------
	CONNECT view_factors.tp_in[1] TO N1.tp_in
	CONNECT view_factors.tp_in[2] TO N2.tp_in
	CONNECT view_factors.tp_in[3] TO N3.tp_in
	CONNECT view_factors.tp_in[4] TO N4.tp_in
	CONNECT view_factors.tp_in[5] TO N5.tp_in
	CONNECT view_factors.tp_in[6] TO N6.tp_in
END COMPONENT

COMPONENT WallConvection
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.WallConvection
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) Input_T (source = Source_Constant,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	THERMAL.BNode  (n = 1) Environment (Label = "Node Label",qi = 0) 
	THERMAL.FreeConvec_Plate  (n = 1,position = wall,thermal_fluid = Air) Convection (A = 200,Lc = 0.1,P = 101325,Grav = 9.80665) 
	THERMAL.Wall  (n = 1,nodes = 10) Wall (mat = Aluminum,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 200,e = 0.5,init_mode = Constant_Temp,To = 298,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.WallConvection
		-----------------------------------------------------------
	CONNECT Input_T.s_out TO Environment.s_temperature
	CONNECT Convection.tp_fluid TO Environment.tp_in
	CONNECT Wall.tp_out TO Convection.tp_surface
END COMPONENT

COMPONENT WallConvectionRadiation
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.WallConvectionRadiation
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) Input_T (source = Source_Constant,Amp = 1,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	THERMAL.BNode  (n = 1) Env_parallel (Label = "Node Label",qi = 0) 
	THERMAL.BNode  (n = 1) Env_series (Label = "Node Label",qi = 0) 
	THERMAL.FreeConvec_Plate  (n = 1,position = wall,thermal_fluid = Air) Convection_parallel (A = 50,Lc = 0.1,P = 101325,Grav = 9.80665) 
	THERMAL.FreeConvec_Plate  (n = 1,position = wall,thermal_fluid = Air) Convection_series (A = 50,Lc = 0.1,P = 101325,Grav = 9.80665) 
	THERMAL.GR  (n = 1) Radiation_parallel (REF = 50) 
	THERMAL.GR  (n = 1) Radiation_series (REF = 50) 
	THERMAL.Wall  (n = 1,nodes = 1) Wall_parallel (mat = GCF,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 50,e = 0.1,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.Wall  (n = 1,nodes = 1) Wall_series (mat = GCF,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 50,e = 0.1,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.WallConvectionRadiation
		-----------------------------------------------------------
	CONNECT Input_T.s_out TO Env_parallel.s_temperature
	CONNECT Input_T.s_out TO Env_series.s_temperature
	CONNECT Convection_parallel.tp_fluid TO Env_parallel.tp_in
	CONNECT Convection_series.tp_fluid TO Env_series.tp_in
	CONNECT Radiation_parallel.tp_out TO Env_parallel.tp_in
	CONNECT Radiation_series.tp_out TO Convection_series.tp_surface
	CONNECT Wall_parallel.tp_out TO Convection_parallel.tp_surface
	CONNECT Wall_parallel.tp_out TO Radiation_parallel.tp_in
	CONNECT Wall_series.tp_out TO Radiation_series.tp_in
END COMPONENT

COMPONENT WallSandwichRadiation
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.WallSandwichRadiation
		-----------------------------------------------------------
	CONTROL.AnalogSource  (n_out = 1) Input_T (source = Source_Constant,Amp = 280,Tstart = 0,Offset = 0,Phase = 0,Period = 10,pulseWidth = 0.001,rampDuration = 10,tabmethod = LinearInterpWithEvents,timeTable = { { 0,10} ,{ 0,0} } ) 
	THERMAL.BNode  (n = 1) Environment (Label = "Node Label",qi = 0) 
	THERMAL.GR  (n = 1) Radiation (REF = 50) 
	THERMAL.Wall  (n = 1,nodes = 1) Inner_wall (mat = GCF,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 5,e = 0.01,init_mode = Constant_Temp,To = 293,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.Wall  (n = 1,nodes = 1) Middle_wall (mat = Titanium,rho = 1000,cp = 500,k = 0.1,TemperatureDependance =  TRUE ,A = 5,e = 0.005,init_mode = Constant_Temp,To = 293,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.Wall  (n = 1,nodes = 1) Outer_wall (mat = GCF,rho = 1000,cp = 500,k = 0.01,TemperatureDependance =  TRUE ,A = 5,e = 0.01,init_mode = Constant_Temp,To = 293,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.WallSandwichRadiation
		-----------------------------------------------------------
	CONNECT Input_T.s_out TO Environment.s_temperature
	CONNECT Radiation.tp_out TO Environment.tp_in
	CONNECT Inner_wall.tp_out TO Middle_wall.tp_in
	CONNECT Middle_wall.tp_out TO Outer_wall.tp_in
	CONNECT Outer_wall.tp_out TO Radiation.tp_in
END COMPONENT

COMPONENT Wall_3
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Wall_3
		-----------------------------------------------------------
	THERMAL.BNode  (n = 1) Environment (Label = "Node Label",qi = 0) 
	THERMAL.GR  (n = 1) GR_1 (REF = 0.5) 
	THERMAL.Wall  (n = 1,nodes = 1) layer1 (mat = None,rho = 1000,cp = 500,k = 0.001,TemperatureDependance =  TRUE ,A = 1,e = 0.001,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.Wall  (n = 1,nodes = 1) layer2 (mat = None,rho = 1000,cp = 500,k = 0.02,TemperatureDependance =  TRUE ,A = 1,e = 0.02,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 
	THERMAL.Wall  (n = 1,nodes = 1) layer3 (mat = GCF,rho = 1000,cp = 500,k = 0.001,TemperatureDependance =  TRUE ,A = 1,e = 0.001,init_mode = Constant_Temp,To = 290,To_linear = { 290,290} ,To_table = { { 0,1} ,{ 290,290} } ) 

		-----------------------------------------------------------
		-- Coded in THERMAL_EXAMPLES.Wall_3
		-----------------------------------------------------------
	CONNECT GR_1.tp_out TO Environment.tp_in
	CONNECT layer1.tp_out TO layer2.tp_in
	CONNECT layer2.tp_out TO layer3.tp_in
	CONNECT layer3.tp_out TO GR_1.tp_in
END COMPONENT

COMPONENT two_thrusters

	TOPOLOGY
		Thruster thruster1
		Thruster thruster2
		BNode Space 	
		GR GR_coupling (REF = 0.000005)

		CONNECT thruster1.tp_N13 TO GR_coupling TO thruster2.tp_N13
		CONNECT thruster1.Space TO Space
		CONNECT thruster2.Space TO Space		

END COMPONENT
