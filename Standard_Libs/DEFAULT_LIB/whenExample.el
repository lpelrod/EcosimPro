--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: whenExample.el
-- DESCRIPTION: Defines "whenExample" component example
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/03/1999
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- WHEN use example: Component to simulate a basic behaviour of a heater (used
-- for WHEN statement demonstration)
--------------------------------------------------------------------------------
COMPONENT whenExample
   "Heater example (used for WHEN statement demonstration)"

   DATA
      REAL Tmin = 20.             UNITS u_C			"Minimum temperature"
      REAL Tmax = 50.             UNITS u_C			"Maximum temperature"

   DECLS
      BOOLEAN HeaterON            UNITS no_units	"Heater power ON flag"
      DISCR REAL HeaterPower      UNITS u_W		   "Heater power"
      REAL T = 10.                UNITS u_C			"System temperature"

   DISCRETE
      WHEN (T < Tmin) THEN
         HeaterON = TRUE
         HeaterPower = 50. AFTER 4.
      END WHEN

      WHEN (T > Tmax) THEN
         HeaterON = FALSE
         HeaterPower = 0.
      END WHEN

   CONTINUOUS
      T' = 0.1 * (HeaterPower - 10)

END COMPONENT
