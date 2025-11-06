--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_ROT_CompSensors.el
--    FILE TYPE:  Rotational Sensor Elements of the MECHANICAL library
--    DESCRIPTION:  Defines sensors to measure rotational variables
--                  for the MECHANICAL library
--    NOTES:  
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
USE MATH 
--------------------------------------------------------------------------------
-- Component R_AbsoluteSensorAngle
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an absolute angular position sensor.
--------------------------------------------------------------------------------
COMPONENT R_AbsoluteSensorAngle IS_A R_AbsoluteSensor
"Absolute angular position sensor"
   DATA
	REAL phi0 = 0		UNITS u_rad		"Initial angular position"
   DECLS
      REAL phi			UNITS u_rad		"Absolute angular position"

   INIT
	phi = phi0

   CONTINUOUS
      m_in.T = 0.

         -- Output signal
      phi' = m_in.omega
      var[1] = phi

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_AbsoluteSensorVelocity
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an absolute angular velocity sensor.
--------------------------------------------------------------------------------
COMPONENT R_AbsoluteSensorVelocity IS_A R_AbsoluteSensor
"Absolute angular velocity sensor"
   DECLS
      REAL w	UNITS u_rad_s		"Absolute angular velocity"

   CONTINUOUS
      m_in.T = 0.

         -- Output signal
      w = m_in.omega
      var[1] = w

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_AbsoluteSensorAcceleration
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an absolute angular acceleration sensor.
--------------------------------------------------------------------------------
COMPONENT R_AbsoluteSensorAcceleration IS_A R_AbsoluteSensor
"Absolute angular acceleration sensor"
   DECLS
      REAL ac		UNITS u_rad_s2		"Absolute angular acceleration"

   CONTINUOUS
      m_in.T = 0.

         -- Output signal
      ac = m_in.omega'
      var[1] = ac

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_AbsoluteSensorTorque
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a torque sensor.
--------------------------------------------------------------------------------
COMPONENT R_AbsoluteSensorTorque IS_A R_RelativeSensor
"Torque sensor"
   DECLS
      REAL T          UNITS u_Nm            "Measured torque"

   CONTINUOUS
      m_out.omega = m_in.omega

      m_in.T = T
      m_out.T = T

         -- Output signal
      var[1] = T

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_RelativeSensorAngle
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a relative angle sensor.
--------------------------------------------------------------------------------
COMPONENT R_RelativeSensorAngle IS_A R_RelativeSensor
"Relative angle sensor"
   DATA
	REAL phi_rel_0 = 0		UNITS u_rad		"Initial relative angle"

   DECLS
	REAL phi_rel				UNITS u_rad		"Relative angle"
   INIT
	phi_rel = phi_rel_0

   CONTINUOUS

	phi_rel' = m_out.omega - m_in.omega

      m_in.T = 0
      m_out.T = 0

         -- Output signal
      var[1] = phi_rel

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_RelativeSensorSpeed
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a relative speed sensor.
--------------------------------------------------------------------------------
COMPONENT R_RelativeSensorSpeed IS_A R_RelativeSensor
"Relative speed sensor"
   DECLS
	REAL w_rel			UNITS u_rad_s	"Relative angular speed"
   CONTINUOUS

	w_rel = m_out.omega - m_in.omega

      m_in.T = 0
      m_out.T = 0

         -- Output signal
      var[1] = w_rel

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_RelativeSensorAcceleration
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a relative acceleration sensor.
--------------------------------------------------------------------------------
COMPONENT R_RelativeSensorAcceleration IS_A R_RelativeSensor
"Relative acceleration sensor"
   DECLS
	REAL a_rel			UNITS u_rad_s2		"Relative angular acceleration"
	REAL w_rel			UNITS u_rad_s		"Relative speed acceleration"
   CONTINUOUS

	w_rel = m_out.omega - m_in.omega
	w_rel' = a_rel

      m_in.T = 0
      m_out.T = 0

         -- Output signal
      var[1] = a_rel

END COMPONENT