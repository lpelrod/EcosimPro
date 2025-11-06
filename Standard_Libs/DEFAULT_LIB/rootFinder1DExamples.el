--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: rootFinder1DExamples.el
-- DESCRIPTION: class ROOTFINDER1D for finding the root of a function of type f(x) using Brent’s method.
--					Brent’s method is an algorithm to find roots of one variable functions that was developed to
--					speed up the bisection method by using the secant method or inverse quadratic interpolation whenever possible
--------------------------------------------------------------------------------
USE MATH 
FUNCTION REAL fun2_enthalpy_N2(IN REAL H UNITS "kJ/kg" "Specific enthalpy",IN REAL T UNITS "K" "Temperature")
DECLS
   --Coefficient of the function for calculating the specific enthalpy of N2
   CONST REAL a1 = 6.56040065635E+03
   CONST REAL a2 = -1.13332258691E+02
   CONST REAL a3 = 1.80536171334E+00
   CONST REAL a4 =-2.53198236453E-03
   CONST REAL a5 = 4.10964119808E-06
   CONST REAL a6 = -2.85694340830E-09
   CONST REAL a7 = 7.47850742086E-13
   CONST REAL a8 = 2.10979698910E+02
BODY
	
   RETURN -a1/T + a2 * log(T) + a3 * T + a4 * T**2/2 + a5 * T**3/3 + \
   a6 * T**4/4 + a7 * T**5/5 + a8 - H
END FUNCTION
--------------------------------------------------------------------------------
-- First Example: 1 Non linear equation
-- A thermodynamic function for calculating the enthalpy of the gas nitrogen as function of temperature
-- The reverse function for calculating the temperature as a function of the enthalpy uses the findRootZBrent method
-- for solving the non-linear equation.
---------------------------------------------------------------------------------
FUNCTION NO_TYPE fun_findRootZBrent_temperature_N2(IN REAL H UNITS "kJ/kg" "Specific enthalpy", OUT REAL T UNITS "K" "Temperature")
DECLS
   REAL lBound, uBound, tol, root, fval
   INTEGER ilast	"Status of the calculation"
	INTEGER k, iter	"Number of iterations"
OBJECTS
   ROOTFINDER1D rf
	
BODY
   -- Set initial bracket where the root is going to be searched for
   lBound = 300
   uBound = 500
   tol = 1e-11 -- Max tolerance
   ilast = 0 --Indicate the start of the calculation
   T = 473.15 --Initialisation of iteration variable

		   --Iteration calculation
   WHILE (ilast != 4 AND ilast >= 0)
	   k = k + 1
      T = rf.findRootZBrent(ilast, fval, lBound, uBound, tol)
      -- Calculate f(x) for next step
      fval = fun2_enthalpy_N2(H,T)
   END WHILE
	  iter = k-1
		WRITE("\n")
		WRITE("Total number of iterations = %d \n", iter)
		WRITE("\n")
--	   WRITE("\n Temp value = %.20g Last state was %d\n\n", T, ilast)
END FUNCTION

-- Component to check the correct implementation of the function fun_temperature_N2, the function fun_enthalpy_N2 will be
-- called from the CONTINUOUS block of a component and the value of the enthalpy calculated by this function will be
-- used as input parameter for the function fun_temperature_N2. I If the function is well coded, the value returned by this
-- function must be the input value of the temperature
COMPONENT example_1NonLinear_findRootZBrent
DATA
   REAL T = 473.15 UNITS "K" "Input Temperature"
DECLS
   REAL H UNITS "kJ/kg" "Specific enthalpy"
   REAL Tcalc UNITS "K" "Calculated Temperature"
   REAL error UNITS "K" "Error"
CONTINUOUS
   H = fun_enthalpy_N2(T)
   fun_findRootZBrent_temperature_N2(H, Tcalc)
   error = Tcalc - T
END COMPONENT

--------------------------------------------------------------------------------
-- Second Example: 
-- Function whose root is going to be searched for
-----------------------------------------------------
FUNCTION REAL func_simpleFunction(REAL x)
BODY
   RETURN (x - 2) * (x + 5)
END FUNCTION
--------------------------------------------------------
-- Testing function
--------------------------------------------------------
FUNCTION NO_TYPE func_findRootZBrent_simpleExample(OUT REAL root)
DECLS
   REAL lBound, uBound, tol, fval
   INTEGER ilast
OBJECTS
   ROOTFINDER1D rf
BODY
   -- Set initial bracket where the root is going to be searched for
   lBound = -6
   uBound = 0
   tol = 1e-3 -- Max tolerance
   root = 0
   ilast = 0
   -- Define the loop for finding a root of the function
   WHILE ( ilast != 4 AND ilast >= 0)
      -- Call to the method. Remember that ilast
      -- will be used in the next iteration and it
      -- will be modified by findRootZBrent
      root = rf.findRootZBrent(ilast, fval, lBound, uBound, tol)
      -- Calculate f(x) for next step
      fval = func_simpleFunction(root)
		WRITE("\n Root = %.20g Last state was %d\n\n", root, ilast)		
   END WHILE
   WRITE("\n Root value = %.20g Last state was %d\n\n", root, ilast)
END FUNCTION
----------------------------------------------------
-- Dummy compponent to test the use of ROOTFINDER1D
----------------------------------------------------
COMPONENT comp_rootFinder1dClass
DECLS
	REAL root1
CONTINUOUS
 func_findRootZBrent_simpleExample(root1)
END COMPONENT

