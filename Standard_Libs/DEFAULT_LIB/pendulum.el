--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: pendulum.el
-- DESCRIPTION: Defines "pendulum" component example
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/03/1999
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- Pendulum example: Simulation of a pendulum oscilation using cartesian
-- coordinates
--------------------------------------------------------------------------------
COMPONENT pendulum
   "Pendulum example"

   DATA
      REAL g = 9.806               UNITS u_m_s2		"Gravity"
      REAL L = 1.                  UNITS u_m			"Pendulum longitude"
      REAL M = 1.                  UNITS u_kg		"Pendulum mass"

   DECLS
      REAL x                       UNITS u_m			"Pendulum X position"
      REAL y                       UNITS u_m			"Pendulum Y position"
      REAL T                       UNITS u_N			"Pendulum wire tension force"

   CONTINUOUS
      x**2 + y**2 = L**2
      M * x'' = - T * (x / L)
      M * y'' = - T * (y / L) - M * g

END COMPONENT
