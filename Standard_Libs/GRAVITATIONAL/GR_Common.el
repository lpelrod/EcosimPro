--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: GR_Common.el
-- DESCRIPTION: Defines the common types, constants, ports, and components for
--    gravitational simulation
-- NOTES:
-- AUTHOR: Borja Garcia Gutierrez
-- CREATION DATE: 7/05/2001
--------------------------------------------------------------------------------
USE MATH 
-- Enumerative types
ENUM Axis = {x, y, z}             "Reference system axis names"


-- Global constants
CONST REAL MStoAUD = 5.77544e-7  UNITS "(AU/day)/(m/s)" 	"Units conversion coefficient"


-- Ports
--------------------------------------------------------------------------------
-- Port for gravitational interactions
--------------------------------------------------------------------------------
PORT GravInter "Gravitational interaction port"
   EQUAL REAL mu_b              	UNITS u_AU3_day2		"GM of the body"
   EQUAL REAL r_b[Axis]          UNITS u_AU				"Position of the body"
   EQUAL REAL f_b[Axis]          UNITS u_AU_day2		"Acceleration due to external forces"

END PORT


-- Components
----------------------------------------------------------------
-- Component that represents an universe scenario
----------------------------------------------------------------
COMPONENT Eter
   (
   INTEGER nbodies = 2
   )

   "Universe scenario"

   PORTS
      IN GravInter gp[nbodies] 			"Input bodies interaction array port"

   DATA
      -- Influence matrix (i : orbital body, j : central body)
      -- I[i,j] = 0 : j body does'n influence i body
      -- I[i,j] = 1 : j body influence i body

      REAL I[nbodies, nbodies]  			"Influence matrix (0/1)"

   DECLS
      REAL mu[nbodies]                 UNITS u_AU3_day2		"GM of the bodies"
      REAL r[nbodies, Axis]            UNITS u_AU				"Position of the bodies"

      REAL d[nbodies, nbodies]         UNITS u_AU				"distance between bodies"

      REAL f[nbodies, Axis]            UNITS u_AU_day2		"Acceleration due to external forces"

      REAL R[nbodies, nbodies, Axis]   UNITS u_AU				"Position of the j body relative to i body"

   CONTINUOUS
      EXPAND_BLOCK (i IN 1,nbodies)
         -- Input asignation
         mu[i] = gp[i].mu_b

         -- Input asignation
         EXPAND (k IN Axis)
            r[i,k] = gp[i].r_b[k]

         -- Distance between bodies
         EXPAND (j IN 1,nbodies)
            d[i,j] = sqrt(SUM(k IN Axis; (r[j,k] - r[i,k])**2))

         -- Relative position of bodies
         EXPAND (j IN 1,nbodies)
            EXPAND (k IN Axis)
               R[i,j,k] = r[j,k] - r[i,k]

         -- Acelerations due to external forces
         EXPAND (k IN Axis)
            f[i,k] = SUM(j IN 1,nbodies EXCEPT i; I[i,j] * mu[j] * (r[j,k] - r[i,k]) / d[i,j]**3)

         -- Output asignation
         EXPAND (k IN Axis)
            gp[i].f_b[k] = f[i,k]

      END EXPAND_BLOCK

END COMPONENT

----------------------------------------------------------------
-- Component that represents a gravitational body
----------------------------------------------------------------
COMPONENT Body
   "Gravitational body"

   PORTS
      IN GravInter gp             		"Input body interaction port"

   DATA
      REAL mu = 1.e-9             		UNITS u_AU3_day2		"GM of the body"

   DECLS
      REAL r[Axis]                		UNITS u_AU				"Position of the body"
      REAL f[Axis]                		UNITS u_AU_day2		"Acceleration due to external forces"

   CONTINUOUS
      EXPAND_BLOCK (k IN Axis)
         -- Input asignation
         f[k] = gp.f_b[k]

         -- Position integration
         r[k]'' = f[k]

         -- Output asignation
         gp.r_b[k] = r[k]
         gp.mu_b = mu

      END EXPAND_BLOCK

END COMPONENT
