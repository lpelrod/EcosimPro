--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompView_Factors.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a component that calculates the radiative heat
--							transfer among the nodes by means of the view factors
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara
--		CREATION DATE:	26-Jan-2004
--------------------------------------------------------------------------------

-- Libraries
USE MATH 
USE PORTS_LIB 

-- Components
--------------------------------------------------------------------------------
-- Component View_Factors
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a component that that calculates the radiative heat transfer
--    among the nodes by means of the view factors.
--------------------------------------------------------------------------------
COMPONENT View_Factors
	(
		INTEGER nports = 2      UNITS no_units       "Number of thermal ports connected by the component"
	)
	"Radiative heat transfer model among the nodes by means of the view factors"
   PORTS
		IN thermal (n = 1) tp_in[nports]  CARDINALITY 0, 1 "Thermal inlet ports"

	DATA
		REAL VF[nports,nports]	UNITS no_units	"View factor for each coupling"
		REAL e[nports]				UNITS no_units	"Emissivity"
		REAL A[nports]				UNITS u_m2	"Area"

	DECLS
		REAL r[nports]				UNITS no_units	"Difuse reflectivity"
		REAL B[nports,nports]	UNITS no_units	"Radiative interchange factor for each GR coupling"
		REAL GR[nports,nports]	UNITS u_m2	"Characteristic value of the radiative conductor"
		REAL Q[nports,nports]	UNITS u_W	"Net heat transfer between two nodes"
		REAL Tk[nports]			UNITS u_K	"Absolute node temperature"

	INIT
		ASSERT (nports > 0) FATAL "View_Factors component: Number of nodes must be at least 1"

	CONTINUOUS
		EXPAND_BLOCK(i IN 1,nports)
			-- Calculation of the reflectivity
			r[i] = 1 - e[i]

			EXPAND_BLOCK(j IN 1,nports)
				-- Calculation of the radiative exchange factor
				B[i,j] = SUM(k IN 1,nports; r[k] * VF[i,k] * B[k,j]) + e[j] * VF[i,j]

				GR[i,j] = A[i] * B[i,j] * e[i]

				-- Calculation of the radiative heat flow of each node coupling
				-- Q[i,j] = GR[i,j] * STEFAN * (Tk[i]**4 - Tk[j]**4)
				Q[i,j] = GR[i,j] * STEFAN * (Tk[i]**2 + Tk[j]**2) * \
						(abs(Tk[i]) + abs(Tk[j])) * (Tk[i] - Tk[j])

			END EXPAND_BLOCK

      END EXPAND_BLOCK

		-- Equations of the ports
		EXPAND_BLOCK(i IN 1,nports)
			-- Net heat flow in each node
			tp_in[i].q[1] = SUM(j IN 1,nports EXCEPT i; Q[i,j])

			-- Net temperatures in each node
			Tk[i] = tp_in[i].Tk[1]

		END EXPAND_BLOCK

END COMPONENT

