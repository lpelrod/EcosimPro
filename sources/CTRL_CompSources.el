--------------------------------------------------------------------------------
-- EA Internacional 2005   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompSources.el
--    FILE TYPE:  Components of the CONTROL library
--    DESCRIPTION:  Defines sources components for the CONTROL library
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  Ramon Perez Vara & Borja Garcia Gutierrez
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
USE MATH 
USE PORTS_LIB 

-- Components
--------------------------------------------------------------------------------
-- Component Clock
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a single output component to obtain the simulation time.
--------------------------------------------------------------------------------
COMPONENT Clock IS_A MO "Generates output signals equal to the simulation model time plus an offset"
   DATA
	REAL Offset = 0		UNITS no_units	"Offset of output signal"

   CONTINUOUS
      EXPAND (i IN 1, n_out)
         s_out.signal[i] = TIME + Offset

END COMPONENT 

--------------------------------------------------------------------------------
-- Component RandomSource
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a component generating random numbers following various
--    probability distrributions, depending on the value of variable "random".
--
-- Modes:
--    Uniform:      p(x) = 1 / (b - a)   when   (a < x < b)
-- 			                      0           otherwise
-- 
--    Binomial:     Pnp(j) = (n over j) * p**j * (1 - p)**(n - j)
--
--    Exponential:  p(x) = exp(-lambda * x)
--
--    Gamma:        p(x) = x**(a - 1) * exp(-x) / gamma(a)
--
--    Gaussian:     p(x) = 1 / sqrt(2 * PI * sigma) * exp(- ((x - mu) / sigma)**2)
--
--    Poisson:      Px(j) = x**j * exp(-x) / j!
--
-- Notes:
--    Random functions need two arrays (one of integer parameters and other of
--    real parameters). This arrays are over dimensioned, and their function is:
--
--    i_array[15]: Components 1 to 5 are needed by uniform random number
--       generator function and represent the modules and two flags which tell
--       wether the function is called the first time or it has been already
--       called. Components 6 to 10 represent integer parameters of the
--       distribution, such as, for example, the number of tries "n" on Binomial
--       distribution. Components 11 to 15 are flags. This flags may save values
--       obtained from integer parameters of the last call, such as old value
--       of "n" on binomial distribution, or simple flags.
--
--    i_array[11]: On gaussian case, which indicates wheter is neccessary to
--       calculate or not.
--
--    r_array[150]: Components 1 to 98 are needed by uniform random number
--       generator function to save the history of the generation. Components
--       99 to 100 are not used. Components 101 to 120 represent real
--       parameters, such as the probability of success "p" on binomial
--       distribution. Components 121 to 150 are flags saving some values
--       obtained from parameters, such as the old value of "p" (r_array[121])
--       on binomial distribution.
--------------------------------------------------------------------------------
COMPONENT RandomSource IS_A SO
   (
   ENUM RandomOption random = Uniform	"Probability distrribution",
   INTEGER iseed = 1200				UNITS no_units	"Integer seed"
   )
