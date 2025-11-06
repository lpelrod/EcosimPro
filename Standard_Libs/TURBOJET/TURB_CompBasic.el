--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: TURB_CompBasic.el
-- DESCRIPTION: Defines basic components
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 17/02/1999
--------------------------------------------------------------------------------

-- Libraries
USE PORTS_LIB 
USE CONTROL 
USE MATH 


-- Abstract components
--------------------------------------------------------------------------------
-- Abstract component for definition of components with a gas inlet and a gas
-- outlet
--------------------------------------------------------------------------------
ABSTRACT COMPONENT GasInGasOut
   "Abstract component for definition of components with a gas inlet and a gas outlet"

   PORTS
      IN Gas g_in                 "Inlet gas port"
      OUT Gas g_out               "Outlet gas port"

   TOPOLOGY 
      PATH g_in TO g_out

END COMPONENT

--------------------------------------------------------------------------------
-- Abstract component for definition of components with a gas inlet, a gas
-- outlet, and a some extra variables
--------------------------------------------------------------------------------
ABSTRACT COMPONENT GasChannel IS_A GasInGasOut
   "Abstract component for definition of components with a gas inlet, a gas outlet, and a some extra variables"

   DECLS
      REAL PQ			UNITS no_units		"Pressure quotient"
      REAL delta     UNITS no_units		"Adimensionalised inlet total pressure"
      REAL theta     UNITS no_units		"Adimensionalised inlet total temperature"

   CONTINUOUS
      theta = g_in.T / Tstd
      delta = g_in.P / Pstd

      g_out.P = g_in.P * PQ

END COMPONENT

--------------------------------------------------------------------------------
-- Abstract component for definition of turbomachinery components
--------------------------------------------------------------------------------
ABSTRACT COMPONENT GasTurbo IS_A GasChannel
   "Abstract component for definition of turbomachinery components"

   PORTS
      IN 	Shaft sh_in						"Input mechanical port"
      OUT 	Shaft sh_out            	"Output mechanical port"

	DATA
      REAL 	I = 10.	UNITS  u_kgm2		"Inertial moment"

   DECLS
      REAL WR			UNITS  u_kg_s		"Corrected Flow Rate"

      REAL Power		UNITS  u_W			"Mechanical power"

      REAL DN			UNITS  u_rpm_s		"Derivative of rotational speed"
      REAL N			UNITS  u_rpm		"Rotational speed"

   CONTINUOUS
      WR = g_in.W * sqrt(theta) / delta

<E>   Power = g_in.W * (g_in.H - g_out.H)

      I * (PI / 30.)**2 * N * DN = Power + sh_in.Power - sh_out.Power

      N' = DN

      sh_in.N = N
      sh_out.N = N

END COMPONENT


