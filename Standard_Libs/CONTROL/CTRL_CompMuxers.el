--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompMuxers.el
--    FILE TYPE:  Components of the CONTROL library
--    DESCRIPTION:  Defines components to combine and split analog signal ports 
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 

--------------------------------------------------------------------------------
-- Component Mux
--------------------------------------------------------------------------------
-- Purpose:
--    To define an abstract component mux to concatenate several input
--    ports into a single output port
--------------------------------------------------------------------------------
COMPONENT Mux 
   (
	INTEGER n_in = 1  	"Number of inputs",
	INTEGER dim_in = 1	"Dimension of input signals"
   ) "This abstract component is used for deriving multiplexers of different number of inputs by inheritance"

   PORTS
	IN  analog_signal  (n = dim_in)    	s_in[n_in]      "Inlet ports"
	OUT analog_signal (n = n_in * dim_in)  s_out	    "Outlet port"

   TOPOLOGY
	PATH s_in TO s_out

   CONTINUOUS
	EXPAND_BLOCK (i IN 1, n_in)
		EXPAND(j IN 1, dim_in)
			s_out.signal[(i-1)*dim_in+j] = s_in[i].signal[j]
	END EXPAND_BLOCK
END COMPONENT 


--------------------------------------------------------------------------------
-- Component Demux
--------------------------------------------------------------------------------
-- Purpose:
--    To define an abstract component demux to split up a single inlet
--    port into several output ports 
--------------------------------------------------------------------------------
COMPONENT Demux 
   (
	INTEGER n_out = 1		"Number of outputs",
	INTEGER dim_out = 1	"Dimension of outlet signals"
   ) "This abstract component is used for deriving demultiplexers of different number of outputs by inheritance"
	
   PORTS
	IN  analog_signal  (n = n_out * dim_out) s_in	"Inlet port"
	OUT analog_signal (n = dim_out)  s_out[n_out]	"Outlet ports"
	
   TOPOLOGY
	PATH s_in TO s_out
	
   CONTINUOUS
	EXPAND (i IN 1, n_out)
		EXPAND(j IN 1, dim_out)
			s_out[i].signal[j] = s_in.signal[j+(i-1)*dim_out]
END COMPONENT

--------------------------------------------------------------------------------
-- Components Mux2, Mux3, Mux4, Mux5, Mux6, Mux7, Mux8
--------------------------------------------------------------------------------
-- Purpose:
--    To define mux components with 2,3,4,5,6,7 and 8 inputs
--------------------------------------------------------------------------------
COMPONENT Mux2 IS_A Mux "Multiplexer of 2 inputs"

   DECLS
	CLOSE n_in = 2

END COMPONENT

COMPONENT Mux3 IS_A Mux "Multiplexer of 3 inputs"

   DECLS
	CLOSE n_in = 3

END COMPONENT

COMPONENT Mux4 IS_A Mux "Multiplexer of 4 inputs"

   DECLS
	CLOSE n_in = 4

END COMPONENT

COMPONENT Mux5 IS_A Mux "Multiplexer of 5 inputs"

   DECLS
	CLOSE n_in = 5

END COMPONENT

COMPONENT Mux6 IS_A Mux "Multiplexer of 6 inputs"

   DECLS
	CLOSE n_in = 6

END COMPONENT

COMPONENT Mux7 IS_A Mux "Multiplexer of 7 inputs"

   DECLS
	CLOSE n_in = 7

END COMPONENT

COMPONENT Mux8 IS_A Mux "Multiplexer of 8 inputs"

   DECLS
	CLOSE n_in = 8

END COMPONENT


--------------------------------------------------------------------------------
-- Components Demux2, Demux3, Demux4, Demux5, Demux6, Demux7, Demux8
--------------------------------------------------------------------------------
-- Purpose:
--    To define demux components with 2,3,4,5,6,7 and 8 outputs
--------------------------------------------------------------------------------
COMPONENT Demux2 IS_A Demux "Demultiplexer of 2 outlets"

   DECLS
	CLOSE n_out = 2

END COMPONENT

COMPONENT Demux3 IS_A Demux "Demultiplexer of 3 outlets"

   DECLS
	CLOSE n_out = 3

END COMPONENT

COMPONENT Demux4 IS_A Demux "Demultiplexer of 4 outlets"

   DECLS
	CLOSE n_out = 4

END COMPONENT

COMPONENT Demux5 IS_A Demux "Demultiplexer of 5 outlets"

   DECLS
	CLOSE n_out = 5

END COMPONENT

COMPONENT Demux6 IS_A Demux "Demultiplexer of 6 outlets"

   DECLS
	CLOSE n_out = 6

END COMPONENT

COMPONENT Demux7 IS_A Demux "Demultiplexer of 7 outlets"

   DECLS
	CLOSE n_out = 7

END COMPONENT

COMPONENT Demux8 IS_A Demux "Demultiplexer of 8 outlets"

   DECLS
	CLOSE n_out = 8

END COMPONENT

--------------------------------------------------------------------------------
-- Component Selector
--------------------------------------------------------------------------------
-- Purpose:
--   To select signals from the input port and transfer them to the outlet port
--------------------------------------------------------------------------------
COMPONENT Selector IS_A MIMO "To select signals from the input port and transfer them to the outlet port"

   DATA
	INTEGER SelElements[n_out] = 1	"Elements to be included in the output vector"

   INIT
	FOR(i IN 1, n_out)
		ASSERT(SelElements[i] < n_in+1 AND SelElements[i]>0) FATAL "One of the selected elements in Selector\
							component is greater than the dimension of the input array or less than 1"
	END FOR

   DISCRETE
	EXPAND(i IN 1, n_out)
		ASSERT(SelElements[i] < n_in+1 AND SelElements[i]>0) FATAL "One of the selected elements in Selector\
							component is greater than the dimension of the input array or less than 1"

   CONTINUOUS
	EXPAND(i IN 1, n_out)
		s_out.signal[i] = GetRealArrayItem(s_in.signal, SelElements[i])


END COMPONENT
