--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompVCHP.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a complete VCHP component for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara & Borja Garcia Gutierrez
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 


-- Components
--------------------------------------------------------------------------------
-- Component VCHP
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a VCHP (Variable Conductance Heat Pipe) component.
--------------------------------------------------------------------------------
COMPONENT VCHP
	(
		INTEGER N_evap = 1			UNITS no_units		"Number of nodes in evaporator",
		INTEGER N_ec = 1				UNITS no_units		"Number of nodes in evap-cond adibatic tube",
		INTEGER N_cond = 5			UNITS no_units		"Number of nodes in condenser",
		INTEGER N_cr = 1				UNITS no_units		"Number of nodes in cond-rese adibatic tube",
		INTEGER N_rese = 1			UNITS no_units		"Number of nodes in reservoir"
	)
	"Variable Conductance Heat Pipe component"
	PORTS
		OUT thermal (n = N_evap) tp_evap		"Evaporator thermal outlet port"
		OUT thermal (n = N_cond) tp_cond		"Condenser thermal outlet port"
		OUT thermal (n = N_rese) tp_rese		"Reservoir thermal outlet port"

	DATA
		BOOLEAN Design = FALSE		UNITS no_units		"Flag used to set model on design or transient mode"

		REAL l_vap_o = 2.				UNITS u_m		"Default total vapour length for design mode"

		REAL T_vap_o = 273.15			UNITS u_K		"Default vapour temperature for design mode"
      REAL T_gas_o = 273.15			UNITS u_K		"Default gas temperature for design mode"
		REAL To = 290.						UNITS u_K		"Initial temperature of tube nodes"
		ENUM Material mat_evap = None	UNITS no_units	"Material used for evaporator"
		REAL h_evap = 1000.				UNITS u_W_m2K	"Vapour-tube heat transfer coefficient in evaporator"
		REAL l_evap = 1.					UNITS u_m		"Length of evaporator"
		REAL D_o_evap = 0.020			UNITS u_m		"Evaporator outer diameter "
		REAL D_i_evap = 0.018			UNITS u_m		"Evaporator inner diameter"
		REAL A_vap_evap = 1.e-4			UNITS u_m2		"Vapour cross section area in evaporator"

		ENUM Material mat_ec = None	UNITS no_units	"Material used for evap-cond adiabatic tube"
		REAL h_ec = 1000.					UNITS u_W_m2K	"Vapour-tube heat transfer coefficient in evap-cond tube "
		REAL l_ec = 0.5					UNITS u_m		"Length of adiabatic evap-cond tube"
		REAL D_o_ec = 0.020				UNITS u_m		"Adiabatic evap-cond outer diameter"
		REAL D_i_ec = 0.018				UNITS u_m		"Adiabatic evap-cond inner diameter"
		REAL A_vap_ec = 1.e-4			UNITS u_m2		"Vapour cross section area in evap-cond adiabatic tube"

		ENUM Material mat_cond = None	UNITS no_units	"Material used for condenser"
		REAL h_cond = 1000.				UNITS u_W_m2K	"Vapour-tube heat transfer coefficient in condenser"
		REAL l_cond = 1.					UNITS u_m		"Length of condenser"
		REAL D_o_cond = 0.020			UNITS u_m		"Condenser outer diameter"
		REAL D_i_cond = 0.018			UNITS u_m		"Condenser inner diameter"
		REAL A_vap_cond = 1.e-4			UNITS u_m2		"Vapour cross section area in condenser"

		ENUM Material mat_cr = None	UNITS no_units	"Material used for cond-rese adiabatic tube"
		REAL h_cr = 1000.					UNITS u_W_m2K		"Vapour-tube heat transfer coefficient in cond-rese tube"
		REAL l_cr = 0.1					UNITS u_m		"Length of adiabatic cond-rese tube"
		REAL D_o_cr = 0.020				UNITS u_m		"Adiabatic cond-rese outer diameter"
		REAL D_i_cr = 0.018				UNITS u_m		"Adiabatic cond-rese inner diameter"
		REAL A_vap_cr = 1.e-4			UNITS u_m2		"Vapour cross section area in cond-rese adiabatic tube"

		ENUM Material mat_rese = None	"Material used for reservoir"
		REAL h_rese = 1000.				UNITS u_W_m2K		"Vapour-tube heat transfer coefficient in reservoir"
		REAL l_rese = 0.1					UNITS u_m			"Length of reservoir"
		REAL D_o_rese = 0.050			UNITS u_m			"Reservoir outer diameter"
		REAL D_i_rese = 0.048			UNITS u_m			"Reservoir inner diameter"
		REAL A_vap_rese = 5.e-4			UNITS u_m2			"Vapour cross section area in reservoir"

		REAL C_vap = 1.					UNITS u_J_K		"Thermal capacitance of vapour"

		REAL n_gas_o = 0.01				UNITS u_mol		"Default number of moles of gas"

	DECLS
		REAL l								UNITS u_m		"Total heater pipe length"
		REAL l_vap							UNITS u_m		"Total vapour length"

		REAL T_vap							UNITS u_K		"Vapour temperature in pipe"

		REAL p								UNITS u_Pa		"Total pressure in pipe"

		REAL n_gas							UNITS u_mol		"Number of moles of gas"
      
		CONST REAL RGAS_mol = 8.314	UNITS u_J_molK	"Universal gas constant"

	TOPOLOGY
      Tube (n = N_evap) evap
         (
         mat = mat_evap,
         h = h_evap,
         l = l_evap,
         D_o = D_o_evap,
         D_i = D_i_evap,
         A_vap = A_vap_evap,
         To = To
         )

      Tube (n = N_ec) adia_ec
         (
         mat = mat_ec,
         h = h_ec,
         l = l_ec,
         D_o = D_o_ec,
         D_i = D_i_ec,
         A_vap = A_vap_ec,
         To = To
         )

      Tube (n = N_cond) cond
         (
         mat = mat_cond,
         h = h_cond,
         l = l_cond,
         D_o = D_o_cond,
         D_i = D_i_cond,
         A_vap = A_vap_cond,
         To = To
         )

      Tube (n = N_cr) adia_cr
         (
         mat = mat_cr,
         h = h_cr,
         l = l_cr,
         D_o = D_o_cr,
         D_i = D_i_cr,
         A_vap = A_vap_cr,
         To = To
         )

      Tube (n = N_rese) rese
         (
         mat = mat_rese,
         h = h_rese,
         l = l_rese,
         D_o = D_o_rese,
         D_i = D_i_rese,
         A_vap = A_vap_rese,
         To = To
         )

      CONNECT evap.tp_N TO adia_ec.tp_1
      CONNECT adia_ec.tp_N TO cond.tp_1
      CONNECT cond.tp_N TO adia_cr.tp_1
      CONNECT adia_cr.tp_N TO rese.tp_1

      CONNECT rese.s_ngas_out TO adia_cr.s_ngas_in
      CONNECT adia_cr.s_ngas_out TO cond.s_ngas_in
      CONNECT cond.s_ngas_out TO adia_ec.s_ngas_in
      CONNECT adia_ec.s_ngas_out TO evap.s_ngas_in

      CONNECT evap.tp_wall TO tp_evap
      CONNECT cond.tp_wall TO tp_cond
      CONNECT rese.tp_wall TO tp_rese

   INIT
		IF (Design == FALSE) THEN
			n_gas = n_gas_o
		ELSE