-- Components
--------------------------------------------------------------------------------
-- Component that represents a station plane
--------------------------------------------------------------------------------
COMPONENT Plane IS_A GasInGasOut
   "Station plane"

   CONTINUOUS
      g_out.W = g_in.W
      g_out.P = g_in.P
      g_out.T = g_in.T
      g_out.FAR = g_in.FAR

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents an inlet
--------------------------------------------------------------------------------
COMPONENT Inlet
   "Inlet"

   PORTS
      OUT Gas g_out               "Outlet gas port"
      OUT Force thrust            "Output force port"

   DATA
      REAL dTamb = 0.						UNITS u_K			"Delta temperature with respect to ISA"
      REAL Rhum = 30. 		UNITS no_units	RANGE 0.,100.	"Relative humidity" 

      ENUM PressLossMode ERAM = FromData    					"Efficiency calculation mode"
      REAL zeram = 0.99                UNITS no_units		"Efficiency"
      TABLE_1D eramxx = {
            {0., 12.5, 25., 30.},
            {1.00, 0.99, 0.98, 0.97}
         } UNITS no_units	"Efficiency vs corrected mass flow kg/s"

   DECLS
      REAL Pamb	UNITS u_Pa			"ISA ambient pressure"
      REAL Tamb	UNITS u_K			"ISA ambient temperature"

      REAL Ts		UNITS u_K			"Static temperature at inlet"
      REAL Psat	UNITS u_Pa     	"Water vapour saturation pressure"
      REAL k		UNITS no_units		"Ratio of specific heats"
      REAL v		UNITS u_m_s			"Flight speed"
      REAL Hs		UNITS u_J_kg		"Static enthalpy"
      REAL Pt_in	UNITS u_Pa			"Total inlet pressure"
      REAL Tt_in	UNITS u_K      	"Total inlet temperature"
      REAL PQ		UNITS no_units		"Total pressures ratio from inlet to outlet"
      REAL WR		UNITS u_kg_s		"Corrected mass flow"

   CONTINUOUS
      -- ISA pressure and temperature
      STD_Atmosphere(Altitude, Pamb, Tamb)

      -- Air composition
      g_out.FAR = 0.

      Ts = Tamb + dTamb

      Psat = psat_H2O(Ts)

      k = Cp_T_FAR(Ts, g_out.FAR) / (Cp_T_FAR(Ts, g_out.FAR) - R_FAR(g_out.FAR))

      v = Mach * ssqrt(k * R_FAR(g_out.FAR) * Ts)

      Hs = H_T_FAR(Ts, g_out.FAR)

      g_out.H = Hs + 0.5 * v**2

      Pt_in = Pamb * exp((Phi_T_FAR(g_out.T, g_out.FAR) - Phi_T_FAR(Tamb, g_out.FAR)) / R_FAR(g_out.FAR))

      Tt_in = T_H_FAR(g_out.H, g_out.FAR)

      WR = g_out.W * ssqrt(Tt_in / Tstd) / (Pt_in / Pstd)

      PQ = ZONE (ERAM == FromData)  zeram
           ZONE (ERAM == FromTable) splineInterp1D(eramxx, WR)
           OTHERS                   0.

      g_out.P = Pt_in * PQ

      thrust.F = -g_out.W * v

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a compressor
--------------------------------------------------------------------------------
COMPONENT Compressor IS_A GasTurbo
   "Compressor"

   DATA
      REAL ND = 10000.	UNITS	u_rpm	           "Design rotational speed"
      REAL CG1 = 1.		UNITS no_units            "Correction coefficient for corrected mass flow"
      REAL CG2 = 1.		UNITS no_units            "Correction coefficient for efficiency"
      REAL CG4 = 1.		UNITS no_units            "Correction coefficient for compression work"

      -- Compressor map
      TABLE_2D F1			UNITS u_J_kgK             "Compression work (J/kg*K) vs adimensional speed (-) and beta parameter (-)"
      TABLE_2D F2			UNITS no_units            "Efficiency (-) vs adimensional speed (-) and beta parameter (-)"
      TABLE_2D F3			UNITS u_kg_s              "Corrected mass flow (kg/s) vs adimensional speed (-) and beta parameter (-)"

   DECLS
      REAL beta = 0.7	UNITS no_units					"Beta parameter"
      REAL PCNR			UNITS u_pct	             	"Adimensional rotational speed"

      REAL DHQTJ			UNITS u_J_kgK              "Non scaled compression work"
      REAL EPDJ			UNITS no_units					"Non scaled efficiency"
      REAL WRJ				UNITS u_kg_s               "Non scaled corrected mass flow"

      REAL DHQT			UNITS u_J_kgK	            "Compression work"
      REAL EPD				UNITS no_units					"Efficiency"

   CONTINUOUS
      -- Conservation of air mass
<M>   g_in.W = g_out.W

      -- Conservation of fuel mass
      g_in.FAR = g_out.FAR

      -- Adimensional rotational speed
      PCNR = 100. * (sh_in.N / ND) / ssqrt(theta)

      DHQTJ = splineInterp2D(F1, PCNR, beta)
      EPDJ = splineInterp2D(F2, PCNR, beta)
      WRJ = splineInterp2D(F3, PCNR, beta)

      DHQT = CG4 * DHQTJ
      EPD = CG2 * EPDJ
      IMPL(beta) g_in.W * ssqrt(theta) / delta = CG1 * WRJ

      g_out.H = g_in.H + DHQT * g_in.T

      (Phi_T_FAR(g_out.T, g_in.FAR) - Phi_T_FAR(g_in.T, g_in.FAR)) * EPD = \
         R_FAR(g_in.FAR) * log(PQ)

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a fan
--------------------------------------------------------------------------------
COMPONENT Fan IS_A Compressor
   "Fan"

   PORTS
      OUT Gas g_pr	               "Outlet primary gas port"

   DATA
      REAL DH_ratio 	= 0.9		UNITS no_units		"Scalar for primary flow compression work"
      REAL EPD_ratio = 0.9		UNITS no_units		"Scalar for primary flow efficiency"

   DECLS
      ALG REAL BPR				UNITS no_units		"By pass ratio"

   CONTINUOUS
