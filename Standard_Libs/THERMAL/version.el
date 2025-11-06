-- Define the version, date, author and comments associated to this library
#LIBRARY_INFO
  #VERSION = "4.0.5"
  #DATE = "10/11/23"
  #AUTHOR= "EAI" 
  #COMMENTS= "Adding new components for free convection calculation. Detaching dependence of FLUID_PROP\
		  New property files of materials added: SA_106_GrB, SA_210_A1, SA_213_T22, SA_335_P22, T409\
		  version 3.4: Adding standard units of variables and two new setof: VarProp and ConstProp for\
		                variable and constant material properties\
		version 3.4.1: Small bug in SS_304.txt corrected \
		version 3.4.2: - removed VERSION from USE library statement in all the .el files \
				  			- Updated symbols and schematics appearance \
							- new integer global variable (setRaleighWarnings) to test validity range in natural convection correlation\
	   version 3.4.3: - updated symbols and schematics appearance \
	   version 3.4.4: - properties files extension for Copper, Aluminum, Epoxy fibreglass and Titanium\
		version 3.5.0: - added new components: Th_Demux and Th_Mux\
		version 3.5.1: Added libraries dependences and file categories\
		version 3.5.2: Added component DNodeMat_vec\
		version 3.5.3: Corrected bug in DNodeMat_vec\
		version 3.5.4: Eliminated expandFilePath() according to internal SPR 3549\
							Source files saved with UTF-8 format\
		version 3.5.5: Corrected number of files in Epoxy_fiberglass.txt\
		version 3.5.6: Included material properties tables as source code control extra files.\
		version 3.5.7: SPR 2111 corrected (Q_sensor component). \
		version 4.0.0: New components Th_Demux1 and Th_Mux1 \
							View_Factors symbol added\
		version 4.0.1: Added new fluids and their property files: Argon and para Hydrogen\
					      Added property files of Oxygen and Nitrogen.\
		version 4.0.3: Added new component R_ClutchBasic\
							Updated attribute editor. \
		version 4.0.4: The paths of the material and fluid property files have been corrected to avoid problems in Linux \
							Added examples of the fluid property files: UsrDef_gas?.txt and UsrDef_liq?.txt\
      version 4.0.5: Updated symbol of DNodeMat, DNodeMat_Vec, GL_mat, VCHP and Wall\
		"

END #LIBRARY_INFO
