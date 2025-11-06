--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_Compcounters.el
--    FILE TYPE:  Common elements of the library
--    DESCRIPTION:  Defines different types of counters 
--    AUTHOR:  EAI
--    CREATION DATE:  Oct-2011
--------------------------------------------------------------------------------
USE PORTS_LIB 
USE MATH 

--------------------------------------------------------------------------------
-- Component Counter_UP
--------------------------------------------------------------------------------
-- Purpose:
--   To define a digital Up-counter   

--------------------------------------------------------------------------------

COMPONENT Counter_UP IS_A SISO

PORTS
	
	IN bool_signal CU				"Counter activation"
	IN bool_signal RESET			"Reset"
	OUT bool_signal Q				"Output"
 
DATA
	REAL PVmax = 100			"Limit"
DECLS
	INTEGER PV					"Maximum value"
	INTEGER CV					"Counter"
	INTEGER t = 0				


INIT

	CV = 0
DISCRETE
	WHEN(Clock_signal == TRUE) THEN
		PV = s_in.signal[1]

	 	IF (CU.signal[1]==TRUE AND CV < PVmax)THEN
			IF (t ==0) THEN
 				CV = 0
 				 t += 1
 			ELSE
 				CV +=1
 			END IF
		END IF 
		IF(CV >= PV)THEN 
			Q.signal[1] =TRUE 
		ELSE 
			Q.signal[1] = FALSE
		END IF
	END WHEN
	
	WHEN (RESET.signal[1]== TRUE) THEN 
	 		CV = 0 
	 		t = 0
	 		Q.signal[1] = FALSE
	END WHEN
	
CONTINUOUS
	
	CV = s_out.signal[1]

	
END COMPONENT

--------------------------------------------------------------------------------
-- Component Counter_DOWN
--------------------------------------------------------------------------------
-- Purpose:
--   To define a digital Down-counter   

--------------------------------------------------------------------------------
COMPONENT Counter_DOWN IS_A SISO

PORTS

	IN bool_signal CD				"Counter activation"
	IN bool_signal LD				"Load signal"
	OUT bool_signal Q				"Output"
 
DATA
	REAL PVmin = 0				"Limit"
	
DECLS
	INTEGER PV	=10				"Maximun value"
	INTEGER CV 					"Counter"
	INTEGER t = 0
INIT

	CV = PV
	Q.signal[1]= FALSE
	CD.signal[1]=FALSE
DISCRETE
	WHEN(Clock_signal == TRUE)THEN
		PV = s_in.signal[1]
		
	 	IF (CD.signal[1]==TRUE AND CV >PVmin AND CV > 0)THEN
			IF (t ==0) THEN
 				CV = PV
 				 t += 1
 			ELSE
 				CV = CV -1
 			END IF
		END IF 
		IF(CV <= 0)THEN 
			Q.signal[1] =TRUE 
		ELSE 
			Q.signal[1] = FALSE
		END IF
	END WHEN
	WHEN (LD.signal[1]== TRUE) THEN 
	 		CV= PV 
	 		t = 0
	 		Q.signal[1] = FALSE
	END WHEN
CONTINUOUS
	
	CV = s_out.signal[1]


END COMPONENT

--------------------------------------------------------------------------------
-- Component Counter_UP_DOWN
--------------------------------------------------------------------------------
-- Purpose:
--   To define a digital Up-down counter   

--------------------------------------------------------------------------------
COMPONENT Counter_UP_DOWN IS_A SISO

PORTS
	IN bool_signal CU				"Up-counter"
	IN bool_signal CD				"Down-counter"
	IN bool_signal RESET			"Reset"
	IN bool_signal LD				"Load"
	OUT bool_signal QU			"Output"
	OUT bool_signal QD			"Output"
 
DATA 
	REAL PVmax	= 100				"Upper limit"
	REAL PVmin	= 0				"Lower limit"
DECLS
	INTEGER PV	=10			"Maximun value"
	INTEGER CV 					"Counter"
INIT
	CV = 0	
DISCRETE
	WHEN (Clock_signal ==TRUE)THEN
		PV = s_in.signal[1]
	 	
	 	IF (CU.signal[1]== TRUE OR CD.signal[1]==TRUE)THEN
	 		IF (CU.signal[1]==TRUE AND CV < PVmax) THEN
	 			CV = CV +1
	 		ELSEIF (CD.signal[1]==TRUE AND CV >PVmin)THEN
	 			CV = CV -1
	 		END IF
 		END IF
		 
		IF(CV >= PV)THEN 
			QU.signal[1] =TRUE 
		ELSE 
			QU.signal[1] = FALSE
		END IF
		
		IF(CV <= 0)THEN 
			QD.signal[1] =TRUE 
		ELSE 
			QD.signal[1] = FALSE
		END IF
		
	END WHEN
	
	WHEN (RESET.signal[1]== TRUE) THEN 
	 		CV= 0 
	 		QU.signal[1] = FALSE
	END WHEN
	WHEN (LD.signal[1]== TRUE) THEN
	 		CV = PV
	 		QD.signal[1] = FALSE
	END WHEN
CONTINUOUS
	
	CV = s_out.signal[1]

	
END COMPONENT
