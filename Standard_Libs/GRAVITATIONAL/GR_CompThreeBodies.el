--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: GR_CompThreeBodies.el
-- DESCRIPTION: Defines a three bodies, one fixed, abstract model and a three
--    bodies, all free, abstract model
-- NOTES:
-- AUTHOR: Borja Garcia Gutierrez
-- CREATION DATE: 8/05/2001
--------------------------------------------------------------------------------
USE MATH 
-- Abstract components
--------------------------------------------------------------------------------
-- Abstract component for definition of three bodies, one fixed, models
--------------------------------------------------------------------------------
ABSTRACT COMPONENT ThreeBodiesFx
   "Abstract component for three bodies, one fixed, models"

   DATA
      REAL CBmu = 1.e-9         	UNITS u_AU3_day2  "GM of the central fixed body"
      REAL OB1mu = 1.e-12        UNITS u_AU3_day2 	"GM of the orbital body 1"
      REAL OB2mu = 1.e-15        UNITS u_AU3_day2 	"GM of the orbital body 2"

   TOPOLOGY
      Eter(
         nbodies = 3
         ) Universe(
            I = {{0, 0, 0}, {1, 0, 0}, {1, 1, 0}}
            )

      Body CentralBody(
         mu = CBmu
         )

      Body OrbitalBody1(
         mu = OB1mu
         )

      Body OrbitalBody2(
         mu = OB2mu
         )

      CONNECT CentralBody.gp TO Universe.gp[1]
      CONNECT OrbitalBody1.gp TO Universe.gp[2]
      CONNECT OrbitalBody2.gp TO Universe.gp[3]

END COMPONENT

--------------------------------------------------------------------------------
-- Abstract component for definition of three bodies, all free, models
--------------------------------------------------------------------------------
ABSTRACT COMPONENT ThreeBodies
   "Abstract component for three bodies, all free, models"

   DATA
      REAL CBmu = 1.e-9           	UNITS u_AU3_day2	"GM of the central fixed body"
      REAL OB1mu = 1.e-12         	UNITS u_AU3_day2	"GM of the orbital body 1"
      REAL OB2mu = 1.e-15         	UNITS u_AU3_day2	"GM of the orbital body 2"

   TOPOLOGY
      Eter(
         nbodies = 3
         ) Universe(
            I = {{0, 1, 1}, {1, 0, 1}, {1, 1, 0}}
            )

      Body CentralBody(
         mu = CBmu
         )

      Body OrbitalBody1(
         mu = OB1mu
         )

      Body OrbitalBody2(
         mu = OB2mu
         )

      CONNECT CentralBody.gp TO Universe.gp[1]
      CONNECT OrbitalBody1.gp TO Universe.gp[2]
      CONNECT OrbitalBody2.gp TO Universe.gp[3]

END COMPONENT
