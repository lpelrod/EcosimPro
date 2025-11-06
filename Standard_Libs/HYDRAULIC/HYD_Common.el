--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: HYD_Common.el
-- DESCRIPTION: Defines the common constants, ports, and components for
--    hydraulic simulation
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/12/2000
--------------------------------------------------------------------------------

-- Libraries
USE PORTS_LIB 
USE MATH 
USE CONTROL 


-- Global constants
CONST REAL g = 9.806   UNITS u_m_s2     "Gravity acceleration"
CONST REAL rho = 1000. UNITS u_kg_m3    "Density of water"
CONST REAL cp = 4186.  UNITS u_J_kgK    "Specific heat of water"


-- Ports
--------------------------------------------------------------------------------
-- Port for hydraulic connections
--------------------------------------------------------------------------------
PORT Hydraulic "Hydraulic port"
   SUM       REAL w   UNITS u_kg_s         "Mass flow"
   EQUAL     REAL p   UNITS u_Pa           "Pressure"
   EQUAL OUT REAL T   UNITS u_K            "Temperature"
             REAL h   UNITS u_J_kg         "Enthalpy"
   SUM   IN  REAL wh  UNITS u_W            "Energy flow"

   CONTINUOUS
      -- Enthalpy
      h = cp * T

      -- Energy flow
      wh = w * h

END PORT


-- Abstract components
--------------------------------------------------------------------------------
-- Abstract component for definition of hydraulic channels
--------------------------------------------------------------------------------
ABSTRACT COMPONENT HydChannel
   "Abstract component for hydraulic channels"

   PORTS
      IN Hydraulic hp_in          "Inlet hydraulic port" 
      OUT Hydraulic hp_out        "Outlet hydraulic port"

   DATA
      REAL z_in = 0.  UNITS u_m   "Geometric elevation of inlet"
      REAL z_out = 0. UNITS u_m   "Geometric elevation of outlet"

   TOPOLOGY
      PATH hp_in TO hp_out

END COMPONENT

--------------------------------------------------------------------------------
-- Abstract component for definition of hydraulic sensors
--------------------------------------------------------------------------------
ABSTRACT COMPONENT HydFluidMeter IS_A ASensor, HydChannel
   "Abstract component for hydraulic sensors"

   CONTINUOUS
      -- Conservation of port variables
      hp_out.w = hp_in.w
      hp_out.p = hp_in.p
      hp_out.T = hp_in.T

END COMPONENT


-- Components
--------------------------------------------------------------------------------
-- Component that represents a tank
--------------------------------------------------------------------------------
COMPONENT HydTank IS_A HydChannel
   "Tank"

   PORTS
      OUT analog_signal s_level   "Output level signal port"

   DATA
      REAL A = 1.   UNITS u_m2              "Cross area of the tank"

      REAL p0 = 101325. UNITS u_Pa          "Pressure"

   DECLS
      REAL H[1]  UNITS u_m        "Level"
      REAL m     UNITS u_kg       "Mass"
      REAL T     UNITS u_K        "Temperature"

   DISCRETE
      ASSERT (H[1] > z_in) ERROR "Uncovered tank inlet"
      ASSERT (H[1] > z_out) ERROR "Uncovered tank outlet"

   CONTINUOUS
      -- Conservation of mass
      H[1]' = (hp_in.w - hp_out.w) / (rho * A)
      m = H[1] * rho * A

      hp_in.p = p0 + rho * g * (H[1] - z_in)
      hp_out.p = p0 + rho * g * (H[1] - z_out)

      -- Conservation of energy
      m * cp * T' + (hp_in.w - hp_out.w) * cp * T = hp_in.wh - hp_out.wh

      hp_out.T = T

      s_level.signal[1] = H[1]

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a pipe
--------------------------------------------------------------------------------
COMPONENT HydPipe IS_A HydChannel
   "Pipe"

   DATA
      REAL l = 1.    UNITS u_m             "Lenght"
      REAL d = 0.1   UNITS u_m             "Diameter"

      REAL f = 0.020  UNITS no_units       "Friction factor"

      REAL dp_lam = 1000. UNITS u_Pa       "Pressure drop for laminar flow"

   DECLS
      REAL A      UNITS u_m2               "Area"

      REAL w_lam  UNITS u_kg_s             "Mass flow corresponding to 'dp_lam'"

   CONTINUOUS
      -- Geometry
      A = 0.25 * PI * d**2

      -- Laminar flow condition
      w_lam = A * sqrt(2 * d * dp_lam * rho / (f * l))

      -- Conservation of mass
      hp_out.w = hp_in.w

      -- Conservation of momentum
      hp_in.p - hp_out.p + rho * g * (z_in - z_out) = \
         0.5 * f * l * fpow2(hp_in.w, w_lam) / (d * rho * A**2)

      -- Conservation of energy
      hp_out.T = hp_in.T

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a valve
--------------------------------------------------------------------------------
COMPONENT HydValve IS_A HydChannel
   "Valve"

   PORTS
      IN analog_signal s_position "Output position signal"

   DATA
      REAL Avo = 0.020  	UNITS u_m2       "Valve area at fully open position"

      REAL dp_lam = 1000.  UNITS u_Pa       "Pressure drop for laminar flow"

   DECLS
      REAL Av              UNITS u_m2      "Valve area"

   CONTINUOUS
      -- Geometry
      Av = Avo * s_position.signal[1]

      -- Conservation of mass
      hp_out.w = hp_in.w

      -- Conservation of momentum
      IMPL(hp_in.w) hp_in.w = Av * sqrt(rho) * \
         fsqrt(hp_in.p - hp_out.p - rho * g * (z_in - z_out), dp_lam)

      -- Conservation of energy
      hp_out.T = hp_in.T

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a mass flow meter
--------------------------------------------------------------------------------
COMPONENT HydFlowMeter IS_A HydFluidMeter
   "Mass flow meter"

   CONTINUOUS
      var[1] = hp_in.w

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a pressure meter
--------------------------------------------------------------------------------
COMPONENT HydPressureMeter IS_A HydFluidMeter
   "Pressure meter"

   CONTINUOUS
      var[1] = hp_in.p

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a temperature meter
--------------------------------------------------------------------------------
COMPONENT HydTemperatureMeter IS_A HydFluidMeter
   "Temperature meter"

   CONTINUOUS
      var[1] = hp_in.T

END COMPONENT
