-- Libraries
USE MATH 
USE PORTS_LIB 

ABSTRACT COMPONENT OnePort 
    "Abstract component with one electrical port = Two Pins"
    PORTS
        IN elec e_p "Positive pin"
        IN elec e_n "Negative pin"
    DECLS 
        REAL i UNITS u_A	"Current flowing from pin e_p to pin e_n"
        REAL v UNITS u_V	"Voltage drop between the two pins = e_p.v - e_n.v"
		  REAL p	UNITS	u_W	"Power"
    CONTINUOUS
        v = e_p.v - e_n.v
        0 = e_p.i + e_n.i
        i = e_p.i
		  p = v * i
END COMPONENT

ABSTRACT COMPONENT TwoPort
    "Abstract component with two electrical ports =  quadripole"
    PORTS 
        IN elec e_p1 "Positive pin of port 1" 
        IN elec e_n1 "Negative pin of port 1" 
        IN elec e_p2 "Positive pin of port 2" 
        IN elec e_n2 "Negative pin of port 2" 
    DECLS
        REAL v1 UNITS u_V	"Voltage drop over the left port"
        REAL v2 UNITS u_V	"Voltage drop over the right port"
        REAL i1 UNITS u_A	"Current flowing from pos. to neg. pin of the left port"
        REAL i2 UNITS u_A	"Current flowing from pos. to neg. pin of the right port"
    CONTINUOUS 
        v1 = e_p1.v - e_n1.v
        v2 = e_p2.v - e_n2.v
        0 = e_p1.i + e_n1.i
        0 = e_p2.i + e_n2.i
        i1 = e_p1.i
        i2 = e_p2.i
END COMPONENT

ABSTRACT COMPONENT AbsoluteSensor 
    "Abstract component to measure the absolute value of a pin variable" 
    PORTS
        IN elec e_p 		"Pin to be measured" 
        OUT analog_signal s_out
END COMPONENT

ABSTRACT COMPONENT RelativeSensor 
    "Abstract component to measure a relative variable between two pins"
    PORTS    
        IN elec e_p 		"Positive pin" 
        IN elec e_n 		"Negative pin" 
        OUT analog_signal s_out
END COMPONENT


