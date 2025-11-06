--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompDiscrete.el
--    FILE TYPE:  Components of the CONTROL library
--    DESCRIPTION: Defines the discrete control components for the CONTROL library
--			 The components of this file has input and output analog signals.
--			 The input signals are sampled by a sample period defined by the
--			 user with the data dt. The output signals are calculated from
--			 the sampled input signals.
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
-- Libraries
USE MATH 

-- Components

--------------------------------------------------------------------------------
-- Component ZeroOrderHold
--------------------------------------------------------------------------------
-- Purpose:
--    To define a zero order hold
--	This component implements a zero-order hold of one sample period
--------------------------------------------------------------------------------
COMPONENT ZeroOrderHold IS_A dMIMOs "Zero-order hold of one sample period"
	DECLS
		REAL u[n]	"Output signal"

   DISCRETE
	WHEN (sample == TRUE) THEN
		FOR (i IN 1, n)
			u[i] = s_in.signal[i]
		END FOR
	END WHEN

   CONTINUOUS
	SEQUENTIAL
		IF (sample == TRUE) THEN
			FOR (i IN 1, n)
				u[i] = s_in.signal[i]
			END FOR
		END IF	
	END SEQUENTIAL
	s_out.signal = u 

END COMPONENT

--------------------------------------------------------------------------------
-- Component FirstOrderHold
--------------------------------------------------------------------------------
-- Purpose:
--    To define a first order hold
--	This component implements a first order sample-and-hold latch
--------------------------------------------------------------------------------
COMPONENT FirstOrderHold IS_A dMIMOs "First order sample-and-hold latch"
   DECLS
	DISCR REAL To						UNITS u_s		"Current sample time" 
	REAL signal_1[n]	UNITS no_units	"Array with values of the last sampled input signal"
	DISCR REAL signal_2[n]	UNITS no_units	"Array with values of the penultimate sampled input signal"
	BOOLEAN ExSEQ = TRUE		"Variable to allow the execution of the SEQUENTIAL block once the array signal_2 is recalculated"
   INIT
	To = TIME
	FOR(i IN 1, n)
		signal_1[i] = 0
		signal_2[i] = 0
	END FOR
	ExSEQ = FALSE
   DISCRETE

	WHEN (sample == TRUE) THEN
		To = TIME
		ExSEQ = TRUE
		
		FOR(i IN 1, n)
			signal_2[i] = signal_1[i]
--			signal_1[i] = s_in.signal[i] 
		END FOR
		
	END WHEN
	
	
	WHEN(sample == FALSE) THEN
		ExSEQ = FALSE
	END WHEN
	
   CONTINUOUS
	SEQUENTIAL
		IF(ExSEQ) THEN		
			FOR(i IN 1, n)
--				signal_2[i] = signal_1[i]
				signal_1[i] = s_in.signal[i] 
			END FOR		
		END IF
	END SEQUENTIAL
	
	EXPAND(i IN 1, n)
		s_out.signal[i] = signal_1[i] + (signal_1[i] - signal_2[i]) * (TIME - To) / dt
END COMPONENT


--------------------------------------------------------------------------------
-- Component UnitDelay
--------------------------------------------------------------------------------
-- Purpose:
--    To define a unit delay component. 
--	This component delay a signal one sample period
--------------------------------------------------------------------------------
COMPONENT UnitDelay IS_A dMIMOs 
"To delay a signal one sample period"
   DATA
	REAL y_o[n] = 0     "Initial condition"
	DECLS
		REAL u[n]			"Output signal"
   INIT 
	FOR(i IN 1, n)
		u[i] = y_o[i]
		s_out.signal[i] = y_o[i]
	END FOR
   CONTINUOUS
		SEQUENTIAL
			IF (sample == TRUE) THEN
				FOR(i IN 1, n)
					s_out.signal[i] = s_in.signal[i] AFTER dt
				END FOR
			END IF 
		END SEQUENTIAL
	

	s_out.signal = u

END COMPONENT

