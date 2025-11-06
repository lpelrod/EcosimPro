--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompDNphases.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a diffusive thermal node with phase changes for
--							the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Stefano Naclerio
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

USE MATH 
-- Components
--------------------------------------------------------------------------------
-- Component DNphases
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a diffusive thermal node taking into account phase changes.
--------------------------------------------------------------------------------
COMPONENT DNphases IS_A Node
	"Diffusive thermal node taking into account phase changes"
	DATA  
		REAL Mass = 1.					UNITS u_kg			"Mass of water"
		REAL To = 290.					UNITS u_K			"Initial Temperature of water"
      REAL CP_l = 4186.				UNITS u_J_kgK		"Specific heat of liquid"
		REAL CP_s = 2039.				UNITS u_J_kgK		"Specific heat of solid"
		REAL CP_v = 1805.				UNITS u_J_kgK		"Specific heat of vapor"
		REAL Hfus = 334000.			UNITS u_J_kg		"Enthalpy of fusion"
		REAL Hvap = 2501000.			UNITS u_J_kg		"Enthalpy of vaporisation"
		REAL T_fusion = 273.15		UNITS u_K			"Fusion temperature"
		REAL T_boiling= 373.15		UNITS u_K			"Boiling temperature"

	DECLS
		REAL T				UNITS u_K				"Temperature"
		REAL u				UNITS u_J				"Internal Energy"
		REAL Uv				UNITS u_J_kg			"Internal energy corresponding to saturated vapor"
		REAL Ul				UNITS u_J_kg			"Internal energy corresponding to saturated liquid"
		REAL Us				UNITS u_J_kg			"Internal energy corresponding to solid at fusion temperature"

	INIT
		IF (To <= T_fusion ) THEN
			u = -Hfus + CP_s * (To - T_fusion)
		ELSEIF (To < T_boiling) THEN
			u = CP_l * (To - T_fusion)
		ELSE
			u = Hvap + CP_l * (T_boiling - T_fusion) + CP_v * (To - T_boiling)
		END IF

	DISCRETE
		ASSERT (To != T_fusion) ERROR "Initial temperature must not be equal to fusion temperature"

		ASSERT (To != T_boiling) ERROR "Initial temperature must not be equal to boiling temperature"

	CONTINUOUS
		u' = q / Mass

		Uv = Hvap + CP_l * (T_boiling - T_fusion)

		Ul = CP_l * (T_boiling - T_fusion)

		Us = -Hfus

		T =	ZONE (u < Us)	T_fusion + (u - Us) / CP_s		-- Solid phase
				ZONE (u < 0 )	T_fusion								-- Liquid and solid phase
				ZONE (u < Ul) 	T_fusion + u / CP_l				-- Liquid phase
				ZONE (u < Uv)	T_boiling							-- Liquid and vapor phase
				OTHERS			T_boiling + (u - Uv) / CP_v	-- Vapor phase

		EXPAND (i IN 1, n)
			tp_in.Tk[i] = T

END COMPONENT
