--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompFreeConvec.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Natural convection couplings for THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Stefano Naclerio
--		CREATION DATE:	18-Jan-2008
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 


ENUM WallType = {wall, floor, ceil}

--------------------------------------------------------------------------------
-- Component FreeConvec_simple
--------------------------------------------------------------------------------
-- Purpose:
--    Coupling to calculate natural convection from a surface to a simplified fluid
---------------------------------------------------------------------------------
COMPONENT FreeConvec_simple 
(
	INTEGER n = 1
) \
	"Natural convection from a surface to a simplified fluid"
	PORTS
		IN thermal (n = n) tp_in					"Inlet thermal ports"
		IN analog_signal (n = 1) s_fluid_tem	"Fluid temperature signal"
	DATA
		REAL A = 1					UNITS u_m2		"Convective heat exchange area"
		REAL Lc = 0.1				UNITS u_m		"Characteristic length"
		REAL b_l = 1.32			UNITS "W/m^1.75 K^1.25"	"Coefficient b in hc = b * (DT/Lc)^0.25 for laminar regime" 
		REAL b_t = 1.24			UNITS "W/m^2 K^1.333"	"Coefficient b in hc = b * DT**0.3333   for turbulent regime"-- (W/m^2 K^1.333)"
		--Default values for b_l and b_t correspond to air 
	DECLS
		REAL T_fluid = 293.15	UNITS u_K		"Fluid Temperature"
		REAL DT[n]    = 0			UNITS u_K		"Temperature difference"
		REAL hc[n]    = 0			UNITS u_W_m2K	"Heat transfer coefficient"
		REAL hc_l[n]  = 0			UNITS u_W_m2K	"Laminar heat transfer coefficient"
		REAL hc_t[n]  = 0			UNITS u_W_m2K	"Turbulent heat transfer coefficient"
		CONST REAL n_exp = 20.	UNITS no_units	"Exponent for laminar turbulent transition"              
	INIT
      
	CONTINUOUS
		T_fluid = s_fluid_tem.signal[1]

		EXPAND_BLOCK (i IN 1, n)  
			DT[i] = abs(tp_in.Tk[i] - T_fluid)  

			hc_l[i] = b_l * (DT[i]/Lc)**0.25    
			hc_t[i] = b_t * DT[i]**(1./3.) 

			hc[i] = (hc_l[i]**n_exp + hc_t[i]**n_exp)**(1./n_exp)    

			--  Thermal conductance
			tp_in.q[i]  = hc[i] * (A / n) * (tp_in.Tk[i] - T_fluid)       

		END EXPAND_BLOCK

END COMPONENT

COMPONENT FreeConvec_Plate
(
	INTEGER n = 1								UNITS no_units		"Dimension of thermal port",
	ENUM WallType position = wall			UNITS no_units		"Film Type",
	ENUM ThFluids thermal_fluid = Air	UNITS no_units		"Interface Fluid"
)

	PORTS
		IN  thermal (n = n) tp_surface  CARDINALITY 0, 1	"Thermal inlet port"
		OUT thermal (n = n) tp_fluid CARDINALITY 0, 1		"Thermal outlet port"
	DATA
		REAL A = 1  				UNITS u_m2 				RANGE 0, Inf		"Convective heat exchange area"
		REAL Lc = 0.1 				UNITS u_m				RANGE 0, Inf		"Height for vertical plate OR perimeter for floor and ceiling option"
		REAL P = 101325 			UNITS u_Pa				RANGE 0, Inf		"Ambient pressure"
		REAL Grav = 9.80665		UNITS u_m_s2			"Gravity"

	DECLS
		REAL q[n]								UNITS u_W			"Heat flux"
		REAL DT[n] = 0							UNITS u_K			"Temperature difference"
		REAL Cp[n] = 0							UNITS u_W_kgK		"Specific heat"
		REAL vis[n]= 0.0001 		UNITS u_kg_sm			RANGE 0, Inf	"Viscosity"
		REAL rho[n]= 0   			UNITS u_kg_m3			RANGE 0, Inf 	"Density"
		REAL Tm[n]= 0				UNITS u_K			"Average Temperature"
		REAL B[n] = 0 				UNITS u_1_K				RANGE 0, Inf	"Beta factor"
		REAL Gr[n] = 0 			RANGE 0, Inf								"Grashof"
		REAL Pr[n] = 0 			RANGE 0, Inf								"Prandtl"
		REAL Ra[n] = 0 			RANGE 0, Inf								"Rayleigh"
		REAL K[n] = 0.0001 		UNITS u_W_mK			RANGE 0, Inf	"Thermal conductivity"
		REAL h[n] 					UNITS u_W_m2K			RANGE 0, Inf	"Convective Heat Transfert Coefficient"	
		REAL Nu[n] = 0 			RANGE 0, Inf						"Nusselt"
	   REAL L[n] = 0.001 		UNITS u_m				RANGE 0, Inf	"Characteristic length"	 
		INTEGER itab

	TOPOLOGY
		PATH tp_surface TO tp_fluid   
	INIT
		ASSERT (n > 0) FATAL "Conductor component: Number of nodes must be at least 1"
       
	CONTINUOUS

		EXPAND_BLOCK (i IN 1, n)  
         Fluid_prop_vs_pT(thermal_fluid, P, Tm[i], Cp[i], vis[i], rho[i], K[i], itab)
			B[i] = ZONE(position == wall) 	Fluid_beta_vs_T(thermal_fluid, tp_fluid.Tk[i], itab)
					 OTHERS     					Fluid_beta_vs_T(thermal_fluid, Tm[i], itab)
      

			DT[i] = abs(tp_surface.Tk[i] - tp_fluid.Tk[i])  
			Tm[i] = (tp_surface.Tk[i] + tp_fluid.Tk[i])/2.
			Gr[i] * vis[i]**2 = Grav * B[i] * DT[i] * L[i]**3 * rho[i]**2
			Pr[i] * K[i] = vis[i] * Cp[i]
			Ra[i] = Gr[i] * Pr[i]
	   	   
			EXPAND  (position == wall) Nu[i] = NusseltWall(Pr[i],Ra[i])
			EXPAND  (position == floor) Nu[i] = NusseltFloor(Ra[i], tp_surface.Tk[i], tp_fluid.Tk[i])
			EXPAND  (position == ceil) Nu[i] = NusseltCeiling(Ra[i],tp_surface.Tk[i], tp_fluid.Tk[i])

			EXPAND  (position == wall) L[i] = Lc
			EXPAND  (position == floor) L[i] = A / Lc 
			EXPAND  (position == ceil) L[i] = A / Lc 

			h[i] = Nu[i] * K[i] / L[i]

			-- Thermal conductance
			tp_surface.q[i]  = h[i] * (A / n) * (tp_surface.Tk[i] - tp_fluid.Tk[i])

			tp_surface.q[i] = q[i]
			tp_fluid.q[i] = q[i]       

		END EXPAND_BLOCK 

