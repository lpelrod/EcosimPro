--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: TURB_Funcs.el
-- DESCRIPTION: Defines functions for thermodynamic properties calculation
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 17/02/1999
--------------------------------------------------------------------------------

-- Libraries
USE MATH 


-- Global constants
CONST REAL T1000_max = 2.		UNITS "1000·K"         "Maximum temperature"

CONST REAL A[11] = { 0.992313, 0.236688, -1.852148, 6.083152,
                    -8.893933, 7.097112, -3.234725, 0.794571,
                    -0.081873, 0.422178,  0.001053} "Thermodynamic coefficients for fluid properties"

CONST REAL B[10] = { -0.718874,   8.747481, -15.863157, 17.254096,
                    -10.233795,   3.081778,  -0.361112, -0.003919,
                      0.0555930, -0.0016079} "Thermodynamic coefficients for fluid properties"


-- Functions
--------------------------------------------------------------------------------
-- Purpose: To calculate water vapour saturation pressure
--------------------------------------------------------------------------------
FUNCTION REAL psat_H2O
   ( 
   IN REAL Tk	UNITS u_K          "Temperature"
   )

   "Calculates water vapour saturation pressure"

   DECLS
      REAL C[13] = {
         -5.6745359e+3, -5.1523058e-1, -9.6778430e-3,  6.2215701e-7,
          2.0747825e-9, -9.4840240e-13, 4.1635019   , -5.8002206e+3,
         -5.5162560e+0, -4.8640239e-2,  4.1764768e-5, -1.4452093e-8,
          6.5459673
         } "Thermodynamic coefficients for water vapour pressure"

   BODY
      IF (Tk < 0.) THEN
         RETURN 1.e+3 * exp(C[1] / Tk + C[2] + C[3] * Tk + C[4] * Tk**2 + \
            C[5] * Tk**3 + C[6] * Tk**4 + C[7] * log(Tk))
      ELSE
         RETURN 1.e+3 * exp(C[8] / Tk + C[9] + C[10] * Tk + C[11] * Tk**2 + \
            C[12] * Tk**3 + C[13] * log(Tk))
      END IF

      RETURN 0.

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate gas constant for products of combustion in dry air
--------------------------------------------------------------------------------
FUNCTION REAL R_FAR
   (
   IN REAL FAR	UNITS no_units                    "Fuel air ratio"
   )

   "Calculates gas constant for products of combustion in dry air"

   BODY
      RETURN 287.05 - 0.00990 * FAR

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate specific heat at constant pressure for products of
-- combustion in dry air
--------------------------------------------------------------------------------
FUNCTION REAL Cp_T_FAR
   (
   IN REAL T			UNITS u_K                      "Temperature",
   IN REAL FAR			UNITS no_units                 "Fuel air ratio"
   )

   "Calculates specific heat at constant pressure for products of combustion in dry air"

   DECLS
      REAL T1000		UNITS "1000·K"                  "Temperature"

   BODY
      T1000 = T / 1.e+3

      IF (T1000 > T1000_max) THEN
         T1000 = T1000_max
      END IF

      IF (FAR < 0.) THEN
         FAR = 0.
      END IF

      RETURN 1.e+3 * (poly(T1000, 9, A) + (FAR / (1. + FAR)) * poly(T1000, 8, B))

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate enthalpy for products of combustion in dry air
--------------------------------------------------------------------------------
FUNCTION REAL H_T_FAR
   (
   IN REAL T			UNITS u_K                      "Temperature",
   IN REAL FAR			UNITS no_units                 "Fuel air ratio"
   )

   "Calculates enthalpy for products of combustion in dry air"

   DECLS
      REAL T1000		UNITS "1000·K"                "Temperature"

      REAL h	UNITS u_J_kg                    		"Enthalpy"

   BODY
      T1000 = T / 1.e+3

      IF (FAR < 0.) THEN
         FAR = 0.
      END IF

      IF (T1000 < T1000_max) THEN
         h = 1.e+6 * (poly_int(T1000, 9, A) + A[10] + \
            (FAR / (1. + FAR)) * poly_int(T1000, 8, B) + B[9])
      ELSE
         h = 1.e+6 * (poly_int(T1000_max, 9, A) + A[10] + \
            (FAR / (1. + FAR)) * poly_int(T1000_max, 8, B) + B[9]) + \
            Cp_T_FAR(T1000_max * 1.e+3, FAR) * (T - T1000_max * 1.e+3)
      END IF

      RETURN h

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate temperature (inverse of enthalpy) for products of
-- combustion in dry air
--------------------------------------------------------------------------------
FUNCTION REAL T_H_FAR
   (
   IN REAL H	UNITS u_J_kg                      "Enthalpy",
   IN REAL FAR	UNITS no_units                    "Fuel air ratio"
   ) 

   "Calculates temperature (inverse of enthalpy) for products of combustion in dry air"

   DECLS
      INTEGER ilast		UNITS no_units           "Control integer"

      REAL T1		UNITS u_K                      "Lower value"
      REAL T2		UNITS u_K                      "Higher value"

      REAL res		UNITS u_J_kg                   "Residue"

      REAL T		UNITS u_K                      "Temperature"
   OBJECTS
   	ROOTFINDER1D		root

   BODY
      IF (FAR < 0.) THEN
         FAR = 0.
      END IF

      T1 = 0.01
      T2 = 3.e+3

      ilast = 0
      res = 0.

      WHILE ((ilast !=4) AND (ilast >= 0))
         T = root.findRootZBrent(ilast, res, T1, T2, 1.e-7)
         res = H_T_FAR(T, FAR) - H
      END WHILE

      ASSERT (ilast == 4) WARNING "Function T_H_FAR does not converge"

      IF (ilast !=4) THEN
         PRINT("   H=$H, FAR=$FAR, T=$T")
      END IF

      RETURN T

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate phi function for products of combustion in dry air
--------------------------------------------------------------------------------
FUNCTION REAL Phi_T_FAR
   (
   IN REAL T		UNITS u_K                      	"Temperature",
   IN REAL FAR		UNITS no_units                   "Fuel air ratio"
   )

   "Calculates phi function for products of combustion in dry air"

   DECLS
      REAL T1000		UNITS "1000·K"                "Temperature"

   BODY
      T1000 = T / 1.e+3

      IF (FAR < 0.) THEN
         FAR = 0.
      END IF

      RETURN 1.e+3 * (poly_dx_int(T1000, 9, A) + A[11] + \
         (FAR / (1. + FAR)) * poly_dx_int(T1000, 8, B) + B[10])

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate temperature (inverse of phi function) for products of
-- combustion in dry air
--------------------------------------------------------------------------------
FUNCTION REAL T_Phi_FAR
   (
   IN REAL Phi		UNITS u_J_kgK                    "Phi function",
   IN REAL FAR 	UNITS no_units                   "Fuel air ratio"
   )

   "Calculates temperature (inverse of phi function) for products of combustion in dry air"

   DECLS
      INTEGER ilast	UNITS no_units		"Control integer"

      REAL T1			UNITS u_K			"Lower value"
      REAL T2 			UNITS u_K			"Higher value"

      REAL res			UNITS u_J_kg		"Residue"

      REAL T			UNITS u_K			"Temperature"
   
   OBJECTS
   	ROOTFINDER1D		root


   BODY
      IF (FAR < 0.) THEN
         FAR = 0.
      END IF

      T1 = 0.01
      T2 = 3.e+3

      ilast = 0
      res = 0.

      WHILE ((ilast !=4) AND (ilast >= 0))
         T = root.findRootZBrent(ilast, res, T1, T2, 1.e-7)
         res = Phi_T_FAR(T, FAR) - Phi
      END WHILE

      ASSERT (ilast == 4) WARNING "Function T_Phi_FAR does not converge"

      IF (ilast !=4) THEN
         PRINT("   Phi=$Phi, FAR=$FAR, T = $T")
      END IF

      RETURN T

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate sound speed for products of combustion in dry air
--------------------------------------------------------------------------------
FUNCTION REAL Vs_T_FAR
   (
   IN REAL T		UNITS u_K				"Temperature",
   IN REAL FAR		UNITS no_units			"Fuel air ratio"
   )

   "Calculates sound speed for products of combustion in dry air"

   DECLS
      REAL cp		UNITS u_J_kgK			"Specific heat at constant pressure"
      REAL R		UNITS u_J_kgK			"Gas constant"
      REAL gamma	UNITS no_units			"Ratio of specific heats"

   BODY
      IF (FAR < 0.) THEN
         FAR = 0.
      END IF

      cp = Cp_T_FAR(T, FAR)
      R = R_FAR(FAR)

      gamma = cp / (cp - R)

      RETURN sqrt(gamma * R * T)

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate critical temperature for products of combustion in
-- dry air
--------------------------------------------------------------------------------
FUNCTION REAL Tcrit_T_FAR
   (
   IN REAL T			UNITS u_K				"Temperature",
   IN REAL FAR			UNITS no_units			"Fuel air ratio"
   )

   "Calculates critical temperature for products of combustion in dry air"

   DECLS
      INTEGER ilast 	UNITS no_units    	"Control integer"

      REAL T1			UNITS u_K       		"Lower value"
      REAL T2			UNITS u_K       		"Higher value"
	
      REAL res			UNITS u_J_kg    		"Residue"

      REAL Tcrit		UNITS u_K       		"Critical temperature"
  	
  	OBJECTS
   	ROOTFINDER1D		root

   BODY
      IF (FAR < 0.) THEN
         FAR = 0.
      END IF

      T1 = 0.5 * T
      T2 = T

      ilast = 0
      res = 0.

      WHILE ((ilast !=4) AND (ilast >= 0))
         Tcrit = root.findRootZBrent(ilast, res, T1, T2, 1.e-7)
         res = H_T_FAR(T, FAR) - H_T_FAR(Tcrit, FAR) - 0.5 * Vs_T_FAR(Tcrit, FAR)**2
      END WHILE

      ASSERT (ilast == 4) ERROR "Function Tcrit_T_FAR does not converge"

      IF (ilast !=4) THEN
         PRINT("   T=$T, FAR=$FAR, Tcrit=$Tcrit")
      END IF

      RETURN Tcrit

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate static conditions from stagnation conditions for
-- products of combustion in dry air
--------------------------------------------------------------------------------
FUNCTION NO_TYPE Static_vs_WA
   (
   IN REAL WA			UNITS u_kg_sm2                "Mass flow per unit area",
   IN REAL Pt			UNITS u_Pa                    "Stagnation pressure",
   IN REAL Ht			UNITS u_J_kg                  "Stagnation enthalpy",
   IN REAL Tt			UNITS u_K                     "Stagnation temperature",
   IN REAL FAR			UNITS no_units                "Fuel air ratio",
   IN ENUM FlowCase flow          				"Flow case",
   OUT REAL Ps			UNITS u_Pa                    "Static pressure",
   OUT REAL Hs			UNITS u_J_kg                  "Static enthalpy",
   OUT REAL Ts			UNITS u_K                     "Static temperature"
   )

   "Calculates static conditions from stagnation conditions for products of combustion in dry air"

   DECLS
      INTEGER ilast	UNITS no_units               "Control integer"

      REAL R			UNITS u_J_kgK                "Gas constant"
      REAL Phit		UNITS u_J_kgK                "Stagnation phi function"

      REAL Tcrit		UNITS u_K	                 "Critical temperature"

      REAL T1			UNITS u_K                    "Lower value"
      REAL T2			UNITS u_K                    "Higher value"

      REAL res			UNITS u_J_kg                 "Residue"

      REAL Phis		UNITS u_J_kgK                "Static phi function"
      REAL rhos		UNITS u_kg_m3                "Density"
      REAL vs        UNITS u_m_s			           "Sound speed"
      
  	OBJECTS
   	ROOTFINDER1D		root
   BODY
      IF (FAR < 0.) THEN
         FAR = 0.
      END IF

      R = R_FAR(FAR)
      Phit = Phi_T_FAR(Tt, FAR)

      Tcrit = Tcrit_T_FAR(Tt, FAR)

      IF (flow == SubSonic) THEN
         T1 = Tcrit
         T2 = Tt
      ELSE
         T1 = 0.001
         T2 = Tcrit
      END IF

      ilast = 0
      res = 0.

      WHILE ((ilast !=4) AND (ilast >=0))
         Ts = root.findRootZBrent(ilast, res, T1, T2, 1.e-7)
         Phis = Phi_T_FAR(Ts, FAR)
         Ps = Pt * exp((Phis - Phit) / R)
         Hs = H_T_FAR(Ts, FAR)
         rhos = Ps / (R * Ts)
         vs = ssqrt(2 * (Ht - Hs))
         res = rhos * vs - WA
      END WHILE

      ASSERT (ilast == 4) ERROR "Function StaticSub_vs_WA does not converge"

      IF (ilast !=4) THEN
         PRINT("   WA=$WA, Pt=$Pt, Ht=$Ht, Tt=$Tt, FAR=$FAR, Ps=$Ps, Hs=$Hs, Ts=$Ts")
      END IF

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate points of the Fanno line for products of combustion
-- in dry air
--------------------------------------------------------------------------------
FUNCTION REAL FannoLine
   (
   IN REAL WA		UNITS u_kg_sm2					"Mass flow per unit area",
   IN REAL Ht		UNITS u_J_kg					"Stagnation enthalpy",
   IN REAL Tt		UNITS u_K						"Stagnation temperature",
   IN REAL FAR		UNITS no_units					"Fuel air ratio",
   IN REAL dyn		UNITS u_Pa						"Dynamic pressure",
   OUT REAL Ps		UNITS u_Pa                 "Static pressure",
   OUT REAL Hs		UNITS u_J_kg               "Static enthalpy",
   OUT REAL Ts		UNITS u_K                  "Static temperature"
   )

   "Calculates points of the Fanno line for products of combustion in dry air"

   DECLS
      INTEGER ilast	UNITS no_units			"Control integer"

      REAL R			UNITS u_J_kgK			"Gas constant"

      REAL Tcrit		UNITS u_K				"Critical temperature"
      REAL vcrit		UNITS u_m_s				"Critical speed"

      REAL res			UNITS u_J_kg			"Residue"

      REAL T1			UNITS u_K				"Lower value"
      REAL T2			UNITS u_K				"Higher value"

      REAL vs			UNITS u_m_s				"Sound speed"
      REAL cp			UNITS u_J_kgK			"Specific heat at constant pressure"
      REAL gamma		UNITS no_units			"Ratio of specific heats"
      REAL Ms			UNITS no_units			"Static Mach number"

      REAL Phit		UNITS u_J_kgK			"Stagnation phi function"
      REAL Phis		UNITS u_J_kgK			"Static phi function"

      REAL Pt			UNITS u_Pa				"Stagnation pressure"

  	OBJECTS
   	ROOTFINDER1D		root
   BODY
      IF (FAR < 0.) THEN
         FAR = 0.
      END IF

      R = R_FAR(FAR) 

      Tcrit = Tcrit_T_FAR(Tt, FAR)
      vcrit = ssqrt(2 * (Ht - H_T_FAR(Tcrit, FAR)))

      ilast = 0
      res = 0.

      WHILE ((ilast !=4) AND (ilast >=0))
         vs = root.findRootZBrent(ilast, res, 0., vcrit, 1.e-9)
         Hs = Ht - 0.5 * vs**2
         Ts = T_H_FAR(Hs, FAR)
         cp = Cp_T_FAR(Ts, FAR)
         gamma = cp / (cp - R)
         Ps = dyn / (1 + vs**2 / (R * Ts))
         Ms = vs / sqrt(gamma * R * Ts)
         res = Ps / (R * Ts) * vs - WA
      END WHILE

      ASSERT (ilast == 4) WARNING "Function FannoLine does not converge"

      IF (ilast !=4) THEN
         PRINT("   WA=$WA, Ht=$Ht, Tt=$Tt, FAR=$FAR, dyn=$dyn, Ps=$Ps, Hs=$Hs, Ts=$Ts")
      END IF

      Phit = Phi_T_FAR(Tt, FAR)
      Phis = Phi_T_FAR(Ts, FAR)

      Pt = Ps * exp((Phit - Phis) / R)

      RETURN Pt

END FUNCTION

--------------------------------------------------------------------------------
-- Purpose: To calculate International Standard Atmosphere (ISA) properties
--------------------------------------------------------------------------------
FUNCTION NO_TYPE STD_Atmosphere
   (
   IN REAL h			UNITS u_m			"Altitude",
   OUT REAL Pamb		UNITS u_Pa			"Ambient pressure",
   OUT REAL Tamb		UNITS u_K			"Ambient temperature"
   )

   "Calculates International Standard Atmosphere (ISA) properties"

   BODY
      IF (h < 11000.) THEN
         Tamb = 288.15 - 0.0065 * h
         Pamb = 101325. * (Tamb / 288.15)**5.25588
      ELSE
         Tamb = 216.67
         Pamb = 22632.53 / exp(0.000157689 * (h - 10998.1))
      END IF

END FUNCTION
