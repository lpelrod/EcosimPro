--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_ROT_CompConstrains.el
--    FILE TYPE:  Components of the MECHANICAL library
--    DESCRIPTION:  Defines some rotational mechanical constrain components
--	for the MECHANICAL library
--    NOTES:
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 


--------------------------------------------------------------------------------
-- Component R_FixedVelocity
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a fixed angular velocity
--------------------------------------------------------------------------------
COMPONENT R_FixedVelocity
"Fixed angular velocity"
   PORTS
	OUT mech_rot m_out	"Rotational outlet port"

   DATA
	REAL w0 = 0.		UNITS u_rad_s		"Fixed angular velocity"

   CONTINUOUS
	m_out.omega = w0

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_FixedTorque
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a fixed torque.
--------------------------------------------------------------------------------
COMPONENT R_FixedTorque
"Fixed torque"
   PORTS
	OUT mech_rot m_out	"Rotational outlet port"

   DATA
	REAL T0 = 0.		UNITS u_Nm		"Fixed torque value"

   CONTINUOUS
	m_out.T = T0

END COMPONENT