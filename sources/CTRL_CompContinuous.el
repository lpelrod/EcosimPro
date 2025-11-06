--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompContinuous.el
--    FILE TYPE:  Components of the CONTROL library
--    DESCRIPTION:  Defines the continuous analog control components for the library
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
-- Libraries
USE MATH 

-- Components
--------------------------------------------------------------------------------
-- Component Integrator
--------------------------------------------------------------------------------
-- Purpose:
--    To integrate an input signal.
--------------------------------------------------------------------------------
COMPONENT Integrator IS_A MIMOs "To integrate an input signal"
   DATA
      REAL output_o[n] = 0.      UNITS no_units	"Initial values of output"
   INIT
	FOR (i IN 1, n)
         s_out.signal[i] = output_o[i]
      END FOR
   CONTINUOUS
      EXPAND (i IN 1,n)
         s_out.signal[i]' =  s_in.signal[i]

END COMPONENT

--------------------------------------------------------------------------------
-- Component Derivative
--------------------------------------------------------------------------------
-- Purpose:
--    To derive an input signal.
--------------------------------------------------------------------------------
COMPONENT Derivative IS_A MIMOs "To derive an input signal"
   DATA
      REAL Tf[n] = 0.001    UNITS u_s	"Filter time"
		REAL output_o[n] = 0. UNITS no_units	"Initial values for dynamic variable"
   DECLS
      REAL yf[n]
   INIT
		FOR (i IN 1, n)
         yf[i] = output_o[i]
      END FOR
   CONTINUOUS
      EXPAND_BLOCK (i IN 1,n)
         yf[i]' = (s_in.signal[i] - yf[i]) / Tf[i]
         s_out.signal[i] = yf[i]'
      END EXPAND_BLOCK

END COMPONENT

--------------------------------------------------------------------------------
-- Component TF_1stOrder
--------------------------------------------------------------------------------
-- Purpose:
--                                            			k·x - y
--    To represent a first order transfer function:  y' = ---------- 
--                                           		         tau
--------------------------------------------------------------------------------
COMPONENT TF_1stOrder IS_A MIMOs "First order transfer function"
   DATA
	REAL gain[n] = 1				UNITS no_units	"Gain"
      REAL tau[n] = 1.			UNITS u_s		"Time constant"
      REAL output_o[n] = 0.	UNITS no_units	"Initial output "

   INIT 
      FOR (i IN 1,n)
         s_out.signal[i] = output_o[i]
      END FOR

   DISCRETE
      EXPAND_BLOCK (i IN 1, n)
         ASSERT (tau[i] != 0.) FATAL 	"tau value cannot be zero in TF_1stOrder component"
         ASSERT (gain[i] != 0.) FATAL 	"gain value cannot be zero in TF_1stOrder component"
	END EXPAND_BLOCK

   CONTINUOUS
      EXPAND (i IN 1, n)
         s_out.signal[i]' = (gain[i] * s_in.signal[i] - s_out.signal[i]) / tau[i]

END COMPONENT

--------------------------------------------------------------------------------
-- Component TF_2ndOrder
--------------------------------------------------------------------------------
-- Purpose:
--                                        		  1                D
--    To represent a second order transfer function:  ----- * y'' + 2 * --- * y' + y = K * x
--                                       			 W^2               W
--
--       Where "W" represents the angular frecuency, "D" the damping and "K"
--       the gain.
--------------------------------------------------------------------------------
COMPONENT TF_2ndOrder IS_A MIMOs "Second order transfer function"
   DATA
      REAL frec[n] = 1.			UNITS u_Hz		"Angular frecuency"
      REAL damp[n] = 1.			UNITS no_units	"Damping"
      REAL gain[n] = 1.			UNITS no_units	"Gain"

      REAL output_o[n] = 0.	UNITS no_units	"Initial values of output"

   DECLS
      REAL z[n]             	UNITS no_units	"Array of dynamic variables"

   INIT
      FOR (i IN 1, n)
         z[i] = 0.
         s_out.signal[i] = output_o[i]
      END FOR

   DISCRETE
      EXPAND (i IN 1, n)
         ASSERT (gain[i] != 0.) FATAL "Gain value cannot be zero in TF_2ndOrder component"

   CONTINUOUS
      EXPAND_BLOCK (i IN 1,n)
         z[i]' = frec[i]**2 * (gain[i] * s_in.signal[i] - (2. * damp[i] / frec[i]) * z[i] - s_out.signal[i])

         s_out.signal[i]' = z[i]

      END EXPAND_BLOCK

