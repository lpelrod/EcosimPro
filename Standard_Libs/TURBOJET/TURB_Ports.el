--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: TURB_Ports.el
-- DESCRIPTION: Defines common port types
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 17/02/1999
--------------------------------------------------------------------------------

-- Libraries
USE MATH 


-- Ports
--------------------------------------------------------------------------------
-- Port for gas flow connections
--------------------------------------------------------------------------------
PORT Gas "Gas port"
   SUM       REAL W           RANGE ZERO,Inf     "Mass flow (kg/s)"
   EQUAL     REAL P           RANGE ZERO,Inf     "Pressure (Pa)"
   EQUAL OUT REAL H = 700000.                    "Enthalpy (J/kg)"
   EQUAL OUT REAL FAR                            "Fuel air ratio (-)"
   SUM   IN  REAL WF                             "Fuel flow (kg/s)"
   SUM   IN  REAL WH                             "Energy Flow (W)"
             REAL T = 500.    RANGE ZERO,Inf     "Temperature (K)"

   CONTINUOUS
      T = T_H_FAR(H, FAR)
      INVERSE(H) H = H_T_FAR(T, FAR)

      WH = W * H

      WF = (FAR / (1 + FAR)) * W

END PORT

--------------------------------------------------------------------------------
-- Port for fuel flow connections
--------------------------------------------------------------------------------
PORT Fuel "Fuel port"
   SUM       REAL W            RANGE ZERO,Inf    "Fuel mass flow (kg/s)"
   EQUAL OUT REAL FHV = 43200.                   "Fuel heat value ()"
   SUM   IN  REAL WFHV                           "Fuel heat value flow ()"
   EQUAL OUT REAL X[FuelComp]                    "Mass fraction of H and C (-)"
   SUM   IN  REAL WX[FuelComp]                   "Mass flow of H, C, and S (kg/s)"

   CONTINUOUS
      WFHV = W * FHV

      EXPAND (j IN FuelComp)
         WX[j] = W * X[j]

END PORT

--------------------------------------------------------------------------------
-- Port for mechanical connections
--------------------------------------------------------------------------------
PORT Shaft "Shaft port"
   SUM   REAL Power               "Mechanical power (W)"
   EQUAL REAL N                   "Rotational speed (rpm)"

END PORT

--------------------------------------------------------------------------------
-- Port for forces connections
--------------------------------------------------------------------------------
PORT Force "Force port"
   SUM REAL F                     "Thrust force (N)"

END PORT 
