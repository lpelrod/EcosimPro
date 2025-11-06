--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_ROT_CompGears.el
--    FILE TYPE:  Gear Elements of the MECHANICAL library
--    DESCRIPTION:  Defines an ideal and a real gear components
--                  for the MECHANICAL library
--    NOTES:  
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 


--------------------------------------------------------------------------------
-- Component R_GearIdeal
--------------------------------------------------------------------------------
-- Purpose:
--    To represent an ideal gear without inertia.
--------------------------------------------------------------------------------
COMPONENT R_GearIdeal IS_A R_Two_Flanges
"Ideal Gear without inertia"
   DATA
	REAL ratio = 1 	UNITS no_units			"Transmission ratio"

   CONTINUOUS
	m_in.omega = ratio * m_out.omega
	ratio * m_in.T = m_out.T
END COMPONENT


--------------------------------------------------------------------------------
-- Component R_GearIdealR2T
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a gearbox transforming rotational into translational motion.
--------------------------------------------------------------------------------
COMPONENT R_GearIdealR2T
"Gearbox transforming rotational into translational motion"
   PORTS
      IN  mech_rot R_m_in			"Inlet rotational port"
      OUT mech_trans T_m_out		"Outlet translational port"

   DATA
      REAL ratio = 1.       UNITS u_rad_m      "Transmission ratio"

   CONTINUOUS
      T_m_out.F = ratio * R_m_in.T

      T_m_out.s' = R_m_in.omega / ratio

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_Gear
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a real gearbox
--------------------------------------------------------------------------------
COMPONENT R_Gear IS_A R_Two_Flanges
"Gearbox"
   DATA
	REAL ratio = 1				UNITS no_units		"Transmision ratio"
	REAL eta = 1				UNITS no_units		"Gear efficiency"
	TABLE_1D friction_pos = {{0, 1},{1, 1}} 	"Positive sliding friction characteristic"
	REAL peak = 1				UNITS no_units		"Maximum friction torque at zero velocity"
	REAL c = 1e5				UNITS u_Nm_rad		"Gear elasticity"
	REAL d = 0					UNITS u_Nms_rad	"Gear damping"
	REAL b = 0					UNITS u_rad			"Total backlash"

   TOPOLOGY
	R_GearIdeal gearRatio(ratio = ratio)
	R_Efficiency gearEfficiency (eta = eta)
	R_BearingFriction bearingFriction (
		tau_pos = friction_pos,
		peak = peak)
	R_ElastoBacklash elastoBacklash (
		c = c,
		d = d,
		ddz = b,
		idz = -b,
		phi_rel0 = 0.)


	CONNECT m_in TO gearRatio.m_in
	CONNECT gearRatio.m_out TO gearEfficiency.m_in
	CONNECT gearEfficiency.m_out TO bearingFriction.m_in
	CONNECT bearingFriction.m_out TO elastoBacklash.m_in
	CONNECT elastoBacklash.m_out TO m_out

END COMPONENT

--------------------------------------------------------------------------------
-- Function fun_R_GearFriction
--------------------------------------------------------------------------------
-- Purpose:
--    To calculate implicitly the path parameter of friction characteristic
--	of the component GearFriction
---------------------------------------------------------------------------
FUNCTION REAL fun_R_GearFriction (
	INTEGER imode	"Operation mode",
	IN REAL a		UNITS u_rad_s2		"Acceleration",
	IN REAL sa		UNITS no_units		"Path parameter",
	IN REAL tau		UNITS u_Nm			"Torque")
"Residue function to calculate implicitly the path parameter of friction \
characteristic of the component GearFriction"
DECLS
	REAL resul		"Residue function result"
BODY
	IF(imode == 0) THEN
		resul = a
	ELSE
		resul = a - (sa - tau)
	END IF

RETURN resul
		
END FUNCTION

--------------------------------------------------------------------------------
-- Component R_GearFriction
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a gear with mesh efficiency and bearing friction (stuck/rolling possible)
--------------------------------------------------------------------------------

COMPONENT R_GearFriction IS_A R_Two_Flanges
"Gear with mesh efficiency and bearing friction (stuck/rolling possible)"
DATA
	REAL trans_ratio = 2 	UNITS no_units		"Transmission ratio"
	TABLE_1D tab_eta_mf1 ={{0, 1}, {0.5, 0.5}} \
		"Data of the mess efficiency in case of input shaft driving as a function of angular velocity"
	TABLE_1D tab_eta_mf2 ={{0, 1}, {0.5, 0.5}}\
		"Data of the mess efficiency in case of output shaft driving as a function of angular velocity"
	TABLE_1D tab_tau_bf1 ={{0, 1}, {0., 0.}} \
		"Data of the absolute bearing friction torque in case of input shaft driving as a function of angular velocity"
	TABLE_1D tab_tau_bf2 ={{0, 1}, {0., 0.}}\
		"Data of the bsolute bearing friction torque in case of output shaft driving as a function of angular velocity"
	BOOLEAN ideal = FALSE 	"TRUE, if losses are neglected"
