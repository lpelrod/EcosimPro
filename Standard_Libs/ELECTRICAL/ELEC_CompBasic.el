---------------------------------------------------------
-- This file contains basic analog electrical components:
--Ground
--Resistor
--Conductor
--Capacitor
--Inductor
--Coupled Inductor
--Gyrator
--EMF
---------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 


COMPONENT Ground 
    "Ground of an electrical circuit"
    PORTS
        IN elec e_p 
    CONTINUOUS 
        e_p.v = 0
END COMPONENT

COMPONENT Resistor IS_A OnePort
    "Resistor"
    DATA
        REAL R=1 UNITS u_Ohm	"Resistance"
    CONTINUOUS 
        R*i = v
END COMPONENT
  
COMPONENT Conductor IS_A OnePort
    "Electrical Conductor" 
    DATA
        REAL G=1 UNITS u_S		"Conductance"
    CONTINUOUS 
        i = G*v
END COMPONENT

COMPONENT Capacitor IS_A OnePort
    "Electrical Capacitor"
    DATA
        REAL C=1e-6 UNITS u_Farad 	"Capacitance"
    CONTINUOUS 
        i = C*v'
END COMPONENT

COMPONENT Inductor IS_A OnePort
    "Inductor"
    DATA
        REAL L=1 UNITS u_H		"Inductance"
    CONTINUOUS 
        L*i' = v
END COMPONENT

COMPONENT CoupledInductor IS_A TwoPort
    "Coupled inductors"

    DATA
        REAL L1=1     UNITS u_H	RANGE 0, Inf  "Primary inductance"
        REAL L2=1     UNITS u_H	RANGE 0, Inf  "Secondary inductance"
        REAL K = 0.5  UNITS no_units	RANGE 0, 1-1e-6   "Coefficient of Coupling Coupling"
    DECLS
        REAL M "Coupling inductance (H)"
    CONTINUOUS 
        M = K * sqrt(L1*L2)
        v1 = L1*i1' + M*i2'
        v2 = M*i1' + L2*i2'
END COMPONENT

COMPONENT Gyrator IS_A TwoPort
    "Gyrator" 

    DATA
        REAL G1=1 UNITS u_S	"Gyration conductance"
        REAL G2=1 UNITS u_S	"Gyration conductance"
    CONTINUOUS 
        i1 =  G2*v2
        i2 = -G1*v1
END COMPONENT

COMPONENT EMF 

    "Electromotive force (electric/mechanic transformer)" \

    PORTS
        IN elec e_p "Positive pin"
        IN elec e_n "Negative pin"
        OUT mech_rot m_out
    DATA
        REAL k = 1 UNITS "Nw.m/A"	"Transformation coefficient"
    DECLS
        REAL v  	 UNITS u_V   		"Voltage drop between the two pins"
        REAL i 	 UNITS u_A   		"Current flowing from positive to negative pin"
        REAL omega UNITS u_rad_s		"Angular velocity of flange_b"
     CONTINUOUS 
        v = e_p.v - e_n.v
        0 = e_p.i + e_n.i
        i = e_p.i
        omega = m_out.omega
        k*omega = v
        m_out.T = k*i
END COMPONENT


