--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_TRANS_CompWalls.el
--    FILE TYPE:  Components of the MECHANICAL library
--    DESCRIPTION:  Defines some wall components for the MECHANICAL library
--    NOTES:
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 


-- Components
--------------------------------------------------------------------------------
-- Component T_Wall
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a wall component with restitution coefficient.
--------------------------------------------------------------------------------
COMPONENT T_Wall
"Wall with restitution coefficient"
   PORTS
      OUT mech_trans m_out

   DATA
      INTEGER ws = -1	UNITS no_units	"Wall solid side: -1=Left & 1=Right"
      REAL wp = 0			UNITS u_m		"Wall position"
      REAL cl = 1.		UNITS no_units	"Restitution coefficient: 0=inelastic <-> 1=elastic"

   DECLS
	REAL s					UNITS u_m		"Absolute position"
      REAL v				UNITS u_m_s		"Absolute velocity"
	REAL a					UNITS u_m_s2	"Absolute acceleration"

   DISCRETE
	ASSERT(ws == 1 OR ws == -1) FATAL "The data ws must be 1 or -1"

      WHEN (((ws == -1) AND (s < wp  - 0.000001)) OR \
            ((ws == 1) AND (s > wp  + 0.000001))) THEN
         s = wp 
	   v = -cl * v
      END WHEN

   CONTINUOUS

	s' = v
	v' = a	     
	s = m_out.s

END COMPONENT
--------------------------------------------------------------------------------
-- Component T_EWall
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an elastic wall with viscous coefficient.
--------------------------------------------------------------------------------
COMPONENT T_EWall
"Wall with viscous coefficient"
   PORTS
      OUT mech_trans m_out

   DATA
      INTEGER ws = -1          UNITS no_units   "Wall solid side: -1=Left & 1=Right"
      REAL wp = 0.             UNITS u_m		   "Wall position"
      REAL E = 1.e308          UNITS u_N_m  		"Elastic coefficient"
      REAL C = 1.              UNITS u_Ns_m   	"Viscous coefficient"

   DISCRETE
	ASSERT(ws == 1 OR ws == -1) FATAL "The data ws must be 1 or -1"

   CONTINUOUS  
      m_out.F = ZONE (((ws == -1) AND (m_out.s < wp)) OR \
            ((ws == 1) AND (m_out.s > wp))) ws *  (E * (m_out.s - wp) + C * m_out.s')
                     OTHERS       0.0

END COMPONENT
