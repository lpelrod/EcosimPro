--------------------------------------------------------------------------------
-- EA Internacional 2005   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompControllers.el
--    FILE TYPE:  Components of the CONTROL library
--    DESCRIPTION:  Defines the analog controller components for the CONTROLlibrary
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
-- Libraries
USE MATH 
USE PORTS_LIB 

-- Abstract Components
--------------------------------------------------------------------------------
-- Component Controller
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of controllers.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT Controller
   (
	INTEGER n = 1				UNITS no_units	"Dimension of inputs and outputs"
   ) "This abstract component is used for deriving controllers of different types by inheritance"

   PORTS
	IN  analog_signal (n = n) s_set	"Set point signal"
	IN  analog_signal (n = n) s_var	"Controlled variable signal"
	OUT analog_signal (n = n) s_out	"Controlled output signal"

   DECLS
	REAL r[n]					UNITS no_units	"Set point"
	REAL y[n]					UNITS no_units	"Measured variable"
	REAL e[n]					UNITS no_units	"Input error"
	REAL u[n]					UNITS no_units	"Output"

   CONTINUOUS

	EXPAND_BLOCK(i IN 1, n)
--         r[i] = s_set.signal[i]

--         y[i] = s_var.signal[i]

         e[i] = r[i] - y[i]

--         s_out.signal[i] = u[i]
	END EXPAND_BLOCK
	r = s_set.signal
	y = s_var.signal	
	s_out.signal = u
END COMPONENT

--------------------------------------------------------------------------------
-- Component Cntrl_P
--------------------------------------------------------------------------------
-- Purpose:
--   To represent controllers of the proportional (P) type
--   with multiple inputs and outputs with the same dimension.
--------------------------------------------------------------------------------
COMPONENT Cntrl_P IS_A Controller "Standard proportional controller"
   DATA
	REAL k[n] = 1.			UNITS no_units	"Proportional gain of the controller"

	REAL u_min[n] = 0.	UNITS no_units	"Low limit of output"
	REAL u_max[n] = 1.	UNITS no_units	"High limit of output"

   DECLS
	REAL v[n]				UNITS no_units	"Unbounded output"

   DISCRETE
	EXPAND(i IN 1, n)
	      ASSERT (u_max[i] > u_min[i]) FATAL "Wrong limits for the controller"

   CONTINUOUS

	EXPAND_BLOCK(i IN 1, n)
	   	v[i] = k[i] * e[i]

		u[i] = ZONE (v[i] > u_max[i]) u_max[i]
      		 ZONE (v[i] < u_min[i]) u_min[i]
            	 OTHERS                 v[i]
	END EXPAND_BLOCK

END COMPONENT

--------------------------------------------------------------------------------
-- Component Cntrl_PI
--------------------------------------------------------------------------------
-- Purpose:
--   To represent controllers of the proportional integral (PI) type
--   with multiple inputs and outputs with the same dimension.
--------------------------------------------------------------------------------
COMPONENT Cntrl_PI IS_A Controller "Standard proportional-integral controller"
   DATA
	REAL k[n] = 1.			UNITS no_units	"Proportional gain of the controller"

	REAL u_min[n] = 0.	UNITS no_units	"Low limit of output"
	REAL u_max[n] = 1.	UNITS no_units	"High limit of output"

	ENUM EndPosBehaviour end_pos = end_I	UNITS no_units	"End position behaviour"

	REAL Ti[n] = 100.						UNITS u_s		"Integrator time or reset time"
      REAL gamma[n] = 0.1				UNITS no_units	"Ratio between the time constant for the antiwindup and the integration time"

	REAL beta[n] = 1. UNITS no_units	RANGE 0,1.		"Weight factor for set point changes in P output"

   DECLS
	REAL es[n]								UNITS no_units	"Saturation error"
	REAL v[n]								UNITS no_units	"Unbounded output"
	REAL vi[n]								UNITS no_units	"Integral part of the output"
	REAL vil[n]								UNITS no_units	"Limited integral part of the output"

   DISCRETE
	EXPAND(i IN 1, n)
	      ASSERT (u_max[i] > u_min[i]) FATAL "Wrong limits for the controller"


   CONTINUOUS

	EXPAND_BLOCK(i IN 1, n)

		u[i] = ZONE (v[i] > u_max[i]) u_max[i]
      		 ZONE (v[i] < u_min[i]) u_min[i]
	             OTHERS                 v[i]

		es[i] = ZONE (end_pos == end_I) vil[i] - vi[i]
	      	  OTHERS                     u[i] - v[i]

		vi[i]' = (k[i] / Ti[i]) * e[i] + es[i] / (gamma[i] * Ti[i])

		vil[i] = ZONE (vi[i] > u_max[i]) u_max[i]
	      	   ZONE (vi[i] < u_min[i]) u_min[i]
			   OTHERS                  vi[i]


		v[i] = k[i] * (beta[i] * r[i] - y[i]) + vi[i]

	END EXPAND_BLOCK


