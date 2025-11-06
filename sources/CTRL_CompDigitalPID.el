--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompDigitalPID.el
--    FILE TYPE:  Components of the CONTROL library
--    DESCRIPTION:  Defines a digital PID component for the CONTROL library
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
-- Libraries
USE MATH 

-- Components
--------------------------------------------------------------------------------
-- Component Cntrl_DigitalPID
--------------------------------------------------------------------------------
-- Purpose:
--    To represent digital controllers of the proportional, integral and
--    derivative (PID) type.
--------------------------------------------------------------------------------
COMPONENT Cntrl_DigitalPID IS_A Controller "Digital controller of PID type"
   DATA  
	INTEGER input_bits[1] = 16		UNITS u_bits	"Size of the input signal"
	INTEGER output_bits[1] = 16	UNITS u_bits	"Size of the output signal"

	REAL period[1] = 20.				UNITS u_s		"Sampling Period"

	REAL min_input[1]	= 0			UNITS no_units	"Low limit of input"
	REAL max_input[1]	= 1			UNITS no_units	"High limit of input"

	REAL min_output[1] = 0.			UNITS no_units	"Low limit of output"
	REAL max_output[1] = 1.			UNITS no_units	"High limit of output"

	REAL prop_gain[1] = 1.			UNITS no_units	"Controller proportional gain"

	REAL reset_time[1] = 100.		UNITS no_units	"Reset or integral time"
	REAL rate_time[1] = 1.			UNITS no_units	"Rate or derivative time"

	REAL output_i[1] = 0.			UNITS no_units	"Initial output value"

	-- Dead band
	REAL eps_in[1] = 0.001			UNITS no_units	"Dead band of the input signal"

	REAL eps[1]	= 0.001				UNITS no_units	"Minimum step of the output signal"

   DECLS
	CLOSE n = 1
		DISCR REAL u_discr[1]		UNITS no_units "Dicrete Output"
      DISCR REAL error0[1]       UNITS no_units "Input error at time t"
      DISCR REAL error1[1]       UNITS no_units "Input error at time t-dt"
      DISCR REAL error2[1]       UNITS no_units "Input error at time t-2*dt"

      REAL frac[1]               UNITS u_s "Period fraction"

      DISCR REAL input_set[1]    UNITS no_units "Quantizied set point signal"
      DISCR REAL input_var[1]    UNITS no_units "Quantizied variable signal"

      DISCR REAL output0[1]      UNITS no_units "Output at time t"
      DISCR REAL output1[1]      UNITS no_units "Output at time t-dt"

      DISCR REAL start[1]

      DISCR REAL step_size_input[1]
      DISCR REAL step_size_output[1]

      DISCR REAL prop_out[1]
      DISCR REAL rate_out[1]

      DISCR REAL int_out0[1]
      DISCR REAL int_out1[1]

      DISCR REAL new_out[1]

   INIT
      int_out0[1] = 0.
      int_out1[1] = 0.

      error0[1] = 0.
      error1[1] = 0.
      error2[1] = 0.

      step_size_input[1] = (max_input[1] - min_input[1]) / 2.**input_bits[1]
      step_size_output[1] = (max_output[1] - min_output[1]) / 2.**output_bits[1]

      output0[1] = quantzr(step_size_output[1], output_i[1])
      output1[1] = quantzr(step_size_output[1], output_i[1])

      start[1] = 0.

      int_out0[1] = output_i[1]
      int_out1[1] = output_i[1]

      u_discr[1] = output0[1]

   DISCRETE
      WHEN (frac[1] > 1.) THEN
         error2[1] = error1[1]
         error1[1] = error0[1]

         step_size_input[1] = (max_input[1] - min_input[1]) / 2.**input_bits[1]
         step_size_output[1] = (max_output[1] - min_output[1]) / 2.**output_bits[1]

         input_set[1] = quantzr(step_size_input[1], s_set.signal[1])
         input_var[1] = quantzr(step_size_input[1], s_var.signal[1])

         error0[1] = input_set[1] - input_var[1]

            -- Dead band of input signal
         IF (error0[1] > eps_in[1]) THEN
            error0[1] = error0[1] - eps_in[1]
         ELSEIF (error0[1] < -eps_in[1]) THEN
            error0[1] = error0[1] + eps_in[1]
         ELSE
            error0[1] = 0.
         END IF

         prop_out[1] = prop_gain[1] * error0[1]
         rate_out[1] = prop_gain[1] * rate_time[1] / period[1] * (error0[1] - error1[1])
         int_out0[1] = int_out1[1] + prop_gain[1] * period[1] / \
            (2 * reset_time[1]) * (error0[1] + error1[1])

         new_out[1] = prop_out[1] + rate_out[1] + int_out0[1]

         IF (new_out[1] > max_output[1]) THEN
            output0[1] = max_output[1]
            int_out0[1] = int_out1[1] + period[1] * (max_output[1] - int_out1[1]) / \
               (period[1] + reset_time[1])
            output1[1] = output0[1]
         ELSEIF (new_out[1] < min_output[1]) THEN
            output0[1] = min_output[1]
            int_out0[1] = int_out1[1] + period[1] * (min_output[1] - int_out1[1]) / \
               (period[1] + reset_time[1])
            output1[1] = output0[1]
         ELSE
            IF (abs(new_out[1]-output1[1]) > eps[1]) THEN
               output0[1] = new_out[1]
               output1[1] = output0[1]
            END IF
         END IF

         int_out1[1] = int_out0[1]

         output0[1] = quantzr(step_size_output[1], output0[1])

         u_discr[1] = output0[1]

         start[1] = start[1] + period[1]

      END WHEN

   CONTINUOUS
      frac[1] = (TIME - start[1]) / period[1]
      u = u_discr

END COMPONENT
