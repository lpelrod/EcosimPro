/*-----------------------------------------------------------------------------------------
 FILE: gravitational_examples
-----------------------------------------------------------------------------------------*/

-- Libraries
USE MATH 
USE GRAVITATIONAL 


-- Components
--------------------------------------------------------------------------------
-- Earth and Moon gravitational interaction example
--------------------------------------------------------------------------------
COMPONENT EarthMoon IS_A TwoBodiesFx
   "Earth and Moon gravitational interaction example"

   DECLS
      CLOSE CBmu = 8.887e-10
      CLOSE OBmu = 2.379e-13

END COMPONENT


-- Components
--------------------------------------------------------------------------------
-- Sun and Earth gravitational interaction example
--------------------------------------------------------------------------------
COMPONENT SunEarth IS_A TwoBodiesFx
   "Sun and Earth gravitational interaction example"

   DECLS
      CLOSE CBmu = 2.957e-4
      CLOSE OBmu = 8.887e-10

END COMPONENT


-- Components
--------------------------------------------------------------------------------
-- Sun, Earth, and Moon gravitational interaction example
--------------------------------------------------------------------------------
COMPONENT SunEarthMoon IS_A ThreeBodiesFx
   "Sun, Earth, and Moon gravitational interaction example"

   DECLS
      CLOSE CBmu = 2.957e-4
      CLOSE OB1mu = 8.887e-10
      CLOSE OB2mu = 2.379e-13

END COMPONENT

-- Components
----------------------------------------------------------------
-- Two free bodies gravitational interaction example
----------------------------------------------------------------
COMPONENT freeBodies IS_A TwoBodies
   "Two free bodies gravitational interaction example"

   DECLS
      CLOSE OB1mu = 8.887e-10
      CLOSE OB2mu = 8.887e-10

END COMPONENT


-- Components
--------------------------------------------------------------------------------
-- Two fixed bodies and one free body gravitational interaction example
--------------------------------------------------------------------------------
COMPONENT openOrbit
   "Two fixed bodies and one free body gravitational interaction example"

   TOPOLOGY
      Eter(
         nbodies = 3
         ) Universe(
            I = {{0, 0, 0}, {0, 0, 0}, {1, 1, 0}}
            )

      Body CentralBody1(
         mu = 10.
         )

      Body CentralBody2(
         mu = 10.
         )

      Body OrbitalBody

      CONNECT CentralBody1.gp TO Universe.gp[1]
      CONNECT CentralBody2.gp TO Universe.gp[2]
      CONNECT OrbitalBody.gp TO Universe.gp[3]

END COMPONENT

