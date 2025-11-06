--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CommonProp.el
--		FILE TYPE:		Common Elements of the THERMAL library
--		DESCRIPTION:	Defines the thermal properties of some materials for the
--							THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Ramon Perez Vara
--		CREATION DATE:	18-Jan-2008
--------------------------------------------------------------------------------

-- Libraries
USE MATH VERSION "3.1"


--------------------------------------------------------------------------------
-- List of materials
--------------------------------------------------------------------------------
ENUM Material = {					None,  
										Aluminum,   
										AL2219,    
										AL3003_F,  
										AL5083_O,  
										AL6061_T6, 
										AL7020,
										Carbon,
										Carbon_Steel, 
										Copper, 
										Cryosof, 
										Dacron_filled_with_helium,
										Dacron_filled_with_nitrogen,
										Epoxy_fiberglass,
										H920A,
										SS_304,
										SS_304L,
										SS_310,
										SS_316,
										SS_321,
										Titanium,
										Vacuum_Insulated_Panel,
										-- New material names 
										SA_210_A1,
										SA_213_T22,
										T409,
										SA_106_GrB,
										SA_335_P22,
										--Old Material Names to be eliminated in future versions
										Al5083,
										GCF,
										Steel321,
										VIP,
										MatUsr1,
										MatUsr2,
										MatUsr3}

SET_OF (Material) PipeMat = {	None,  
										Aluminum,   
										AL2219,    
										AL3003_F,  
										AL5083_O,  
										AL6061_T6, 
										AL7020,
										Carbon_Steel, 
										Copper, 
										Epoxy_fiberglass,
										SS_304,
										SS_304L,
										SS_310,
										SS_316,
										SS_321,
										Titanium,
										Al5083,
										Steel321,
										MatUsr1,
										MatUsr2,
										MatUsr3}

PRIVATE CONST STRING Mat_internal_name[Material] =  \
                  {				"None",  
										"Aluminum",   
										"AL2219",    
										"AL3003_F",  
										"AL5083_O",  
										"AL6061_T6", 
										"AL7020",
										"Carbon",
										"Carbon_Steel",
										"Copper", 
										"Cryosof", 
										"Dacron_filled_with_helium",
										"Dacron_filled_with_nitrogen",
										"Epoxy_fiberglass",
										"H920A",
										"SS_304",
										"SS_304L",
										"SS_310",
										"SS_316",
										"SS_321",
										"Titanium",
										"Vacuum_Insulated_Panel",
										-- New material names 
										"SA_210_A1",
										"SA_213_T22",
										"T409",
										"SA_106_GrB",
										"SA_335_P22",
										--Old materials
										"AL5083_O",
										"Epoxy_fiberglass",
										"SS_321",
										"Vacuum_Insulated_Panel",
										"MatUsr1",
										"MatUsr2",
										"MatUsr3"}

PRIVATE FILEPATH path_tables = "@THERMAL@/tables/"

--------------------------------------------------------------------------------
-- List of material properties
--------------------------------------------------------------------------------
ENUM PropSolid = {Density, ElasticityModulus, PoissonCoeff, SpecificHeat, Conductivity} 

-- List of constant material properties
SET_OF (PropSolid) ConstProp ={Density, ElasticityModulus, PoissonCoeff} 
-- List of variable material properties
SET_OF (PropSolid) VarProp = {SpecificHeat, Conductivity}

--Property identifier (Position in the dependent variable columns) 
PRIVATE INTEGER IdProp[PropSolid]= {1, 2, 3, 1, 2}

-- Codes to memorize if an error in a material has been produced
PRIVATE INTEGER ier_mi[Material]	              "Tmin error identifier"
PRIVATE INTEGER ier_ma[Material]	              "Tmax error identifier"

PRIVATE INTEGER IdMat[Material] = -1				"Position of the material in the static structure of tables"

--------------------------------------------------------------------------------
-- Function interpolating vs T the material properties read in a file
--------------------------------------------------------------------------------
FUNCTION REAL FunVarSolidProp
	(
		IN ENUM Material mat							"Material", 
		IN ENUM VarProp prop						"Property", 
		IN REAL Tk						UNITS u_K	"Temperature",
		IN REAL v_None									"Property if Material == None",
		OUT INTEGER itab_pointer						"Pointer to last table interval for speed up calculation"
	) "Function interpolating vs T the material properties read in a file"

	DECLS
		TABLE_1D tab					"Table of properties"
		REAL T_min						"Minimum Temperature range"				
		REAL T_max						"Maximum Temperature range"						
		REAL v							"Output value"
		INTEGER ier						"Error identifier"
	     
    BODY
		IF (mat == None) THEN     -- Constant properties
			v = v_None
			RETURN v
		END IF 

	  	
		--Call of the function to read properties in a file and returning a table 
		get_table_prop_from_file(path_tables, Mat_internal_name[mat], IdProp[prop], tab, T_min,T_max, IdMat[mat], ier)

		--Error check
		IF (ier != 0) THEN
			PRINT("****Error: Problems with Table of Properties for material $mat")
		END IF
		ASSERT(ier == 0) FATAL "Execution aborted: Table for Solid Properties not found or wrong"
	     
		--Test alowed ranges
		IF(Tk < T_min) THEN
			IF(ier_mi[mat] == 0)THEN
				WRITE("\n **** Material: %s. Temperature (%g) below minimum range: %g\n\n", Mat_internal_name[mat],Tk,T_min)
			END IF
			ier_mi[mat] = ier_mi[mat] + 1
			v = linearInterpHist1D(tab, T_min, itab_pointer)
			RETURN v
		END IF
		IF(Tk > T_max) THEN
			IF(ier_ma[mat] == 0)THEN
				WRITE("\n **** Material: %s. Temperature (%g) above maximum range: %g\n\n", Mat_internal_name[mat],Tk,T_max)
			END IF
			ier_ma[mat] = ier_ma[mat] + 1
			v = linearInterpHist1D(tab, T_max, itab_pointer)
			RETURN v           
		END IF

		--Interpolation of the data table
		v = linearInterpHist1D(tab, Tk, itab_pointer)
		RETURN v

END FUNCTION
       
FUNCTION REAL FunConstSolidProp
	(
		IN ENUM Material mat			"Material", 
		IN ENUM ConstProp prop		"Property", 
		IN REAL v_None					"Value of the property if Material == None"
	) "Function to read constant material properties in a file"
	DECLS
		REAL v                              "Output value"
		INTEGER ier	                       "Error identifier"
	BODY
		IF (mat == None) THEN
			v = v_None
			RETURN v
		END IF
        

		--Call of the function to read tables
		v = get_const_prop_from_file(path_tables, Mat_internal_name[mat], IdProp[prop], IdMat[mat], ier)

		--Error check
		IF (ier != 0) THEN
			PRINT("****Error: Problems with Table of Properties for material $mat")
			PRINT("           Error code ier = $ier")
		END IF
		ASSERT(ier == 0) FATAL "Execution aborted: Table for Solid Properties not found or wrong"
        
		RETURN v
END FUNCTION    
