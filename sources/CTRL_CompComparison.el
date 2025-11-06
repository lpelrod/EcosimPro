--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompComparison.el
--    FILE TYPE:  Components of the library
--    DESCRIPTION:  Defines components to compare two signals 
--    AUTHOR:  EAI
--    CREATION DATE:  Oct-2011
--------------------------------------------------------------------------------
USE MATH 
USE PORTS_LIB 

--------------------------------------------------------------------------------
-- Component EQ
--------------------------------------------------------------------------------
-- Purpose: Equality
-- based in IEC 61131-3 International Standard 
--------------------------------------------------------------------------------
COMPONENT EQ IS_A SI2bSO "Equality"

		DISCRETE
				WHEN (abs(s_in_1.signal[1] - s_in_2.signal[1]) > 0) THEN
					s_out.signal[1] = FALSE
				END WHEN
				WHEN (NOT abs(s_in_1.signal[1] - s_in_2.signal[1]) > 0) THEN
					s_out.signal[1] = TRUE
				END WHEN
			
END COMPONENT

--------------------------------------------------------------------------------
-- Component NEQ
--------------------------------------------------------------------------------
-- Purpose: Inequality
-- based in IEC 61131-3 International Standard 
--------------------------------------------------------------------------------
COMPONENT NEQ IS_A SI2bSO "Inequality"

		DISCRETE
				WHEN (abs(s_in_1.signal[1] - s_in_2.signal[1]) > 0) THEN
					s_out.signal[1] = TRUE
				END WHEN
				WHEN (NOT abs(s_in_1.signal[1] - s_in_2.signal[1]) > 0) THEN
					s_out.signal[1] = FALSE
				END WHEN
		CONTINUOUS
		
END COMPONENT

--------------------------------------------------------------------------------
-- Component LE
--------------------------------------------------------------------------------
-- Purpose: Lower or equal than
-- based in IEC 61131-3 International Standard
--------------------------------------------------------------------------------
COMPONENT LE IS_A SI2bSO "Lower or equal than"
 		
		DISCRETE
				WHEN (s_in_1.signal[1] > s_in_2.signal[1]) THEN
					s_out.signal[1] = FALSE
				END WHEN
				WHEN (NOT s_in_1.signal[1] > s_in_2.signal[1]) THEN
					s_out.signal[1] = TRUE
				END WHEN
	CONTINUOUS
		SEQUENTIAL
			IF (s_in_1.signal[1] > s_in_2.signal[1]) THEN
				s_out.signal[1] = FALSE
			ELSE
				s_out.signal[1] = TRUE
			END IF
		END SEQUENTIAL
END COMPONENT
--------------------------------------------------------------------------------
-- Component LT
--------------------------------------------------------------------------------
-- Purpose:Lower than
--  based in IEC 61131-3 International Standard    
--------------------------------------------------------------------------------
COMPONENT LT IS_A SI2bSO "Lower than"
 		
		DISCRETE
				WHEN (s_in_1.signal[1] < s_in_2.signal[1]) THEN
					s_out.signal[1] = TRUE
				END WHEN
				WHEN (NOT s_in_1.signal[1] < s_in_2.signal[1]) THEN
					s_out.signal[1] = FALSE
				END WHEN
	CONTINUOUS
		SEQUENTIAL
			IF (s_in_1.signal[1] < s_in_2.signal[1]) THEN
				s_out.signal[1] = TRUE
			ELSE
				s_out.signal[1] = FALSE
			END IF
		END SEQUENTIAL			
END COMPONENT
--------------------------------------------------------------------------------
-- Component GE
--------------------------------------------------------------------------------
-- Purpose:Greater or equal than
-- based in IEC 61131-3 International Standard   
--------------------------------------------------------------------------------
COMPONENT GE IS_A SI2bSO "Greater or equal than" 		
		DISCRETE
				WHEN (s_in_1.signal[1] < s_in_2.signal[1]) THEN
					s_out.signal[1] = FALSE
				END WHEN
				WHEN (NOT (s_in_1.signal[1] < s_in_2.signal[1])) THEN
					s_out.signal[1] = TRUE
				END WHEN
	CONTINUOUS
		SEQUENTIAL
			IF(s_in_1.signal[1] < s_in_2.signal[1]) THEN
				s_out.signal[1] = FALSE
			ELSE
				s_out.signal[1] = TRUE
			END IF
		END SEQUENTIAL
END COMPONENT

--------------------------------------------------------------------------------
-- Component GT
--------------------------------------------------------------------------------
-- Purpose:Greater than
-- based in IEC 61131-3 International Standard   
--------------------------------------------------------------------------------
COMPONENT GT IS_A SI2bSO "Greater than"
 		
		DISCRETE
				WHEN (s_in_1.signal[1] > s_in_2.signal[1]) THEN
					s_out.signal[1] = TRUE
				END WHEN
				WHEN (NOT s_in_1.signal[1] > s_in_2.signal[1]) THEN
					s_out.signal[1] = FALSE
				END WHEN
	CONTINUOUS
		SEQUENTIAL
			IF (s_in_1.signal[1] > s_in_2.signal[1]) THEN
				s_out.signal[1] = TRUE
			ELSE
				s_out.signal[1] = FALSE
			END IF
		END SEQUENTIAL		
END COMPONENT