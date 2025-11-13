/*-----------------------------------------------------------------------------------------
 FILE: physiological_examples
-----------------------------------------------------------------------------------------*/

-- Libraries
USE MATH 
USE PHYSIOLOGICAL 

COMPONENT physbe
"Human body physiological example"
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in PHYSIOLOGICAL_EXAMPLES.physbe
		-----------------------------------------------------------
	PHYSIOLOGICAL.Cava Cava (rai = 0.01,rao = 0.01,comp = 250) 
	PHYSIOLOGICAL.Lungs Lungs (rai = 0.01,rao = 0.1875,comp = 10) 
	PHYSIOLOGICAL.Head Head (rai = 2.58,rao = 5,comp = 1.21) 
	PHYSIOLOGICAL.Aorta Aorta (rai = 0.01,rao = 0.01,comp = 1.01) 
	PHYSIOLOGICAL.Ventricle Ventricle_left (rai = 0.0275,rao = 0.006,period = 1,rec_comp = { { 0,0.4,0.5,1} ,{ 0.0133,0.428,0.0133,0.0133} } ) 
	PHYSIOLOGICAL.Arms Arms (rai = 5.15,rao = 10,comp = 34) 
	PHYSIOLOGICAL.Ventricle Ventricle_right (rai = 0.003,rao = 0.003,period = 1,rec_comp = { { 0,0.4,0.5,1} ,{ 0.0133,0.428,0.0133,0.0133} } ) 
	PHYSIOLOGICAL.Legs Legs (rai = 2.58,rao = 5,comp = 11.1) 
	PHYSIOLOGICAL.Trunk Trunk (rai = 0.67,rao = 1.42,comp = 34) 

		-----------------------------------------------------------
		-- Coded in PHYSIOLOGICAL_EXAMPLES.physbe
		-----------------------------------------------------------
	CONNECT Ventricle_left.p_out TO Aorta.p_in
	CONNECT Aorta.p_out TO Legs.p_in
	CONNECT Aorta.p_out TO Head.p_in
	CONNECT Legs.p_out TO Cava.p_in
	CONNECT Head.p_out TO Cava.p_in
	CONNECT Cava.p_out TO Ventricle_right.p_in
	CONNECT Ventricle_right.p_out TO Lungs.p_in
	CONNECT Lungs.p_out TO Ventricle_left.p_in
	CONNECT Aorta.p_out TO Trunk.p_in
	CONNECT Trunk.p_out TO Cava.p_in
	CONNECT Aorta.p_out TO Arms.p_in
	CONNECT Arms.p_out TO Cava.p_in
END COMPONENT
