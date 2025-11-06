--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: equation.el
-- DESCRIPTION: Defines "equation" component example
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/03/1999
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- First order delay equation example: Component to solve a differential
-- equation which is used to introduce a first order delay to a variable
--------------------------------------------------------------------------------
COMPONENT equation
   "Example to solve a differential equation"

   DATA
      REAL tau = 0.6              UNITS u_s			"Delay time"

   DECLS
      REAL x                      UNITS no_units	"Main variable"
      REAL y                      UNITS no_units	"Delayed variable"

   CONTINUOUS
      -- Differential equation to introduce a delay to "x" variable
      y' = (x - y) / tau

END COMPONENT
