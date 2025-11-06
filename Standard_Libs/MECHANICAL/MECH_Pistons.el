
-- Libraries
USE PORTS_LIB 
USE MATH 



-------------------------------------------------
--            Linear Piston
-------------------------------------------------

COMPONENT T_Piston IS_A T_Rigid \
"Dynamic model of a Piston submitted to the forces of pressure, spring, friction ..."
 
    PORTS
        IN  analog_signal s_Fext           "Piston external force signal"
 
    DATA

        REAL Mp      = 1.0			UNITS u_kg    "Piston mass"
--        REAL A1_pis  = 0.01   "Left piston area (m^2)"
--        REAL A2_pis  = 0.01   "Right piston area (m^2)"

        REAL xini      = 0.000   UNITS u_m  	"Piston initial position"
        REAL xmin      = 0.000   UNITS u_m  	"Piston position lower limit"
        REAL xmax      = 0.050   UNITS u_m  	"Piston position upper limit"

        REAL K_spr     = 1e5     UNITS u_N_m		"Spring constant"
        REAL Fpl       = 100.0   UNITS u_N		"Piston preload at xmin"

        REAL cv        = 20.0    UNITS u_N_ms  	"Viscous friction coeffient"
        REAL fc1       = 0.000   UNITS u_N  		"Direct coulomb friction"
        REAL fc2       = 0.000   UNITS u_N	 	"Inverse coulomb friction"

    DECLS
 
        REAL x         UNITS u_m     "Piston position"
        REAL x0        UNITS u_m   	 "Piston precharge" 
        REAL F         UNITS u_N     "Net Force on piston"

    INIT
       x = xini
       x' = 0.

    DISCRETE
     WHEN (((x-xmin)/(xmax-xmin)<=0) OR ((x-xmin)/(xmax-xmin)>=1)) THEN
		 x' = 0 
     END WHEN

    CONTINUOUS

       x0 = xmin-Fpl/max(K_spr, 1e-20)

--   Forces calculations 

      F = - K_spr * (x-x0) + rev_fri(x',fc1,fc2) - cv*x'  \
          + s_Fext.signal[1] + m_in.F + m_out.F 

      x'' = ZONE ((x-xmin)/(xmax-xmin)<=0 AND F/Mp < 0) 0  
            ZONE ((x-xmin)/(xmax-xmin)>=1 AND F/Mp > 0) 0
            OTHERS F/Mp

--    Output displacemnt signals 
 
      m_in.s  = x 

END COMPONENT


-------------------------------------------------
--             Piston (Angular)
-------------------------------------------------

COMPONENT R_Piston IS_A T_Rigid \
"Dynamic model of an angular Piston submitted to the forces of pressure, spring, friction ..."
 
    PORTS
        IN  analog_signal s_Mext           "Piston external torque signal"
 
    DATA

        REAL R         = 0.100     UNITS u_m   		"Effective radius"
        REAL Ip        = 0.0100    UNITS u_kgm2   	"Movil parts inertia"
--        REAL A1_pis  = 0.01   "Left piston area (m^2)"
--        REAL A2_pis  = 0.01   "Right piston area (m^2)"

        REAL theini    = 0.000     UNITS u_rad	"Piston initial position"
        REAL themin    = 0.000     UNITS u_rad	"Piston position lower limit"
        REAL themax    = 1.000     UNITS u_rad	"Piston position upper limit"

        REAL K_spr     = 1e3       UNITS u_Nm_rad	"Spring constant"
        REAL Mpl       = 10.       UNITS u_Nm		"Piston preload at themin"

        REAL cv        = 20.0      UNITS u_N_ms	"Viscous friction coeffient"
        REAL fc1       = 0.000     UNITS u_N		"Direct coulomb friction torque"
        REAL fc2       = 0.000     UNITS u_N	"Inverse coulomb friction torque"

    DECLS
 
        REAL the      UNITS u_rad        	"Angular piston position"
        REAL the0     UNITS u_rad        	"Angular piston precharge"
        REAL M        UNITS u_Nm     		"Net M on piston"

    INIT
      the  = theini
      the' = 0.

    DISCRETE
        WHEN (((the-themin)/(themax-themin)<0) OR ((the-themin)/(themax-themin)>1)) THEN
        the' = 0 
	  END WHEN

    CONTINUOUS

      the0 = themin - Mpl/max(K_spr, 1e-20)

--   Forces calculations 

      M = - K_spr*(the-the0) + (rev_fri(R*the',fc1,fc2) - cv*the'*R)*R \
          + s_Mext.signal[1] + (m_in.F + m_out.F)*R

      the'' = ZONE ((the-themin)/(themax-themin)<0 AND M/Ip < 0) 0  
              ZONE ((the-themin)/(themax-themin)>1 AND M/Ip > 0) 0
              OTHERS M/Ip

--    Output displacemnt signals 
 
      m_in.s = the*R       
END COMPONENT
