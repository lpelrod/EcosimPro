
-- Libraries
USE MATH 
USE PORTS_LIB 

-------------------------------------------------
--            Lever Model (two points)
-------------------------------------------------
COMPONENT Lever2 "Lever Model (two points)"

 PORTS
      IN mech_rot fulcrum 
      IN mech_trans  load1
      IN mech_trans  load2   
 DATA
    REAL L1= 1  		UNITS u_m		 "Distance from load input 1 to fulcrum"
                 --Positive if a positive displacement increases the rotation angle around the fulcrum (m)"
    REAL L2 = 0.5 	UNITS u_m		"Distance from load input 2 to fulcrum"
                 --Positive if a positive displacement increases the rotation angle around the fulcrum (m)"
    REAL I = 1    	UNITS u_kgm2	"Inertia of the lever"

--    REAL c = 0          "Spring constant (N*m/rad)"
--    REAL phi_rel0 = 0.  "Angular shift for unstretched spring (rad)"
    REAL phi0 = 0.         UNITS u_rad		"Initial angular position"
    REAL phi_min =-0.50   	UNITS u_rad		"Lever lower limit angular position"
    REAL phi_max = 0.50   	UNITS u_rad		"Lever upper limit angular position"

 DECLS
--    CLOSE fulcrum
    REAL phi      UNITS u_rad		"Lever angle"
    REAL s1       UNITS u_m		"Displacement of load 1 application point"
    REAL s2       UNITS u_m		"Displacement of load 2 application point"
    BOOLEAN initial = TRUE
    
 TOPOLOGY
   R_GearIdealR2T arm1(ratio = 1/L1)
   R_GearIdealR2T arm2(ratio = 1/L2)
   R_Stop Inertia(I = I, w0 = 0, phi0=phi0, phi_min=phi_min, phi_max=phi_max)

--   R_Spring spring(phi_rel_i = 0, c = c, phi_rel0 = phi_rel0)

   CONNECT fulcrum TO arm2.R_m_in
   CONNECT fulcrum TO Inertia.m_in
   CONNECT fulcrum TO arm1.R_m_in
--   CONNECT spring.m_out TO fulcrum

   CONNECT arm1.T_m_out TO load1
   CONNECT arm2.T_m_out TO load2

 INIT
	phi = phi0
   
 DISCRETE
   WHEN(initial) THEN
     initial = FALSE
     PRINT("********** phi0=$phi0")
     arm1.T_m_out.s = phi0*L1
     arm2.T_m_out.s = phi0*L2
   END WHEN

   ASSERT(phi < 1) FATAL "The lever angular position is too big (positive)"
   ASSERT(phi >-1) FATAL "The lever angular position is too big (negative)"

 CONTINUOUS

--   spring.m_in.n = 0
   fulcrum.T = 0
   Inertia.m_out.T = 0

   phi' = Inertia.m_in.omega
   s1 = load1.s
   s2 = load2.s

END COMPONENT

-------------------------------------------------
--            Lever Model (three points)
-------------------------------------------------
COMPONENT Lever3 "Lever Model (three points)"

 PORTS
      IN mech_rot fulcrum 
      IN mech_trans  load1
      IN mech_trans  load2   
      IN mech_trans  load3  

 DATA
    REAL L1= 1   		UNITS u_m		"Distance from load input 1 to fulcrum"
                 --Positive if a positive displacement increases the rotation angle around the fulcrum (m)"
    REAL L2 = 0.5 	UNITS u_m		"Distance from load input 2 to fulcrum"
                 --Positive if a positive displacement increases the rotation angle around the fulcrum (m)"
    REAL L3 = 0.5 	UNITS u_m		"Distance from load input 3  to fulcrum"
                 --Positive if a positive displacement increases the rotation angle around the fulcrum (m)"
    REAL I = 1    	UNITS u_kgm2	"Inertia of the lever"

--    REAL c = 0          "Spring constant (N*m/rad)"
--    REAL phi_rel0 = 0.  "Angular shift for unstretched spring (rad)"
    REAL phi0 = 0.        UNITS u_rad 		"Initial angular position"
    REAL phi_min =-0.50   UNITS u_rad 		"Lever lower limit angular position"
    REAL phi_max = 0.50   UNITS u_rad		"Lever upper limit angular position"

 DECLS
--    CLOSE fulcrum
    REAL phi      UNITS u_rad		"Lever angle"
    REAL s1       UNITS u_m		"Displacement of load 1 application point"
    REAL s2       UNITS u_m		"Displacement of load 2 application point"
    REAL s3       UNITS u_m		"Displacement of load 2 application point"

 TOPOLOGY

   R_GearIdealR2T arm1(ratio = 1/L1)
   R_GearIdealR2T arm2(ratio = 1/L2)
   R_GearIdealR2T arm3(ratio = 1/L3)

   R_Stop Inertia(I = I, w0 = 0, phi0=phi0, phi_min=phi_min, phi_max=phi_max)
--   R_Spring spring(phi_rel_i = 0, c = c, phi_rel0 = phi_rel0)

   CONNECT fulcrum TO arm2.R_m_in
   CONNECT fulcrum TO arm3.R_m_in
   CONNECT fulcrum TO Inertia.m_in
   CONNECT fulcrum TO arm1.R_m_in
--   CONNECT spring.m_out TO fulcrum

   CONNECT arm1.T_m_out TO load1
   CONNECT arm2.T_m_out TO load2
   CONNECT arm3.T_m_out TO load3

 INIT
	phi = phi0

 DISCRETE
   ASSERT(phi < 1) FATAL "The lever angular position is too big (positive)"
   ASSERT(phi >-1) FATAL "The lever angular position is too big (negative)"

CONTINUOUS

--   spring.m_in.n = 0
   fulcrum.T = 0
   Inertia.m_out.T = 0

   phi' = Inertia.m_in.omega
   s1 = load1.s
   s2 = load2.s
   s3 = load3.s
END COMPONENT


