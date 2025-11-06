
USE MATH 

--Functions of the Electrical Library

FUNCTION REAL integer_value
(
	IN REAL x
) "Function to calculate convert real to integer"
	DECLS
		INTEGER i
		REAL z
	BODY
		i = x
		z = i
		RETURN z
END FUNCTION

FUNCTION REAL expLin
    (
        IN REAL x 
    )
    "Linearized exponential function"
    DECLS
        CONST REAL ExpMin = -100. "if x < EMin, the exp(x) function is linearized"
        CONST REAL ExpMax =   40. "if x > EMax, the exp(x) function is linearized"
        REAL y
    BODY
        IF (x < ExpMin) THEN
            y = exp(ExpMin)*(x - ExpMin + 1)
        ELSEIF (x < ExpMax) THEN
            y = exp(x)
        ELSE 
            y = exp(ExpMax)*(x - ExpMax + 1)
        END IF
        RETURN y
END FUNCTION
        
FUNCTION REAL JunctionCap 
    (
        IN REAL C0 	UNITS u_Farad "Zero bias junction capacitance",
        IN REAL V  	UNITS u_V "Voltage difference",
        IN REAL PHI  UNITS u_V "Junction built-in potential",
        IN REAL M 	UNITS no_units  "Grading coefficient",
        IN REAL FC 	UNITS no_units "Coefficient for forward-bias depletion capacitance formula"
    )
   "Function to calculate the electrical capacity of a junction (F)"
    DECLS
        REAL C
    BODY
        IF (V < FC * PHI) THEN
            C =  C0 / (1. - V/PHI)**M
        ELSE
            C = C0 * (1 - FC * (1 + M) + M * V/PHI)/(1-FC)**(1+M)
        END IF
        RETURN C
END FUNCTION
  