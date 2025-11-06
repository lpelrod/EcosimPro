-- Libraries
USE MATH 
--file Sensors 

COMPONENT SensorPotential IS_A AbsoluteSensor
    "Sensor to measure the potential in point"
    DECLS
        REAL phi UNITS u_V		"Absolute voltage potential"
    CONTINUOUS
        e_p.i = 0
        phi = e_p.v
        phi = s_out.signal[1]
END COMPONENT

COMPONENT SensorVoltage IS_A RelativeSensor
    "Sensor to measure the voltage between two pins"
    DECLS
        REAL v "Voltage between pin p and n (= p.v - n.v)"
    CONTINUOUS 
        e_p.i = 0
        e_n.i = 0
        v = e_p.v - e_n.v
        v = s_out.signal[1]
END COMPONENT
  
COMPONENT SensorCurrent IS_A RelativeSensor
    "Sensor to measure the current in a branch" 
    DECLS
        REAL i UNITS u_A	"Current in the branch from p to n"
    CONTINUOUS 
        e_p.v = e_n.v
        e_p.i = i
        e_n.i = -i
        i = s_out.signal[1] 
END COMPONENT
