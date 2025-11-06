USE MATH 

COMPONENT VCVS IS_A TwoPort
    "Linear voltage-controlled voltage source" 
    DATA
        REAL gain=1    UNITS no_units  "Voltage gain"
        REAL R1 = 1e40 UNITS u_Ohm  "Input resistance"
        REAL R2 = 0    UNITS u_Ohm  "Output resistance"
    CONTINUOUS         
        v2 = v1*gain - R2*i2
        i1 = v1/R1
END COMPONENT

COMPONENT VCCS IS_A TwoPort
"Linear voltage-controlled current source"

    DATA
        REAL transConductance=1 UNITS u_S	"Transconductance"
        REAL R1 = 1e40  UNITS u_Ohm	 "Input resistance"
        REAL R2 = 1e40  UNITS u_Ohm	 "Output resistance"
    CONTINUOUS 
        i2 = v1*transConductance - v2/R2
        i1 = v1/R1
END COMPONENT

COMPONENT CCVS IS_A TwoPort 
    "Linear current-controlled voltage source"
    DATA
        REAL  transResistance=1 UNITS u_Ohm	"Transresistance"
        REAL R1 = 0   UNITS u_Ohm	"Input resistance"
        REAL R2 = 0   UNITS u_Ohm	"Output resistance"
    CONTINUOUS 
        v2 = i1*transResistance - i2*R2
        v1 = i1*R1
END COMPONENT

COMPONENT CCCS IS_A TwoPort
    "Linear current-controlled current source" 
    DATA
        REAL gain=1 		UNITS no_units     "Current gain"
        REAL R1 = 0  	UNITS u_Ohm    "Input resistance"
        REAL R2 = 1e40  UNITS u_Ohm "Output resistance"
    CONTINUOUS 
        i2 = i1*gain - v2/R2
        v1 = i1*R1
END COMPONENT