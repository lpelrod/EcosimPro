--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_FunVCHPs.el
--		FILE TYPE:		Functions of the THERMAL library
--		DESCRIPTION:	Defines common functions for heater pipes for the
--							THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Jose A. Romera Garcia & Borja Garcia Gutierrez
--		CREATION DATE:	18-Jan-2008
--------------------------------------------------------------------------------

USE MATH 
USE PORTS_LIB 

-- Functions
--------------------------------------------------------------------------------
-- Function Psat
--------------------------------------------------------------------------------
-- Purpose:
--    Calculate NH3 vapour pressure ussing a 6th order polynomial:
--       Psat(T) = a[1] + a[2] * T + ... + a[6] * T^5 + a[7] * T^6
--------------------------------------------------------------------------------
FUNCTION REAL Psat
   (
   IN REAL Tk                     "Temperature of NH3 (K)"
   )

   DECLS
      REAL a[7] = {4.283253e+5, 1.598058e+4,  2.371318e+2, \
                   1.616482e+0, 2.325724e-3, -1.272831e-5, \
                   1.313368e-7}  UNITS no_units  "Polynomial coefficients"
      REAL Tc 		UNITS u_C 	"Temperature"
   BODY
      Tc = Tk - 273.15
      RETURN poly(Tc, 7, a)

END FUNCTION

--------------------------------------------------------------------------------
-- Function Lvap
--------------------------------------------------------------------------------
-- Purpose:
--    Function to calculate vapour/gas-front position measured from the tube
--    begin (first node side).
--------------------------------------------------------------------------------
FUNCTION REAL Lvap
   (
   IN  INTEGER N                  "Number of nodes (-)",
   IN  REAL l                     "Length of tube (m)",
   IN  REAL A                     "Cross sectional inner area of tube (m**2)",
   IN  REAL n_gas_in              "Number of moles of gas at inlet node (mol)",
   IN  REAL p                     "Total pressure in tube (Pa)",
   IN  REAL T[N]                  "Temperature of gas at each node (K)",
   OUT REAL chi[N]                "Vapour-fluid moles ratio at each node (-)",
   OUT REAL n_gas_out             "Number of moles of gas at output node (mol)"
   )

   DECLS
      INTEGER j                   "Aux. var. used to detect vapour/gas-front node (-)"

      REAL dx                     "Node length (m)"

      REAL n_gas                  "Total number of moles of gas (mol)"
      REAL ngas[N]                "Number of moles of gas in j-node for fully filled node (mol)"

      REAL l_vap                  "Vapour length measured from the tube begin (m)"
      CONST REAL RGAS_mol = 8.314 "Universal gas constant (J/mol*K)"
   BODY
         -- Node length calculation
      dx = l / N

         -- Verification of presence of gas at tube inlet
      IF (n_gas_in <= 0.) THEN
            -- Tube Empty of Gas
         FOR (i IN 1,N)
            chi[i] = 1.
         END FOR

         n_gas_out = 0.

         l_vap = l

      ELSE
            -- Number of moles of gas at each node for fully filled node
         FOR (j IN 1,N)
            ngas[j] = max(p - Psat(T[j]),0) * A * dx / (RGAS_mol * T[j])           
         END FOR

            -- Total number of moles of gas in tube for fully filled tube
         n_gas = SUM(j IN 1,N; ngas[j])

         n_gas_out = n_gas_in - n_gas

            -- Verification of Fully Filled Tube
         IF (n_gas_out >= 0.) THEN
               -- Tube Fully Filled of Gas
            FOR (i IN 1,N)
               chi[i] = 0.
            END FOR

            l_vap = 0.

         ELSE
            n_gas_out = 0.

               -- Localization of Vapour/Gas-front Node (j)
            j = N

            n_gas = ngas[j]

            WHILE (n_gas < n_gas_in)
               chi[j] = 0.
               j = j - 1
               n_gas = n_gas + ngas[j]
            END WHILE

               -- Vapour-Fluid Moles Ratio at j Node Section
            chi[j] = (n_gas - n_gas_in) / ngas[j]

            FOR (i IN 1,j-1)
               chi[i] = 1.
            END FOR

               -- Vapour Length Measured from the Tube Begin
            l_vap = ((j - 1) + chi[j]) * dx

         END IF

      END IF

   RETURN l_vap

END FUNCTION