<:M>  g_pr.W = (1. / (1. + BPR)) * g_in.W
      g_out.W = (BPR / (1. + BPR)) * g_in.W

      g_pr.FAR = g_in.FAR

      g_pr.H = g_in.H + DH_ratio * DHQT * g_in.T

      (Phi_T_FAR(g_pr.T, g_in.FAR) - Phi_T_FAR(g_in.T, g_in.FAR)) * EPD_ratio * EPD = \
         R_FAR(g_in.FAR) * log(g_pr.P / g_in.P)

<:E>  Power = g_in.W * g_in.H - g_out.W * g_out.H - g_pr.W * g_pr.H

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a burner
--------------------------------------------------------------------------------
COMPONENT Burner IS_A GasChannel
   "Burner"

   PORTS
      IN Fuel f_in                "Inlet fuel port"

   DATA
      REAL VOL = 1.	UNITS u_m3		"Chamber volume"
      REAL GLP = 0.	UNITS u_s_kg	"Loss coefficient"

      REAL CX[6] = {99.7, -0.004568246, 0.000300007, -8.73718e-6, 3.97923e-8, -5.46974e-11} "Coefficients for efficiency calculation from air loading"

   DECLS
      REAL AL 			UNITS	u_kg_sm3		"Air loading"
      REAL eta			UNITS no_units		"Efficiency"

   CONTINUOUS
      g_out.W = g_in.W + f_in.W
      g_out.W * g_out.FAR / (1 + g_out.FAR) = g_in.W * g_in.FAR / (1 + g_in.FAR) + f_in.W

      AL = g_in.W / (VOL * (g_in.P / Pstd)**1.8 * 10**(0.00145 * (g_in.T - 400)))

      eta = poly(AL, 6, CX) / 100.

      g_out.W * g_out.H = g_in.W * g_in.H + eta * f_in.W * f_in.FHV * 1000.

      PQ = 1. - GLP * ((g_in.W * theta / ssqrt(delta)))

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a turbine
--------------------------------------------------------------------------------
COMPONENT Turbine IS_A GasTurbo
   "Turbine"

   DATA
      REAL CG1 = 1.		UNITS no_units               "Correction coefficient for corrected mass flow"
      REAL CG2 = 1.		UNITS no_units               "Correction coefficient for efficiency"
      REAL CG3 = 1.		UNITS no_units               "Correction coefficient for rotational speed"
      REAL CG4 = 1.		UNITS no_units               "Correction coefficient for power"

      -- Turbine map
      TABLE_2D G1			UNITS u_kg_s						"Corrected mass flow (kg/s) vs power (J/kg*K) and corrected rotational speed (rpm)"
      TABLE_2D G2			UNITS no_units                "Efficiency (-) vs power (J/kg*K) and corrected rotational speed (rpm)"

   DECLS
      REAL DHQTJ			UNITS u_J_kgK						"Non scaled power"
      REAL NRJ				UNITS u_rps							"Non scaled corrected rotational speed"
      REAL WRJ				UNITS u_kg_s						"Non scaled corrected mass flow"
      REAL EPDJ			UNITS no_units						"Non scaled efficiency"

      REAL DHQT			UNITS u_J_kgK						"Power"
      REAL NR				UNITS u_rps							"Corrected rotational speed"
      REAL EPD				UNITS no_units						"Efficiency"

   CONTINUOUS
      -- Conservation of air mass
      g_out.W = g_in.W

      -- Conservation of fuel mass
      g_out.FAR = g_in.FAR

      DHQT = Power / (g_in.W * g_in.T)
      NR = sh_out.N / ssqrt(g_in.T)

      DHQTJ = DHQT / CG4
      NRJ = NR / CG3

      WRJ = splineInterp2D(G1, DHQTJ, NRJ)
      EPDJ = splineInterp2D(G2, DHQTJ, NRJ)

      IMPL(g_out.T) WR - CG1 * WRJ = 0.
      EPD = CG2 * EPDJ

      R_FAR(g_in.FAR) * log(PQ) = \
         (Phi_T_FAR(g_out.T, g_in.FAR) - Phi_T_FAR(g_in.T, g_in.FAR)) / EPD

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a mixer
--------------------------------------------------------------------------------
COMPONENT Mixer
   "Mixer"

   PORTS
      IN Gas g_in1                "Primary inlet gas port"
      IN Gas g_in2                "Secondary inlet gas port"
      OUT Gas g_out               "Outlet gas port"

   DATA
      REAL A1 = 1.	UNITS u_m2		"Primary cross sectional area"
      REAL A2 = 2.	UNITS u_m2		"Secondary cross sectional area"

   DECLS
      REAL Rgas1		UNITS u_J_kgK		"Primary flow gas constant"
      REAL Rgas2		UNITS u_J_kgK		"Secondary flow gas constant"
      REAL Rgas_out	UNITS u_J_kgK		"Mixed flow gas constant"

      REAL Ts1			UNITS u_K         "Primary flow static temperature"
      REAL Ts2			UNITS u_K         "Secondary flow static temperature"
      REAL Ts_out 	UNITS u_K         "Mixed flow static temperature"

      REAL Hs1	 		UNITS u_J_K       "Primary flow static enthalpy"
      REAL Hs2	 		UNITS u_J_K       "Secondary flow static enthalpy"
      REAL Hs_out	 	UNITS u_J_K       "Mixed flow static enthalpy"

      REAL c1	 	UNITS u_m_s          "Primary flow sound speed"
      REAL c2	 	UNITS u_m_s          "Secondary flow sound speed"
      REAL c_out	UNITS u_m_s          "Mixed flow sound speed"

      REAL v1		UNITS u_m_s          "Primary flow mass flow speed"
      REAL v2		UNITS u_m_s          "Secondary flow mass flow speed"
      REAL v_out	UNITS u_m_s          "Mixed flow mass flow speed"

      REAL M1		UNITS no_units       "Primary flow Mach number"
      REAL M2		UNITS no_units       "Secondary flow Mach number"
      REAL M_out	UNITS no_units       "Mixed flow Mach number"

      REAL Ps1		UNITS u_Pa           "Primary flow static pressure"
      REAL Ps2		UNITS u_Pa           "Secondary flow static pressure"
      REAL Ps_out	UNITS u_Pa           "Mixed flow static pressure"

      REAL rhos1	UNITS u_kg_m3        "Primary flow static density"
      REAL rhos2	UNITS u_kg_m3        "Secondary flow static density"
      REAL rhos_out	UNITS u_kg_m3     "Mixed flow static density"

      REAL dyn		UNITS u_Pa           "Dynamic pressure"

   CONTINUOUS
      Rgas1 = R_FAR(g_in1.FAR)
      Rgas2 = R_FAR(g_in2.FAR)

      Ts1 = T_Phi_FAR(Phi_T_FAR(g_in1.T, g_in1.FAR) - Rgas1 * log(g_in1.P / Ps1), g_in1.FAR)
      Ts2 = T_Phi_FAR(Phi_T_FAR(g_in2.T, g_in2.FAR) - Rgas2 * log(g_in2.P / Ps2), g_in2.FAR)

      Hs1 = H_T_FAR(Ts1, g_in1.FAR)
      Hs2 = H_T_FAR(Ts2, g_in2.FAR)

      c1 = Vs_T_FAR(Ts1, g_in1.FAR) 
      c2 = Vs_T_FAR(Ts2, g_in2.FAR)

      v1 = ssqrt(2 * (g_in1.H - Hs1))
      v2 = ssqrt(2 * (g_in2.H - Hs2))

      M1 = v1 / c1
      M2 = v2 / c2

      Ps1 = Ps2

      rhos1 = Ps1 / (Rgas1 * Ts1)
      rhos2 = Ps2 / (Rgas2 * Ts2)

      IMPL(g_in1.W) g_in1.W = rhos1 * A1 * v1
      IMPL(g_in2.W) g_in2.W = rhos2 * A2 * v2

      g_out.W = g_in1.W + g_in2.W

      g_out.FAR / (1 + g_out.FAR) = (g_in1.WF + g_in2.WF) / (g_in1.W + g_in2.W)

      g_out.H = (g_in1.WH + g_in2.WH) / (g_in1.W + g_in2.W)

      Rgas_out = R_FAR(g_out.FAR)

      rhos_out = Ps_out / (Rgas_out * Ts_out)

      c_out = Vs_T_FAR(Ts_out, g_out.FAR)

      v_out = g_out.W / (rhos_out * (A1 + A2))

      M_out = v_out / c_out

      dyn = ((Ps1 + rhos1 * v1**2) * A1 + (Ps1 + rhos2 * v2**2) * A2) / (A1 + A2)

      g_out.P = FannoLine((g_in1.W + g_in2.W) / (A1 + A2), g_out.H, g_out.T, g_out.FAR, \
         dyn, Ps_out, Hs_out, Ts_out)

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents an afterburner
--------------------------------------------------------------------------------
COMPONENT AfterBurner IS_A GasChannel
   "Afterburner"

   PORTS
      IN Fuel f_in                "Inlet fuel port"

	DATA
      REAL A = 1.                 "Cross sectional area (m^2)"
      REAL Cd = 0.1               "Drag coefficient (-)"
      REAL eta = 0.98             "Combustion efficiency (-)"

   DECLS
      REAL Ps_in	UNITS u_Pa      "Inlet flow static pressure"
      REAL Ps_out	UNITS u_Pa      "Static pressure at outlet"

      REAL Hs_in	UNITS u_J_kg    "Inlet flow static enthalpy"
      REAL Hs_out	UNITS u_J_kg    "Static enthalpy at outlet"

      REAL Ts_in	UNITS u_K       "Inlet flow static temperature"
      REAL Ts_out	UNITS u_K       "Static temperature at outlet"

      REAL Rgas_in	UNITS u_J_kgK	"Inlet flow gas constant"
      REAL Rgas_out	UNITS u_J_kgK	"Gas constant at outlet"

      REAL rhos_in	UNITS u_kg_m3  "Inlet flow static density"
      REAL rhos_out	UNITS u_kg_m3  "Static density at outlet"

      REAL c_in		UNITS u_m_s    "Inlet flow sound speed"
      REAL c_out		UNITS u_m_s    "Speed of sound at outlet"

      REAL v_in 		UNITS u_m_s		"Inlet flow speed"
      REAL v_out		UNITS u_m_s		"Fluid speed at outlet"

      REAL M_in		UNITS no_units "Inlet flow Mach number"
      REAL M_out		UNITS no_units "Outlet flow Mach number"

      REAL dyn_in		UNITS u_Pa     "Inlet flow dynamic pressure"
      REAL dyn_out	UNITS u_Pa     "p + rho*v**2 at outlet"

   CONTINUOUS
      g_out.W = g_in.W + f_in.W

      g_out.FAR / (1 + g_out.FAR) = (g_in.WF + f_in.W) / g_out.W

      g_out.W * g_out.H = g_in.W * g_in.H + eta * f_in.W * f_in.FHV * 1000.

      Static_vs_WA(g_in.W / A, g_in.P, g_in.H, g_in.T, g_in.FAR, SubSonic, Ps_in, Hs_in, Ts_in)

      Rgas_in = R_FAR(g_in.FAR)
      Rgas_out = R_FAR(g_out.FAR)

      rhos_in = Ps_in / (Rgas_in * Ts_in)
      rhos_out = Ps_out / (Rgas_out * Ts_out)

      c_in = Vs_T_FAR(Ts_in, g_in.FAR) 
      c_out = Vs_T_FAR(Ts_out, g_out.FAR)

      v_in = g_in.W / (rhos_in * A)
      v_out = g_out.W / (rhos_out * A)

      M_in = v_in / c_in
      M_out = v_out / c_out

      dyn_in = Ps_in + rhos_in * v_in**2
      dyn_out = dyn_in - 0.5 * Cd * rhos_in * spow2(v_in)

      g_out.P = FannoLine(g_out.W / A, g_out.H, g_out.T, g_out.FAR, dyn_out, Ps_out, Hs_out, Ts_out)

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a nozzle
--------------------------------------------------------------------------------
COMPONENT Nozzle
   "Nozzle"

   PORTS
      IN Gas g_in                 "Inlet gas port"
      OUT Force thrust            "Output force port"

   DATA
      REAL A_exit = 1.			UNITS u_m2	 RANGE ZERO,Inf    "Exit area"

   DECLS
      REAL A_exit_v				UNITS u_m2    "Exit area"

      REAL Pamb					UNITS u_Pa    "ISA ambient pressure"
      REAL Tamb					UNITS u_K     "ISA ambient temperature"

      REAL Rgas					UNITS u_J_kgK "Gas constant"

      REAL Ts_out_choked 		UNITS u_K	"Choked outlet gas flow static temperature"
      REAL Ps_out_choked		UNITS u_Pa	"Choked outlet gas flow static pressure"

      REAL Ts_out 				UNITS u_K         "Outlet gas flow static temperature"
      REAL Ps_out 				UNITS u_Pa        "Outlet gas flow static pressure"

      REAL v_out 					UNITS u_m_s       "Outlet gas flow speed"

   CONTINUOUS
