--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_Common.el
--    FILE TYPE:  Common elements of the library
--    DESCRIPTION:  Defines common enumerative types, ports and abstract components
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
USE MATH 
USE PORTS_LIB 

-- Global variables
BOOLEAN Clock_signal
-- Enumeratives
--------------------------------------------------------------------------------
-- State of the controller (ON/OFF)
--------------------------------------------------------------------------------
ENUM state_type = {OFF, ON}

--------------------------------------------------------------------------------
-- End position behaviour of PI and PID controller
--------------------------------------------------------------------------------
ENUM EndPosBehaviour = {end_I, end_PI}

--------------------------------------------------------------------------------
-- Enumerative modes for source components
--------------------------------------------------------------------------------
ENUM RandomOption = {Uniform, Binomial, Exponential, Gamma, Gaussian, Poisson}
ENUM SourceOption = {Source_Constant, Source_Sine, Source_Pulse, Source_Step, Source_SawTooth,
			    Source_Square, Source_Ramp, Source_Table}
--------------------------------------------------------------------------------
-- Enumerative modes for the method to interpolate or connect the table points
--------------------------------------------------------------------------------
ENUM tableMethod = {LinearInterpWithEvents, LinearInterpWithoutEvents, SplineInterp, StepConnect}

--------------------------------------------------------------------------------
-- Enumerative mode for relational operation
--------------------------------------------------------------------------------
ENUM RelationalOption = {Equal, NotEqual, GreaterThan, GreaterEqual, LessThan, LessEqual}

--------------------------------------------------------------------------------
-- Enumerative mode of the mathematical functions
--------------------------------------------------------------------------------
ENUM MathOption = {FunAbs, FunSign, FunSqrt, FunSin, FunCos, FunTan, 
			FunAsin, FunAcos, FunAtan, FunSinh, FunCosh, FunTanh, 
			FunExp, FunLog, FunLog10}

--------------------------------------------------------------------------------
-- Enumerative mode for initialise the discrete zero poles
-- component
--------------------------------------------------------------------------------
ENUM InitOption= {InitialStates, InitialOutput}

--------------------------------------------------------------------------------
-- Enumerative mode for discrete-time integration methods
--------------------------------------------------------------------------------
ENUM dIntegMethod = {ForwardEuler, BackwardEuler, Trapezoidal}

--------------------------------------------------------------------------------
-- Enumerative mode to indicate the operations to be performed on the inputs 
-- in the multi-addition component
--------------------------------------------------------------------------------
ENUM AddOperation = {Plus, Minus}
CONST REAL signValue[AddOperation] = {1, -1}
ENUM ProductOperation = {Multiplication, Division}

-- Abstract Components
--------------------------------------------------------------------------------
-- Component MO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with multiple
--    analog output signals.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT MO 
   (
   INTEGER n_out = 1            UNITS no_units	"Dimension of outputs"
   )"This abstract component is used for deriving components with only one multiple output analog port"

   PORTS
      OUT analog_signal (n = n_out) s_out		"Outlet signal "

END COMPONENT

--------------------------------------------------------------------------------
-- Component bMO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with multiple
--    boolean output signals.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT bMO
   (
   INTEGER n_out = 1            UNITS no_units	"Dimension of outputs "
   )
"This abstract component is used for deriving components with one multiple output Boolean port"
   PORTS
      OUT bool_signal (n = n_out) s_out	"Outlet signal"

END COMPONENT

--------------------------------------------------------------------------------
-- Component MIMO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with multiple
--    analog inputs and multiple analog outputs.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT MIMO \
   (
   INTEGER n_in = 1             UNITS no_units	"Dimension of inputs",
   INTEGER n_out = 1            UNITS no_units	"Dimension of outputs"
   )
"This abstract component is used for deriving components with one multiple input analog port and one multiple output analog port. The dimension of the input port signals can be different to the dimension of output port signals"

   PORTS
      IN  analog_signal (n = n_in)  s_in		"Inlet signal"
      OUT analog_signal (n = n_out) s_out		"Outlet signal"

   TOPOLOGY
      PATH s_in TO s_out

END COMPONENT

--------------------------------------------------------------------------------
-- Component bMIMO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with multiple
--    boolean inputs and multiple boolean outputs.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT bMIMO
   (
   INTEGER n_in = 1             UNITS no_units	"Dimension of inputs",
   INTEGER n_out = 1            UNITS no_units	"Dimension of outputs"
   )
