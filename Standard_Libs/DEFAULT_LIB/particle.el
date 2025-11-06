--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: particle.el
-- DESCRIPTION: Defines "particle" component example
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/03/1999
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- Particle example: Movement of a particle of which the position as a function
-- of time is known
--------------------------------------------------------------------------------
COMPONENT particle
   "Particle example"

   DATA
      REAL m = 1.                 UNITS u_kg			"Mass"

   DECLS
      REAL F                      UNITS u_N			"Applied force"
      REAL x                      UNITS u_m			"Position "

   CONTINUOUS
      -- Newton's law
      F = m * x''

      -- Position as a function of time
      x = sin(TIME)

END COMPONENT
