
-- Libraries
USE MATH 
USE PORTS_LIB 

--This file contains lossy and lossless transmission lines.

COMPONENT Line_LRCG (INTEGER N = 10)    "Lossy Transmission Line" 
    PORTS
        IN elec e_p1 
        IN elec e_p2 
        IN elec e_p3 
    DATA
        REAL  r     = 1   UNITS u_Ohm_m   RANGE 1e-40, 1e40    "Resistance per meter"
        REAL  l     = 1   UNITS u_H_m     RANGE 1e-40, 1e40    "Inductance per meter"
        REAL  g     = 1   UNITS u_S_m     RANGE 1e-40, 1e40    "Conductance per meter"
        REAL  c     = 1   UNITS u_Farad_m     RANGE 1e-40, 1e40    "Capacitance per meter"
        REAL length = 1   UNITS u_m       RANGE 1e-40, 1e40    "Length of line"
    DECLS
        REAL v13
        REAL v23
        REAL i1
        REAL i2
    TOPOLOGY 
        Resistor R[N+1] (R = r * length / (N + 1))
        Inductor L[N+1] (L = l * length / (N + 1))
        Capacitor C[N] (C = c * length / N)
        Conductor G[N] (G = g * length / N)
        CONNECT e_p1  TO  R[1].e_p
        EXPAND_BLOCK (i IN 1,N)
            CONNECT R[i].e_n TO L[i].e_p
            CONNECT L[i].e_n TO C[i].e_p
            CONNECT L[i].e_n TO G[i].e_p
            CONNECT C[i].e_n TO e_p3
            CONNECT G[i].e_n TO e_p3
            CONNECT L[i].e_n TO R[i + 1].e_p
        END EXPAND_BLOCK
        CONNECT R[N + 1].e_n TO L[N + 1].e_p
        CONNECT L[N + 1].e_n TO e_p2
        CONTINUOUS
        v13 = e_p1.v - e_p3.v
        v23 = e_p2.v - e_p3.v
        i1 = e_p1.i
        i2 = e_p2.i
END COMPONENT

COMPONENT Line_RC (INTEGER N = 10) "Uniform Distributed RC Line" 
    PORTS
        IN    elec    e_p1
        IN    elec    e_p2
        IN    elec    e_p3

    DATA
        REAL r      = 1  UNITS u_Ohm_m  RANGE 1e-40, 1e40    "Resistance per meter"
        REAL c      = 1  UNITS u_Farad_m  	 RANGE 1e-40, 1e40    "Capacitance per meter"
        REAL length = 1  UNITS u_m  	 RANGE 1e-40, 1e40    "Length of line"
    DECLS    
        REAL v13
        REAL v23
        REAL i1
        REAL i2
    TOPOLOGY
        Resistor R[N+1] (R = r * length / (N + 1))
        Capacitor C[N] (C = c * length / N)

        CONNECT e_p1  TO  R[1].e_p
            EXPAND_BLOCK (i IN 1,N)
                CONNECT R[i].e_n TO C[i].e_p
                CONNECT C[i].e_n TO e_p3
                CONNECT R[i].e_n TO R[i + 1].e_p
            END EXPAND_BLOCK
        CONNECT R[N + 1].e_n TO e_p2

    CONTINUOUS
        v13 = e_p1.v - e_p3.v
        v23 = e_p2.v - e_p3.v
        i1 = e_p1.i
        i2 = e_p2.i
END COMPONENT





  