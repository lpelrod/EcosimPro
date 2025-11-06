--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MECH_ROT_CompFriction.el
--    FILE TYPE:  Rotational Friction Elements of the MECHANICAL library
--    DESCRIPTION:  Defines a clutch, a brake and a friction gear components
--                  for the MECHANICAL library
--    NOTES:  
--    AUTHOR:  Jose Luis Pastor Fernandez
--    CREATION DATE:  19-Jan-2004
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 


--------------------------------------------------------------------------------
-- Function fun_R_AbsFriction
--------------------------------------------------------------------------------
-- Purpose:
--    To calculate implicitly the path parameter of friction characteristic
--------------------------------------------------------------------------------
FUNCTION REAL fun_R_AbsFriction(
	INTEGER imode	"Operation mode",
	REAL a_relfric	"Relative angular acceleration (rad/s^2)",
	REAL sa		"Path parameter of friction characteristic (-)",
	REAL tau0		"Friction torque for w=0 (N*m)")
"Residue function to calculate implicitly the path parameter of friction \
characteristic of the components that inherit from the abstract component R_AbsFriction"

DECLS
	REAL resul
BODY
	IF(imode == 0) THEN
	   resul = a_relfric
	ELSEIF(imode == 1) THEN
	   resul = a_relfric - (sa - tau0)
	ELSEIF(imode == -1) THEN
	   resul = a_relfric - (sa + tau0)
	ELSEIF(imode == 2) THEN
	   resul = a_relfric - (sa - tau0)
	ELSEIF(imode == -2) THEN
	   resul = a_relfric - (sa + tau0)
	ELSE
	   resul = a_relfric - sa
	END IF

	RETURN resul

END FUNCTION

--------------------------------------------------------------------------------
-- Component R_AbsInertia
--------------------------------------------------------------------------------
-- Purpose:
--    It is an abstract component to represent a rotational component with inertia
--------------------------------------------------------------------------------
ABSTRACT COMPONENT R_AbsFriction
"Abstract component of rotational coulomb friction components " 
   DECLS

	BOOLEAN free = FALSE 	UNITS no_units		"TRUE, if frictional element is not active"    
	REAL w_relfric  			UNITS u_rad_s		"Relative angular velocity between frictional surfaces"
	REAL a_relfric  			UNITS u_rad_s2		"Relative angular acceleration between frictional surfaces"
	REAL tau        			UNITS u_Nm			"Friction torque: positive, if directed in opposite direction of w_rel (N*m)"
	REAL tau0       			UNITS u_Nm			"Friction torque for w=0 and forward sliding (N*m)"
	REAL tau0_max   			UNITS u_Nm			"Maximum friction torque for w=0 and locked (N*m)"
	REAL sa 						UNITS no_units		"Path parameter of friction characteristic (-)"
	INTEGER imode = -2 		UNITS no_units		"Operation mode (-)"

   DISCRETE

	WHEN(free) THEN
	   imode = 3 AFTER 0.0
	END WHEN


	WHEN (imode == 1 AND w_relfric > 0) THEN
	   imode = 2 AFTER 0.0
	END WHEN 

	WHEN (imode == 2 AND w_relfric <= 0) THEN
	   imode = 0 AFTER 0.0
	END WHEN

	WHEN (imode == -1 AND w_relfric < 0) THEN
	   imode = -2 AFTER 0.0
	END WHEN
 
	WHEN (imode == -2 AND w_relfric >= 0) THEN
	   imode = 0 AFTER 0.0
	END WHEN

	WHEN (imode == 0 AND sa > tau0_max) THEN
	   imode = 1 AFTER 0.0
	END WHEN

	WHEN (imode == 0 AND sa < -tau0_max) THEN
	   imode = -1 AFTER 0.0
	END WHEN


   CONTINUOUS

	fun_R_AbsFriction(imode, a_relfric, sa, tau0) = 0  

END COMPONENT
--------------------------------------------------------------------------------
-- Component R_ClutchBasic
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a basic clutch based on Coulomb friction
--------------------------------------------------------------------------------
COMPONENT R_ClutchBasic IS_A R_Compliant
"Clutch based on viscous friction coeffient and Coulomb friction" 
   PORTS
	IN analog_signal(n = 1) inPort  "Normalized force signal"
   DATA  
		REAL cv  = 1000.0  UNITS u_Nms_rad 		"Maximum viscous friction coeffient"
		REAL fn_max = 0  	 UNITS u_Nm				"Maximum Coulomb Torque"
		TABLE_1D mue_pos ={{0,1}, {0.5, 0.5}} 	"Positive sliding friction coefficient vs. relative angular speed"

   DECLS
		REAL w_rel 			UNITS u_rad_s		"Relative angular velocity"
		REAL fn 				UNITS u_Nm				"Coulomb Torque"


   CONTINUOUS
		w_rel =  phi_rel'
		fn = linearInterp1D(mue_pos, w_rel) * fn_max * inPort.signal[1]
  
		--Friction torque due to normal and viscous  forces
		T = ZONE (inPort.signal[1] > 0) -cv*w_rel*inPort.signal[1] + rev_fri(w_rel,fn,fn)  OTHERS 0

