--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MATH_f_Equations.el
--    FILE TYPE:  External objects of the MATH library
--    DESCRIPTION:  Defines a non-linear system of equations solver for the
--                  MATH library
--    NOTES:  Based on EcosimPro MATH library
--    AUTHOR:  Borja Garcia Gutierrez
--    CREATION DATE:  12-Jan-2004
--------------------------------------------------------------------------------


-- External Objects

--------------------------------------------------------------------------------
-- Function EcoNonLinearEqnSolver
--------------------------------------------------------------------------------
-- Purpose: to find a zero of a system of N nonlinear functions in N variables X by a modification of the Powell hybrid method: FVEC (X) = 0.
-- How to use:
/*
INFREV: IN, OUT, INTEGER, reverse communication parameter INFREV is an integer variable hat must be set by the user to a non-positive value initially, in order to indicate the start of the calculation. The value of INFREV on each return indicates the reason for the return. 
If it is 1,3 or 4, then the user's program has to provide new values of FVEC, and then recall the subroutine with INFREV still set to this number. 
If it is 2, then the user's program has to provide new values of FVEC and FJAC, and then recall the subroutine with INFREV set to 2.
         INFREV on return
            = 0: Solver terminated
            = 1: Calculate FVEC at starting point
            = 2: Calculate FVEC and FJAC (only if IOPT=1)
            = 3: Calculate FVEC to compute Jacobian approximation
            = 4: Calculate FVEC to compute next step)
 IOPT  : IN, INTEGER, selection parameter
         IOPT specifies how the Jacobian will be calculated.
         1: the user must supply the Jacobian.
         2: the code will approximate the Jacobian by forward-differencing.
         3: same as IOPT=2, but for the first call (INVREF<=0) the user must supply the Jacobian.
 N     : IN, INTEGER, N.gt.0
         Number of functions and variables.
 X     : IN, OUT, DOUBLE(N)
         On input X must contain an initial estimate of the solution vector.
         On output X contains the values for which FVEC has to be computed in the next iteration step (INFREV=1,2,3 or 4) or the final estimate of the solution vector (INFREV=0).

 FVEC  : IN, DOUBLE(N)
        FVEC has to contain the functions evaluated at X  (INFREV=1,2,3,4).
 FJAC  : IN, DOUBLE(N,N)
         FJAC has to contain the Jakobian (INFREV=2) The Jacobian has to be provided only if IOPT=1.
         If IOPT=2 or 3, FJAC is used as a work array.  It contains the approximation of the Jacobian.
 TOL   : IN, DOUBLE, TOL.ge.0.d0
         Termination occurs when the algorithm estimates that the relative error between X and the solution is at most TOL.
         If TOL=0.D0 is given, a tolerance of sqrt(machine precision) is assumed.
 INFO  : OUT, INTEGER
		 IF INFREV > 0 THEN  Iteration continues
					INFO =  0  Internal step
						 = 10  Internal step completed
		  ELSEIF INFREV = 0 THEN Iteration terminated. Termination status:
					INFO =  0  Improper input parameters (wrong initialization)
					INFO =  1  Algorithm estimates that the relative error between X and the solution is at most TOL  (regular end).
					INFO =  2  Number of calls to FCN has reached or exceeded 100(N+1) for IOPT=1 or 200(N+1) for IOPT=2.
					INFO =  3  TOL is too small.  No further improvement in the approximate solution X is possible.
					INFO =  4  Iteration is not making good progress.
		 ENDIF
 DUM   : OUT, DOUBLE( (N2+13N)/2 )
         work array of length LDUM = 20 + (N2+13N)/2
 LDUM  : IN, INTEGER
         Provided length of the work array DUM. LDUM must not be less than 20 + (N2+13N)/2.
 IDUM  : IN, INTEGER
         work array of length 20.
 EPSFCN: IN, DOUBLE
         Used in determining a suitable step for the forward-difference approximation. This approximation assumes that the relative errors in the functions are of the order of epsfcn. If epsfcn  is less than the machine precision, it is assumed that the relative errors in the functions are of the order of the  machine precision. If iopt=1, then epsfcn can be ignored (treat it as a dummy argument).
*/

"FORTRAN" FUNCTION NO_TYPE EcoNonLinearEqnSolver (     
    OUT INTEGER ILAST,
    IN INTEGER IOPT,
    IN INTEGER N,
    OUT REAL X[],
    OUT REAL FVEC[],
    OUT REAL FJAC[],
    IN REAL tol,
    OUT INTEGER INFO,
    IN REAL DUM[],
    IN INTEGER LDUM,
    IN INTEGER IDUM[],
    IN REAL EPSFCN) IN "MATH.lib"

"FORTRAN" FUNCTION NO_TYPE EcoMachDep ()           IN "MATH.lib"
			  
