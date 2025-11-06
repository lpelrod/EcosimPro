
--------------VISUAL SOURCE SAFE INFO------------------------------
-- $Archive: /LIBRARIES ECOSIMPRO 4.4/THERMAL/sources/TH_FuncsPureFluids.el $
-- $Author: Frj $
-- $Revision: 2 $
-- $JustDate: 25/09/09 $
-------------------------------------------------------------------
--  **
--  ** Purpose: Set of functions to calculate the simplified gas/liquid properties 
--  **

USE MATH 
--List of Working Fluids for THERMAL Library

ENUM ThFluids = {Air, Nitrogen, Oxygen, Water_ReheatedVap, Argon, Hydrogen_para, UsrDef_gas1, UsrDef_gas2, UsrDef_gas3, \
                 Water_liq,                                UsrDef_liq1, UsrDef_liq2, UsrDef_liq3}

PRIVATE CONST STRING FluidFileName[ThFluids] = \
           {"Air", "Nitrogen", "Oxygen", "Water_ReheatedVap", "Argon", "Hydrogen_para", "UsrDef_gas1", "UsrDef_gas2", "UsrDef_gas3", 
            "Water_liq" ,                                     "UsrDef_liq1", "UsrDef_liq3", "UsrDef_liq3" }
--Enumerative data type for the property's names

ENUM LiqFlProps  = {LIQ_density, LIQ_cp, LIQ_vsound, LIQ_beta, LIQ_viscosity, LIQ_thermal_conductivity, LIQ_surface_tension} 
ENUM GasFlProps  = {GAS_cp, GAS_viscosity, GAS_thermal_conductivity} 

--ENUM PropLiquidCtn = {Molecular_weight, Crit_pressure, Crit_temperature, Crit_compressibility, Azentric_factor} 

--CONST REAL RGAS  = 8314.4     "Gas constant (J/kmol ºK)"

-- Automatic properties files path calculation
PRIVATE CONST FILEPATH PathFlProps= "@THERMAL@/tables/Simple_Fluids/"


-- Codes to memorize if an error in a material has been produced
PRIVATE INTEGER ier_fl_mi[ThFluids]           "Tmin error identifier"
PRIVATE INTEGER ier_fl_ma[ThFluids]           "Tmax error identifier"
PRIVATE INTEGER  posFluid[ThFluids]=-1        "Position of the fluid in the static structure of tables"

--------------------------------------------------------------------------------
-- Generic Functions to interpolate a liquid property in table vs temperature
--------------------------------------------------------------------------------
FUNCTION REAL propLiq_vs_T(
        IN ENUM ThFluids liq      "Liquid", 
        IN ENUM LiqFlProps prop   "Property", 
        IN REAL Tk    UNITS u_K	 "Temperature",
        OUT INTEGER itab_pointer  "Pointer to last table interval for speed up calculation"
        ) "Function interpolating vs T the Liquid properties read in a file"

    DECLS
        TABLE_1D tab              "Table of properties"
        REAL T_min                "Minimum Temperature range"            
        REAL T_max                "Maximum Temperature range"                  
        REAL v                    "Output value"
        INTEGER ier               "Error identifier"

    BODY
		
        --Call of the function to read properties in a file and returning a table 
        get_table_prop_from_file(PathFlProps, FluidFileName[liq], setofPos(LiqFlProps, prop), tab, T_min,T_max, posFluid[liq], ier)

        --Error check
        IF (ier != 0) THEN
           WRITE("*****Error: Problems reading fluid properties. Liquid %s",FluidFileName[liq])
        END IF
        ASSERT(ier == 0) FATAL "Execution aborted: Table for Simplified Fluid Properties not found or wrong"

        --Test alowed ranges
        IF(Tk < 0.9*T_min) THEN
           IF(ier_fl_mi[liq] == 0)THEN
             WRITE("\n **** fluid: %s. Temperature (%g) below minimum range: %g\n\n", FluidFileName[liq],Tk,T_min)
           END IF
           ier_fl_mi[liq] = 1
        END IF
        IF(Tk > 1.1*T_max) THEN
           IF(ier_fl_ma[liq] == 0)THEN
             WRITE("\n **** fluid: %s. Temperature (%g) above maximum range: %g\n\n", FluidFileName[liq],Tk,T_max)
           END IF
           ier_fl_ma[liq] = 1
        END IF

        --Interpolation of the data table
        v = linearInterpHist1D(tab, Tk, itab_pointer)
--        WRITE("Temp=%g posFluid=%d FluidFileName=%s var =%g \n",Tk,posFluid[liq],FluidFileName[liq],v)

        RETURN  v
