--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_TRANS_Common.el
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


--ENUMERATIVE TYPES
--------------------------------------------------------------------------------
-- Enumerative type called FrictionState to represent the different states of
-- a component with Coulomb friction
--------------------------------------------------------------------------------
ENUM FrictionState = {Stuck, StartBackward, Backward, StartForward, Forward}



-- ABSTRACT COMPONENTS
--------------------------------------------------------------------------------
-- Component T_Two_Flanges
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of components with two translational
--    ports.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT T_Two_Flanges
"Abstract class for definition of components with two translational ports"
   PORTS
      IN  mech_trans m_in	"Left / driving mech_trans"
      OUT mech_trans m_out	"Right / driven mech_trans"

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_Rigid
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a rigid connection of two
--    translational ports.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT T_Rigid IS_A T_Two_Flanges
"Abstract class for definition of a rigid connection of two translational ports"
   DECLS
      REAL s		UNITS u_m		"Absolute position of component"

   CONTINUOUS
      m_in.s = s
      m_out.s = s

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_Compliant
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a compliant connection of two
--    translational ports.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT T_Compliant IS_A T_Two_Flanges
"Abstract class for definition of a compliant connection of two translational ports"
   DECLS
      REAL F			UNITS u_N		"Translational transmited force"

      REAL s_rel		UNITS u_m	"Distance between ports"

   CONTINUOUS
      m_in.F = -F
      m_out.F = F

      s_rel = m_out.s - m_in.s

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_Actuator
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of generic translational actuators.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT T_Actuator
"Abstract class for definition of generic translational actuators"
   PORTS
      IN  analog_signal s_in		"Input signal port"
      OUT mech_trans m_out		"Output translational mechanical port"

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_AbsoluteSensor
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of generic translational absolute
--    sensors.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT T_AbsoluteSensor IS_A ASensor
"Abstract class for definition of generic translational absolute sensors"
   PORTS
      IN mech_trans m_in		"Mechanical left port"

END COMPONENT


--------------------------------------------------------------------------------
-- Component T_RelativeSensor
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of generic translational relative
--    sensors.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT T_RelativeSensor IS_A ASensor
"Abstract class for definition of generic translational relative sensors"
   PORTS
      IN  mech_trans m_in		"Mechanical left port"
      OUT mech_trans m_out		"Mechanical right port"

END COMPONENT