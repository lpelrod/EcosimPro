--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_TRANS_CompFriction.el
--    FILE TYPE:  Friction Elements of the MECHANICAL library
--    DESCRIPTION:  Defines a sliding mass with hard stop and Stribeck friction
--                  for the MECHANICAL library
--    NOTES:  
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
USE MATH 
--------------------------------------------------------------------------------
-- Component T_Stop
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a sliding mass with hard stop and Stribeck friction.
--------------------------------------------------------------------------------
COMPONENT T_Stop IS_A T_Rigid
"Sliding mass with hard stop and Stribeck friction"
    DATA
        REAL m = 1            UNITS u_kg		"Mass"
        REAL smax = 25        UNITS u_m		"Right stop for sliding mass"
        REAL smin = -25       UNITS u_m		"Left stop for sliding mass"
        REAL F_prop = 1       UNITS u_Ns_m	"Velocity dependent friction" --(N/[m/s])"
        REAL F_Coulomb  = 5   UNITS u_N		"Constant friction: Coulomb force"
        REAL F_Stribeck = 10 	UNITS u_N 		"Stribeck effect"
        REAL fexp = 2         UNITS u_s_m		"Exponential decay" --(1/[m/s])"
        REAL sini      = 0.000   UNITS u_m  	"Initial position"

    DECLS
--	  REAL fr0              	UNITS u_N		"Friction force for v = 0 and forward sliding"
--        REAL fr0_max          UNITS u_N		"Maximum friction force fro v = 0 and locked"
        REAL fr               UNITS u_N		"Friciton force" 
        REAL f						UNITS u_N		"External forces"
        REAL v                UNITS u_m_s		"Velocity"
        REAL a                UNITS u_m_s2	"Acceleration"
--        ENUM FrictionState state = Stuck	"Friction state"
        BOOLEAN var_initial = TRUE		"Initial state"

    INIT
		var_initial = FALSE
		s = sini
		s' = 0
      ASSERT(s >= smin AND s <= smax) FATAL "Error in initialization of hard stop s must be within margins"

    DISCRETE
       WHEN (((s-smin)/(smax-smin)<=0) OR ((s-smin)/(smax-smin)>=1)) THEN
          v = 0 
       END WHEN
/*
        WHEN (state == Stuck AND (f > fr0_max AND s < smax)) THEN
            state = StartForward
        END WHEN

        WHEN (state == Stuck AND (f < -fr0_max AND s > smin)) THEN
            state = StartBackward
        END WHEN

        WHEN (state == StartForward AND v > 0 AND s < smax) THEN
            state = Forward
        END WHEN 

        WHEN (state == Forward AND (v <= 0 OR s > smax)) THEN
            state = Stuck
        END WHEN

        WHEN (state == StartBackward AND v < 0 AND s > smin) THEN
            state = Backward
        END WHEN
 
        WHEN (state == Backward AND (v >= 0 OR s < smin)) THEN
            state = Stuck
        END WHEN
*/
    CONTINUOUS
--        fr0 = (F_Coulomb + F_Stribeck)
--        fr0_max = fr0 * 1.001

        s' = v
        v' = a

        f  = m_in.F + m_out.F 

        fr = F_prop*v +  sign(v)*F_Stribeck*exp(-fexp*abs(v)) - rev_fri(v,F_Coulomb,F_Coulomb)

        a = ZONE ((s-smin)/(smax-smin)<=0 AND (f-fr)/m < 0) 0  
            ZONE ((s-smin)/(smax-smin)>=1 AND (f-fr)/m > 0) 0
            OTHERS (f-fr)/m
/*
        fr = ZONE (state == Stuck)               f
             ZONE (state == StartForward)        F_prop * v + F_Coulomb + F_Stribeck
             ZONE (state == Forward)             F_prop * v + F_Coulomb + F_Stribeck * exp(-fexp * abs(v))
             ZONE (state == StartBackward)       F_prop * v - F_Coulomb - F_Stribeck             
             ZONE (state == Backward)            F_prop * v - F_Coulomb - F_Stribeck * exp(-fexp * abs(v))
             OTHERS                              0.0
*/
END COMPONENT 