END FUNCTION

--------------------------------------------------------------------------------
-- Generic Functions to interpolate a gas property in table vs temperature
--------------------------------------------------------------------------------
FUNCTION REAL propGas_vs_T(
        IN ENUM ThFluids Gas      "Gas", 
        IN ENUM GasFlProps prop   "Property", 
        IN REAL Tk    UNITS u_K   "Temperature",
        OUT INTEGER itab_pointer  "Pointer to last table interval for speed up calculation"
        ) "Function interpolating vs T the Gas properties read in a file"

    DECLS
        TABLE_1D tab              "Table of properties"
        REAL T_min                "Minimum Temperature range"            
        REAL T_max                "Maximum Temperature range"                  
        REAL v                    "Output value"
        INTEGER ier               "Error identifier"

    BODY
            
        --Call of the function to read properties in a file and returning a table 
        get_table_prop_from_file(PathFlProps, FluidFileName[Gas], setofPos(GasFlProps, prop), tab, T_min,T_max, posFluid[Gas], ier)

        --Error check
        IF (ier != 0) THEN
           WRITE("*****Error: Problems reading fluid properties. Gas %s",FluidFileName[Gas])
        END IF
        ASSERT(ier == 0) FATAL "Execution aborted: Table for Simplified Fluid Properties not found or wrong"

        --Test alowed ranges
        IF(Tk < 0.9*T_min) THEN
           IF(ier_fl_mi[Gas] == 0)THEN
             WRITE("\n **** fluid: %s. Temperature (%g) below minimum range: %g\n\n", FluidFileName[Gas],Tk,T_min)
           END IF
           ier_fl_mi[Gas] = 1
        END IF
        IF(Tk > 1.1*T_max) THEN
           IF(ier_fl_ma[Gas] == 0)THEN
             WRITE("\n **** fluid: %s. Temperature (%g) above maximum range: %g\n\n", FluidFileName[Gas],Tk,T_max)
           END IF
           ier_fl_ma[Gas] = 1
        END IF

        --Interpolation of the data table
        v = linearInterpHist1D(tab, Tk, itab_pointer)

        RETURN v
END FUNCTION


----------------------------------------------------------------------
--  Functions to calculate  
--  the chem properties versus two other variables
----------------------------------------------------------------------

FUNCTION NO_TYPE Fluid_prop_vs_pT(
        IN ENUM  ThFluids chem      "Working chemical constituent",
        IN REAL  p       UNITS u_Pa          "Pressure", 
        IN REAL  T       UNITS u_K           "Temperature",
        OUT REAL Cp      UNITS u_W_kgK			"Specific heat",
		  OUT REAL vis		 UNITS u_kg_sm			"Viscosity",
		  OUT REAL rho		 UNITS u_kg_m3			"Density",
		  OUT REAL K		 UNITS u_W_mK			"Thermal conductivity",
        OUT INTEGER itab           "Index in table")

     DECLS
        REAL MW
        INTEGER ier

     BODY
        IF (setofPos(ThFluids, chem) > 9) THEN
            Cp  =  propLiq_vs_T(chem, LIQ_cp, T, itab)
            rho =  propLiq_vs_T(chem, LIQ_density, T, itab)
            vis =  propLiq_vs_T(chem, LIQ_viscosity, T, itab)
            K   =  propLiq_vs_T(chem, LIQ_thermal_conductivity, T, itab)
        ELSE
            Cp  =  propGas_vs_T(chem, GAS_cp, T, itab)
            vis =  propGas_vs_T(chem, GAS_viscosity, T, itab)
            K   =  propGas_vs_T(chem, GAS_thermal_conductivity, T, itab)
            MW  =  get_const_prop_from_file(PathFlProps, FluidFileName[chem], 1, posFluid[chem], ier)
--            rho =  p / ((RGAS / MW) * T)
				rho =  p / ((8314.4 / MW) * T)
            
--WRITE("P=%g Tm=%g Cp=%g visc=%g cond=%g rho=%g B=%g MW=%g \n",p,T,Cp, vis, K, rho, B, MW)
        END IF

END FUNCTION


FUNCTION REAL Fluid_beta_vs_T(
        IN ENUM  ThFluids chem      "Working chemical constituent",
        IN REAL  T          UNITS u_K       "Temperature ",
        OUT INTEGER itab          		 "Index in table")

     DECLS
        REAL B
        INTEGER ier

     BODY
        IF (setofPos(ThFluids, chem) > 9) THEN
            B   =  propLiq_vs_T(chem, LIQ_beta, T, itab)
        ELSE
            B   =  1/T
        END IF

        RETURN B
END FUNCTION

