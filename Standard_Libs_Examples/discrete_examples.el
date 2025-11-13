/*-----------------------------------------------------------------------------------------
 FILE: discrete_examples
-----------------------------------------------------------------------------------------*/

-- Libraries
USE MATH 
USE DISCRETE_LIB 

COMPONENT counter
"Counter example"
TOPOLOGY

		-----------------------------------------------------------
		-- Coded in DISCRETE_EXAMPLES.counter
		-----------------------------------------------------------
	DISCRETE_LIB.Clock Clock (period = 1) 
	DISCRETE_LIB.Reset Reset (delay = 2) 
	DISCRETE_LIB.T_flip_flop T_flip_flop3 (delay = 0.1) 
	DISCRETE_LIB.T_flip_flop T_flip_flop2 (delay = 0.1) 
	DISCRETE_LIB.T_flip_flop T_flip_flop1 (delay = 0.1) 

		-----------------------------------------------------------
		-- Coded in DISCRETE_EXAMPLES.counter
		-----------------------------------------------------------
	CONNECT T_flip_flop3.po TO T_flip_flop3.pi
	CONNECT T_flip_flop2.po TO T_flip_flop3.clock
	CONNECT Reset.po TO T_flip_flop3.reset
	CONNECT T_flip_flop2.po TO T_flip_flop2.pi
	CONNECT T_flip_flop1.po TO T_flip_flop2.clock
	CONNECT Reset.po TO T_flip_flop2.reset
	CONNECT T_flip_flop1.po TO T_flip_flop1.pi
	CONNECT Clock.po TO T_flip_flop1.clock
	CONNECT Reset.po TO T_flip_flop1.reset
END COMPONENT
