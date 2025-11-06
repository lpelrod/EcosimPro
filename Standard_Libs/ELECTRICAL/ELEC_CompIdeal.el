
--This file contains ideal components:
--       Ideal thyristor
--       Ideal GTO thyristor
--       switches
--       diode
--       transformer
--       gyrator
--       operational amplifier
--       operational amplifier (3 Pins)
--       short cut

-- Libraries
USE MATH 
USE PORTS_LIB 

COMPONENT IdealThyristor IS_A OnePort

    "Ideal thyristor"

    PORTS

        IN bool_signal b_fire

    DATA
 
        REAL Roff = 1.E-5 UNITS u_Ohm	RANGE 0,1.e38 "Closed thyristor resistance"
        REAL Gon  = 1.E-5 UNITS u_S		RANGE 0,1.e38 "Opened thyristor conductance"

    DECLS

        REAL s 		"Auxiliary variable"
             --s is equal to voltage difference when open 
             --and equal to current when closed
        BOOLEAN closed = FALSE
        BOOLEAN open = TRUE

    DISCRETE

        WHEN (open AND s > 0 AND b_fire.signal[1]) THEN
            open = FALSE
            closed = TRUE
        END WHEN
        WHEN (closed AND  s < 0 ) THEN
            closed = FALSE
            open = TRUE
        END WHEN

    CONTINUOUS
 
        v = ZONE (open) s
            OTHERS Roff*s

        i = ZONE (open) Gon*s 
            OTHERS s

END COMPONENT 

COMPONENT IdealGTOThyristor IS_A OnePort 
    "Ideal GTO thyristor"
    PORTS
        IN bool_signal b_fire
    DATA
        REAL Roff = 1.E-5  UNITS u_Ohm	RANGE 0, 1e38 "Closed thyristor resistance"
        REAL Gon  = 1.E-5  UNITS u_S	RANGE 0, 1e38 "Opened thyristor conductance"
    DECLS
        REAL s 			"Auxiliary variable"
             --s is equal to voltage difference when open 
             --and equal to current when closed
        BOOLEAN closed = FALSE
        BOOLEAN open = TRUE
    DISCRETE

        WHEN (open AND s > 0 AND b_fire.signal[1]) THEN
            open = FALSE
            closed = TRUE
        END WHEN

        WHEN (closed AND (s < 0  OR NOT b_fire.signal[1])) THEN
            closed = FALSE
            open = TRUE
        END WHEN



    CONTINUOUS


        --fire = b_fire.signal[1]

        v = ZONE (open) s
            OTHERS Roff*s

        i = ZONE (open) Gon*s 
            OTHERS s
END COMPONENT

COMPONENT IdealSwitch IS_A OnePort 
    "Ideal electrical switch"

    PORTS
        IN bool_signal b_fire

    DATA      
        REAL Roff = 1.E-5  UNITS u_Ohm		RANGE 0, 1e38 "Closed thyristor resistance"
        REAL Gon  = 1.E-5  UNITS u_S		RANGE 0, 1e38 "Opened thyristor conductance"
    DECLS       
	 REAL s 				"Auxiliary variable"
             --s is equal to voltage difference when open 
             --and equal to current when closed
        BOOLEAN closed = FALSE
        BOOLEAN open = TRUE
    DISCRETE

        WHEN (b_fire.signal[1]) THEN
            open = FALSE
            closed = TRUE
        END WHEN
        WHEN (NOT b_fire.signal[1]) THEN
            closed = FALSE
            open = TRUE
        END WHEN

  CONTINUOUS 


        v = ZONE (open) s
            OTHERS Roff*s

        i = ZONE (open) Gon*s 
            OTHERS s

END COMPONENT