<G>   A_exit_v = A_exit

      STD_Atmosphere(Altitude, Pamb, Tamb)

      Rgas = R_FAR(g_in.FAR)

      -- Ideal nozzle
      Ts_out_choked = Tcrit_T_FAR(g_in.T, g_in.FAR)

      Ps_out_choked = g_in.P / exp((Phi_T_FAR(g_in.T, g_in.FAR) - Phi_T_FAR(Ts_out_choked, g_in.FAR)) / Rgas)

      Ps_out = max(Ps_out_choked, Pamb)

      Ts_out = T_Phi_FAR(Phi_T_FAR(g_in.T, g_in.FAR) - Rgas * log(g_in.P / Ps_out), g_in.FAR)

      v_out = ssqrt(2. * (g_in.H - H_T_FAR(Ts_out, g_in.FAR)))

     -- IMPL() 0 = A_exit - g_in.W / ((Ps_out / (Rgas * Ts_out)) * v_out)
      0 = A_exit - g_in.W / ((Ps_out / (Rgas * Ts_out)) * v_out)

      thrust.F = g_in.W * v_out + A_exit * (Ps_out - Pamb)

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a variable area nozzle
--------------------------------------------------------------------------------
COMPONENT Nozzle_Var IS_A Nozzle
   "Variable area nozzle"

   PORTS
      IN analog_signal s_Area		"Inlet area signal port (m^2)"

   CONTINUOUS