--------------------------------------------------------------------------------
--	Function calculating the transfer function by FFT
--
--   *****************************************************************
--   * inputs:                                                       *
--   *     iff= Type of spectral treatment desired :              *
--   *           iff=1  Fourier transform. in amplitude              *
--   *           iff=2  Fourier transform. in phase                  *
--   *           iff=3  Fourier transform. en spectral density       *
--   *           iff=4  Transfer function in amplitude               *
--   *           iff=5  Transfer function in phase                   *
--   *     time= simulation time                                     *
--   *     np = num. of points for arrays pxnfft,pynfft              *
--   *     px = array values for x for evenly spaced times.          *
--   *     py = array values for y for evenly spaced times.          *
--   * outputs                                                       *
--   *     lnp=number of frecuencies after transformation            *
--   *     xfft=frecuencies array de frecuencias                     *
--   *     yfft=output array (y/x if iff>3) frecuency function       *
--   *****************************************************************
-- First version function (not fully tested)
"FORTRAN" FUNCTION NO_TYPE treatfft(
	INTEGER iff, REAL time, INTEGER np, REAL px[],REAL py[], REAL fr1, REAL fr2, 
	OUT INTEGER lnp, OUT REAL xfft[], OUT REAL yfft[])             IN "MATH.lib"


COMPONENT testFFT 
   PORTS

   DATA  
		REAL f  = 10
		REAL phase = 10
		REAL m = 1
		REAL K_spr= 1
      REAL cv   = 1.0    "Viscous friction coeffient(N/m*s)"
		REAL for= 1

   DECLS
		REAL x,y,z

   INIT
   DISCRETE

   CONTINUOUS
		
		y = 1 + sin(2*PI*f*TIME+phase/180*PI) -- + sin(4*PI*f*TIME)
		m*z'' = -K_spr*z - cv*z' + for*x

END COMPONENT

/* For previous component the next experiment was developed for calculating the transfer function by FFT.
   This experiment must be taken as a template to perform this kind of calculations.
	
EXPERIMENT exp1 ON testFFT.default
   DECLS
		INTEGER ic, lnp, np_fft
		REAL To = 1
		REAL px[2048], py[2048], pz[2048], xfft[1024], yfft_amy[1024], yfft_amz[1024], yfft_phy[1024]
   OBJECTS
   INIT
      -- initial values for state variables
      y = 1
      z = 1
      z' = 0

   BOUNDS
		x = step(TIME,To)*(TIME-To)

   BODY
      f  = 3
		for = 10
		cv = 0.01
		K_spr = 100
		fase = 10


      -- set the debug level (valid range [0,4])
      DEBUG_LEVEL= 1   
      -- select default integration solver. Valid methods are IDAS (_SPARSE), DASSL(_SPARSE), , CVODE_AM, RK4, EULER, AM1, AM2 and AM4
      IMETHOD= CVODE_BDF_SPARSE -- default is DASSL
      -- Settings for different actions. Valid actions are: SEV_DISABLE, SEV_NONE, SEV_WARNING, SEV_ERROR, SEV_KILLPOINT, SEV_FATAL
      eSetErrorAction(ERR_BAD_OPER,SEV_KILLPOINT) -- Detect bad numerical operations (eg division by zero), default is SEV_NONE, recommended is SEV_KILLPOINT
      eSetErrorAction(ERR_NAN_INF, SEV_KILLPOINT) -- Detect NaN or Inf values, default is SEV_NONE, recommended is SEV_KILLPOINT
      eSetConfig(CFG_FORCE_STOP_CINT,TRUE) -- Force or not to stop the solver each CINT. Sometimes you can speed up the simulation if you select FALSE
      -- set tolerances and other important inputs
      REL_ERROR = 1e-06 -- transient solver relative tolerance
      ABS_ERROR = 1e-06 -- transient solver absolute tolerance
      TOLERANCE = 1e-06 -- steady solver relative tolerance
      INIT_INTEG_STEP = -1 -- initial integration step size (-1 means use the solver estimation) 
      MAX_INTEG_STEP = -1 -- maximum integration step size (-1 means use the solver estimation) 
      NSTEPS = 1 -- Only for explicit solvers use CINT/NSTEPS as integration step size
      REPORT_MODE = IS_STEP -- by default it reports results at every CINT and event detection. Other valid options are IS_STEP, IS_CINT and IS_MANUAL_REFRESH 

      TIME = 0
      TSTOP = To
      CINT = 1
--		setSilentMode(TRUE)		
      INTEG()
--		setSilentMode(FALSE)		

      TSTOP = To + 5
		-- determinacion del paso de tiempo para FFT
		np_fft = 2**11
      CINT = (TSTOP-TIME)/(np_fft-1)
		EXEC_INIT()  -- solo necesario si no hay un INTEG previo

		ic = 1
		px[ic] = x
		py[ic] = y
		pz[ic] = z
		WHILE(INTEG_CINT() != INTEG_END)
			ic = ic + 1
			px[ic] = x
			py[ic] = y
			pz[ic] = z
--WRITEF("timeHistory.rpt","\n%g\t%g\t%g\t%g\t",TIME,px[ic],py[ic],pz[ic])
		END WHILE
		ic = ic + 1
		px[ic] = x
		py[ic] = y
		pz[ic] = z
--WRITEF("timeHistory.rpt","\n%g\t%g\t%g\t%g\t",TIME,px[ic],py[ic],pz[ic])
		ASSERT(ic == np_fft) FATAL ("ERROR: no. de pasos de INTEG_CINT mal calculado")

		-- Function calculating the transfer function by FFT
		treatfft(4,TIME-To, ic, px,py, 0,50., lnp, xfft,yfft_amy)
		treatfft(5,TIME-To, ic, px,py, 0,50., lnp, xfft,yfft_phy)
		treatfft(4,TIME-To, ic, px,pz, 0,50., lnp, xfft,yfft_amz)

		REPORT_REFRESH()
*/