--------------------------------------------------------------------------------
-- Component dStateSpace
--------------------------------------------------------------------------------
-- Purpose:
--    To define a discrete state-space model
--------------------------------------------------------------------------------
COMPONENT dStateSpace IS_A dMIMO(
	INTEGER n_states = 1 	UNITS no_units	"Number of states") 
"To define a discrete state-space model"
   DATA
		REAL A[n_states, n_states]		"Matrix A of state space model"
      REAL B[n_states, n_in]			"Matrix B of state space model"
      REAL C[n_out, n_states]			"Matrix C of state space model"
      REAL D[n_out, n_in]				"Matrix D of state space model"
		REAL x_o[n_states] = 0			"Initial conditions for output array"

	DECLS
   	REAL u[n_out]				"Output signal"
		DISCR REAL x[n_states]  "States"
		REAL xn[n_states]    	"New states"	
		BOOLEAN ExSEQ = FALSE	"Variable to avoid the execution before sampling of the WHEN block that calculates the new states before sampling"	
	INIT
		FOR (j IN 1, n_states)
			x[j] = x_o[j]
		END FOR
		ExSEQ = FALSE
   DISCRETE
		WHEN (sample == TRUE) THEN
			ExSEQ = TRUE
		END WHEN	

		WHEN(sample == FALSE AND ExSEQ) THEN
				FOR (i IN 1, n_states)
					x[i] = xn[i]
				END FOR
		END WHEN

   CONTINUOUS

		SEQUENTIAL				
			IF (sample) THEN
				FOR (i IN 1, n_out)
					u[i] = SUM(j IN 1, n_states; C[i,j] * x[j]) + SUM(j IN 1, n_in; D[i,j] * s_in.signal[j])
				END FOR
		
				FOR (i IN 1, n_states)
					xn[i] = SUM(j IN 1, n_states; A[i,j] * x[j]) + SUM(j IN 1, n_in; B[i,j] * s_in.signal[j])
				END FOR
			END IF
		END SEQUENTIAL

	s_out.signal = u

END COMPONENT

--------------------------------------------------------------------------------
-- Component dZeroPole
--------------------------------------------------------------------------------
-- Purpose:
--    To define a discrete zero pole
--	This component implements a discrete transfer function in terms of poles
--	and zeros
--------------------------------------------------------------------------------
COMPONENT dZeroPole IS_A dSISO(
	INTEGER n_zeros = 1	UNITS no_units	"Number of zeros",
	INTEGER n_poles = 1	UNITS no_units	"Number of poles")
