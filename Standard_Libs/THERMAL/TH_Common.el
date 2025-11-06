--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_Common.el
--		FILE TYPE:		Common Elements of the THERMAL library
--		DESCRIPTION:	Defines common constants, functions, thermal port and
--							abstract components for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------
-- Libraries
USE MATH VERSION "3.1"


-- Globals

BOUND REAL SOLAR_CONSTANT = 1410.   		UNITS u_W_m2		"Solar power received at earth orbit"
BOUND REAL Orbit_Period = 2. * 3600.   	UNITS u_s		"Orbit period to determine cyclic temperature dynamics in nodes"

BOOLEAN PRINT_TEMP = FALSE             "Flag for print name label and temperature of nodes"


-- Functions
--------------------------------------------------------------------------------
-- Function Bmax
--------------------------------------------------------------------------------
-- Purpose:
--    Calculate the maximum between two variables and return the value on the
--    first one.
--------------------------------------------------------------------------------
FUNCTION REAL Bmax
   (
       OUT REAL xmax,
       IN REAL x
   )
   "Function to calculate the maximum between two variables and return the value on the first one"
   BODY
       xmax = max(xmax, x)
       RETURN 0.
END FUNCTION

--------------------------------------------------------------------------------
-- Function Bmin
--------------------------------------------------------------------------------
-- Purpose:
--    Calculate the minimum between two variables and return the value on the
--    first one.
--------------------------------------------------------------------------------
FUNCTION REAL Bmin
   (
       OUT REAL xmin,
       IN REAL x
   )
	"Function to calculate the minimum between two variables and return the value on the first one."
   BODY
       xmin = min(xmin, x)
       RETURN 0.

END FUNCTION