END COMPONENT


--------------------------------------------------------------------------------
-- Component TransferFunction
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a linear transfer function.
--------------------------------------------------------------------------------
COMPONENT TransferFunction IS_A SISO 
   (
   INTEGER n_num = 0		UNITS no_units	"Order of the numerator polynomial",
   INTEGER n_den = 1		UNITS no_units	"Order of the denominator polynomial"
   )
"Linear P(s)/Q(s) transfer function"
   DATA
      REAL p[n_num+1] = 1.	UNITS no_units	"Coefficients of numerator polynomial: p[1]*s^n+...+p[n+1]"
      REAL q[n_den+1] = 1.	UNITS no_units	"Coefficients of denominator polynomial: q[1]*s^n+...+q[n+1]"

      REAL output_o = 0.	UNITS no_units	"Initial value of the output"

   DECLS

      INTEGER j			UNITS no_units	"Auxiliary index"

      REAL z[n_den]		UNITS no_units	"Array of dynamic variables"

   INIT

      ASSERT (n_den >= n_num) FATAL "The order of numerator must be lower than the order of denominator"

      ASSERT (q[1] != 0) FATAL "Highest order coefficient in denominator cannot be zero"


      FOR (i IN 2,n_den)
         z[i] = 0.
      END FOR

      IF (n_num < n_den) THEN
         j = 1

         WHILE (p[(n_num+2) - j] == 0 AND j < (n_num+2))
            j = j + 1
         END WHILE

	   z[j] = output_o / p[(n_num + 2 - j)]


      ELSE
         j = 1

         WHILE ((p[(n_den + 2 - j)] == 0) AND (q[n_den + 2 - j] == 0))
            j = j + 1
         END WHILE

         z[j] = (output_o * q[1] - p[1] * s_in.signal[1]) / \
            (p[(n_den + 2 - j)] * q[1] - q[n_den + 2 - j] * p[1])

      END IF

   DISCRETE
      ASSERT (n_den >= n_num) FATAL "The order of numerator must be lower than the order of denominator"

      ASSERT (q[1] != 0) FATAL "Highest order coefficient in denominator cannot be zero"

   CONTINUOUS
      EXPAND (i IN 1,n_den-1)
         z[i]' = z[i+1]

      z[n_den]' = (s_in.signal[1] - SUM(i IN 1,n_den; q[n_den + 2 - i] * z[i])) / q[1]

      s_out.signal[1] = p[n_num + 1] * z[1] + SUM(i IN 1,n_num; p[n_num + 1 -i] * z[i]')

END COMPONENT


--------------------------------------------------------------------------------
-- Component StateSpace
--------------------------------------------------------------------------------
-- Purpose:
--    To define a state-space model.
--------------------------------------------------------------------------------
COMPONENT StateSpace IS_A MIMO
   (
	INTEGER n UNITS no_units "Number of states"
   ) 
"To define a state-space model"
   DATA
	REAL A[n,n]			"Matrix A"
      REAL B[n,n_in]		"Matrix B"	
      REAL C[n_out,n]		"Matrix C"
      REAL D[n_out,n_in]	"Matrix D"	
	REAL x_o[n] = 0         "Initial condition vector"

   DECLS
      REAL x[n]			"States"

   INIT

	FOR (j IN 1, n)
		x[j] = x_o[j]
	END FOR

   CONTINUOUS

      EXPAND(i IN 1,n)
      	x[i]' = SUM(j IN 1,n; A[i,j]*x[j]) + SUM(j IN 1,n_in; B[i,j] * s_in.signal[j])    

      EXPAND(i IN 1,n_out)
            s_out.signal[i] = SUM(j IN 1,n; C[i,j]*x[j]) + SUM(j IN 1,n_in; D[i,j] * s_in.signal[j])

END COMPONENT 

--------------------------------------------------------------------------------
-- Component ZeroPole
--------------------------------------------------------------------------------
-- Purpose: To define the component zero-pole transfer function
--
--	          (s - z1)(s - z2) ... (s - zn)	
--	F(s)=  K --------------------------------
--		    (s - p1)(s - p2) ... (s - pn)	
-- 
-- WARNING: A complex zero/pole MUST be accompanied by its complex 
-- conjugate!!
--------------------------------------------------------------------------------
COMPONENT ZeroPole IS_A SISO(
		INTEGER nzeros = 1 UNITS no_units	"Number of zeros",
		INTEGER npoles = 1 UNITS no_units	"Number of poles"
		)
"Zero-poles transfer function"
   DATA
	REAL K = 1.			"Gain"
	REAL zeros[nzeros, 2]	"Values of the zeros: real part, imaginary part"
	REAL poles[npoles, 2]	"Values of the poles: real part, imaginary part"
	ENUM InitOption option = InitialStates \
					"Initialization of discrete component: states or output"
	REAL y_o = 0		"Initial value for the output"
	REAL x_o[npoles] = 0	"Array with initial values of the states"
	
   DECLS
	DISCR REAL p[nzeros + 1]				"Coefficients of the numerator (in increasing powers of s)"
	DISCR REAL q[npoles + 1]				"Coefficients of the denominator (in increasing powers of s)"
	REAL x[npoles + 1]						"State variables"
	INTEGER j				UNITS no_units	"Index"
   INIT

	ASSERT (nzeros <= npoles) FATAL("Numerator cannot be of higher order than denominator")

	Coeff_from_factorized(nzeros, zeros, p)
	
	Coeff_from_factorized(npoles, poles, q)

	IF(option == InitialStates) THEN
		FOR (j IN 1,npoles)
			x[j] = x_o[j]
		END FOR
	ELSE
		IF (nzeros == npoles) THEN
			ASSERT (q[npoles + 1] !=0) FATAL("Coefficient on highest power of denominator cannot be zero")
			IF (npoles == 1) THEN
				ASSERT (p[1] * q[2] != p[2] * q[1]) FATAL("Numerator and denominator are proportionals")
				x[1] = (y_o - s_in.signal[1] * p[2] / q[2]) / (p[1] - p[2] * q[1] / q[2])
				x[2] = (s_in.signal[1] - q[1] * x[1]) / q[2]	
			ELSE
				j = 1
				WHILE (p[nzeros + 1] * q[j] == p[j] * q[npoles + 1]) 	
					x[j] = 0
					j = j + 1
				END WHILE
				ASSERT (j <= npoles) FATAL("Numerator and denominator are proportionals")

				x[j] = (y_o - s_in.signal[1] * p[nzeros + 1] / q[npoles + 1]) / (p[j] - p[nzeros + 1] * q[j] / q[npoles + 1])  			
				FOR (k IN j+1, npoles)
					x[k] = 0
				END FOR
				x[npoles + 1] = (s_in.signal[1] - q[j] * x[j]) / q[npoles + 1]
			END IF

		ELSE
			ASSERT (q[npoles + 1] !=0) FATAL("Highest power coefficient on denominator cannot be zero")
			ASSERT (p[nzeros + 1] !=0) FATAL("Highest power coefficient on numerator cannot be zero")
			x[1] = y_o / p[1]
		
			IF (npoles > 1) THEN
				FOR (j IN 2,npoles)
					x[j] = 0
				END FOR
			END IF
		
			x[npoles + 1] = (s_in.signal[1] - q[1] * x[1]) / q[npoles + 1]
		END IF


	END IF

   CONTINUOUS

	EXPAND (j IN 1, npoles)
		x[j+1] = x[j]'
	

	s_in.signal[1] = SUM(i IN 1, npoles + 1; x[i] * q[i])
	s_out.signal[1] = SUM(i IN 1, nzeros + 1; K * x[i] * p[i])

END COMPONENT

--------------------------------------------------------------------------------
-- Component ButterLow
--------------------------------------------------------------------------------
-- Purpose:
--    Output the input signal filtered with a low pass Butterworth
--	filter of any order
--------------------------------------------------------------------------------
COMPONENT ButterLow IS_A SISO (
	INTEGER n_f = 2	"Order of the filter",
	INTEGER m)
"Defines a transfer function as an n_f-th order low pass filter with Butterworth characteristics and cut-off frequency"

   DATA
	REAL freq = 1	UNITS u_Hz		"Cut-off frequency "
   DECLS
	CLOSE m = (n_f+1)/2
	REAL z[m + 1]
	REAL polereal[m]					"Real part of the poles"
	REAL poleimag[m]					"Imaginary part of the poles"
	REAL realpol
	REAL k2[m]							"Gain in the second order filters"
	REAL D[m]							"Damping in the second order filters"
	REAL w0[m]		UNITS u_Hz		"Angular frequency in the second order filters "
	REAL x1[m]							"States 1 of second order filters"
	REAL x2[m]							"States 2 of second order filters"
	REAL xr								"State of real pole for uneven order otherwise dummy"
	REAL k1								"Unitary gain in the first order filter for odd order Butterlow filters"
	REAL T			UNITS u_s		"Time constant in the first order filter for odd order Butterlow filters"
	REAL w			UNITS u_rad_s	"Angular frequency"

   CONTINUOUS
	EXPAND(i IN 1, m)
		k2[i] = 1.

	k1 =1.

	w = 2.*MATH.PI*freq
	
	z[1] = s_in.signal[1]

	EXPAND_BLOCK(i IN 1, m)
		polereal[i] = cos(MATH.PI/2. + MATH.PI/n_f * (i - 0.5))
		poleimag[i] = sin(MATH.PI/2. + MATH.PI/n_f * (i - 0.5))
		--Scaling and calculation of second order filter coefficients
		w0[i] = (polereal[i]**2 + poleimag[i]**2)*w
		D[i] = -polereal[i]/w0[i]*w
	END EXPAND_BLOCK

	realpol = 1.*w

	T = 1./realpol
	
	EXPAND_BLOCK(2*m == n_f)
	--Even order
	   EXPAND_BLOCK(i IN 1, m)
		x1[i]' = x2[i]
		x2[i]' = k2[i] * w0[i]**2 * z[i] - 2*D[i] * w0[i] * x2[i] \
				- w0[i]**2 * x1[i]
		z[i+1] = x1[i]
	   END EXPAND_BLOCK

		xr = 0.
		s_out.signal[1] = z[m+1]

	END EXPAND_BLOCK

	EXPAND_BLOCK(2*m != n_f)
	--Odd order
	   EXPAND_BLOCK(i IN 1, m-1)
		x1[i]' = x2[i]
		x2[i]' = k2[i] * w0[i]**2 * z[i] - 2*D[i] * w0[i] * x2[i] \
				- w0[i]**2 * x1[i]
		z[i+1] = x1[i]
	   END EXPAND_BLOCK
	   x1[m] = 0
	   x2[m] = 0
	   z[m+1] = z[m]

	   xr' = (k1 * z[m+1] - xr)/T
	   s_out.signal[1] = xr
	END EXPAND_BLOCK

END COMPONENT

--------------------------------------------------------------------------------
-- Component CritDamping
--------------------------------------------------------------------------------
-- Purpose:
--    Output the input signal filtered with an n-th order filter with
--	critical damping
--------------------------------------------------------------------------------
COMPONENT CritDamping IS_A SISO(
	INTEGER n_f = 1	UNITS no_units "Order of filter")
"n_f-order filter with critical damping characteristics and cut-off frequency freq. It is implemented as a series of first order filters"
   DATA
	REAL freq = 1	UNITS u_Hz 		"Cut-off frequency"
   DECLS
	REAL x[n_f+1]						"State variables"
	REAL w			UNITS u_rad_s	"Angular frequency"
   CONTINUOUS
	w = 2 * MATH.PI * freq

	x[1] = s_in.signal[1]

	EXPAND(i IN 2, n_f + 1)
		x[i]' = (x[i-1] - x[i]) * w/(2*MATH.PI)

	s_out.signal[1] = x[n_f+1]
	
END COMPONENT



