--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		TH_CompCylinder.el
--		FILE TYPE:		Components of the THERMAL library
--		DESCRIPTION:	Defines a metallic cylinder for the THERMAL library
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Stefano Naclerio
--		CREATION DATE:	18-Jan-2008
--------------------------------------------------------------------------------

-- Libraries
USE PORTS_LIB 
USE MATH 

    

-- Components
--------------------------------------------------------------------------------
-- Component Cylinder
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a cylinder component, divided into a number of longitudinal and
--    radial shapes (nodes). Heat flow is considered at each end of cylinder
--    and radially (positive for increasing value of node index, particularly
--    for outgoing flow in the case of radial flow).
--------------------------------------------------------------------------------
COMPONENT Cylinder 
	(
		INTEGER nz= 5 "Number of axial nodes", 
		INTEGER nr= 3  "Number of radial nodes"
	)
	"2D thermal model of a cylinder wall"
	PORTS
		IN thermal  (n=nr) tpz_in					"Axial inlet port"
		OUT thermal (n=nr) tpz_out					"Axial outlet port"
		IN thermal  (n=nz) tpr_in					"Radial inlet port"
		OUT thermal (n=nz) tpr_out					"Radial outlet port"
	DATA
		--Geometry
		REAL L  = 1							UNITS u_m			"Length"
		REAL Di = 0.1						UNITS u_m			"Inside diameter"
		REAL Do = 0.12						UNITS u_m			"Outside diameter"    
      REAL num = 1             		UNITS no_units		"Number of parallel tubes"
		--Material properties
		ENUM Material mat = None		UNITS no_units			"Material"
		REAL k = 0.1						UNITS u_W_mK			"Wall conductivity if mat=None"
		REAL rho = 1000.					UNITS u_kg_m3			"Wall density if mat=None"
		REAL cp = 500.						UNITS u_J_kgK			"Wall Specific heat if mat=None"
		BOOLEAN TemperatureDependance = TRUE	"Option to consider or not the temperature depence on the material properties"
		--Initial Temperature Distribution
		ENUM WALL_INIT_MODE init_mode = Constant_Temp 	"Option for the initiliazation of the nodal temperatures"
		REAL To = 290.									UNITS u_K			"Constant initial temperature of nodes if init_mode = Constant_Temp"
		REAL To_linear[2] = {290., 290.}			UNITS u_K			"Initial temperatures at both side if init_mode = Linear_Temp"
		TABLE_1D To_table = { {  0.,   1.},  
  	                           {290., 290.}}	"Table with initial wall temperature versus \
 															non-dimensional position if init_mode = Table_Temp (K)"
	DECLS
		REAL rho_var						UNITS u_kg_m3		"Density of wall material"
		EXPL REAL dr						UNITS u_m			"Nodal distance in r"
		EXPL REAL dz						UNITS u_m			"Nodal distance in z"
		REAL V[nr,nz]						UNITS u_m3			"Nodal volume"
		REAL T[nr,nz]						UNITS u_K			"Nodal temperature"
		REAL cp_var[nr,nz]				UNITS u_J_kgK		"Nodal specific heat" 
		REAL cp_tpr[2,nz]					UNITS u_J_kgK		"Nodal specific heat of outer-inner skin"
		REAL cp_tpz[nr,2]					UNITS u_J_kgK		"Nodal specific heat of first-last section skin"

		EXPL REAL k_var[nr,nz]			UNITS u_W_mK		"Nodal thermal conductivities"
        
		REAL C_rad[nr+1,nz]				UNITS u_W_K			"Radial equivalent conductance between the thermal nodes"
		REAL C_axi[nr,nz+1]				UNITS u_W_K			"Axial equivalent conductance between the thermal nodes"
        

		REAL qr[nr+1,nz]					UNITS u_W			"Heat flows between nodes in radial direction"
		REAL qz[nr, nz+1]					UNITS u_W			"Heat flows between nodes in axial direction"
        
		INTEGER ito										"Pointer to time interval for To in Property Tables"
		INTEGER icpk[nr,nz]							"Pointer to last interpolation interval for each node"
		INTEGER icpk_tpr[2,nz]						"Pointer to last interpolation interval for each radial port node"
		INTEGER icpk_tpz[nr,2]						"Pointer to last interpolation interval for each axial port node"
		
		CONST REAL F = 0.0001			UNITS no_units			"Thermal capacity ratio assigned to the surface"
        
        
	INIT
		--Initialization of nodal temperatures depending on the option
   
		IF (init_mode == Constant_Temp) THEN
			FOR (j IN 1, nz)
				tpr_in.Tk[j] = To
				tpr_out.Tk[j] = To
				FOR (i IN 1, nr)
					T[i,j] = To
				END FOR 
			END FOR
			FOR (i IN 1, nr)
				tpz_in.Tk[i] = To
				tpz_out.Tk[i] = To
			END FOR    
		ELSEIF (init_mode == Linear_Temp) THEN
			FOR (j IN 1, nz)
				tpr_in.Tk[j] = To_linear[1]
				tpr_out.Tk[j] = To_linear[2]
				FOR (i IN 1, nr)
					T[i,j] = To_linear[1] + ((i-0.5)/nr)*(To_linear[2] - To_linear[1])
				END FOR
			END FOR 
			FOR (i IN 1, nr)
				tpz_in.Tk[i] = To_linear[1] + ((i-0.5)/nr)*(To_linear[2] - To_linear[1])
				tpz_out.Tk[i] = To_linear[1] + ((i-0.5)/nr)*(To_linear[2] - To_linear[1])
			END FOR    
		ELSEIF (init_mode == Table_Temp) THEN   
			FOR (j IN 1, nz)
				tpr_in.Tk[j]  = linearInterp1D(To_table, 0.)
				tpr_out.Tk[j] = linearInterp1D(To_table, 1.) 
				FOR (i IN 1, nr) 
					T[i,j] =linearInterp1D(To_table, (i-0.5)/nr)
				END FOR
			END FOR
			FOR (i IN 1, nr)
				tpz_in.Tk[i] = linearInterp1D(To_table, (i-0.5)/nr)
				tpz_out.Tk[i] = linearInterp1D(To_table, (i-0.5)/nr)
			END FOR
		END IF

	CONTINUOUS
		-- Material properties
		rho_var = FunConstSolidProp(mat, Density, rho)

		-- Volumes-------------------------------------------------------------------------------
		-- "Core volumes"
		EXPAND (j IN 1, nz)
			EXPAND (i IN 1, nr)
				V[i,j] = (0.25 * PI * ( (Di+2*i*dr)**2 - (Di+2*(i-1)*dr)**2)) * dz
		----------------------------------------------------------------------------------------                
		--Geometry
		dr = (Do - Di) / 2. / nr
		dz = L / nz  
         
		--Properties ---------------------------------------------------------------------------                
		EXPAND_BLOCK(j IN 1, nz)
			EXPAND_BLOCK(i IN 1, nr)
				cp_var[i,j] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, T[i,j], cp, icpk[i,j])
									OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, icpk[i,j])
                              
				k_var[i,j] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, Conductivity, T[i,j], k, icpk[i,j])
									OTHERS                       FunVarSolidProp(mat, Conductivity, To, k, icpk[i,j])
         
			END EXPAND_BLOCK            
		END EXPAND_BLOCK

		-- Skin volumes --> Radial sides, affected by F
		EXPAND_BLOCK(j IN 1,nz)
			cp_tpr[1,j] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, tpr_in.Tk[j], cp, icpk_tpr[1,j])
								OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, icpk_tpr[1,j])
			cp_tpr[2,j] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, tpr_out.Tk[j], cp, icpk_tpr[2,j])
								OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, icpk_tpr[2,j])                              
		END EXPAND_BLOCK
		-- Skin volumes --> Axial sides, affected by F
		EXPAND_BLOCK(i IN 1,nr)
			cp_tpz[i,1] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, tpz_in.Tk[i], cp, icpk_tpz[i,1])
								OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, icpk_tpz[i,1])
			cp_tpz[i,2] =	ZONE (TemperatureDependance) FunVarSolidProp(mat, SpecificHeat, tpz_out.Tk[i], cp, icpk_tpz[i,2])
								OTHERS                       FunVarSolidProp(mat, SpecificHeat, To, cp, icpk_tpz[i,2])                              
		END EXPAND_BLOCK 
		---------------------------------------------------------------------------------------- 
		--Compute Equivalent Conductances -------------------------------------------------------       
		-- Axial -------------------------------------------------------------------------------
		EXPAND_BLOCK (i IN 1, nr)
			--first section
			C_axi[i,1] = (2*k_var[i,1]/dz)*(V[i,1]/dz) --Equivalent Conductance for F-->0 
			--core
			EXPAND (j IN 2, nz)
				C_axi[i,j] =(k_var[i,j-1]*k_var[i,j])/(k_var[i,j]*0.5*dz + k_var[i,j-1]*0.5*dz)* (V[i,j]/dz)
			--last section
			C_axi[i,nz+1] = (2*k_var[i,nz]/dz)*(V[i,nz]/dz) --here it's used formula for F-->0 
		END EXPAND_BLOCK
		--
		-- Radial -------------------------------------------------------------------------------  
		EXPAND_BLOCK (j IN 1, nz)
			--outer skin 
			C_rad[1,j] = (2*PI*dz*k_var[1,j])/log(1 + dr/Di)  --here it's used formula for F-->0 
			--core
			EXPAND (i IN 2, nr)
				C_rad[i,j] = (log((Di + (2*i-2)*dr)/(Di + (2*i-3)*dr))/(2*PI*dz*k_var[i-1,j]) + \
								log((Di + (2*i-1)*dr)/(Di + (2*i-2)*dr))/(2*PI*dz*k_var[i,j]))**(-1)
			--inner skin
			C_rad[nr+1,j] = (2*PI*dz*k_var[nr,j])/log(Do/(Do-dr)) --here it's used formula for F-->0
		END EXPAND_BLOCK
		---------------------------------------------------------------------------------------------
		--Compute Internal Heat Flows ---------------------------------------------------------------     
		--Axial -------------------------------------------------------------------------------------  
		EXPAND_BLOCK (i IN 1, nr)
			qz[i,1] = C_axi[i,1] * (tpz_in.Tk[i] - T[i,1])
			qz[i,nz+1] = C_axi[i,nz+1] * (T[i,nz] - tpz_out.Tk[i]) 
			EXPAND (j IN 2, nz)
				qz[i,j] = C_axi[i,j] * (T[i, j-1] - T[i, j])
		END EXPAND_BLOCK     
		-- Radial------------------------------------------------------------------------------------- 
		EXPAND_BLOCK  (j IN 1, nz)
			EXPAND (i IN 2, nr)
				qr[i,j] = C_rad[i,j] * (T[i-1, j] - T[i, j])

			qr[1,j] = C_rad[1,j] * (tpr_in.Tk[j] - T[1, j])
			qr[nr+1,j] = C_rad[nr+1,j] * (T[nr,j] - tpr_out.Tk[j])  
		END EXPAND_BLOCK        
		--------------------------------------------------------------------------------------------

		--Boundary Conditions
		EXPAND_BLOCK (i IN 1, nr)
			cp_tpz[i,1] * F * V[i,1] * rho_var * tpz_in.Tk[i]' = tpz_in.q[i]/num - qz[i,1]   
			cp_tpz[i,2] * F * V[i,nz] * rho_var * tpz_out.Tk[i]' = qz[i,nz+1] - tpz_out.q[i]/num
		END EXPAND_BLOCK

		--Boundary Conditions
		EXPAND_BLOCK (j IN 1, nz)
			cp_tpr[1,j] * F * V[1,j] * rho_var * tpr_in.Tk[j]' = tpr_in.q[j]/num - qr[1,j]   
			cp_tpr[2,j] * F * V[nr,j] * rho_var * tpr_out.Tk[j]' = qr[nr+1,j] - tpr_out.q[j]/num
		END EXPAND_BLOCK
        
		EXPAND (i IN 2, nr-1)
			EXPAND (j IN 2, nz-1)
				cp_var[i,j] * V[i,j] * rho_var*T[i,j]' = qz[i,j] - qz[i,j+1] + qr[i,j] - qr[i+1,j]

		EXPAND_BLOCK (i IN 2,nr-1)
			EXPAND_BLOCK(nz > 1)
				cp_var[i,1] * (1-F)* V[i,1] * rho_var * T[i,1]' = qz[i,1] - qz[i,2] + qr[i,1] - qr[i+1,1]
				cp_var[i,nz] *(1-F)* V[i,nz] * rho_var * T[i,nz]' = qz[i,nz] - qz[i,nz+1] + qr[i,nz] - qr[i+1,nz]    
			END EXPAND_BLOCK
			
			EXPAND(nz == 1)
				cp_var[i,1] * (1-2*F)* V[i,1] * rho_var * T[i,1]' = qz[i,1] - qz[i,2] + qr[i,1] - qr[i+1,1]
		END EXPAND_BLOCK

		EXPAND_BLOCK (j IN 2,nz-1)
			EXPAND_BLOCK(nr > 1)
				cp_var[1,j] * (1-F) * V[1,j] * rho_var*T[1,j]' = qz[1,j] - qz[1,j+1] + qr[1,j] - qr[2,j]
				cp_var[nr,j] * (1-F) * V[nr,j] * rho_var * T[nr,j]' = qz[nr,j] - qz[nr,j+1] + qr[nr,j] - qr[nr+1,j]
			END EXPAND_BLOCK

			EXPAND(nr == 1)
				cp_var[1,j] * (1-2*F) * V[1,j] * rho_var*T[1,j]' = qz[1,j] - qz[1,j+1] + qr[1,j] - qr[2,j]            	
		END EXPAND_BLOCK

		EXPAND_BLOCK (nz > 1 AND nr > 1)
			cp_var[1,nz] * (1-2*F)* V[1,nz] * rho_var*T[1,nz]' = qz[1,nz] - qz[1,nz+1] + qr[1,nz] - qr[2,nz]
			cp_var[nr,1] * (1-2*F) * V[nr,1] * rho_var*T[nr,1]' = qz[nr,1] - qz[nr,2] + qr[nr,1] - qr[nr+1,1]       
			cp_var[nr,nz] * (1-2*F)* V[nr,nz] * rho_var*T[nr,nz]' = qz[nr,nz] - qz[nr,nz+1] + qr[nr,nz] - qr[nr+1,nz]
			cp_var[1,1] * (1-2*F)* V[1,1] * rho_var*T[1,1]' = qz[1,1] - qz[1,2] + qr[1,1] - qr[2,1]    
		END EXPAND_BLOCK
		  
		EXPAND_BLOCK (nz==1 AND nr > 1)		
			cp_var[1,1] * (1-3*F)* V[1,1] * rho_var*T[1,1]' = qz[1,1] - qz[1,2] + qr[1,1] - qr[2,1] 
			cp_var[nr,1] * (1-3*F) * V[nr,1] * rho_var*T[nr,1]' = qz[nr,1] - qz[nr,2] + qr[nr,1] - qr[nr+1,1]               		   
		END EXPAND_BLOCK

		EXPAND_BLOCK (nz > 1 AND nr==1)		
			cp_var[1,1] * (1-3*F)* V[1,1] * rho_var*T[1,1]' = qz[1,1] - qz[1,2] + qr[1,1] - qr[2,1] 
			cp_var[1,nz] * (1-3*F)* V[1,nz] * rho_var*T[1,nz]' = qz[1,nz] - qz[1,nz+1] + qr[1,nz] - qr[2,nz]
		END EXPAND_BLOCK

		EXPAND_BLOCK(nz == 1 AND nr ==1)
			cp_var[1,1] * (1-4*F)* V[1,1] * rho_var*T[1,1]' = qz[1,1] - qz[1,2] + qr[1,1] - qr[2,1] 		  
		END EXPAND_BLOCK
        
END COMPONENT

COMPONENT Cylinder_AI IS_A Cylinder
	"2D thermal model of a cylinder wall axially Isolated"
	DECLS
		CLOSE tpz_in
		CLOSE tpz_out

	CONTINUOUS    
		--Both axial extremes are isolated
		EXPAND_BLOCK (i IN 1, nr)
			tpz_in.q[i] = 0
			tpz_out.q[i] = 0
		END EXPAND_BLOCK

END COMPONENT
