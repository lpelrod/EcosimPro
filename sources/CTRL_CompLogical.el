--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompLogics.el
--    FILE TYPE:  Components of the CONTROL library
--    DESCRIPTION:  Defines the logic components for the CONTROL library
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
USE MATH 
USE PORTS_LIB

--------------------------------------------------------------------------------
-- Component Gate_OR
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a logic OR gate.
--------------------------------------------------------------------------------
COMPONENT Gate_OR IS_A bSI2SO "Defines a logic OR gate"
   DISCRETE
      EXPAND_BLOCK (i IN 1, n)
         WHEN ((s_in_1.signal[i] == TRUE) OR (s_in_2.signal[i] == TRUE)) THEN
            s_out.signal[i] = TRUE
         END WHEN

         WHEN ((s_in_1.signal[i] == FALSE) AND (s_in_2.signal[i] == FALSE)) THEN
            s_out.signal[i] = FALSE
         END WHEN

      END EXPAND_BLOCK
	CONTINUOUS
/*
		SEQUENTIAL
	      FOR (i IN 1, n)
	         IF ((s_in_1.signal[i] == TRUE) OR (s_in_2.signal[i] == TRUE)) THEN
	            s_out.signal[i] = TRUE
	         ELSE	
	            s_out.signal[i] = FALSE
	         END IF	
	      END FOR			
		END SEQUENTIAL
*/
END COMPONENT

--------------------------------------------------------------------------------
-- Component Gate_AND
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a logic AND gate.
--------------------------------------------------------------------------------
COMPONENT Gate_AND IS_A bSI2SO "Defines a logic AND gate"
   DISCRETE
      EXPAND_BLOCK (i IN 1,n)
         WHEN ((s_in_1.signal[i] == TRUE) AND (s_in_2.signal[i] == TRUE)) THEN
            s_out.signal[i] = TRUE
         END WHEN

         WHEN ((s_in_1.signal[i] == FALSE) OR (s_in_2.signal[i] == FALSE)) THEN
            s_out.signal[i] = FALSE
         END WHEN

      END EXPAND_BLOCK
		
	CONTINUOUS
/*
		SEQUENTIAL
	      FOR (i IN 1,n)
	         IF ((s_in_1.signal[i] == TRUE) AND (s_in_2.signal[i] == TRUE)) THEN
	            s_out.signal[i] = TRUE
	        	ELSE
	            s_out.signal[i] = FALSE
	         END IF
	
	      END FOR		
		END SEQUENTIAL
*/		
END COMPONENT


--------------------------------------------------------------------------------
-- Component Gate_XOR
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a logic exclusive XOR gate.
--	The output is false if the two inputs are equal and it is true
--	if the two inputs are different
--------------------------------------------------------------------------------
COMPONENT Gate_XOR IS_A bSI2SO "Defines a logic exclusive XOR gate"
   DISCRETE
      EXPAND_BLOCK (i IN 1,n)
         WHEN (s_in_1.signal[i] != s_in_2.signal[i]) THEN
            s_out.signal[i] = TRUE
         END WHEN

         WHEN (s_in_1.signal[i] == s_in_2.signal[i]) THEN
            s_out.signal[i] = FALSE
         END WHEN

      END EXPAND_BLOCK
		
	CONTINUOUS
/*	
		SEQUENTIAL
	      FOR (i IN 1,n)
	         IF (s_in_1.signal[i] != s_in_2.signal[i]) THEN
	            s_out.signal[i] = TRUE
	         ELSE
	            s_out.signal[i] = FALSE
	         END IF	
	      END FOR
		END SEQUENTIAL
*/
END COMPONENT


--------------------------------------------------------------------------------
-- Component Gate_NOT
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a logic inverter or NOT gate
--------------------------------------------------------------------------------
COMPONENT Gate_NOT IS_A bSISO "Defines a logic inverter or NOT gate"
   DISCRETE
      EXPAND_BLOCK (i IN 1,n)
         WHEN (s_in.signal[i] == TRUE) THEN
            s_out.signal[i] = FALSE
         END WHEN

         WHEN (s_in.signal[i] == FALSE) THEN
            s_out.signal[i] = TRUE
         END WHEN

      END EXPAND_BLOCK
	
	CONTINUOUS
/*
		SEQUENTIAL
	      FOR (i IN 1,n)
	         IF (s_in.signal[i] == TRUE) THEN
	            s_out.signal[i] = FALSE
				ELSE				
	            s_out.signal[i] = TRUE
	         END IF	
	      END FOR				
		END SEQUENTIAL
*/
END COMPONENT