"Defines a component generating random numbers following various probability distributions"
   DATA
      REAL dt = 0.1              UNITS u_s	"Time between samples"

         -- Uniform case
      REAL a = 0.                UNITS no_units "Lower limit of interval on uniform distribution"
      REAL b = 1.                UNITS no_units "Higher limit of interval on uniform distribution"

         -- Binomial caser
      INTEGER n = 10             UNITS no_units "Number of tries on binomial distribution"
      REAL p = 0.5               UNITS no_units "Success probability on binomial distribution"

         -- Exponential case
      REAL lambda = 1.           UNITS no_units "Mean of exponential distribution"

         -- Gamma case
      INTEGER order = 3          UNITS no_units "Order of gamma distribution"

         -- Gaussian case
      REAL mu = 0.               UNITS no_units "Mean of gaussian distribution"
      REAL sigma = 1.            UNITS no_units "Typical deviation of gaussian distribution"

         -- Poisson case
      REAL xm = 1.               UNITS no_units "Mean of Poisson distribution"

   DECLS

      BOOLEAN Sample = TRUE       "Sampler (TRUE/FALSE)"

      INTEGER i_array[15]        UNITS no_units "Auxiliar array of integers"

      DISCR REAL r_array[150]    UNITS no_units "Auxiliar array"

      DISCR REAL x               UNITS no_units "Random numbers"

   INIT
         -- Initializes sampling
      Sample = TRUE

         -- These flags are always needed
      i_array[4] = iseed
      i_array[5] = 0

         -- Initializes neccessary parameters or flags
      IF (random == Gaussian) THEN
         i_array[11] = 0
      ELSEIF (random == Gamma) THEN
         i_array[6] = order
      ELSEIF (random == Poisson) THEN
         r_array[101] = xm
         r_array[121] = -1.
      ELSEIF (random == Binomial) THEN
         i_array[6] = n
         i_array[11] = -1
         r_array[101] = p
         r_array[121] = -1.
      END IF

   DISCRETE
      WHEN (Sample == TRUE) THEN
         Sample = FALSE

         Sample = TRUE AFTER dt

         IF (random == Uniform) THEN
            x = ran1(i_array, r_array)
         ELSEIF (random == Binomial) THEN
            x = bnldev(i_array, r_array)
         ELSEIF (random == Exponential) THEN
            x = expdev(i_array, r_array)
         ELSEIF (random == Gamma) THEN
            x = gamdev(i_array, r_array)
         ELSEIF (random == Gaussian) THEN
            x = gasdev(i_array, r_array)
         ELSEIF (random == Poisson) THEN
            x = poidev(i_array, r_array)
         END IF

      END WHEN

   CONTINUOUS

      EXPAND (random == Uniform)
         s_out.signal[1] = a + (b - a) * x

      EXPAND ((random == Binomial) OR (random == Gamma) OR (random == Poisson))
         s_out.signal[1] = x

      EXPAND (random == Exponential)
         s_out.signal[1] = x / lambda

      EXPAND (random == Gaussian)
         s_out.signal[1] = mu + sigma * x

END COMPONENT


--------------------------------------------------------------------------------
-- Component AnalogSource
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a component generating diferent standard sources depending on the
--    value of variable "source".
--------------------------------------------------------------------------------
COMPONENT AnalogSource IS_A MO \
"Signal generator producing different waveforms"
   DATA
	ENUM SourceOption source = Source_Constant	"Waveform"
   REAL Amp = 1.		UNITS no_units				"Signal amplitude or height"
	REAL Tstart = 0		UNITS u_s					"Starting time of signal generation"
	REAL Offset = 0		UNITS no_units				"Offset of output signal"

	   -- Sine Source
	REAL Phase = 0			UNITS u_rad					"Phase of sine source"

	   -- Sine, Pulse, SawTooth or Square Source
	REAL Period = 10		UNITS u_s					"Period of sine, pulse, sawtooth, or square source"
	
         -- Pulse Source
      REAL pulseWidth = 0.001		UNITS u_s		"Pulse width of pulse wave"

	   -- Ramp Source
	REAL rampDuration = 10	UNITS u_s				"Duration of the ramp"
	

         -- Table waves
	ENUM tableMethod tabmethod = LinearInterpWithEvents	"Method to interpolate or connect the table points"
      TABLE_1D timeTable = {
                             {0., 10.},
                             {0.,  0.}
                            }	UNITS no_units "Table for table source"
	DECLS                            
		REAL signal				"Signal wave form"

   CONTINUOUS

	EXPAND_BLOCK(i IN 1, n_out)
	   s_out.signal[i] =	ZONE (TIME < Tstart) Offset                                  
								OTHERS signal
--		s_out.signal[i] =	( 1 - step(TIME, Tstart)) * Offset + step(TIME, Tstart) * signal
	END EXPAND_BLOCK
	
      signal = IF (source == Source_Constant)
					   Amp  + Offset
					ELSEIF (source == Source_Sine)
					   Amp * sin(2 * PI /Period * (TIME - Tstart) + Phase) + Offset

					ELSEIF (source == Source_Pulse)
					   Amp * pulse(TIME-Tstart, Period, pulseWidth) + Offset

					ELSEIF (source == Source_Step)
					   Amp * step(TIME, Tstart) + Offset

					ELSEIF (source == Source_SawTooth)
					   Amp * ramp(TIME-Tstart, Period) / Period + Offset     
         
					ELSEIF  (source == Source_Square)
					   Amp * square(TIME-Tstart, Period)  + Offset

					ELSEIF (source == Source_Ramp)
					   Amp / rampDuration * (TIME - Tstart) *\
					    (1- step(TIME, Tstart + rampDuration)) \
					   + Amp * step(TIME, Tstart + rampDuration) + Offset
	
					ELSEIF (source == Source_Table AND tabmethod == LinearInterpWithEvents)
					   Amp * timeTableInterp(TIME-Tstart, timeTable) + Offset

					ELSEIF (source == Source_Table AND tabmethod == LinearInterpWithoutEvents)
					   Amp * linearInterp1D (timeTable, TIME-Tstart) + Offset

					ELSEIF (source == Source_Table AND tabmethod == SplineInterp)
					   Amp * splineInterp1D (timeTable, TIME-Tstart) + Offset

					ELSEIF (source == Source_Table AND tabmethod == StepConnect)
					   Amp * timeTableStep(TIME-Tstart, timeTable) + Offset

					ELSE
					   0.0


 
