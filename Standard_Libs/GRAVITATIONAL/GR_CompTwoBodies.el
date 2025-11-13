--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: GR_CompTwoBodies.el
-- DESCRIPTION: Defines a two bodies, one fixed, abstract model and a two
--    bodies, both free, abstract model
-- NOTES:
-- AUTHOR: Borja Garcia Gutierrez
-- CREATION DATE: 8/05/2001
--------------------------------------------------------------------------------
USE MATH 
-- Abstract components
--------------------------------------------------------------------------------
-- Abstract component for definition of two bodies, one fixed, models
--------------------------------------------------------------------------------
ABSTRACT COMPONENT TwoBodiesFx
   "Abstract component for two bodies, one fixed, models"

   DATA
      REAL CBmu = 1.e-9         	UNITS u_AU3_day2	"GM of the central fixed body (AU**3/day**2)"
      REAL OBmu = 1.e-12         UNITS u_AU3_day2 	"GM of the orbital body (AU**3/day**2)"

   TOPOLOGY
      Eter(
         nbodies = 2
         ) Universe(
            I = {{0, 0}, {1, 0}}
            )

      Body CentralBody(
         mu = CBmu
         )

      Body OrbitalBody(
         mu = OBmu
         )

      CONNECT CentralBody.gp TO Universe.gp[1]
      CONNECT OrbitalBody.gp TO Universe.gp[2]

END COMPONENT

--------------------------------------------------------------------------------
-- Abstract component for definition of two bodies, both free, models
--------------------------------------------------------------------------------
ABSTRACT COMPONENT TwoBodies
   "Abstract component for two bodies, both free, models"

   DATA
      REAL OB1mu = 1.e-9       	UNITS u_AU3_day2	"GM of the orbital body 1"
      REAL OB2mu = 1.e-12        UNITS u_AU3_day2 	"GM of the orbital body 2"

   TOPOLOGY
      Eter(
         nbodies = 2
         ) Universe(
            I = {{0, 1}, {1, 0}}
            )

      Body OrbitalBody1(
         mu = OB1mu
         )

      Body OrbitalBody2(
         mu = OB2mu
         )

      CONNECT OrbitalBody1.gp TO Universe.gp[1]
      CONNECT OrbitalBody2.gp TO Universe.gp[2]

END COMPONENT
