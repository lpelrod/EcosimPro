--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_TRANS_CompBasics.el
--    FILE TYPE:  Components of the MECHANICAL library
--    DESCRIPTION:  Defines translational basic components 
--                  for the MECHANICAL library
--    NOTES:
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
USE MATH 

-- Components
--------------------------------------------------------------------------------
-- Component T_SlidingMass
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a sliding mass with inertia.
--------------------------------------------------------------------------------
COMPONENT T_SlidingMass IS_A T_Rigid
"Sliding mass with inertia"
   DATA
      REAL m = 1      	UNITS u_kg    	"Mass of body"

      REAL s0 = 0       UNITS u_m	  	"Initial body position"
      REAL v0 = 0       UNITS u_m_s		"Initial body velocity"

   DECLS
	REAL v	        	UNITS u_m_s		"Absolute velocity"
	REAL a	        	UNITS u_m_s2	"Absolute acceleration"

   INIT
      s = s0
	v = v0

   CONTINUOUS
	s' = v
	v' = a
      m * a = m_in.F + m_out.F

END COMPONENT

--------------------------------------------------------------------------------
-- Purpose:
--    To represent a rod without inertia
--------------------------------------------------------------------------------
COMPONENT T_Rod IS_A T_Rigid
"Rod without inertia"
   CONTINUOUS

      0 = m_in.F + m_out.F

END COMPONENT

--------------------------------------------------------------------------------
-- Component T_Spring
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an ideal linear spring.
--------------------------------------------------------------------------------
COMPONENT T_Spring IS_A T_Compliant
"Ideal linear spring"
   DATA
      REAL k = 0.             UNITS u_N_m    "Spring constant"
      REAL s_rel0 = 0.        UNITS u_m  		"Distance between ports for unloaded spring"

   CONTINUOUS
      F = - k * (s_rel - s_rel0)

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_SpringBacklash
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a linear spring with backlash.
--------------------------------------------------------------------------------
COMPONENT T_SpringBacklash IS_A T_Compliant
"Linear spring with backlash"
   DATA
      REAL k = 0.            UNITS u_N_m     "Spring constant"

      REAL s_rel0 = 0.       UNITS u_m     "Distance between ports for unloaded spring"

      REAL ddz = 0.          UNITS u_m     "Direct dead zone"
      REAL idz = 0.          UNITS u_m    "Inverse dead zone"

   CONTINUOUS
      F = ZONE (s_rel >= ddz) - k * (s_rel - s_rel0 - ddz)
          ZONE (s_rel <= idz) - k * (s_rel - s_rel0 - idz)
          OTHERS                     0.

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_Damper
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an ideal linear damper.
--------------------------------------------------------------------------------
COMPONENT T_Damper IS_A T_Compliant
"Ideal linear damper"
   DATA
      REAL d = 0.            UNITS u_Ns_m     "Damping constant"

   DECLS
      REAL v_rel = 0.        UNITS u_m_s     "Relative velocity between ports"

   CONTINUOUS
      s_rel' = v_rel

      F = - d * v_rel

END COMPONENT

--------------------------------------------------------------------------------
-- Component T_SpringDamper
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an ideal linear damper and linear spring in parallel
--------------------------------------------------------------------------------
COMPONENT T_SpringDamper IS_A T_Compliant
"Ideal linear damper and spring in parallel"
   DATA
      REAL d = 0.              UNITS u_Ns_m   "Damping constant"
      REAL k = 0.              UNITS u_N_m   "Spring constant"
      REAL s_rel0 = 0.         UNITS u_m   "Distance between ports for unloaded spring"

   DECLS
      REAL v_rel = 0.          UNITS u_m_s   "Relative velocity between ports"

   CONTINUOUS
      s_rel' = v_rel

      F =  - k * (s_rel - s_rel0) - d * v_rel

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_ElastoGap
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an ideal spring damper combination with gap
--------------------------------------------------------------------------------
COMPONENT T_ElastoGap IS_A T_Compliant
"Ideal spring damper combination with gap"
   DATA
      REAL d = 0.             UNITS u_Ns_m   	"Damping constant"
      REAL k = 0.             UNITS u_N_m	   	"Spring constant"
      REAL s_rel0 = 0.        UNITS u_m   		"Distance between ports for unloaded spring"

   DECLS
      REAL v_rel = 0.         UNITS u_m_s    	"Relative velocity between ports"
	BOOLEAN contact

   DISCRETE
	WHEN(s_rel < s_rel0) THEN
	   contact = TRUE
	END WHEN

	WHEN(s_rel > s_rel0) THEN
	   contact = FALSE
	END WHEN

   CONTINUOUS
      s_rel' = v_rel
	

      F = ZONE(contact) - k * (s_rel - s_rel0) - d * v_rel
	    OTHERS 0.0

END COMPONENT