END COMPONENT

--------------------------------------------------------------------------------
-- Component Cntrl_PID
--------------------------------------------------------------------------------
-- Purpose:
--   To represent controllers of the proportional, integral and derivative
--   (PID) type with multiple inputs and outputs with the same dimension.
--------------------------------------------------------------------------------
COMPONENT Cntrl_PID IS_A Controller "Standard proportional-integral-derivative controller"
   DATA
	REAL k[n] = 1.					UNITS no_units	"Proportional gain of the controller"

	REAL u_min[n] = 0.			UNITS no_units	"Low limit of output"
	REAL u_max[n] = 1.			UNITS no_units	"High limit of output"

	ENUM EndPosBehaviour end_pos = end_I    UNITS no_units	"End position behaviour"

	REAL Ti[n] = 100.				UNITS u_s		"Integrator time or reset time"
      REAL gamma[n] = 0.1		UNITS no_units	"Ratio between the time constant for the antiwindup and the integration time "


	REAL beta[n] = 1. 			UNITS no_units	RANGE 0,1	"Weight factor for set point changes in P output"

	REAL Td[n] = 0.1				UNITS u_s						"Rate or derivative time"
	REAL alpha[n] = 0.1 			UNITS no_units	RANGE 0.,1."Derivative filter parameter"

   DECLS
	REAL es[n]				UNITS no_units	"Saturation error"
	REAL v[n]				UNITS no_units	"Unbounded output"
	REAL vi[n]				UNITS no_units	"Integral part of the output"
	REAL vil[n]				UNITS no_units	"Limited integral part of the output"

	REAL yf[n]				UNITS no_units	"Filtered variable"

   DISCRETE
	EXPAND(i IN 1, n)
	      ASSERT (u_max[i] > u_min[i]) FATAL "Wrong limits for the controller"


   CONTINUOUS

	EXPAND_BLOCK(i IN 1, n)

		u[i] = ZONE (v[i] > u_max[i]) u_max[i]
      		 ZONE (v[i] < u_min[i]) u_min[i]
	             OTHERS                 v[i]

		es[i] = ZONE (end_pos == end_I) vil[i] - vi[i]
	      	  OTHERS                     u[i] - v[i]

		vi[i]' = (k[i] / Ti[i]) * e[i] + es[i] / (gamma[i] * Ti[i])

		vil[i] = ZONE (vi[i] > u_max[i]) u_max[i]
	      	   ZONE (vi[i] < u_min[i]) u_min[i]
			   OTHERS                  vi[i]


		v[i] = k[i] * (beta[i] * r[i] - y[i] - Td[i] * yf[i]') + vi[i]

		yf[i]' = (y[i] - yf[i]) / (alpha[i] * Td[i])

	END EXPAND_BLOCK

END COMPONENT


COMPONENT Cntrl_PI_ExtTrack IS_A Controller "Standard proportional-integral controller with external tracking"
    PORTS
        IN analog_signal (n=n) s_track
   DATA
	REAL k[n] = 1.			UNITS no_units	"Proportional gain of the controller"

	REAL u_min[n] = 0.	UNITS no_units	"Low limit of output"
	REAL u_max[n] = 1.	UNITS no_units	"High limit of output"

	REAL Ti[n] = 100.						UNITS u_s		"Integrator time or reset time"
      REAL gamma[n] = 0.1				UNITS no_units	"Ratio between the time constant for the antiwindup and the integration time"

	REAL beta[n] = 1. UNITS no_units	RANGE 0,1.		"Weight factor for set point changes in P output"

   DECLS
	REAL es[n]								UNITS no_units	"Saturation error"
	REAL v[n]								UNITS no_units	"Unbounded output"
	REAL vi[n]								UNITS no_units	"Integral part of the output"

   DISCRETE
	EXPAND(i IN 1, n)
	      ASSERT (u_max[i] > u_min[i]) FATAL "Wrong limits for the controller"


   CONTINUOUS

	EXPAND_BLOCK(i IN 1, n)

		u[i] = ZONE (v[i] > u_max[i]) u_max[i]
      		 ZONE (v[i] < u_min[i]) u_min[i]
	             OTHERS                 v[i]

		es[i] = s_track.signal[i] - v[i]

		vi[i]' = (k[i] / Ti[i]) * e[i] + es[i] / (gamma[i] * Ti[i])


		v[i] = k[i] * (beta[i] * r[i] - y[i]) + vi[i]

	END EXPAND_BLOCK


END COMPONENT

--------------------------------------------------------------------------------
-- Component Cntrl_PID_ExtTrack
--------------------------------------------------------------------------------
-- Purpose:
--   To represent controllers of the proportional, integral and derivative
--   (PID) type with multiple inputs and outputs with the same dimension.
--------------------------------------------------------------------------------
COMPONENT Cntrl_PID_ExtTrack IS_A Controller "Standard proportional-integral-derivative controller with external tracking"
    PORTS
        IN analog_signal (n=n) s_track
   DATA
	REAL k[n] = 1.					UNITS no_units	"Proportional gain of the controller"

	REAL u_min[n] = 0.			UNITS no_units	"Low limit of output"
	REAL u_max[n] = 1.			UNITS no_units	"High limit of output"


	REAL Ti[n] = 100.				UNITS u_s		"Integrator time or reset time"
      REAL gamma[n] = 0.1		UNITS no_units	"Ratio between the time constant for the antiwindup and the integration time "


	REAL beta[n] = 1. 			UNITS no_units	RANGE 0,1	"Weight factor for set point changes in P output"

	REAL Td[n] = 0.1				UNITS u_s						"Rate or derivative time"
	REAL alpha[n] = 0.1 			UNITS no_units	RANGE 0.,1."Derivative filter parameter"

   DECLS
	REAL es[n]				UNITS no_units	"Saturation error"
	REAL v[n]				UNITS no_units	"Unbounded output"
	REAL vi[n]				UNITS no_units	"Integral part of the output"

	REAL yf[n]				UNITS no_units	"Filtered variable"

   DISCRETE
	EXPAND(i IN 1, n)
	      ASSERT (u_max[i] > u_min[i]) FATAL "Wrong limits for the controller"


   CONTINUOUS

	EXPAND_BLOCK(i IN 1, n)

		u[i] = ZONE (v[i] > u_max[i]) u_max[i]
      		 ZONE (v[i] < u_min[i]) u_min[i]
	             OTHERS                 v[i]

		es[i] = s_track.signal[i] - v[i]

		vi[i]' = (k[i] / Ti[i]) * e[i] + es[i] / (gamma[i] * Ti[i])


		v[i] = k[i] * (beta[i] * r[i] - y[i] - Td[i] * yf[i]') + vi[i]

		yf[i]' = (y[i] - yf[i]) / (alpha[i] * Td[i])

	END EXPAND_BLOCK

END COMPONENT