"This abstract component is used for deriving components with one multiple input Boolean port and one multiple output Boolean port. The dimension of input port signals can be different to the dimension of output port signals"

   PORTS
      IN  bool_signal (n = n_in)  s_in      "Inlet signal"
      OUT bool_signal (n = n_out) s_out    "Outlet signal"

   TOPOLOGY
      PATH s_in TO s_out

END COMPONENT

--------------------------------------------------------------------------------
-- Component MIMOs
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with multiple
--    analog inputs and multiple analog outputs where the sizes of the input
--	and output array are identical
--------------------------------------------------------------------------------
ABSTRACT COMPONENT MIMOs \
   (
   INTEGER n = 1	          UNITS no_units	"Dimension of inputs and outputs"
   )
"This abstract component is used for deriving components with one multiple input analog port and one multiple output analog port. The dimension of the input port signals and the output port signals are the same"

   PORTS
      IN  analog_signal (n = n) s_in	"Inlet signal"
      OUT analog_signal (n = n) s_out	"Outlet signal"

   TOPOLOGY
      PATH s_in TO s_out

END COMPONENT

--------------------------------------------------------------------------------
-- Component bMIMOs
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with multiple
--    boolean inputs and multiple boolean outputs where the sizes of the input
--	and output array are identical
--------------------------------------------------------------------------------
ABSTRACT COMPONENT bMIMOs
   (
	INTEGER n = 1		UNITS no_units	"Dimension of inputs and outputs"
   )
"This abstract component is used for deriving components with one multiple input Boolean port and one multiple output Boolean port. The dimension of the input port signals and the output port signals are the same"
   PORTS
      IN  bool_signal (n = n) s_in		"Inlet signal"
      OUT bool_signal (n = n) s_out		"Outlet signal"

   TOPOLOGY
      PATH s_in TO s_out

END COMPONENT

----------------------------------------------------------------
-- Component MI2MOs
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with two multiple
--    analog inputs and a multiple analog outputs where the sizes of the input
--	and output arrays are identical
--------------------------------------------------------------------------------
ABSTRACT COMPONENT MI2MOs \
   (
   INTEGER n = 1	          UNITS no_units "Dimension of inputs and outputs"
   )
"This abstract component is used for deriving components with two multiple input analog ports and one multiple output analog port of the same dimension"

   PORTS
      IN  analog_signal (n = n) s_in_1	"Inlet signal"
      IN  analog_signal (n = n) s_in_2	"Inlet signal"
      OUT analog_signal (n = n) s_out	"Outlet signal"


END COMPONENT

----------------------------------------------------------------
-- Component bMI2MOs
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with two multiple
--    boolean inputs and a multiple boolean outputs where the sizes of the input
--	and output arrays are identical
--------------------------------------------------------------------------------
ABSTRACT COMPONENT bMI2MOs
   (
   INTEGER n = 1	          UNITS no_units "Dimension of inputs and outputs"
   )
"This abstract component is used for deriving components with two multiple input Boolean ports and one multiple output Boolean port. The inlet ports and the outlet ports have the same dimension"

   PORTS
      IN  bool_signal (n = n) s_in_1	"Inlet signal"
      IN  bool_signal (n = n) s_in_2	"Inlet signal"
      OUT bool_signal (n = n) s_out		"Outlet signal"


END COMPONENT

--------------------------------------------------------------------------------
-- Component SO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with one analog
--    output.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT SO IS_A MO \
"This abstract component is used for deriving components with only one single output analog port"
   DECLS
      CLOSE n_out = 1

END COMPONENT

--------------------------------------------------------------------------------
-- Component bSO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with one boolean
--    output.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT bSO IS_A bMO \
"This abstract component is used for deriving components with one single output Boolean port"
   DECLS
      CLOSE n_out = 1

END COMPONENT

--------------------------------------------------------------------------------
-- Component SISO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with one analog
--    input and one analog output.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT SISO IS_A MIMOs \
"This abstract component is used for deriving components with one single input analog port and one single output analog port"
   DECLS
      CLOSE n = 1

END COMPONENT

--------------------------------------------------------------------------------
-- Component bSISO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with one boolean
--    input and one boolean output.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT bSISO IS_A bMIMOs \
"This abstract component is used for deriving components with one single input Boolean port and one single output Boolean port"
   DECLS
      CLOSE n = 1