--------------------------------------------------------------------------------
-- Component BooleanToReal
--------------------------------------------------------------------------------
-- Purpose: Transforms a boolean signal to an analog (real) signal   
--------------------------------------------------------------------------------
COMPONENT BooleanToReal
   (
	INTEGER n = 1		UNITS no_units	"Dimension of inputs and outputs signal vectors"
   )
"Transforms Boolean signals to analog signals. The user defines the value of the output signals when the input signals are TRUE or FALSE"

   PORTS
      IN  bool_signal (n = n) s_in		"Boolean inlet signal"
      OUT analog_signal (n = n) s_out	"Analog outlet signal"

   DATA
	REAL ValueTrue = 1.0	"Output analog signal for TRUE Boolean input (-)"
	REAL ValueFalse = 0.0	"Output analog signal for FALSE Boolean input (-)"

   TOPOLOGY
      PATH s_in TO s_out

   CONTINUOUS

	EXPAND(i IN 1, n)
	   s_out.signal[i] = ZONE(s_in.signal[i]) ValueTrue
				   OTHERS ValueFalse
	
END COMPONENT


--------------------------------------------------------------------------------
-- Component RealToBoolean
--------------------------------------------------------------------------------
-- Purpose: Transforms an analog (real) signal to a Boolean signal
--    
--------------------------------------------------------------------------------
COMPONENT RealToBoolean
   (
	INTEGER n = 1		UNITS no_units	"Dimension of inputs and outputs signal vectors"
   )
"Transforms an analog (real) signal to a Boolean signal"
   PORTS
      IN  analog_signal (n = n) s_in	"Analog inlet signal"
      OUT bool_signal (n = n) s_out		"Boolean outlet signal"

   DATA
	REAL ValueTrue = 0.5		UNITS no_units	"Lower limit for switching the Boolean output to TRUE"
	REAL ValueFalse = 0.5	UNITS no_units	"Upper limit for switching the Boolean output to FALSE"

   TOPOLOGY
      PATH s_in TO s_out
	
   DISCRETE

	EXPAND_BLOCK(i IN 1, n)
	   WHEN(s_in.signal[i] > ValueTrue) THEN
		s_out.signal[i] = TRUE
	   END WHEN

	   WHEN(s_in.signal[i] < ValueFalse) THEN
		s_out.signal[i] = FALSE
	   END WHEN

	END EXPAND_BLOCK

	CONTINUOUS
/*	
		SEQUENTIAL
			FOR(i IN 1, n)
			   IF(s_in.signal[i] > ValueTrue) THEN
					s_out.signal[i] = TRUE
			   ELSEIF(s_in.signal[i] < ValueFalse) THEN
					s_out.signal[i] = FALSE
			   END IF	
			END FOR		
		END SEQUENTIAL
*/		
END COMPONENT


--------------------------------------------------------------------------------
-- Component RelationalOperator
--------------------------------------------------------------------------------
-- Purpose: To perform specified relational operation on the input signals
--    
--------------------------------------------------------------------------------

COMPONENT RelationalOperator IS_A SI2bSO 
  (
	ENUM RelationalOption option = Equal	"Relational Operation"
  )
