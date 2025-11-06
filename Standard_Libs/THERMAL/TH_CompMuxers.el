/*-----------------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompMuxers.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a splitting and mixer thermal ports
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Jose Moral Moral
--		CREATION DATE:	26-Jan-2004
-----------------------------------------------------------------------------------------*/

-- Libraries
USE MATH 
USE PORTS_LIB 


--------------------------------------------------------------------------------
-- Purpose: Splitting of thermal ports (thermal demultiplexer, splitting a thermal port of dimension m+n into two ports with dimension m and n and vice versa
--------------------------------------------------------------------------------
 COMPONENT Th_Demux (INTEGER n1=1 "First outlet thermal port dimension", INTEGER n2=1 "Second outlet thermal port dimension") \
"Thermal demultiplexer, splitting a thermal port  into two ports "
    PORTS
       IN thermal (n = n1+n2) tp_in
       OUT thermal (n=n1) tp_out1
       OUT thermal (n=n2) tp_out2
    INIT
--       ASSERT (n_in == n1+n2) FATAL "Th_Demux: Sum of outlet port dimensions not equal to the inlet dimension"

    CONTINUOUS
        EXPAND(j IN 1, n1) tp_out1.q[j]  = tp_in.q[j]
        EXPAND(j IN 1, n1) tp_out1.Tk[j] = tp_in.Tk[j]

        EXPAND(j IN 1, n2) tp_out2.q[j]  = tp_in.q[j+n1]
        EXPAND(j IN 1, n2) tp_out2.Tk[j] = tp_in.Tk[j+n1]
END COMPONENT
           
 COMPONENT Th_Mux (INTEGER n1=1 "First inlet thermal port dimension", INTEGER n2=1 "Second inlet thermal port dimension")\
"Thermal multiplexer, bringing together two thermal ports into one port "
    PORTS
       IN  thermal (n=n1) tp_in1
       IN  thermal (n=n2) tp_in2
       OUT thermal (n = n1+n2) tp_out
    INIT
--       ASSERT (n_out == n1+n2) FATAL "Th_Mux: Sum of inlet port dimensions not equal to the outlet dimension"

    CONTINUOUS
        EXPAND(j IN 1, n1) tp_in1.q[j]  = tp_out.q[j]
        EXPAND(j IN 1, n1) tp_in1.Tk[j] = tp_out.Tk[j]

        EXPAND(j IN 1, n2) tp_in2.q[j]  = tp_out.q[j+n1]
        EXPAND(j IN 1, n2) tp_in2.Tk[j] = tp_out.Tk[j+n1]
END COMPONENT


--------------------------------------------------------------------------------
-- Purpose: Splitting of thermal ports (thermal demultiplexer, splitting a thermal port of dimension n into n ports with dimension 1
--------------------------------------------------------------------------------
 COMPONENT Th_Demux1 (INTEGER n=1 "Inlet thermal port dimension") \
"Thermal demultiplexer, splitting a thermal port of dimension n into n ports of dimension 1"
    PORTS
       IN thermal (n = n) tp_in
       OUT thermal (n=1) tp_out[n]
    INIT
--       ASSERT (n_in == n1+n2) FATAL "Th_Demux: Sum of outlet port dimensions not equal to the inlet dimension"

    CONTINUOUS
        EXPAND(j IN 1, n) tp_out[j].q[1]  = tp_in.q[j]
        EXPAND(j IN 1, n) tp_out[j].Tk[1] = tp_in.Tk[j]
END COMPONENT
           
 COMPONENT Th_Mux1 (INTEGER n=1 "Outlet thermal port dimension")\
"Thermal multiplexer, bringing together n thermal ports of dimension 1 into one port of dimension n "
    PORTS
       IN  thermal (n = 1) tp_in[n]
       OUT thermal (n = n) tp_out
    INIT
--       ASSERT (n_out == n1+n2) FATAL "Th_Mux: Sum of inlet port dimensions not equal to the outlet dimension"

    CONTINUOUS
        EXPAND(j IN 1, n) tp_out.q[j]  = tp_in[j].q[1]
        EXPAND(j IN 1, n) tp_out.Tk[j] = tp_in[j].Tk[1]
END COMPONENT           