END COMPONENT


--------------------------------------------------------------------------------
-- Component SourceChirp
--------------------------------------------------------------------------------
-- Purpose:
--    Generate a sine wave with increasing frequency
--------------------------------------------------------------------------------
COMPONENT SourceChirp IS_A MO "Generate a sine wave with increasing frequency"

   DATA
      REAL Amp = 1.			UNITS no_units	"Signal amplitude"
      REAL frec_o = 0.1		UNITS u_Hz		"Initial signal frecuency"
	REAL Phase = 0				UNITS u_rad		"Signal phase"
	REAL Tstart = 0			UNITS u_s		"Starting time of signal generation"
	REAL Offset = 0			UNITS no_units	"Offset of output signal"
	REAL frec_slope = 0.1	UNITS u_1_s2	"Frecuency linear rate with time"
   DECLS
	REAL frec					UNITS u_Hz		"Signal frecuency"

   INIT
	frec = frec_o

   CONTINUOUS

	frec' = ZONE(TIME < Tstart) 0.0
		  OTHERS frec_slope

	EXPAND(i IN 1, n_out)		
		s_out.signal[i] - Offset = ZONE(TIME < Tstart) 0.0
						   OTHERS Amp * sin(2 * MATH.PI * frec * (TIME - Tstart) + Phase)

END COMPONENT


--------------------------------------------------------------------------------
-- Component SourceExpSine
--------------------------------------------------------------------------------
-- Purpose:
--    Generate a sine wave with increasing frequency
--------------------------------------------------------------------------------

COMPONENT SourceExpSine IS_A MO "Generate a sine wave with increasing frequency"
   DATA
      REAL Amp = 1.						UNITS no_units	"Signal amplitude"
      REAL frec = 1./(2.*MATH.PI)	UNITS u_Hz		"Signal frecuency"
	REAL Phase = 0							UNITS u_rad		"Signal phase"
	REAL Damping = 1						UNITS "1/s"		"Damping coefficients of sine waves"
	REAL Tstart = 0						UNITS u_s		"Starting time of signal generation"
	REAL Offset = 0						UNITS no_units	"Offset of output signal"

   CONTINUOUS
	EXPAND(i IN 1, n_out)
		s_out.signal[i] - Offset = ZONE(TIME < Tstart) 0.0
						   OTHERS Amp * exp(-(TIME-Tstart)*Damping) \
							    *sin(2 * MATH.PI * frec * (TIME - Tstart) + Phase)

END COMPONENT



--------------------------------------------------------------------------------
-- Component SourceExp
--------------------------------------------------------------------------------
-- Purpose:
--    Generate a rising and falling exponential signal
--------------------------------------------------------------------------------

COMPONENT SourceExp IS_A MO "Generate a rising and falling exponential signal"
   DATA
      REAL outMax = 1.			UNITS no_units	"Height of output for infinite riseTime"
      REAL riseTime = 	0.5	UNITS u_s		"Rise Time"
	REAL riseTimeConst = 0.1	UNITS u_s		"Rise time constant"
	REAL fallTimeConst = 0.1	UNITS u_s		"Fall time constant"
	REAL Tstart = 0.5				UNITS u_s		"Starting time of signal generation"
	REAL Offset = 0				UNITS no_units	"Offset of output signal"
   DECLS
	REAL y_riseTime

   CONTINUOUS
	y_riseTime = outMax * (1 - exp(-riseTime/riseTimeConst))

	EXPAND_BLOCK(i IN 1, n_out)

		s_out.signal[i] - Offset = ZONE(TIME < Tstart) 0.0
							ZONE(TIME < Tstart + riseTime) outMax * (1 - exp(-(TIME- Tstart)/riseTimeConst))
							OTHERS y_riseTime * exp(-(TIME- Tstart-riseTime)/fallTimeConst)
	END EXPAND_BLOCK


