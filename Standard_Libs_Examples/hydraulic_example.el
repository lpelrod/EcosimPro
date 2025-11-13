/*-----------------------------------------------------------------------------------------
 FILE: hydraulic_example
-----------------------------------------------------------------------------------------*/
-- Libraries
USE MATH 
USE HYDRAULIC 

COMPONENT hydro_circuit1
"Simple hydraulic circuit example 1"
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in HYDRAULIC_EXAMPLES.hydro_circuit1
		-----------------------------------------------------------
	HYDRAULIC.HydTank HydTank1 (z_in = 0,z_out = 0,A = 1,p0 = 101325) 
	HYDRAULIC.HydTank HydTank2 (z_in = 0,z_out = 0,A = 1,p0 = 101325) 
	HYDRAULIC.HydPipe HydPipe (z_in = 0,z_out = 0,l = 1,d = 0.1,f = 0.02,dp_lam = 1000) 

		-----------------------------------------------------------
		-- Coded in HYDRAULIC_EXAMPLES.hydro_circuit1
		-----------------------------------------------------------
	CONNECT HydTank1.hp_out TO HydPipe.hp_in
	CONNECT HydPipe.hp_out TO HydTank2.hp_in
END COMPONENT

COMPONENT hydro_circuit2
"Simple hydraulic circuit example 2"
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in HYDRAULIC_EXAMPLES.hydro_circuit2
		-----------------------------------------------------------
	HYDRAULIC.HydTank HydTank1 (z_in = 0,z_out = 0,A = 1,p0 = 101325) 
	HYDRAULIC.HydTank HydTank3 (z_in = 0,z_out = 0,A = 1,p0 = 101325) 
	HYDRAULIC.HydTank HydTank2 (z_in = 0,z_out = 0,A = 1,p0 = 101325) 
	HYDRAULIC.HydPipe HydPipe4 (z_in = 0,z_out = 0,l = 1,d = 0.1,f = 0.02,dp_lam = 1000) 
	HYDRAULIC.HydPipe HydPipe1 (z_in = 0,z_out = 0,l = 1,d = 0.1,f = 0.02,dp_lam = 1000) 
	HYDRAULIC.HydPipe HydPipe2 (z_in = 0,z_out = 0,l = 1,d = 0.1,f = 0.02,dp_lam = 1000) 
	HYDRAULIC.HydPipe HydPipe3 (z_in = 0,z_out = 0,l = 1,d = 0.1,f = 0.02,dp_lam = 1000) 

		-----------------------------------------------------------
		-- Coded in HYDRAULIC_EXAMPLES.hydro_circuit2
		-----------------------------------------------------------
	CONNECT HydPipe2.hp_out TO HydPipe4.hp_in
	CONNECT HydPipe4.hp_out TO HydTank3.hp_in
	CONNECT HydTank1.hp_out TO HydPipe1.hp_in
	CONNECT HydPipe1.hp_out TO HydPipe2.hp_in
	CONNECT HydPipe2.hp_out TO HydPipe3.hp_in
	CONNECT HydPipe3.hp_out TO HydTank2.hp_in
END COMPONENT

COMPONENT hydro_circuit3
"Controlled hydraulic circuit example"
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in HYDRAULIC_EXAMPLES.hydro_circuit3
		-----------------------------------------------------------
	CONTROL.Cntrl_PID  (n = 1) Cntrl_pid1 (k = { 1} ,u_min = { 0} ,u_max = { 1} ,end_pos = end_I,Ti = { 100} ,gamma = { 0.01} ,beta = { 1} ,Td = { 0.1} ,alpha = { 0.1} ) 
	HYDRAULIC.HydFlowMeter  (n_out = 1) HydFlowMeter1 (gain = { 1} ,bias = { 0} ,z_in = 0,z_out = 0) 
	HYDRAULIC.HydTank HydTank1 (z_in = 0,z_out = 0,A = 1,p0 = 101325) 
	HYDRAULIC.HydTank HydTank2 (z_in = 0,z_out = 0,A = 1,p0 = 101325) 
	HYDRAULIC.HydValve HydValve1 (z_in = 0,z_out = 0,Avo = 0.02,dp_lam = 1000) 
	HYDRAULIC.HydPipe HydPipe2 (z_in = 0,z_out = 0,l = 1,d = 0.1,f = 0.02,dp_lam = 1000) 
	HYDRAULIC.HydPipe HydPipe1 (z_in = 0,z_out = 0,l = 1,d = 0.1,f = 0.02,dp_lam = 1000) 

		-----------------------------------------------------------
		-- Coded in HYDRAULIC_EXAMPLES.hydro_circuit3
		-----------------------------------------------------------
	CONNECT HydFlowMeter1.s_out TO Cntrl_pid1.s_var
	CONNECT Cntrl_pid1.s_out TO HydValve1.s_position
	CONNECT HydValve1.hp_out TO HydFlowMeter1.hp_in
	CONNECT HydFlowMeter1.hp_out TO HydPipe2.hp_in
	CONNECT HydPipe2.hp_out TO HydTank2.hp_in
	CONNECT HydTank1.hp_out TO HydPipe1.hp_in
	CONNECT HydPipe1.hp_out TO HydValve1.hp_in
END COMPONENT