"To implement a discrete transfer function in terms of poles"
   PORTS

   DATA
	REAL K = 1				UNITS no_units	"Gain array"
	REAL zeros[n_zeros, 2]		"Values of the zeros (real part, imaginary part)"
	REAL poles[n_poles, 2]		"Values of the poles (real part, imaginary part)"
	ENUM InitOption option = InitialStates \
				"Initialization of discrete component: states or output"
	REAL x_o[n_poles] = 0.0		"Initial conditions of the states"
	REAL y_o = 0			"Initial condition for the output"	

   DECLS
   REAL u[n]					"Output signals"
	DISCR REAL p[n_zeros + 1]    	"Coefficients of numerator polinomial in increasing power of z"
	DISCR REAL q[n_poles + 1]    	"Coefficients of denominator polinomial in increasing power of z"
	DISCR REAL x[n_poles + 1]    	"Values of the states" 
	INTEGER j				"Auxiliary index"
	BOOLEAN ExSEQ = TRUE	"Variable to avoid the execution before sampling of the WHEN block that calculates the new states before sampling"
   INIT
	
	Coeff_from_factorized(n_zeros, zeros, p)
	
	Coeff_from_factorized(n_poles, poles, q)

	IF(option == InitialStates) THEN
		FOR(j IN 2, n_poles + 1) 
			x[j] = x_o[j - 1]
		END FOR

	ELSE
		ASSERT (n_zeros <= n_poles) FATAL("Numerator cannot be of higher order than denominator in component dZeroPole")
		IF (n_poles == n_zeros) THEN
			ASSERT (q[n_poles + 1] !=0) FATAL("Coefficient on highest power of denominator cannot be zero in component dZeroPole")
			IF (n_poles == 1) THEN
				ASSERT (p[2] * q[1] != p[1] * q[2]) FATAL("Numerator and denominator are proportionals")
				x[2] = (y_o - p[2] * s_in.signal[1] / q[2]) / (p[1] - p[2] * q[1] / q[2])
			
			ELSE
				j = 2
				WHILE (p[n_zeros + 1] * q[n_poles + 2 - j] == p[n_zeros + 2 - j] * q[n_poles + 1]) 	
					x[j] = 0
					j = j + 1
				END WHILE
	
				ASSERT (j < n_poles + 1) FATAL("Numerator and denominator are proportionals")

				x[j] = (y_o - s_in.signal[1] * p[n_zeros + 1] / q[n_poles + 1]) / (p[n_zeros + 2 - j] - p[n_zeros + 1] * q[n_poles + 2 - j] / q[n_poles + 1])  
			
				FOR (k IN j+1, n_poles + 1)
					x[k] = 0
				END FOR
			END IF

		ELSE
			ASSERT (q[n_poles + 1] != 0 AND p[n_zeros + 1] !=0) FATAL("Highest power coefficient on denominator or numerator cannot be zero")
		
			x[n_poles - n_zeros + 1] = y_o / p[n_zeros + 1]
		
			FOR (j IN 2, n_poles - n_zeros)
				x[j] = 0
			END FOR
				
		END IF	
	END IF
	ExSEQ = FALSE
   DISCRETE
		WHEN (sample == TRUE) THEN
			ExSEQ = TRUE
		END WHEN	


		WHEN(sample == FALSE AND ExSEQ) THEN
			FOR (j IN 1, n_poles)
				x[n_poles + 2 - j] = x[n_poles + 1 - j]
			END FOR
		END WHEN

   CONTINUOUS

		SEQUENTIAL				
			IF (sample) THEN
				x[1] = (s_in.signal[1] - SUM(j IN 2, n_poles + 1; x[j] * q[n_poles + 2 - j])) / q[n_poles + 1]
		
				u[1] = K * SUM(j IN 1, n_zeros + 1; x[n_poles + 2 - j] * p[j]) 
			END IF
		END SEQUENTIAL

	s_out.signal = u

END COMPONENT

--------------------------------------------------------------------------------
-- Component dFilter
--------------------------------------------------------------------------------
-- Purpose:
--    To define the component discrete filter. Its transfer function
--    is of the form: F(z) = num(1/z) / den(1/z)
--------------------------------------------------------------------------------
COMPONENT dFilter IS_A dSISO(
	INTEGER n_num = 0			UNITS no_units	"Order of numerator polinomial [1/z]",
	INTEGER n_den = 1			UNITS no_units	"Order of denominator polinomial [1/z]")
"Discrete filter on the form: F(z) = num(1/z) / den(1/z)"
   DATA
	REAL pdata[n_num + 1] = 1	"Coefficients of numerator polinomial in ascending powers of 1/z"
	REAL qdata[n_den +1] = 1	"Coefficients of denominator polinomial in ascending powers of 1/z"

   DECLS
   REAL u[n]
	DISCR REAL x[n_den + 1]		"Values of states"
	DISCR REAL p[n_den + 1]		"Coefficients of numerator polinomial in ascending powers of 1/z" 
	BOOLEAN ExSEQ = FALSE		"Variable to avoid the execution before sampling of the WHEN block that calculates the new states before sampling"
   INIT
      ASSERT(n_num <= n_den) FATAL "The order of the denominator must be greater than \
		or equal to the order of the numerator"
 
	FOR (j IN 1, n_num + 1)
		p[j] = pdata[j]
	END FOR
	FOR (j IN n_num + 2, n_den + 1)
		p[j] = 0
	END FOR
	ExSEQ = FALSE
   DISCRETE
		WHEN (sample == TRUE) THEN
			ExSEQ = TRUE
		END WHEN	

		WHEN(sample == FALSE AND ExSEQ) THEN
			FOR (j IN 1, n_den)
				x[n_den + 2 - j] = x[n_den + 1 - j]
			END FOR
		END WHEN
		
   CONTINUOUS
		SEQUENTIAL				
			IF (sample == TRUE) THEN			
				x[1] = (s_in.signal[1] - SUM(j IN 2, n_den + 1; x[j] * qdata[j])) / qdata[1]
				u[1] = SUM(j IN 1, n_num + 1; x[j] * p[j]) 
			END IF
		END SEQUENTIAL
	
	s_out.signal = u

