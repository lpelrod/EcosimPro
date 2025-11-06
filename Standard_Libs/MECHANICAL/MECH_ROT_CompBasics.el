--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_ROT_CompBasics.el
--    FILE TYPE:  Components of the MECHANICAL library
--    DESCRIPTION:  Defines basic rotational components 
--                  for the MECHANICAL library
--    NOTES:
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
USE MATH 

--------------------------------------------------------------------------------
-- Component R_Inertia
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a rotating mass with inertia.
--------------------------------------------------------------------------------
COMPONENT R_Inertia IS_A R_Rigid
"Rotating mass with inertia"
   DATA
	REAL I = 1.   			UNITS u_kgm2         "Moment of inertia of body"
      REAL w0 = 0.      UNITS u_rad_s          "Initial angular velocity"

   DECLS
	REAL a		"Absolute angular acceleration (rad/s^2)"
   INIT
	w = w0

   CONTINUOUS

	w' = a
      I * a = m_in.T - m_out.T

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_Stop
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a rotating mass with hard stops.
--------------------------------------------------------------------------------
COMPONENT R_Stop IS_A R_Rigid
"Rotating mass with inertia and stops"
   DATA
	REAL I = 1.            UNITS u_kgm2		"Moment of inertia of body"
   REAL phi0 = 0.         UNITS u_rad		"Initial angular position"
   REAL w0 = 0.           UNITS u_rad_s		"Initial angular velocity"
   REAL phi_min =-0.50    UNITS u_rad		"Lower limit angular position"
   REAL phi_max = 0.50    UNITS u_rad		"Upper limit angular position"

   DECLS
	REAL a    		UNITS u_rad_s2			"Absolute angular acceleration"
	REAL phi 		UNITS u_rad				"Absolute angular position"	
   REAL M    		UNITS u_Nm				"Net Moment on lever"

   INIT
	w = w0
	phi = phi0

   DISCRETE
   WHEN (((phi-phi_min)/(phi_max-phi_min)<0) OR ((phi-phi_min)/(phi_max-phi_min)>1)) THEN
		w = 0 
   END WHEN

   CONTINUOUS
	w' = a
	phi' = w
   M = m_in.T - m_out.T

   w' = ZONE ((phi-phi_min)/(phi_max-phi_min)<0 AND M/I < 0) 0  
        ZONE ((phi-phi_min)/(phi_max-phi_min)>1 AND M/I > 0) 0
        OTHERS M/I

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_Spring
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an ideal helicoidal spring.
--------------------------------------------------------------------------------
COMPONENT R_Spring IS_A R_Compliant
"Ideal helicoidal spring"
   DATA
      REAL c = 0.             UNITS u_Nm_rad	   "Spring constant"
      REAL phi_rel0 = 0.      UNITS u_rad		   "Angular distance between ports for unstretched spring"

   CONTINUOUS
      T = - c * (phi_rel - phi_rel0)

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_Damper
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an ideal rotational damper.
--------------------------------------------------------------------------------
COMPONENT R_Damper IS_A R_Compliant
"Ideal rotational damper"
   DATA
      REAL d = 0.           UNITS u_Nms_rad     "Damping constant"

   DECLS
      REAL w_rel = 0.       UNITS u_rad_s      "Relative angular velocity between ports"

   CONTINUOUS

	w_rel = m_out.omega - m_in.omega

      T = - d * w_rel

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_SpringDamper
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an ideal rotational damper.
--------------------------------------------------------------------------------
COMPONENT R_SpringDamper IS_A R_Compliant
"Linear spring and linear damper in parallel"
   DATA
      REAL d = 0.              UNITS u_Nms_rad  "Damping constant"
      REAL c = 0.              UNITS u_Nm_rad	"Spring constant"
      REAL phi_rel0 = 0.       UNITS u_rad	   "Angular distance between ports for unstretched spring"


   DECLS
      REAL w_rel = 0.         UNITS u_rad_s    "Relative angular velocity between ports"

   CONTINUOUS

	w_rel = m_out.omega - m_in.omega

      T = - c*(phi_rel - phi_rel0) - d * w_rel

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_SpringBacklash
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an helicoidal spring with backlash.
--------------------------------------------------------------------------------
COMPONENT R_SpringBacklash IS_A R_Compliant
"Helicoidal spring with backlash"
   DATA
      REAL c = 0.              UNITS u_Nm_rad   "Spring constant"

      REAL phi_rel0 = 0.       UNITS u_rad   	"Angular distance between ports for unstretched spring"

      REAL ddz = 0.            UNITS u_rad  		"Direct dead zone"
      REAL idz = 0.            UNITS u_rad  		"Inverse dead zone"

   CONTINUOUS
      T = ZONE (phi_rel >= ddz) - c * (phi_rel - phi_rel0 - ddz)
          ZONE (phi_rel <= idz) - c * (phi_rel - phi_rel0 + idz)
          OTHERS                       0.

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_ElastoBacklash
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an helicoidal spring with backlash.
--------------------------------------------------------------------------------
COMPONENT R_ElastoBacklash IS_A R_Compliant
"Helicoidal spring and damper with backlash"
   DATA
      REAL d = 0.             UNITS u_Nms_rad   "Damping constant"

      REAL c = 0.             UNITS u_Nm_rad    "Spring constant"

      REAL phi_rel0 = 0.      UNITS u_rad   		"Angular distance between ports for unstretched spring"

      REAL ddz = 0.           UNITS u_rad			"Direct dead zone"
      REAL idz = 0.           UNITS u_rad   		"Inverse dead zone"

   DECLS
      REAL w_rel             	UNITS u_rad_s		"Relative angular velocity between ports"

   CONTINUOUS

	w_rel = m_out.omega - m_in.omega

      T = ZONE (phi_rel >= ddz) - c * (phi_rel - phi_rel0 - ddz) - d * w_rel
          ZONE (phi_rel <= idz) - c * (phi_rel - phi_rel0 + idz) - d * w_rel
          OTHERS                       0.

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_Efficiency
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a mechanical efficiency (Same angular velocity in both ports).
--------------------------------------------------------------------------------
COMPONENT R_Efficiency IS_A R_Rigid
"Mechanical efficiency"
   DATA
      REAL eta = 1.         UNITS no_units      "Efficiency: [0,1]"

   DECLS
      REAL P_a              UNITS u_W      		"Power"

   CONTINUOUS
      P_a = m_in.T * w

      m_out.T = ZONE (P_a >= 0) eta * m_in.T
                   OTHERS          m_in.T / eta

END COMPONENT