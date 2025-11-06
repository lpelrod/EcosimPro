--------------------------------------------------------------------------------
-- EA Internacional 2004   EcosimPro 3.3 Simulation Source Code
--
--    FILE NAME:  MATH_Common.el
--    FILE TYPE:  Common elements of the MATH library
--    DESCRIPTION:  Defines common constants for the MATH library
--    NOTES:  Based on EcosimPro MATH library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  12-Jan-2004
--------------------------------------------------------------------------------

-- Constants
CONST REAL ZERO = 0.                                       "Zero value"

CONST REAL Eps = 1.e-8                                     " "
CONST REAL Inf = 1.e38                                     " "

CONST REAL Small = 1.e-16                                  " "

CONST INTEGER Inf_int = 2147483647                         " "

--------------------------------------------------------------------------------
-- Mathematical and cientific constants
--------------------------------------------------------------------------------
CONST REAL E =     2.7182818284590452353602874713527       "Natural logarithmic base"
CONST REAL GAMMA = 0.5772156649015328606065120900824       "Euler's Constant"
CONST REAL PI =    3.1415926535897932384626433832795       "PI, Archimedes' number"



--------------------------------------------------------------------------------
-- Units conversion constants
--------------------------------------------------------------------------------
CONST REAL DtoR = PI / 180.       	"Degree to radian"
CONST REAL RtoD = 180. / PI       	"Radian to degrees"
CONST REAL D2R = PI / 180.       	"Degree to radian"
CONST REAL R2D = 180./ PI       		"Radian to degrees"
CONST REAL in2cm = 2.54					"In to centimetre"
CONST REAL cm2in = 1/in2cm				"Centimetre to inch"
CONST REAL m2ft = 3.28084    			"Metre to foot"
CONST REAL ft2m = 1/m2ft				"Foot to metre"
CONST REAL kg2lb = 2.20462    		"Kilogram to pound"
CONST REAL lb2kg = 1/kg2lb 			"Pound to kilogram"
CONST REAL	bar2Pa = 1e5				"Bar to pascal"
CONST REAL Pa2bar = 1/bar2Pa			"Pascal to bar"
CONST REAL atm2bar = 1.01325 			"Atmosphere to bar"
CONST REAL bar2atm = 1/atm2bar		"Bar to atmosphere"
CONST REAL atm2Pa = 101325				"Atmosphere to pascal"
CONST REAL Pa2atm = 1/atm2Pa			"Pascal to atmosphere"
CONST REAL Wh2J = 3600					"Watts-hour to Joule"
CONST REAL J2Wh = 1/Wh2J				"Joule to Watts-hour"
--------------------------------------------------------------------------------
-- Thermal Global Variables
--------------------------------------------------------------------------------
CONST REAL STEFAN = 5.6696e-8 UNITS 				"W/m^2*K^4"	"Stefan constant"
CONST REAL TZERO  = 273.15    UNITS u_K			"Celsius scale shift with respect to Kelvin scale"
CONST REAL TMAX   = 1.e5      UNITS u_K			"Maximum Temperature to report a warning"


