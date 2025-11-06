--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_TRANS_CompActuators.el
--    FILE TYPE:  Translational Actuator Elements of the MECHANICAL library
--    DESCRIPTION:  Defines translational actuators for the MECHANICAL library
--    NOTES:  
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
-- Libraries
USE MATH 


-- Components
--------------------------------------------------------------------------------
-- Component T_ActuatorPosition
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a position actuator.
--------------------------------------------------------------------------------
COMPONENT T_ActuatorPosition IS_A T_Actuator 
"Position actuator"
   CONTINUOUS
      m_out.s = s_in.signal[1]

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_ActuatorAcceleration
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an acceleration  actuator.
--------------------------------------------------------------------------------
COMPONENT T_ActuatorAcceleration IS_A T_Actuator
"Acceleration actuator"
   DATA
	REAL s_0=0		UNITS u_m		"Start position"
	REAL v_0=0		UNITS u_m_s		"Start velocity"

   DECLS
	REAL s			UNITS u_m		"Absolute position"
	REAL v			UNITS u_m_s		"Absolute speed"
	REAL a			UNITS u_m_s2	"Absolute acceleration"
	
   INIT
	s = s_0
	v = v_0 

   CONTINUOUS  
--	s' = v
	v' = a
      a = s_in.signal[1]
	s'' = a
	m_out.s = s

END COMPONENT

--------------------------------------------------------------------------------
-- Component T_ActuatorForce
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a force actuator.
--------------------------------------------------------------------------------
COMPONENT T_ActuatorForce IS_A T_Actuator 
"Force actuator"
   CONTINUOUS  
      m_out.F = s_in.signal[1]

END COMPONENT