END COMPONENT

--------------------------------------------------------------------------------
-- Component SourcebConstant
--------------------------------------------------------------------------------
-- Purpose:
--    Generate a constant signal of type BOOLEAN
--------------------------------------------------------------------------------

COMPONENT SourcebConstant IS_A bMO "Generate a constant signal of type BOOLEAN"
   DATA
	BOOLEAN k = TRUE		UNITS no_units	"Constant output Boolean value"
	
   INIT
	FOR(i IN 1, n_out)
	   s_out.signal[i] = k
	END FOR
   DISCRETE
	   WHEN(k == TRUE) THEN
		FOR(i IN 1, n_out) 
		   s_out.signal[i] = TRUE
		END FOR
	   END WHEN

	   WHEN(k == FALSE) THEN
		FOR(i IN 1, n_out) 
		   s_out.signal[i] = FALSE
		END FOR
	   END WHEN

   CONTINUOUS

END COMPONENT


--------------------------------------------------------------------------------
-- Component SourcebStep
--------------------------------------------------------------------------------
-- Purpose:
--    Generate step signal of type BOOLEAN
--------------------------------------------------------------------------------

COMPONENT SourcebStep IS_A bMO "Generate step signal of type BOOLEAN"
   DATA
	REAL Tstart = 0		UNITS u_s	"Starting time of signal generation"
   INIT
	FOR(i IN 1, n_out)
		s_out.signal[i] = FALSE
	END FOR

   DISCRETE

	WHEN(TIME > Tstart) THEN 
	   FOR(i IN 1, n_out)
		s_out.signal[i] = TRUE
	   END FOR
	END WHEN

END COMPONENT


--------------------------------------------------------------------------------
-- Component SourcebPulse
--------------------------------------------------------------------------------
-- Purpose:
--    Generate pulse signal of type BOOLEAN
--------------------------------------------------------------------------------

COMPONENT SourcebPulse IS_A bMO "Generate pulse signal of type BOOLEAN"
   DATA
	REAL Period = 10			UNITS u_s	"Period of pulse"
      REAL pulseWidth = 5	UNITS u_s	"Pulse width"
	REAL Tstart = 5			UNITS u_s	"Starting time of signal generation"
   DECLS
	BOOLEAN State				UNITS no_units	"Auxiliar Boolean variable"
   INIT
	State = FALSE
	FOR(i IN 1, n_out)
		s_out.signal[i] = FALSE
	END FOR

   DISCRETE

	WHEN(TIME > Tstart) THEN
	   State = TRUE
	   FOR(i IN 1, n_out)
		s_out.signal[i] = TRUE
	   END FOR
	END WHEN

	WHEN(State) THEN
	   State = FALSE AFTER pulseWidth
	   FOR(i IN 1, n_out)
		s_out.signal[i] = FALSE AFTER pulseWidth
	   END FOR
	END WHEN

	WHEN(State==FALSE AND TIME > Tstart) THEN
	   State = TRUE AFTER (Period - pulseWidth)
	   FOR(i IN 1, n_out)
		s_out.signal[i] = TRUE AFTER (Period - pulseWidth)
	   END FOR
	END WHEN


END COMPONENT


--------------------------------------------------------------------------------
-- Component SourceSampleTrigger
--------------------------------------------------------------------------------
-- Purpose:
--    Generate sample trigger of BOOLEAN type
--------------------------------------------------------------------------------
COMPONENT SourcebSampleTrigger IS_A bMO "Generate sample trigger of BOOLEAN type"
   DATA
	REAL Period = 2		UNITS u_s	"Period of sample"
	REAL Tstart = 1		UNITS u_s	"Starting time of signal generation"
   DECLS
	BOOLEAN state							"Boolean state TRUE or FALSE"
   INIT
	FOR(i IN 1, n_out)
		s_out.signal[i] = FALSE
	END FOR


   DISCRETE

	WHEN(state) THEN
	   FOR(i IN 1, n_out)
		s_out.signal[i] = TRUE 
	   END FOR
	END WHEN

	WHEN(NOT state) THEN
	   FOR(i IN 1, n_out)
		s_out.signal[i]= FALSE AFTER 1e-6
	   END FOR
	END WHEN

	WHEN(TIME >= Tstart) THEN
	   state = TRUE
	END WHEN
	

	WHEN (state == TRUE) THEN     
	   state = FALSE AFTER 0
	   state = TRUE AFTER Period
	END WHEN 