END COMPONENT

--------------------------------------------------------------------------------
-- Component dTransferFunction
--------------------------------------------------------------------------------
-- Purpose:
--    To define a discrete transfer function 
--		   num(z)
-- 	H(z) = ---------
--		   den(z)
--
--------------------------------------------------------------------------------
COMPONENT dTransferFunction IS_A dSISO(
	INTEGER n_num = 0		UNITS no_units	"Order of numerator polinomial",
	INTEGER n_den = 1		UNITS no_units	"Order of denominator polinomial")
"To define a discrete transfer function"
   DATA
		REAL pdata[n_num + 1] = 1	"Coefficients of numerator polinomial in descending power of z: p[1]*z^n+...+p[n+1]"
		REAL qdata[n_den +1] = 1	"Coefficients of denominator polinomial in descending power of z: q[1]*z^n+...+q[n+1]"
		ENUM InitOption option = InitialStates \
						"Initialization of discrete component: states or output"
		REAL x_o[n_den] = 0     	"Initial conditions of the states"
		REAL y_o = 0 			"Initial condition for the output"
		
   DECLS
		REAL u[n]						"Output signals"
		DISCR REAL x[n_den + 1]    "Values of states"
		INTEGER j						"Auxiliary index"
		BOOLEAN ExSEQ = FALSE		"Variable to avoid the execution before sampling of the WHEN block that calculates the new states before sampling"
   INIT
	IF(option == InitialStates) THEN
		FOR(j IN 2, n_den + 1) 
			x[j] = x_o[j - 1]
		END FOR
	ELSE
		ASSERT (n_num <= n_den) FATAL("Numerator cannot be of higher order than denominator")
		IF (n_den == n_num) THEN
			ASSERT (qdata[1] !=0) FATAL("Coefficient on highest power of denominator cannot be zero")
			IF (n_den == 1) THEN
				ASSERT (pdata[2] * qdata[1] != pdata[1] * qdata[2]) FATAL("Numerator and denominator are proportionals")
				x[2] = (y_o - pdata[1] * s_in.signal[1] / qdata[1]) / (pdata[2] - pdata[1] * qdata[2] / qdata[1])
			
			ELSE
				j = 2
				WHILE (pdata[1] * qdata[j] == pdata[j] * qdata[1]) 	
					x[j] = 0
					j = j + 1
				END WHILE
	
				ASSERT (j < n_den + 1) FATAL("Numerator and denominator are proportionals")

				x[j] = (y_o - s_in.signal[1] * pdata[1] / qdata[1]) / (pdata[j] - pdata[1] * qdata[j] / qdata[1])  
			
				FOR (k IN j+1, n_den + 1)
					x[k] = 0
				END FOR
			END IF

		ELSE
			ASSERT (qdata[1] !=0 AND pdata[1] !=0) FATAL("Highest power coefficient on denominator or numerator cannot be zero")
		
			x[n_den - n_num + 1] = y_o / pdata[1]
		
			FOR (j IN 2,n_den - n_num)
				x[j] = 0
			END FOR
				
		END IF			
	END IF
	ExSEQ = FALSE
   DISCRETE
		WHEN (sample == TRUE) THEN
			ExSEQ = TRUE
		END WHEN
		
		WHEN(sample == FALSE AND ExSEQ) THEN
			FOR (j IN 1, n_den)
				x[n_den + 2 - j] = x[n_den + 1 - j]
			END FOR
		END WHEN
   CONTINUOUS

		SEQUENTIAL				
			IF(sample) THEN
				x[1] = (s_in.signal[1] - SUM(j IN 2, n_den + 1; x[j] * qdata[j])) / qdata[1]		
				u[1] = SUM(j IN 1, n_num + 1; x[n_den + 2 - j] * pdata[n_num + 2 - j]) 
			END IF
		END SEQUENTIAL

	s_out.signal = u
