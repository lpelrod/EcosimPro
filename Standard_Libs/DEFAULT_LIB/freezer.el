--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: freezer.el
-- DESCRIPTION: Defines "freezer" component example
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/03/1999
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- Freezer example: Simulation of a physical freezer
--------------------------------------------------------------------------------
COMPONENT freezer
   "Freezer example"

   DATA
      REAL aka = 0.18             UNITS u_kW_C		"Heat transfer coeficient"
      REAL carn = 0.45            UNITS no_units	"Carnot efficiency"
      REAL ec = 0.7               UNITS u_C			"Coolant temperature"
      REAL qb = 1.5               UNITS u_kW			"Internal heat production"
      REAL ta = 25.               UNITS u_C			"Ambient temperature"
      REAL ua = 1.7               UNITS u_kW_C		"Heat transfer coeficient"
      REAL c0 = 0.5895            UNITS u_kW			"Compressor characteristic 0"
      REAL c1 = 0.010264          UNITS u_kW_C		"Compressor characteristic 1"
      REAL c2 = 2.869e-4          UNITS "kW/degC^2"		"Compressor characteristic 2"
      REAL cpw = 4.2              UNITS u_kJ_kgC	"Specific heat of water"
      REAL flc = 0.40334          UNITS u_kg_s		"Coolant flow"
      REAL sf = 13.               UNITS no_units	"Size of compressor"
      REAL tc1 = 20.              UNITS u_C			"Input coolant temperature "

   DECLS
      BOOLEAN compressorON        "Compressor state (ON: TRUE / OFF: FALSE)"

      REAL mc                     UNITS u_J_C		"Heat capacity"
      REAL wk                     UNITS u_W			"Electric power"
      REAL qc                     UNITS u_W			"Condenser heat"
      REAL tc2                    UNITS u_C			"Output coolant temperature"
      REAL tc                     UNITS u_C			"Condenser temperature"
      REAL te                     UNITS u_C			"Evaporator temperature"
      REAL tr                     UNITS u_C			"Room temperature"
      REAL qe                     UNITS u_W			"Heat transferred from the air"

   DISCRETE
      WHEN (tr > -18) THEN
         compressorON = TRUE
      END WHEN

      WHEN (tr < -20) THEN
         compressorON = FALSE
      END WHEN

   CONTINUOUS
      wk = ZONE (compressorON == TRUE) (c0 + c1 * tc + c2 * tc * te) * sf
           OTHERS                      0.

      qc = wk * carn * (tc + 273.15) / (tc - te)

      tc2 = qc / (flc * cpw) + tc1

      tc = (tc2 - tc1) / ec + tc1

      te = tr - qe / ua

      qe = qc - wk

      tr' = (qb + aka * (ta - tr) - qe) / mc

END COMPONENT