--			n_gas = (bound(l_evap - l_vap_o, 0., l_evap) * (0.25 * PI * D_i_evap**2) + \
--						bound(l_evap + l_ec - l_vap_o, 0., l_ec) * (0.25 * PI * D_i_ec**2) + \
--						bound(l_evap + l_ec + l_cond - l_vap_o, 0., l_cond) * (0.25 * PI * D_i_cond**2) + \
--						bound(l_evap + l_ec + l_cond + l_cr - l_vap_o, 0., l_cr) * (0.25 * PI * D_i_cr**2) + \
--						bound(l_evap + l_ec + l_cond + l_cr + l_rese - l_vap_o, 0., l_rese) * (0.25 * PI * D_i_rese**2) ) * \
--						Psat(T_vap_o) / (RGAS_mol * T_gas_o)

			n_gas = (bound(l_evap - l_vap_o, 0., l_evap) * A_vap_evap + \
						bound(l_evap + l_ec - l_vap_o, 0., l_ec) * A_vap_ec + \
						bound(l_evap + l_ec + l_cond - l_vap_o, 0., l_cond) * A_vap_cond + \
						bound(l_evap + l_ec + l_cond + l_cr - l_vap_o, 0., l_cr) * A_vap_cr + \
						bound(l_evap + l_ec + l_cond + l_cr + l_rese - l_vap_o, 0., l_rese) * A_vap_rese ) * \
						Psat(T_vap_o) / (RGAS_mol * T_gas_o)						

			PRINT("VCHP component: Design calculation finished, n_gas = $n_gas")

		END IF

	DISCRETE
		ASSERT ((rese.s_ngas_in.signal[1] < 0.) OR (rese.s_ngas_out.signal[1] > 0.)) \
			WARNING "VCHP component: Front in reservoir"

		ASSERT ((evap.s_ngas_in.signal[1] <= 0.) OR (evap.s_ngas_out.signal[1] > 0.)) \
			WARNING "VCHP component: Front in evaporator"