END COMPONENT


COMPONENT FreeConvec_Horizontal_Cylinder
(
	INTEGER n = 1								UNITS no_units		"Dimension of thermal port",
	ENUM ThFluids thermal_fluid = Air  	UNITS no_units	"Interface Fluid"
)

	PORTS
		IN  thermal (n = n) tp_surface CARDINALITY 0, 1	"Thermal inlet port"
		OUT thermal (n = n) tp_fluid CARDINALITY 0, 1	"Thermal outlet port"
	DATA
		REAL d = 1 				UNITS u_m	RANGE 0, Inf		"Diameter of the cylinder"
		REAL L = 0.1 			UNITS u_m	RANGE 0, Inf		"Length of the cylinder"
		REAL P = 101325 		UNITS u_Pa	RANGE 0, Inf		"Ambient pressure"
		REAL Grav = 9.80665					UNITS u_m_s2		"Gravity"
	DECLS
		REAL q[n]									UNITS u_W			"Heat flow"
		REAL DT[n] = 0								UNITS u_K			"Temperature difference"
		REAL Cp[n] = 0								UNITS u_J_kgK		"Specific heat"
		REAL vis[n] = 0.0001	UNITS u_kg_sm	RANGE 0, Inf		"Viscosity"
		REAL rho[n] = 0		UNITS u_kg_m3	RANGE 0, Inf 		"Density"
		REAL Tm[n] = 0		   					UNITS u_K			"Average Temperature"
		REAL B[n] = 0			UNITS u_1_K		RANGE 0, Inf		"Beta factor K^-1"
		REAL Gr[n] = 0			RANGE 0, Inf							"Grashof"
		REAL Pr[n] = 0			RANGE 0, Inf							"Prandtl"
		REAL Ra[n] = 0			RANGE 0, Inf							"Rayleigh"
		REAL K[n] = 0.0001	UNITS u_W_mK	RANGE 0, Inf		"Thermal conductivity"
		REAL h[n]				UNITS u_W_m2K	RANGE 0, Inf		"Convective Heat Transfert Coefficient"	
		REAL Nu[n] = 0			RANGE 0, Inf							"Nusselt"
		REAL A = 1				UNITS u_m2		RANGE 0, Inf		"Surface"	 
		INTEGER itab
   
	TOPOLOGY
		PATH tp_surface TO tp_fluid   
	INIT
		ASSERT (n > 0) FATAL "Conductor component: Number of nodes must be at least 1"
   
	CONTINUOUS

		A = PI*d*L

		EXPAND_BLOCK (i IN 1, n)  
         Fluid_prop_vs_pT(thermal_fluid, P, Tm[i], Cp[i], vis[i], rho[i], K[i], itab)
			B[i] = Fluid_beta_vs_T(thermal_fluid, tp_fluid.Tk[i], itab)

			DT[i] = abs(tp_surface.Tk[i] - tp_fluid.Tk[i])  
			Tm[i] = (tp_surface.Tk[i] + tp_fluid.Tk[i])/2.
			Gr[i] * vis[i]**2 = Grav * B[i] * DT[i] * d**3 * rho[i]**2
			Pr[i] * K[i] = vis[i] * Cp[i]
			Ra[i] = Gr[i] * Pr [i]
	   	   
			Nu[i] = NusseltCylinder(Pr[i],Ra[i])

			h[i] = Nu[i] * K[i] / d

			--Thermal conductance

			tp_surface.q[i]  = h[i] * (A / n) * (tp_surface.Tk[i] - tp_fluid.Tk[i])

			tp_surface.q[i] = q[i]
			tp_fluid.q[i] = q[i]       

		END EXPAND_BLOCK 

