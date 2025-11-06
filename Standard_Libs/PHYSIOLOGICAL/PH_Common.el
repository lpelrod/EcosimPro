--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: PH_Common.el
-- DESCRIPTION: Defines the common ports and components for physiological
--    simulation
-- NOTES:
-- AUTHOR: Luis Ordoñez Inda
-- CREATION DATE: 23/11/2000
--------------------------------------------------------------------------------
USE MATH
-- Ports
--------------------------------------------------------------------------------
-- Port for physiological connections
--------------------------------------------------------------------------------
PORT Physi "Physiological port"
   SUM   REAL w                   	UNITS u_cm3_s		"Mass flow"
   EQUAL REAL p                   	UNITS u_Pa			"Pressure"

END PORT


-- Abstract components
--------------------------------------------------------------------------------
-- Abstract component for definition of lumps and ventricles
--------------------------------------------------------------------------------
ABSTRACT COMPONENT Volume
   "Abstract component for lump and ventricles"

	PORTS
      IN Physi p_in               	"Inlet physiological port"
      OUT Physi p_out             	"Outlet physiological port"

   DATA
      REAL rai = 0.01             	UNITS u_Pas_cm3	"Inlet resistance, only for forward flow"
      REAL rao = 0.01             	UNITS u_Pas_cm3	"Outlet resistance, only for forward flow"

   DECLS
      REAL vrai                   	UNITS u_Pas_cm3	"Inlet resistance"
      REAL vrao                   	UNITS u_Pas_cm3	"Outlet resistance"

      REAL vcomp                  	UNITS u_cm3_Pa		"Compliance"

      REAL vol                    	UNITS u_cm3			"Blood volume"

      REAL p                      	UNITS	u_Pa			"Pressure"

   CONTINUOUS
      vol' = p_in.w - p_out.w

      p = vol / vcomp

END COMPONENT

--------------------------------------------------------------------------------
-- Abstract component for definition of lumps (legs, lungs...)
--------------------------------------------------------------------------------
ABSTRACT COMPONENT Lump IS_A Volume
   "Abstract component for lump (legs, lungs...)"

	DATA
      REAL comp = 1      				UNITS u_cm3_Pa		"compliance"

   CONTINUOUS
      vrai = rai
      vrao = rao

      vcomp = comp

      p_in.w = (p_in.p - p) / vrai
      p_out.w = (p - p_out.p) / vrao

END COMPONENT


-- Components
--------------------------------------------------------------------------------
-- Component that represents a ventricle
--------------------------------------------------------------------------------
COMPONENT Ventricle IS_A Volume
   "Ventricle"

   DATA
      REAL period = 1.            	UNITS u_s			"Period"

      TABLE_1D rec_comp = {
            {0, 0.4, 0.5, 1},
            {0.0133, 0.428, 0.0133, 0.0133}
         } 			UNITS u_cm3_Pa		"Table for the inverse ventricle compliance (u_u_cm3_Pa) vs period (s)"

   CONTINUOUS
      vcomp = 1. / periodTimeTableInterp(TIME, rec_comp, period)

      vrai = ZONE (p_in.p > p) rai
             OTHERS            1.e+5

      vrao = ZONE (p > p_out.p) rai
             OTHERS             1.e+5

      IMPL(p_in.w) p_in.w = (p_in.p - p) / vrai

      IMPL(p_out.w) p_out.w = (p - p_out.p) / vrao

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a cava vein
--------------------------------------------------------------------------------
COMPONENT Cava IS_A Lump
   "Cava vein"

   INIT
      vol = 650.

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents an aorta artery
--------------------------------------------------------------------------------
COMPONENT Aorta IS_A Lump
   "Aorta artery"

   INIT
      vol = 80.8

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a head
--------------------------------------------------------------------------------
COMPONENT Head IS_A Lump
   "Head"

   INIT
      vol = 68.

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a trunk
--------------------------------------------------------------------------------
COMPONENT Trunk IS_A Lump
   "Trunk"

   INIT
      vol = 2180

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents lungs
--------------------------------------------------------------------------------
COMPONENT Lungs IS_A Lump
   "Lungs"

   INIT
      vol = 200.

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents arms
--------------------------------------------------------------------------------
COMPONENT Arms IS_A Lump
   "Arms"

   INIT
      vol = 268.

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents legs
--------------------------------------------------------------------------------
COMPONENT Legs IS_A Lump
   "Legs"

   INIT
      vol = 700.

END COMPONENT
