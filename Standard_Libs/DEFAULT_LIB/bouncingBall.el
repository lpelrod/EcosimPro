--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: bouncingBall.el
-- DESCRIPTION: Defines "bouncingBall" component example
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/03/1999
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- Bouncing ball example: Simulation of a rubber ball which, dropped from a
-- certain height, bounces successively on the ground until it stops (used for
-- WHEN statement demonstration)
--------------------------------------------------------------------------------
COMPONENT bouncingBall
   "Bouncing ball example (used for WHEN statement demonstration)"

   DATA
      REAL g = 9.80665            UNITS u_m_s2		"Gravity"
      REAL k = 0.8                UNITS no_units	"Restitution coefficient"

   DECLS
      REAL h = 10.                UNITS u_m			"Height"

   DISCRETE
      -- Event when bouncing on the ground
      WHEN (h < 0) THEN
         h' = -k * h'
      END WHEN

      -- Event to detect stopping the simulation
      WHEN (h < -.003) THEN
         PRINT("****** End of simulation: height < -0.003")
         TSTOP = TIME
      END WHEN

   CONTINUOUS
      h'' = -g

END COMPONENT
