--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: lorentz.el
-- DESCRIPTION: Defines "lorentz" component example
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/03/1999
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- Lorentz's system of equations example: This component simulates Lorentz's
-- system of equations, which solution is always rounding two space points,
-- never reaching them
--------------------------------------------------------------------------------
COMPONENT lorentz
   "Example to solve the Lorentz's system of equations"

   DATA
      REAL alfa = 10.             UNITS no_units	"'Alpha' parameter "
      REAL b = 8./3.              UNITS no_units	"'b' parameter"
      REAL r = 28.                UNITS no_units	"'r' parameter"

   DECLS
      REAL y1 = 0.                UNITS no_units	"Variable"
      REAL y2 = 1.                UNITS no_units	"Variable"
      REAL y3 = 0.                UNITS no_units	"Variable"

   CONTINUOUS
      y1' = alfa * (y2 - y1)
      y2' = r * y1 - y2 - y1 * y3
      y3' = y1 * y2 - b * y3

END COMPONENT
