--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_ROT_Common.el
--    FILE TYPE:  Common Elements of the MECHANICAL library
--    DESCRIPTION:  Defines common functions, mechanical ports and abstract
--                  components for the MECHANICAL library
--    NOTES:  
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 
USE CONTROL 


--------------------------------------------------------------------------------
-- Component R_Two_Flanges
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of components with two rotational ports.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT R_Two_Flanges 
"Abstract class for definition of components with two rotational ports"
   PORTS
      IN  mech_rot m_in     "Left / driving mech_rot"
      OUT mech_rot m_out    "Right / driven mech_rot"

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_Rigid
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a rigid connection of two rotational
--    ports.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT R_Rigid IS_A R_Two_Flanges
"Abstract class for the definition of a rigid connection of two rotational ports"
   DECLS
      REAL w			UNITS u_rad_s		"Absolute angular velocity (rad/s)"

   CONTINUOUS
      m_in.omega = w
      m_out.omega = w

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_Compliant
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a compliant connection of two
--    rotational ports.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT R_Compliant IS_A R_Two_Flanges
"Abstract class for definition of a compliant connection of two rotational ports"
   DATA
	REAL phi_rel_i = 0		UNITS u_rad 	"Initial angular distance between ports"

   DECLS
      REAL T					UNITS u_Nm		"Rotational transmited torque"
      REAL phi_rel			UNITS u_rad		"Angular distance between ports"

   INIT
	phi_rel = phi_rel_i

   CONTINUOUS
      m_in.T = T
      m_out.T = T

      phi_rel' = m_out.omega - m_in.omega

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_Actuator
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of generic rotational actuators.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT R_Actuator
"Abstract class for definition of generic rotational actuators"
   PORTS
      IN  analog_signal s_in		"Input signal port"
      OUT mech_rot m_out		"Outlet rotational mechanical port"

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_AbsoluteSensor
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of generic rotational absolute sensors.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT R_AbsoluteSensor IS_A ASensor
"Abstract class for definition of generic rotational absolute sensors"
   PORTS
      IN mech_rot m_in     "Rotational mechanical inlet port"

END COMPONENT


--------------------------------------------------------------------------------
-- Component R_RelativeSensor
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of generic rotational relative sensors.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT R_RelativeSensor IS_A ASensor
"Abstract class for definition of generic rotational relative sensors"
   PORTS
      IN mech_rot m_in		"Rotational mechanical inlet port"
      OUT mech_rot m_out	"Rotational mechanical outlet port"

END COMPONENT