COMPONENT ControlledIdealSwitch
    "Controlled Ideal Switch" 
    PORTS 
        IN elec e_p "Positive pin" 
        IN elec e_n "Negative pin" 
        IN elec e_control "Control pin: control.v > level open, otherwise closed" 

    DATA
        REAL level=0.5 	  UNITS u_V		"Switch level"
        REAL Roff = 1.E-5 UNITS u_Ohm	RANGE 0, 1e40  "Closed switch resistance"
        REAL Gon  = 1.E-5 UNITS u_S		RANGE 0, 1e40  "Opened switch conductance"
    DECLS 
        REAL s "Auxiliary variable"
             --s is equal to voltage difference when open 
             --and equal to current when closed

    CONTINUOUS

        e_control.i = 0.

	 0 = e_p.i + e_n.i

        e_p.v - e_n.v =	ZONE(e_control.v < level)	s*Roff
				OTHERS			s

        e_n.i = 		ZONE(e_control.v < level)	s
				OTHERS			Gon*s


END COMPONENT


COMPONENT ControlledIdealCommutingSwitch 
    "Ideal commuting switch" 

    PORTS
        IN elec e_p "Positive pin" 
        IN elec e_n2 "Negative pin 2"
        IN elec e_n1 "Negative pin 1" 
        IN elec e_control "Control pin: control.v > level p--n2, otherwise p--n1" 
    DATA 
        REAL level=0.5 	  UNITS u_V			"Switch level"
        REAL Roff = 1.E-5 UNITS u_Ohm	RANGE 0, 1e40  "Closed switch resistance"
        REAL Gon  = 1.E-5 UNITS u_S		RANGE 0, 1e40  "Opened switch conductance"
  DECLS
    REAL s1 "Auxiliary variable 1"
    REAL s2 "Auxiliary variable 2"
  
  CONTINUOUS 

    e_control.i = 0

    0 = e_p.i + e_n2.i + e_n1.i
    
    e_p.v - e_n1.v = ZONE(e_control.v > level) s1 
				OTHERS Roff*s1

    e_n1.i = ZONE(e_control.v > level) Gon*s1
             OTHERS s1

    e_p.v - e_n2.v = ZONE(e_control.v > level) Roff*s2
                        OTHERS s2

    e_n2.i = ZONE(e_control.v > level)s2
		    OTHERS Gon*s2

END COMPONENT

COMPONENT IdealOpAmp IS_A TwoPort 
    "Ideal Operational Amplifier"

   DATA
         REAL G = 1e6 	UNITS no_units  "Amplifier gain"

   CONTINUOUS 

       v1 = e_p1.v - e_n1.v
       v2 = e_p2.v - e_n2.v
       0 = e_p1.i + e_n1.i
       0 = e_p2.i + e_n2.i
       i1 = e_p1.i
       i2 = e_p2.i
       v2 = G * v1 
       i1 = 0

END COMPONENT

COMPONENT IdealOpAmp3Pin 
    "Ideal Operational Amplifier with 3 pins" 

    PORTS
        IN elec e_in_p "Positive pin of the input port" 
        IN elec e_in_n "Negative pin of the input port" 
        IN elec e_out  "Output pin" 
    DATA
        REAL G = 1e6  UNITS no_units	 "Amplifier gain"
    CONTINUOUS 
        e_out.v = G * (e_in_p.v - e_in_n.v)
        e_in_p.i = 0
        e_in_n.i = 0
END COMPONENT

COMPONENT IdealDiode IS_A OnePort
    "Ideal electrical diode"


    DATA 
       REAL Roff = 1.E-5 UNITS u_Ohm	"Closed diode resistance"
       REAL Gon = 1.E-5  UNITS u_S		"Opened diode conductance"


    DECLS
 
       REAL s 					"Auxiliary variable"
       BOOLEAN off = TRUE 	"Switching state of diode"
    DISCRETE

		WHEN ( s < 0) THEN
			off = TRUE
		END WHEN
		WHEN ( s >= 0) THEN
			off = FALSE
		END WHEN

  CONTINUOUS 
 
    v  = ZONE(off)s
            OTHERS Roff*s
    i  = ZONE(off)Gon*s
            OTHERS s

END COMPONENT

COMPONENT IdealTransformer IS_A TwoPort
    "Ideal electrical transformer" 
    DATA
        REAL n=2 UNITS no_units	"Turns ratio"
    CONTINUOUS 
        v1 =  n*v2
        i2 = -n*i1
END COMPONENT

COMPONENT Short IS_A OnePort 
    "Short cut branch" 
    CONTINUOUS 
        v = 0
END COMPONENT