END COMPONENT


--------------------------------------------------------------------------------
-- Component dIntegrator
--------------------------------------------------------------------------------
-- Purpose:
--    To define a discrete integrator
--	This component performs discrete-time integration of the input signal
--------------------------------------------------------------------------------
COMPONENT dIntegrator IS_A dMIMOs (
	ENUM dIntegMethod Method = ForwardEuler)
"Discrete-time integration of the input signal"
   DATA
	REAL y_o[n] = 0		"Initial condition for the output"

   DECLS
		DISCR REAL x[n]			"Values of states"
		REAL u[n]					"Output signals"	
		BOOLEAN ExSEQ = FALSE	"Variable to avoid the execution before sampling of the WHEN block that calculates the new states before sampling"
		DISCR REAL TIME_o = 0
   INIT
		FOR(i IN 1, n)
			x[i] = y_o[i]
			s_out.signal[i] = y_o[i]
		END FOR
		ExSEQ = FALSE
		TIME_o = TIME

   DISCRETE
		WHEN (sample == TRUE) THEN
			ExSEQ = TRUE
		END WHEN

		EXPAND_BLOCK(Method == ForwardEuler)
			WHEN (sample == FALSE AND ExSEQ) THEN
				FOR(i IN 1, n)
					x[i] = u[i] + dt * s_in.signal[i]
			END FOR
		END WHEN
	END EXPAND_BLOCK
	
	WHEN(TIME > TIME_o) THEN
	END WHEN
		
	EXPAND_BLOCK (Method == BackwardEuler)
		WHEN (sample == FALSE AND ExSEQ) THEN
			FOR(i IN 1, n)
				x[i] = u[i]
			END FOR
		END WHEN
	END EXPAND_BLOCK

	EXPAND_BLOCK (Method == Trapezoidal)
		WHEN (sample == FALSE AND ExSEQ) THEN
			FOR(i IN 1, n)
				x[i] = u[i] + dt/2 * s_in.signal[i]
			END FOR
			
		END WHEN
	END EXPAND_BLOCK
		
   CONTINUOUS
		IF(Method == ForwardEuler)	 INSERT
			SEQUENTIAL			
				IF (sample == TRUE) THEN					
					FOR(i IN 1, n)
						u[i] = x[i]
					END FOR
				END IF
			END SEQUENTIAL
		ELSEIF(Method == BackwardEuler) INSERT
			SEQUENTIAL
				IF (sample == TRUE) THEN
					IF(TIME > TIME_o) THEN
						FOR(i IN 1, n)
						u[i] = x[i] + dt * s_in.signal[i]
						END FOR
					ELSE
						FOR(i IN 1, n)
						u[i] = x[i]
						END FOR
					END IF	
				END IF
			END SEQUENTIAL
		ELSEIF(Method == Trapezoidal) INSERT
			SEQUENTIAL
				IF (sample == TRUE) THEN
					IF(TIME > TIME_o) THEN
						FOR(i IN 1, n)
							u[i] = x[i] + dt/2 * s_in.signal[i]
						END FOR
					ELSE
						FOR(i IN 1, n)					
							u[i] = x[i]
						END FOR
					END IF						
				END IF
			END SEQUENTIAL
		END IF

	s_out.signal = u

END COMPONENT
