--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: zoneExample.el
-- DESCRIPTION: Defines "zoneExample" component example
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/03/1999
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- Zone example: Component to maintain a delayed variable within a minimum and
-- a maximum limits (used for ZONE statement demonstration)
--------------------------------------------------------------------------------
COMPONENT zoneExample
   "Zone example (used for ZONE statement demonstration)"

   DATA
      REAL ymax = 0.8             UNITS no_units 	"Maximum value"
      REAL ymin = -0.5            UNITS no_units 	"Minimum value"
      REAL tau = 0.01             UNITS u_s 			"Characteristic delay time"

   DECLS
      REAL dy                     UNITS u_Hz			"Finite differences derivative"
      REAL x                      UNITS no_units	"Main variable"
      REAL y                      UNITS no_units	"Limited and delayed variable"

   CONTINUOUS
      dy = (x - y) / tau

      y' = ZONE ((y > ymax) AND (dy > 0)) 0.
           ZONE ((y < ymin) AND (dy < 0)) 0.
           OTHERS                         dy

END COMPONENT
