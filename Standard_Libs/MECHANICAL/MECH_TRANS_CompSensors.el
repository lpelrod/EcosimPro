--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_TRANS_CompSensors.el
--    FILE TYPE:  Translational Sensor Elements of the MECHANICAL library
--    DESCRIPTION:  Defines sensors to measure translational variables
--                  for the MECHANICAL library
--    NOTES:  
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- Component T_AbsoluteSensorPosition
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an absolute position sensor.
--------------------------------------------------------------------------------
COMPONENT T_AbsoluteSensorPosition IS_A T_AbsoluteSensor
"Absolute position sensor"
   DECLS
      REAL s              UNITS u_m        "Absolute position"

   CONTINUOUS
      m_in.F = 0.

         -- Output signal
      s = m_in.s
      var[1] = s

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_AbsoluteSensorVelocity
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an absolute velocity sensor.
--------------------------------------------------------------------------------
COMPONENT T_AbsoluteSensorVelocity IS_A T_AbsoluteSensor
"Absolute velocity sensor"
   DECLS
      REAL v             UNITS u_m_s         "Absolute velocity"

   CONTINUOUS
      m_in.F = 0.

         -- Output signal
      v = m_in.s'
      var[1] = v

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_AbsoluteSensorAcceleration
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an absolute acceleration sensor.
--------------------------------------------------------------------------------
COMPONENT T_AbsoluteSensorAcceleration IS_A T_AbsoluteSensor
"Absolute acceleration sensor"
   DECLS
      REAL a               UNITS u_m_s2       "Absolute acceleration"

   CONTINUOUS
      m_in.F = 0.

         -- Output signal
      a = m_in.s''
      var[1] = a

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_AbsoluteSensorForce
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a absolute force sensor.
--------------------------------------------------------------------------------
COMPONENT T_AbsoluteSensorForce IS_A T_RelativeSensor
"Absolute force sensor"
   DECLS
      REAL  F                 UNITS u_N    "Measured force"

   CONTINUOUS
      m_out.s = m_in.s

      m_in.F = F
      m_out.F = F

         -- Output signal
      var[1] = F

END COMPONENT