END COMPONENT


--------------------------------------------------------------------------------
-- Component SourceDataFile
--------------------------------------------------------------------------------
-- Purpose:
--    To generate an analog signal interpolating in a table that is read 
--    from a ASCII file specified by the user
--------------------------------------------------------------------------------
COMPONENT SourceDataFile IS_A SO "To generate an analog signal interpolated in a table read from a ASCII file specified by the user"
   DATA
	ENUM tableMethod tabmethod = LinearInterpWithEvents	"Method to interpolate or connect the table points"
	INTEGER nt = 1		UNITS no_units	"Number of the column of time data in the file"
	INTEGER ny = 2		UNITS no_units	"Number of the column of the independant variable in the file"
	FILEPATH filename		"Pathname of the ASCII file, for example: C:\\DataFiles\\myTable.txt"

   DECLS
      TABLE_1D timeTable	"Name of the table to be filled in"

   INIT

	readTableCols1D(filename ,nt, ny, timeTable)

   CONTINUOUS


	EXPAND_BLOCK(i IN 1, n_out)
	   s_out.signal[i] =	ZONE (tabmethod == LinearInterpWithEvents)
					timeTableInterp(TIME, timeTable)

					ZONE (tabmethod == LinearInterpWithoutEvents)
					linearInterp1D (timeTable, TIME)

					ZONE (tabmethod == SplineInterp)
					splineInterp1D (timeTable, TIME)

					OTHERS
					timeTableStep(TIME, timeTable)
										
	END EXPAND_BLOCK


END COMPONENT

--------------------------------------------------------------------------------
-- Component Digital_ramp
--------------------------------------------------------------------------------
-- Purpose:
--    To represent a digital component that generates a ramp according to the 
-- ramp function defined in IEC 61131-3
--------------------------------------------------------------------------------

COMPONENT Digital_ramp "Digital ramp"
  
  PORTS
		IN analog_signal (n=1) RUN		"Signal of activation: 1 = TRUE, 0 = FALSE"
		IN analog_signal (n=1) X0		"Default value"
		IN analog_signal (n=1) X1		"Initial value"
		IN analog_signal (n=1) TR		"Ramp duration"
		IN analog_signal (n=1) CYCLE	"Sampling time"
		OUT analog_signal (n=1) XOUT	"Output signal"
		OUT bool_signal (n=1) BUSY		"Boolean to determine if the ramp is activated"
  
		
   DECLS
		 DISCR REAL XI			"Initial value"	
		 DISCR REAL T			"Time (s)"
		 DISCR REAL xout		"Output"
		 DISCR REAL Tstart		"Initial time (s)"

   INIT
		
		T = 0
		XI = X0.signal[1]	
		BUSY.signal[1]= FALSE
		Tstart = 0
 					 	
 	DISCRETE
 		
 	    WHEN(TIME-Tstart >= CYCLE.signal[1])THEN 
 	 			Tstart = TIME
     		IF (RUN.signal[1] == 1) THEN
         	BUSY.signal[1] = TRUE
         	IF (T >= TR.signal[1]) THEN
         		xout = X1.signal[1]
         	ELSE
           		xout = XI + (X1.signal[1] - XI)  * T/ TR.signal[1]
         		T = T + CYCLE.signal[1]
         	END IF
         ELSEIF (RUN.signal[1]==0) THEN
     			BUSY.signal[1] = FALSE
         	xout = X0.signal[1]
         	XI = X0.signal[1]
         	T = 0 	
         ELSE
         	ASSERT (FALSE) FATAL "RUN can only take values 0 and 1"
         END IF
        END WHEN	
     CONTINUOUS
     
     	xout = XOUT.signal[1] 
 	
END COMPONENT


