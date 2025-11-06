--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_ROT_Actuators.el
--    FILE TYPE:  Rotational Actuator Elements of the MECHANICAL library
--    DESCRIPTION:  Defines rotational actuators for the MECHANICAL library
--    NOTES:  
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------

USE MATH 
--------------------------------------------------------------------------------
-- Component R_ActuatorVelocity
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an angular position actuator.
--------------------------------------------------------------------------------
COMPONENT R_ActuatorVelocity IS_A R_Actuator
"Angular velocity actuator"
   CONTINUOUS
      m_out.omega = s_in.signal[1]

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_ActuatorTorque
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a torque actuator.
--------------------------------------------------------------------------------
COMPONENT R_ActuatorTorque IS_A R_Actuator
"Torque actuator"
   CONTINUOUS
	m_out.T = s_in.signal[1]

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_ActuatorAcceleration
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a rotational acceleration actuator.
--------------------------------------------------------------------------------
COMPONENT R_ActuatorAcceleration IS_A R_Actuator
"Rotational acceleration actuator"
   DATA
      REAL wi = 0	 	UNITS u_rad_s		"Initial angular velocity"

   INIT
	m_out.omega = wi

   CONTINUOUS
      m_out.omega' = s_in.signal[1]

END COMPONENT