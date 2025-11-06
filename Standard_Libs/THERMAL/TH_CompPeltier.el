--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompPeltier.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a thermoelectric heat pump for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramón Pérez Vara
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 


-- Components
--------------------------------------------------------------------------------
-- Component Peltier
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a thermoelectric heat pump.
--------------------------------------------------------------------------------
COMPONENT Peltier
	(
		INTEGER n = 1			UNITS no_units			"Dimension of thermal port"
	)
	"Thermoelectric heat pump model"
	PORTS
		IN  thermal (n = n) tp_in		"Thermal inlet port"
		OUT thermal (n = n) tp_out		"Thermal outlet port"

		IN  elec e_p						"Electrical inlet port for the n-type semiconductor"
		IN  elec e_n						"Electrical outlet port for the p-type semiconductor"

	DATA
		INTEGER NTE = 1				UNITS no_units		"Number of TE elements"
		REAL G = 4.e-2					UNITS u_m			"Area length of the TE elements"

		REAL a_coef[3] = { 22224.e-9, 930.6e-9, -0.9905e-9} \
			"Temperature coefficients of seebeck effect (V/K, V/K^2, V/K^3)"
		REAL r_coef[3] = {5112.e-10, 163.4e-10, 0.6279e-10} \
			"Temperature coefficients of resistivity (Ohm*m, Ohm*m/K, Ohm*m/K^2)"
		REAL k_coef[3] = {62605.e-4, -277.7e-4, 0.4131e-4} \
			"Temperature coefficients of thermal conductivity (W/m*K, W/m*K^2, W/m*K^3)"

	DECLS
		REAL Tk_in			UNITS u_K				"Inlet temperature"
		REAL Tk_out			UNITS u_K				"Outlet temperature"
		REAL Tk_ave			UNITS u_K				"Average temperature"

		REAL a				UNITS u_V_K				"Seebeck coefficient"
		REAL r				UNITS u_Ohmm			"Resistivity"
		REAL k				UNITS u_W_mK			"Thermal conductivity"

		REAL I				UNITS u_A				"Current"
		REAL Iopt			UNITS u_A				"Optimum Current"
		REAL Imax			UNITS u_A				"Maximum Current"

		REAL V				UNITS u_V				"Voltage"

		REAL Pel				UNITS u_W				"Electrical power"

		REAL Z				UNITS u_1_K				"Figure of Merit"

		REAL DT				UNITS u_K				"Temperature jump"
		REAL DTmax			UNITS u_K				"Maximum temperature jump"

		REAL COP				UNITS no_units			"Coefficient of performance"
		REAL COPopt			UNITS no_units			"Optimum coefficient of performance"

		REAL qin				UNITS u_W				"Inlet heat flux"
		REAL qout			UNITS u_W				"Outlet heat flux"

	INIT
		ASSERT (n > 0) FATAL "Peltier component: Number of nodes must be at least 1"

	CONTINUOUS
		-- Calculation of the side temperatures and the average temperature
		Tk_in  = SUM (i IN 1, n; tp_in.Tk[i]) / n 
		Tk_out = SUM (i IN 1, n; tp_out.Tk[i]) / n 
		Tk_ave = 0.5 * (Tk_in + Tk_out)

		-- Calculation of material properties
		a = (a_coef[1] + a_coef[2] * Tk_ave + a_coef[3] * Tk_ave**2)
		r = (r_coef[1] + r_coef[2] * Tk_ave + r_coef[3] * Tk_ave**2) 
		k = (k_coef[1] + k_coef[2] * Tk_ave + k_coef[3] * Tk_ave**2)

		V = 2 * NTE * ((I * r / G) + a * DT)

		Pel = I * V

		-- Calculation of thermoelectric module performance
		Z = a**2 / (r * k)
		DT = Tk_out - Tk_in
		COP = SUM(i IN 1, n; tp_in.q[i]) / (Pel + 1.e-6)

		qin = 2 * NTE * (a * I * Tk_in - I**2 * r /(2 * G) - k * DT * G)
		qout = 2 * NTE * (a * I * Tk_out + I**2 * r /(2 * G) - k * DT * G)

		-- Optimum point
		Iopt = k * DT * G * (1 + (1 + Z * Tk_ave)**0.5) / (a * Tk_ave)
		COPopt = (Tk_ave / max(DT, 1.e-5)) * (sqrt(1 + Z * Tk_ave) - 1) / \
			(sqrt(1 + Z * Tk_ave) + 1) - 0.5

		-- Maximum point (maximum DT, q = 0)
		Imax = (k * G / a) * (sqrt(1 + 2 * Z * Tk_out) - 1)
		DTmax = 0.5 * Z * Tk_in**2

		-- Positive heat flow from the tp_in port to tp_out port
		EXPAND_BLOCK (i IN 1, n)
			tp_in.q[i] = qin / n
			tp_out.q[i] = tp_in.q[i] + Pel / n
		END EXPAND_BLOCK

		-- Positive intensity from the n-type material to the p-type material
		e_p.i = I
		e_n.i = -I
		e_n.v = e_p.v - V

END COMPONENT

