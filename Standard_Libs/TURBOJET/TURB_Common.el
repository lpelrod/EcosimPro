--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: TURB_Common.el
-- DESCRIPTION: Defines common enumerative types, global constants, and global
--    variables
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 17/02/1999
--------------------------------------------------------------------------------
USE MATH 

-- Enumerative types
--------------------------------------------------------------------------------
-- List of chemical elements
--------------------------------------------------------------------------------
ENUM Chemicals = {H, C, S, N2, O2, Ar, CO2, H2Ov, SO2} "Chemical elements"

--------------------------------------------------------------------------------
-- List of flow cases
--------------------------------------------------------------------------------
ENUM FlowCase = {SubSonic, SuperSonic} "Flow cases"

--------------------------------------------------------------------------------
-- List of data pressure loss modes
--------------------------------------------------------------------------------
ENUM PressLossMode = {FromData, FromTable} "Data pressure loss modes"


-- Set of enumeratives
--------------------------------------------------------------------------------
-- Set of chemical elements for gas flow
--------------------------------------------------------------------------------
SET_OF (Chemicals) GasComp = {N2, O2, Ar, CO2, H2Ov, SO2} "Chemical elements for gas flow"

--------------------------------------------------------------------------------
-- Set of chemical elements for fuel flow
--------------------------------------------------------------------------------
SET_OF (Chemicals) FuelComp = {H, C, S} "Chemical elements for fuel flow"


-- Global constants
CONST REAL g = 9.806    	UNITS  u_m_s2	"Gravity acceleration"

CONST REAL Pstd = 101325.	UNITS  u_Pa	"Standard pressure"
CONST REAL Tstd = 288.5   	UNITS  u_K	"Standard temperature"

CONST REAL MW[Chemicals] = {1.00797, 12.011, 32.066, 28.013, 31.999, 39.948, 44.010, 18.014, 64.063} "Molecular weights of chemical elements (kg/kmol)"


-- Global variables
BOUND REAL Altitude = 0. 	UNITS  u_m        "Altitude"
BOUND REAL Mach = 0.     	UNITS  no_units   "Mach number"