<:G>  A_exit_v = A_exit * s_Area.signal[1]

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a convergent-divergent nozzle
--------------------------------------------------------------------------------
COMPONENT Nozzle_ConDiv
   "Convergent-divergent nozzle"

   PORTS
      IN Gas g_in                 "Inlet gas port"
      OUT Force thrust            "Output force port"

   DATA
      REAL A_throat = 0.9	UNITS u_m2 RANGE ZERO,Inf    		"Throat area"
      REAL A_exit = 1.		UNITS u_m2 RANGE ZERO,Inf       	"Exit area"

   DECLS
      REAL Pamb	UNITS u_Pa      "ISA ambient pressure"
      REAL Tamb 	UNITS u_K       "ISA ambient temperature"

      REAL Rgas	UNITS u_J_kgK   "Gas constant"

      REAL Ts_out_choked 	UNITS u_K	"Choked outlet gas flow static temperature"
      REAL Ps_out_choked	UNITS u_Pa	"Choked outlet gas flow static pressure"

      REAL Ts_out 	UNITS u_K			"Outlet gas flow static temperature"
      REAL Ps_out		UNITS u_Pa			"Outlet gas flow static pressure"

      REAL v_out                  "Outlet gas flow speed (m/s)"

   CONTINUOUS
      STD_Atmosphere(Altitude, Pamb, Tamb)

      Rgas = R_FAR(g_in.FAR)

      -- Ideal nozzle
      Ts_out_choked = Tcrit_T_FAR(g_in.T, g_in.FAR)

      Ps_out_choked = g_in.P / exp((Phi_T_FAR(g_in.T, g_in.FAR) - Phi_T_FAR(Ts_out_choked, g_in.FAR)) / Rgas)

      Ps_out = ZONE (Ps_out_choked > Pamb) Ps_out_choked
               OTHERS                      Pamb

      Ts_out = T_Phi_FAR(Phi_T_FAR(g_in.T, g_in.FAR) - Rgas * log(g_in.P / Ps_out), g_in.FAR)

      v_out = ssqrt(2. * (g_in.H - H_T_FAR(Ts_out, g_in.FAR)))

      IMPL(g_in.W) 0 = A_exit - g_in.W / ((Ps_out / (Rgas * Ts_out)) * v_out)

      thrust.F = g_in.W * v_out + A_exit * (Ps_out - Pamb)

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents an ideal pipe (withou pressure drop)
--------------------------------------------------------------------------------
COMPONENT Pipe IS_A GasChannel
   "Ideal pipe (withou pressure drop)"

   DECLS
      REAL A	UNITS u_m2                     "Cross sectional area"

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a gas flow splitter
--------------------------------------------------------------------------------
COMPONENT SplitFrac
   "Gas flow splitter"

	PORTS
      IN Gas g_in                 "Inlet gas port"
      OUT Gas g_out               "Outlet gas port"
      OUT Gas g_branch            "Branch gas port"

   DATA
      REAL k = 0.04	UNITS no_units	"Branch mass flow fraction"

   TOPOLOGY
      PATH g_in TO g_out

   CONTINUOUS
      g_out.W = (1 - k) * g_in.W 
      g_branch.W = k * g_in.W

      g_out.FAR = g_in.FAR
      g_branch.FAR = g_in.FAR

      g_out.P = g_in.P

      g_out.H = g_in.H
      g_branch.H = g_in.H

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a gas flow junction
--------------------------------------------------------------------------------
COMPONENT Junction
   "Gas flow junction"

   PORTS
      IN Gas g_in1                "Inlet gas port"
      IN Gas g_in2                "Inlet gas port"
      OUT Gas g_out               "Outlet gas port"

   DATA
      REAL c1 = 1.                "Scalar for g_in1 flow"
      REAL c2 = 1.                "Scalar for g_in2 flow"

   CONTINUOUS
      g_out.W = c1 * g_in1.W + c2 * g_in2.W

      g_out.FAR / (1 + g_out.FAR) = (c1 * g_in1.WF + c2 * g_in2.WF) / g_out.W

      g_out.H = (c1 * g_in1.WH + c2 * g_in2.WH) / g_out.W

      g_out.P = g_in1.P
      g_out.P = g_in2.P

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a regenerator
--------------------------------------------------------------------------------
COMPONENT Regenerator
   "Regenerator"

   PORTS
      IN Gas g_gas_in             "Inlet gas port"
      IN Gas g_cold_in            "Inlet colder gas port"
      OUT Gas g_gas_out           "Outlet gas port"
      OUT Gas g_cold_out          "Outlet colder gas port"

   DECLS
      REAL Q	UNITS u_W                      "Heat transfer"

      REAL cp_gas		UNITS u_J_kgK	"Specific heat at constant pressure"
      REAL cp_cold	UNITS u_J_kgK	"Specific heat at constant pressure"

      REAL C_gas		UNITS u_J_K		"Heat capacity"
      REAL C_cold		UNITS u_J_K		"Heat capacity"

   CONTINUOUS
      g_gas_out.W = g_gas_in.W
      g_cold_out.W = g_cold_in.W

      Q = g_gas_in.WH - g_gas_out.WH
      Q = g_cold_out.WH - g_cold_in.WH

      cp_gas = (H_T_FAR(g_gas_in.T, g_gas_in.FAR) - H_T_FAR(g_gas_out.T, g_gas_out.FAR)) / \
         (g_gas_in.T - g_gas_out.T)

      cp_cold = (H_T_FAR(g_cold_out.T, g_cold_out.FAR) - H_T_FAR(g_cold_in.T, g_cold_in.FAR)) / \
         (g_cold_out.T - g_cold_in.T)

      C_gas  = g_gas_in.W * cp_gas
      C_cold = g_cold_in.W * cp_cold

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a mechanical gear
--------------------------------------------------------------------------------
COMPONENT Gear
   "Mechanical gear"

   PORTS
      IN Shaft sh_in              "Inlet mechanical port"
      OUT Shaft sh_out            "Outlet mechanical port"

   DATA
      REAL eff = 0.9			UNITS no_units		"Efficiency"

      REAL Nratio = 0.25	UNITS no_units		"Rotational speeds ratio"

      REAL I1 = 1.			UNITS u_kg_m2   	"Inlet gear inertia moment"
      REAL I2 = 4.			UNITS u_kg_m2   	"Outlet gear inertia moment"

   DECLS
      REAL Power 				UNITS u_W       	"Transmited power"

   CONTINUOUS
      sh_out.N = sh_in.N * Nratio

      I2 * sh_out.N * sh_out.N' = eff * Power - sh_out.Power
      I1 * sh_in.N * sh_in.N' = sh_in.Power - Power

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a mechanical shaft with inertia
--------------------------------------------------------------------------------
COMPONENT ShaftI
   "Mechanical shaft with inertia"

   PORTS
      IN Shaft sh_in              "Inlet mechanical port"
      OUT Shaft sh_out            "Outlet mechanical port"

   DATA
      REAL I = 1.				UNITS u_kg_m2  	"Shaft inertia moment"

   CONTINUOUS
      sh_in.N = sh_out.N

      I * sh_in.N * sh_in.N' = sh_in.Power - sh_out.Power

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a mechanical shaft end
--------------------------------------------------------------------------------
COMPONENT ShaftEnd
   "Mechanical shaft end"

	PORTS
      IN Shaft sh_in              "Inlet mechanical port"

   CONTINUOUS
      sh_in.Power = 0.

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a fuel tank
--------------------------------------------------------------------------------
COMPONENT FuelTank
   "Fuel tank"

   PORTS
      OUT Fuel f_out

   DATA
      REAL FHV = 43200.		UNITS u_kJ_kg     "Fuel heat value"

      REAL X[FuelComp] = {0.25, 0.75, 0.}   "Mass fractions of H, C, and S in fuel"

   CONTINUOUS
      f_out.FHV = FHV

      EXPAND (j IN FuelComp)
         f_out.X[j] = X[j]

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a fuel flow control valve
--------------------------------------------------------------------------------
COMPONENT FuelValve
   "Fuel flow control valve"

   PORTS
      IN analog_signal s_flow			"Input fuel flow control signal port (kg/s)"
      IN Fuel f_in                	"Inlet fuel port"
      OUT Fuel f_out              	"Outlet fuel port"

   DATA
      REAL k = 1.	UNITS no_units 	"Valve coefficient"

   CONTINUOUS
      f_out.W = k * s_flow.signal[1]
      f_out.W = f_in.W

      f_out.FHV = f_in.FHV

      f_out.X = f_in.X

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a fuelmeter
--------------------------------------------------------------------------------
COMPONENT Fuelmeter
   "Fuelmeter"

   PORTS
      IN Fuel f_in                				"Inlet fuel port"
      OUT Fuel f_out              				"Outlet fuel port"
      OUT analog_signal s_out						"Output fuel mass flow signal port (kg/s)"

   TOPOLOGY
      PATH f_in TO f_out

   CONTINUOUS
      f_in.W = f_out.W
      f_in.FHV = f_out.FHV
      f_in.X = f_out.X

      s_out.signal[1] = f_in.W

END COMPONENT

--------------------------------------------------------------------------------
-- Component that represents a performances monitor
--------------------------------------------------------------------------------
COMPONENT Monitor
   "Performances monitor"

   PORTS
      IN analog_signal s_fuel					     	"Input fuel mass flow signal port (kg/s)"
      IN Force thrust             					"Input force port"

   DECLS
      REAL SFC						UNITS u_kg_Ns     "Specific fuel consumption"
      REAL Thrust_kgf			UNITS u_kgf       "Thrust"

   CONTINUOUS
      SFC = s_fuel.signal[1] / thrust.F

      Thrust_kgf = thrust.F / g

END COMPONENT