"To perform specified relational operation on the input signals"
   DECLS
   DISCRETE
	EXPAND_BLOCK(i IN 1, n)

		EXPAND_BLOCK(option == Equal)
			WHEN(s_in_1.signal[i] == s_in_2.signal[i]) THEN
				s_out.signal[i] = TRUE
			END WHEN
			WHEN(s_in_1.signal[i] != s_in_2.signal[i]) THEN
				s_out.signal[i] = FALSE
			END WHEN
		END EXPAND_BLOCK

		EXPAND_BLOCK(option == NotEqual)
			WHEN(s_in_1.signal[i] != s_in_2.signal[i]) THEN
				s_out.signal[i] = TRUE
			END WHEN
			WHEN(s_in_1.signal[i] == s_in_2.signal[i]) THEN
				s_out.signal[i] = FALSE
			END WHEN
		END EXPAND_BLOCK

		EXPAND_BLOCK(option == GreaterThan)
			WHEN(s_in_1.signal[i] > s_in_2.signal[i]) THEN
				s_out.signal[i] = TRUE
			END WHEN
			WHEN(s_in_1.signal[i] <= s_in_2.signal[i]) THEN
				s_out.signal[i] = FALSE
			END WHEN
		END EXPAND_BLOCK

		EXPAND_BLOCK(option == GreaterEqual)
			WHEN(s_in_1.signal[i] >= s_in_2.signal[i]) THEN
				s_out.signal[i] = TRUE
			END WHEN
			WHEN(s_in_1.signal[i] < s_in_2.signal[i]) THEN
				s_out.signal[i] = FALSE
			END WHEN
		END EXPAND_BLOCK

		EXPAND_BLOCK(option == LessThan)
			WHEN(s_in_1.signal[i] < s_in_2.signal[i]) THEN
				s_out.signal[i] = TRUE
			END WHEN
			WHEN(s_in_1.signal[i] >= s_in_2.signal[i]) THEN
				s_out.signal[i] = FALSE
			END WHEN
		END EXPAND_BLOCK

		EXPAND_BLOCK(option == LessEqual)
			WHEN(s_in_1.signal[i] <= s_in_2.signal[i]) THEN
				s_out.signal[i] = TRUE
			END WHEN
			WHEN(s_in_1.signal[i] > s_in_2.signal[i]) THEN
				s_out.signal[i] = FALSE
			END WHEN
		END EXPAND_BLOCK


	END EXPAND_BLOCK

   CONTINUOUS
		SEQUENTIAL
			FOR(i IN 1, n)		
				IF(option == Equal) THEN
					IF(s_in_1.signal[i] == s_in_2.signal[i]) THEN
						s_out.signal[i] = TRUE
					ELSE
						s_out.signal[i] = FALSE
					END IF	
					
				ELSEIF(option == NotEqual) THEN
					IF(s_in_1.signal[i] != s_in_2.signal[i]) THEN
						s_out.signal[i] = TRUE
					ELSE
						s_out.signal[i] = FALSE
					END IF
					
				ELSEIF(option == GreaterThan) THEN
					IF(s_in_1.signal[i] > s_in_2.signal[i]) THEN
						s_out.signal[i] = TRUE
					ELSE
						s_out.signal[i] = FALSE
					END IF
		
				ELSEIF(option == GreaterEqual) THEN
					IF(s_in_1.signal[i] >= s_in_2.signal[i]) THEN
						s_out.signal[i] = TRUE
					ELSE
						s_out.signal[i] = FALSE
					END IF
		
				ELSEIF(option == LessThan) THEN
					IF(s_in_1.signal[i] < s_in_2.signal[i]) THEN
						s_out.signal[i] = TRUE
					ELSE
						s_out.signal[i] = FALSE
					END IF
		
				ELSEIF(option == LessEqual) THEN
					IF(s_in_1.signal[i] <= s_in_2.signal[i]) THEN
						s_out.signal[i] = TRUE
					ELSE
						s_out.signal[i] = FALSE
					END IF
				END IF			
			END FOR
		
		END SEQUENTIAL


END COMPONENT


--------------------------------------------------------------------------------
-- Component Switch
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a switch between two analog signal inputs
--	This component switches depending on the value of the logic
--	input port s_b_in between the two inlet analog signals (s_in[1] and s_in[2])
--------------------------------------------------------------------------------
COMPONENT Switch
  (
   INTEGER n = 1				UNITS no_units	"Dimension of inputs and outputs"
  )
 "Defines a analog switch"
   PORTS
      IN  analog_signal (n = n) s_in[2]	"Inlet signal"
      IN  bool_signal (n = n) s_b_in	"Boolean inlet signal"
      OUT analog_signal (n = n) s_out	"Outlet signal"

   CONTINUOUS
	EXPAND_BLOCK (i IN 1, n)
		s_out.signal[i] = ZONE(s_b_in.signal[i]) s_in[1].signal[i]
					   OTHERS s_in[2].signal[i]	
	END EXPAND_BLOCK
END COMPONENT


--------------------------------------------------------------------------------
-- Component LogicalSwitch
--------------------------------------------------------------------------------
-- Purpose:
--    Defines a logical switch that switches depending on the value of
--	the Boolean midle port (s_in[2]) between the two possible Boolean
--	input signals (s_in[1] and s_in[3])
--------------------------------------------------------------------------------
COMPONENT LogicalSwitch
  (
   INTEGER n = 1					UNITS no_units	"Dimension of inputs and outputs"
  )
 "Defines a logical switch"
   PORTS
      IN bool_signal (n = n) s_in[3]	"Boolean inlet signal"
      OUT bool_signal (n = n) s_out		"Boolean outlet signal"

   DISCRETE
	EXPAND_BLOCK(i IN 1, n)
		WHEN(s_in[2].signal[i] == TRUE) THEN
			s_out.signal[i] = s_in[1].signal[i]
		END WHEN

		WHEN(s_in[2].signal[i] == FALSE) THEN
			s_out.signal[i] = s_in[3].signal[i]
		END WHEN
		
	END EXPAND_BLOCK
	CONTINUOUS
		SEQUENTIAL
			FOR(i IN 1, n)
				IF(s_in[2].signal[i] == TRUE) THEN
					s_out.signal[i] = s_in[1].signal[i]
				ELSE
					s_out.signal[i] = s_in[3].signal[i]
				END IF					
			END FOR
		END SEQUENTIAL	
END COMPONENT