DECLS
	EXPL REAL Tloss 		UNITS u_Nm		"Torque loss due to friction in the gear teeth and in the bearings"
	REAL Tloss_max 		UNITS u_Nm		"Torque loss for positive speed"
	REAL Tloss_min 		UNITS u_Nm		"Torque loss for negative speed"
	REAL eta_mf1			UNITS no_units	"Mesh efficiency in case of input shaft driving"
	REAL eta_mf2			UNITS no_units	"Mesh efficiency in case of output shaft driving"
	REAL tau_bf1			UNITS u_Nm		"Absolute bearing friction torque in case of input shaft driving"
	REAL tau_bf2			UNITS u_Nm		"Absolute bearing friction torque in case of output shaft driving"
	REAL sa							"Path parameter for acceleration and torque loss"
	REAL q1		UNITS u_Nm		"First quadrant"
	REAL q2		UNITS u_Nm		"Second quadrant"
	REAL q3		UNITS u_Nm		"Third quadrant"
	REAL q4		UNITS u_Nm		"Forth quadrant"
	INTEGER imode	"Operation mode"	

	REAL T		UNITS u_Nm			"Torque"
	REAL w		UNITS u_rad_s		"Angular velocity of inlet port"
	REAL a		UNITS u_rad_s2		"Angular acceleration"

	CONST REAL lossTable_ideal[4] = {1, 1, 0, 0}	\
		"Array for mesh efficiencies and bearing friction if losses are neglected"

   DISCRETE

	ASSERT(abs(trans_ratio) > 0) FATAL "Error in initialization of GearFriction: i can not be zero"

	WHEN(ideal) THEN
	   imode = 3
	END WHEN

	WHEN(NOT ideal) THEN
	   imode = 0
	END WHEN

	WHEN (imode == 1 AND w > 0) THEN
	   imode = 2
	END WHEN 

	WHEN (imode == 2 AND w < 0) THEN
	   imode = 0
	END WHEN

	WHEN (imode == -1 AND w < 0) THEN
	   imode = -2
	END WHEN
 
	WHEN (imode == -2 AND w > 0) THEN
	   imode = 0
	END WHEN

	WHEN (imode == 0 AND sa > Tloss_max) THEN
	   imode = 1 AFTER 0.0
	END WHEN

	WHEN (imode == 0 AND sa < Tloss_min) THEN
	   imode = -1 AFTER 0.0 
	END WHEN

	

CONTINUOUS

	eta_mf1 = ZONE(ideal) lossTable_ideal[1]
		    OTHERS linearInterp1D(tab_eta_mf1, abs(w))

	eta_mf2 = ZONE(ideal) lossTable_ideal[2]
		    OTHERS linearInterp1D(tab_eta_mf2, abs(w))

	tau_bf1 = ZONE(ideal) lossTable_ideal[3]
		    OTHERS abs(linearInterp1D(tab_tau_bf1, abs(w)))

	tau_bf2 = ZONE(ideal) lossTable_ideal[4]
		    OTHERS abs(linearInterp1D(tab_tau_bf2, abs(w)))


	q1 = (1 - eta_mf1) * T + tau_bf1
	q2 = (1 - 1/eta_mf2) * T + tau_bf2
	q3 = (1 - eta_mf1) * T - tau_bf1
	q4 = (1 - 1/eta_mf2) * T - tau_bf2

	m_in.omega = trans_ratio * m_out.omega
	m_in.omega = w

	m_out.T - trans_ratio * (T - Tloss) = 0
	m_in.T = T

	IMPL(sa) 0 = fun_R_GearFriction (imode, a, sa, Tloss)

	a = w'


	Tloss_max = ZONE(imode == 3 OR T > 0.0 ) q1
			OTHERS q2
	Tloss_min = ZONE(imode == 3 OR T > 0.0) q4
			OTHERS q3


	Tloss = ZONE(imode == 0) sa
		  ZONE(imode == 1) Tloss_max
		  ZONE(imode == 2) Tloss_max
		  ZONE(imode == -1) Tloss_min
		  ZONE(imode == -2) Tloss_min
		  OTHERS 0.0	

END COMPONENT