END COMPONENT
--------------------------------------------------------------------------------
-- Component R_Clutch
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a clutch based on Coulomb friction
--------------------------------------------------------------------------------
COMPONENT R_Clutch IS_A R_AbsFriction, R_Compliant
"Clutch based on Coulomb friction " 
   PORTS
	IN analog_signal(n = 1) inPort  "Normalized force signal"

   DATA  
	TABLE_1D mue_pos ={{0,1}, {0.5, 0.5}} "Positive sliding friction coefficient"
	REAL peak = 1.1							"Maximum value of mue for w_rel=0"
	REAL cgeo = 1 								"Geometry constant containing friction distribution assumption"
	REAL fn_max = 20  	UNITS u_N		"Maximum normal force"
	REAL w_rel_i = 1  	UNITS u_rad_s	"Initial relative angular velocity"

   DECLS
	REAL w_rel 				UNITS u_rad_s		"Relative angular velocity"
	REAL a_rel 				UNITS u_rad_s2		"Relative angular acceleration"
  
	REAL mue0 				"Friction coefficient for w=0 and forward sliding"
	REAL fn 				UNITS u_N			"Normal force"

   INIT
	w_rel = w_rel_i

   DISCRETE
	WHEN(fn<= 0.0) THEN
	   free = TRUE
	END WHEN

	WHEN(fn > 0.0) THEN
		free = FALSE
		IF(w_relfric > 0) THEN
			imode = 2
		ELSE
			imode = -2
		END IF
	END WHEN

   CONTINUOUS

	--Constant auxiliary variable
	mue0 = linearInterp1D(mue_pos, 0.0)
  
	--Relative quantities
	w_rel =  phi_rel'
	a_rel = w_rel'
	w_relfric = w_rel
	a_relfric = a_rel
  
	--Normal force and friction torque for w_rel=0
	fn = fn_max*inPort.signal[1]
	tau0 = mue0*cgeo*fn
	tau0_max = peak*tau0
  
	--Friction torque
	tau =   ZONE(imode == 0) sa
	  ZONE(imode == 1) cgeo*fn*linearInterp1D(mue_pos, w_rel)
        ZONE(imode == -1) -cgeo*fn*linearInterp1D(mue_pos, -w_rel)
        ZONE(imode == 2) cgeo*fn * linearInterp1D(mue_pos, w_rel) 
        ZONE(imode == -2) - cgeo*fn*linearInterp1D(mue_pos, -w_rel)
        OTHERS 0.0
	
	tau = -T

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_Brake
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a frictional brake.
--------------------------------------------------------------------------------
COMPONENT R_Brake IS_A R_AbsFriction, R_Rigid
"Frictional brake" 
   PORTS
	IN analog_signal(n = 1) inPort  "Normalized force signal (= normal_force/fn_max; clutch is engaged if > 0)"

   DATA  
	TABLE_1D mue_pos ={{0,1}, {0.5, 0.5}} "[w,mue] positive sliding friction coefficient: w_rel>=0"
	REAL peak = 1.1  							"Maximum value of mue for w_rel=0"
	REAL cgeo = 1 								"Geometry constant containing friction distribution assumption"
	REAL fn_max = 20  	UNITS u_N		"Maximum normal force"
	REAL w_i = 1  			UNITS u_rad_s	"Initial relative angular velocity"

   DECLS
	REAL a				UNITS u_rad_s2		"Absolute angular acceleration"
	REAL mue0									"Friction coefficient for w=0 and forward sliding"
	REAL fn				UNITS u_N		"Normal force"

   INIT
	w = w_i

   DISCRETE
	WHEN(fn<= 0.0) THEN
	   free = TRUE
	END WHEN

	WHEN(fn > 0.0) THEN
	   free = FALSE
		IF(w_relfric > 0) THEN
			imode = 2 AFTER 0.0
		ELSE
			imode = -2 AFTER 0.0
		END IF
	END WHEN

   CONTINUOUS

	--Constant auxiliary variable
	mue0 = linearInterp1D(mue_pos, 0.0)
  
	--Angular velocity and angular velocity
	a = w'
	w_relfric = w
	a_relfric = a
  
	--Torque equilibrium, normal force and friction torque for w = 0

-- 	0 = m_in.T - m_out.T - tau
	1e-8*a = m_in.T - m_out.T - tau

	fn = fn_max*inPort.signal[1]
	tau0 = mue0*cgeo*fn
	tau0_max = peak*tau0
  
	--Friction torque
	tau =   ZONE(imode == 0) sa
	  ZONE(imode == 1) cgeo*fn*linearInterp1D(mue_pos, w)
        ZONE(imode == -1) -cgeo*fn*linearInterp1D(mue_pos, -w)
        ZONE(imode == 2) cgeo*fn * linearInterp1D(mue_pos, w) 
        ZONE(imode == -2) - cgeo*fn*linearInterp1D(mue_pos, -w)
        OTHERS 0.0

END COMPONENT

--------------------------------------------------------------------------------
-- Component R_BearingFriction
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a bearing with Coulomb friction
--------------------------------------------------------------------------------
COMPONENT R_BearingFriction IS_A R_Rigid, R_AbsFriction
"Bearing with Coulomb friction"
   DATA
	TABLE_1D tau_pos = {{0, 1}, {1, 1}}	"Positive sliding friction characteristic for positive speed"
	REAL peak = 1				"Auxiliary variable to calculate the maximum friction torque"
   DECLS
	REAL a				UNITS u_rad_s2		"Absolute angular acceleration"

   INIT
	free = FALSE

   CONTINUOUS

	tau0 = linearInterp1D(tau_pos, 0.0)
	tau0_max = peak * tau0
	
	w' = a
      w_relfric = w
      a_relfric = a

	0 = m_in.T - m_out.T - tau

	tau = ZONE(imode == 0)
			sa
		 ZONE(imode == 2 OR imode == 1) 
			linearInterp1D(tau_pos, w)
		 ZONE(imode == -2 OR imode == -1) 
			-linearInterp1D(tau_pos, -w)
		 OTHERS
			0.0
END COMPONENT