END COMPONENT

ENUM WIRE_POSITION = {Horizontal, Vertical}

COMPONENT FreeConvec_Wire
(
	INTEGER n = 1												UNITS no_units		"Dimension of thermal port",
	ENUM WIRE_POSITION position = Horizontal			UNITS no_units		"Wire Position",
	ENUM ThFluids thermal_fluid = Air					UNITS no_units		"Interface Fluid"
)

	PORTS
		IN  thermal (n = n) tp_surface  CARDINALITY 0, 1	"Thermal inlet port"
		OUT thermal (n = n) tp_fluid CARDINALITY 0, 1		"Thermal outlet port"
   DATA
		REAL d = 0.01				UNITS u_m	RANGE 0, Inf		"Diameter of Wire"
		REAL L = 1					UNITS u_m	RANGE 0, Inf		"Length of Wire"
		REAL P = 101325			UNITS u_Pa	RANGE 0, Inf		"Ambient pressure"
		REAL Grav = 9.80665						UNITS u_m_s2		"Gravity"

	DECLS
		REAL q[n]										UNITS u_W		"Heat flow"
		REAL DT[n] = 0									UNITS u_K		"Temperature difference"
      REAL Cp[n] = 0									UNITS u_W_kgK	"Specific heat"
		REAL vis[n] = 0.0001	UNITS u_kg_sm		RANGE 0, Inf	"Viscosity"
		REAL rho[n] = 0		UNITS u_kg_m3		RANGE 0, Inf	"Density"
		REAL Tm[n] = 0									UNITS u_K		"Average Temperature"
		REAL B[n] = 0			UNITS u_1_K			RANGE 0, Inf	"Beta factor"
		REAL Gr[n] = 0			RANGE 0, Inf							"Grashof"
		REAL Pr[n] = 0			RANGE 0, Inf							"Prandtl"
		REAL Ra[n] = 0			RANGE 0, Inf							"Rayleigh"
		REAL K[n] = 0.0001	UNITS u_W_mK		RANGE 0, Inf	"Thermal conductivity"
		REAL h[n]				UNITS u_W_m2K		RANGE 0, Inf	"Convective Heat Transfert Coefficient"	
		REAL Nu[n] = 0			RANGE 0, Inf							"Nusselt"
		REAL A = 0				UNITS u_m			RANGE 0, Inf	"Surface of the Wire"
		INTEGER itab
   
	TOPOLOGY
		PATH tp_surface TO tp_fluid   
	INIT
		ASSERT (n > 0) FATAL "Conductor component: Number of nodes must be at least 1"
       
	CONTINUOUS
		A = PI*d*L
		EXPAND_BLOCK (i IN 1, n)  
         Fluid_prop_vs_pT(thermal_fluid, P, Tm[i], Cp[i], vis[i], rho[i], K[i], itab)
			B[i] = Fluid_beta_vs_T(thermal_fluid, Tm[i], itab)

			DT[i] = abs(tp_surface.Tk[i] - tp_fluid.Tk[i])  
			Tm[i] = (tp_surface.Tk[i] + tp_fluid.Tk[i])/2.
			Gr[i] * vis[i]**2 = Grav * B[i] * DT[i] * d**3 * rho[i]**2
			Pr[i] * K[i] = vis[i] * Cp[i]
			Ra[i] = Gr[i] * Pr [i]
	   	   
			EXPAND  (position == Horizontal) Nu[i] = NusseltWireHorizontal(Pr[i],Ra[i])
			EXPAND  (position == Vertical) Nu[i] = NusseltWireVertical(Pr[i],Ra[i], d, L)
	
			h[i] = Nu[i] * K[i] / d

			tp_surface.q[i]  = h[i] * (A / n) * (tp_surface.Tk[i] - tp_fluid.Tk[i])

			tp_surface.q[i] = q[i]
			tp_fluid.q[i] = q[i]       

		END EXPAND_BLOCK 

END COMPONENT

COMPONENT FreeConvec_UserDefined IS_A AGL
	DATA
		REAL A = 1.				UNITS u_m2		"Area to thermal path ratio"
		TABLE_1D h_table = {
                          {0, 1000.},
                          {1.,   1.}
                         }			"Heat transfer coefficient vs Temperature Difference (W/m^2*K vs K)"

	CONTINUOUS
		-- Conductance is distributed along the port connections
		EXPAND (i IN 1, n)
			Vcond[i] = (A/n) * linearInterp1D(h_table, abs(tp_in.Tk[i] - tp_out.Tk[i]))

END COMPONENT
