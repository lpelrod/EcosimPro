--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_TRANS_CompConstrains.el
--    FILE TYPE:  Components of the MECHANICAL library
--    DESCRIPTION:  Defines some translational mechanical constrain components for the
--                  MECHANICAL library
--    NOTES:
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 

-- Components
--------------------------------------------------------------------------------
-- Component T_FixedPosition
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a fixed translational position.
--------------------------------------------------------------------------------
COMPONENT T_FixedPosition
"Fixed translational position"
   PORTS
      OUT mech_trans m_out

   DATA
      REAL s0 = 0.	UNITS u_m		"Fixed offset position"

   CONTINUOUS
      m_out.s = s0

END COMPONENT

--------------------------------------------------------------------------------
-- Component T_FixedAcceleration
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a fixed translational acceleration.
--------------------------------------------------------------------------------
COMPONENT T_FixedAcceleration
"Fixed translational acceleration"
   PORTS
      OUT mech_trans m_out
   DATA
      REAL a0 = 0.	UNITS u_m_s2	"Fixed acceleration value"

   DECLS
      REAL s			UNITS u_m		"Absolute position"
--	REAL v				UNITS u_m_s		"Absolute velocity"	

   CONTINUOUS
      s''= a0
--	s' = v

      m_out.s = s

END COMPONENT

--------------------------------------------------------------------------------
-- Component T_FixedForce
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a fixed force.
--------------------------------------------------------------------------------
COMPONENT T_FixedForce
"Fixed force"
   PORTS
      OUT mech_trans m_out

   DATA
      REAL F0 = 0.        UNITS u_N        "Fixed force value"

   CONTINUOUS
      m_out.F = F0

END COMPONENT