--		ASSERT ((rese.s_ngas_in.signal[1] >= 0.) AND (evap.s_ngas_out.signal[1] <= 0.)) \
--			FATAL "VCHP component: Front out of heater pipe"

		ASSERT ((rese.s_ngas_in.signal[1] >= 0.) AND (evap.s_ngas_out.signal[1] <= 0.)) \
			WARNING "VCHP component: Front out of heater pipe"


		WHEN (Design == TRUE) THEN
			PRINT("VCHP component: Switching to Design mode")
		END WHEN

		WHEN (Design == FALSE) THEN
			PRINT("VCHP component: Switching to Transient mode")
		END WHEN

	CONTINUOUS
		-- Total heater pipe length
		l = l_evap + l_ec + l_cond + l_cr + l_rese

		-- Total vapour length measured from the evaporator end of pipe
		l_vap = evap.s_lvap.signal[1] + adia_ec.s_lvap.signal[1] + cond.s_lvap.signal[1] + \
		adia_cr.s_lvap.signal[1] + rese.s_lvap.signal[1]

		-- Energy equation for vapour due to all heat flows
		C_vap * T_vap' = -(evap.tp_vapour.q[1]  + adia_ec.tp_vapour.q[1] + cond.tp_vapour.q[1] + \
		adia_cr.tp_vapour.q[1] + rese.tp_vapour.q[1])

		-- Temperature of vapour is constant in pipe
		evap.tp_vapour.Tk[1] = T_vap
		adia_ec.tp_vapour.Tk[1] = T_vap
		cond.tp_vapour.Tk[1] = T_vap
		adia_cr.tp_vapour.Tk[1] = T_vap
		rese.tp_vapour.Tk[1]= T_vap

		-- Total pressure in pipe is constant
		p = Psat(T_vap)

		-- Pressure of gas is constant in pipe
		evap.s_p.signal[1] = p
		adia_ec.s_p.signal[1] = p
		cond.s_p.signal[1] = p
		adia_cr.s_p.signal[1] = p
		rese.s_p.signal[1] = p

		-- Axial heat flows at the end of VCHP are zero
		evap.tp_1.q[1] = 0.
		rese.tp_N.q[1] = 0.

		-- Radial heat flows at adiabatic evaporator-condenser section are zero
		EXPAND (i IN 1,N_ec)
			adia_ec.tp_wall.q[i] = 0.

		-- Radial heat flows at adiabatic condenser-reservoir section are zero
		EXPAND (i IN 1,N_cr)
			adia_cr.tp_wall.q[i] = 0.

		n_gas' = 0.

		-- Number of moles at port connection
		rese.s_ngas_in.signal[1] = n_gas

END COMPONENT