END COMPONENT

--------------------------------------------------------------------------------
-- Component SI2SO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with two analog
--    inputs and one analog output.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT SI2SO IS_A MI2MOs \
"This abstract component is used for deriving components with two single input analog ports and one single output analog port"
   DECLS
	CLOSE n = 1
END COMPONENT

--------------------------------------------------------------------------------
-- Component bSI2SO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with two boolean
--    inputs and one boolean output.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT bSI2SO IS_A bMI2MOs \
"This abstract component is used for deriving components with two single input Boolean ports and one single output Boolean port"
   DECLS
	CLOSE n = 1

END COMPONENT

--------------------------------------------------------------------------------
-- Component SI2bSO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a control component with two analog
--    inputs and one boolean output.
--------------------------------------------------------------------------------

ABSTRACT COMPONENT SI2bSO
  (
   INTEGER n = 1	     UNITS no_units 			"Dimension of inputs and outputs"
  )
"This abstract class is used for the definition of a control component with two single analog input ports and one single boolean output port"
   PORTS
      IN  analog_signal (n = n) s_in_1	"Inlet signal"
      IN  analog_signal (n = n) s_in_2	"Inlet signal"
      OUT bool_signal (n = n) s_out    	"Outlet signal"

   DECLS
	CLOSE n = 1

END COMPONENT


-----------------------------------------------------------
-- Defines an abstract component sampler.
-----------------------------------------------------------
ABSTRACT COMPONENT Sampler "This abstract component is used for deriving components that needs to sample the input signals"
   DATA
	REAL dt = 0.1			UNITS u_s "Sample time"

   DECLS
	BOOLEAN sample  = FALSE

   DISCRETE

	WHEN(TIME == 0) THEN
		sample = TRUE AFTER 0.
	END WHEN

	WHEN (sample == TRUE) THEN
	   sample = FALSE AFTER 0.
	   sample = TRUE AFTER dt
	END WHEN

END COMPONENT
--------------------------------------------------------------------------------
-- Component dMIMO
--------------------------------------------------------------------------------
-- Purpose:
--	An abstract class for definition of a discrete control component with multiple 
--	analog inputs and one multiple analog outputs. 
--	The signals are sampled due to a defined sample time
--------------------------------------------------------------------------------
ABSTRACT COMPONENT dMIMO IS_A Sampler
   (
	INTEGER n_in = 1	UNITS no_units	"Dimension of inputs",
	INTEGER n_out = 1	UNITS no_units	"Dimension of outputs"
   )
"This abstract component is used for deriving components with one multiple input analog port and one multiple output analog port. The input signals are sampled at each sample time period dt. The dimension of input port signals can be different to the dimension of output port signals"
   PORTS
      IN  analog_signal (n = n_in)  s_in	"Inlet signal"
      OUT analog_signal (n = n_out) s_out	"Outlet signal"

   TOPOLOGY
      PATH s_in TO s_out


END COMPONENT

--------------------------------------------------------------------------------
-- Component dMIMOs
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a discrete control component with multiple
--    analog inputs and multiple analog output where the sizes of the input
--	and output array are identical
--	The signals are sampled due to a defined sample time	
--------------------------------------------------------------------------------
ABSTRACT COMPONENT dMIMOs IS_A Sampler
   (
	INTEGER n = 1		UNITS no_units	"Dimension of inputs and outputs"
   )
"This abstract component is used for deriving components with one multiple input analog port and one multiple output analog port. The input signals are sampled at each sample time period dt. The dimension of input port signals and the dimension of output port signals are the same"
   PORTS
      IN  analog_signal (n = n) s_in	"Inlet signal"
      OUT analog_signal (n = n) s_out	"Outlet signal"

   TOPOLOGY
      PATH s_in TO s_out


END COMPONENT

--------------------------------------------------------------------------------
-- Component dSISO
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of a discrete control component with one analog
--    input and one analog output.
--	The signals are sampled due to a defined sample time	
--------------------------------------------------------------------------------
ABSTRACT COMPONENT dSISO IS_A dMIMOs \
"This abstract component is used for deriving components with one single input analog port and one single output analog port. The input signal is sampled at each sample time period dt"
   DECLS
      CLOSE n = 1

END COMPONENT



