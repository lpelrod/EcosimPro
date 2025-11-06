--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: nonLinearEqnExamples.el
-- DESCRIPTION: Non-linear systems solved using the function EcoNonLinearEqnSolver
--------------------------------------------------------------------------------
USE MATH 

--------------------------------------------------------------------------------
-- First Example: 1 Non linear equation
-- A thermodynamic function for calculating the enthalpy of the gas nitrogen as function of temperature
-- This example shows how to calculate the temperature of the nitrogen in gas phase if the enthalpy is known using the
-- EcoNonLinearSolver function with IOPT = 2 (aproximated Jacobian)
--------------------------------------------------------------------------------
-- The function for calculating the enthalpy as a function of temperature
FUNCTION REAL fun_enthalpy_N2(IN REAL T UNITS "K" "Temperature")
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
   REAL H UNITS "kJ/kg" "Specific enthalpy"
BODY
   H = -a1/T + a2 * log(T) + a3 * T + a4 * T**2/2 + a5 * T**3/3 + \
   a6 * T**4/4 + a7 * T**5/5 + a8
	
   RETURN H
END FUNCTION
--The reverse function for calculating the temperature as a function of the enthalpy uses the EcoNonLinearSolver function
-- for solving the non-linear equation.
FUNCTION REAL fun_temperature_N2(REAL H UNITS "kJ/kg" "Specific enthalpy")
DECLS
   REAL T UNITS "K" "Temperature"
   CONST INTEGER n = 1 "Size of the non-linear system"
   CONST INTEGER ldum = 20 + (n**2+13*n)/2 "Length of the work array"
   REAL xx[n] "Values of the iteration variables"
   REAL fvec[n] "Residue functions"
   REAL dum[ldum] "Work array"
   REAL fjac[n*n] "Jacobian"
   REAL tol "Tolerance of the calculation"
   INTEGER idum[20] "Work array"
   INTEGER info "Information message of the calculation"
   INTEGER ilast "Status of the calculation"
   INTEGER iopt "Option for specifying how the Jacobian is calculated"
   STRING str_error[4] = {"Convergence reached",
                       "Number of calls to FCN has reached or exceeded the maximum value",
                       "TOL is too small. No further improvement in the calculation is possible",
                       "Iteration is not making good progress."}        "Information and error messages"
BODY
   --Initialization of the calculation options and iteration variables
   iopt = 2 --The Jacobian calculated by forward-differencing
   ilast = -1 --Indicate the start of the calculation
   tol = 1e-12 --Tolerance
   xx[1] = 298.15 --Initialisation of iteration variable
   EcoMachDep() --Function to calculate the machine precision
		   --Iteration calculation
   WHILE (ilast != 0)
      EcoNonLinearEqnSolver(ilast,iopt,n,xx,fvec,fjac,tol,info,dum,ldum,idum,0)
      T = xx[1]
      fvec[1] = H - fun_enthalpy_N2(T) --closing equation
   END WHILE
   --Checking whether the convergence has been sucessfull
   IF(info > 1 AND info < 5) THEN
      ASSERT(FALSE) ERROR str_error[info]
   ELSEIF(info == 0) THEN
      ASSERT(FALSE) ERROR "Improper input parameters (wrong initialization)"
   END IF
   --Return the calculated value
   RETURN T
END FUNCTION

-- Component to check the correct implementation of the function fun_temperature_N2, the function fun_enthalpy_N2 will be
-- called from the CONTINUOUS block of a component and the value of the enthalpy calculated by this function will be
-- used as input parameter for the function fun_temperature_N2. I If the function is well coded, the value returned by this
-- function must be the input value of the temperature
COMPONENT example_1NonLinearEqnSolver
DATA
   REAL T = 473.15 UNITS "K" "Input Temperature"
DECLS
   REAL H UNITS "kJ/kg" "Specific enthalpy"
   REAL Tcalc UNITS "K" "Calculated Temperature"
   REAL error UNITS "K" "Error"
CONTINUOUS
   H = fun_enthalpy_N2(T)
   Tcalc = fun_temperature_N2(H)
   error = Tcalc - T
END COMPONENT

--------------------------------------------------------------------------------
-- Second Example: 2 Non linear equations
-- Non linear system: a equation of a parabola and of a straight line
-- Used EcoNonLinearSolver function with IOPT = 1 (analytical Jacobian)
/*	x^2 + y^2 - 5 = 0
	x*e^y - e^(2*x) = 0
Solution: x = 1; y = 2*/
--------------------------------------------------------------------------------
-- The function where the system is solved by iteration calling to EcoNonLinearSolver function.
FUNCTION NO_TYPE fun_solve_2NonLinearEqn (OUT REAL x, OUT REAL y)
DECLS
 
   CONST INTEGER n = 2 "Size of the non-linear system"
   CONST INTEGER ldum = 20 + (n**2+13*n)/2 "Length of the work array"
   REAL xx[n] "Values of the iteration variables"
   REAL fvec[n] "Residue functions"
   REAL dum[ldum] "Work array"
   REAL fjac[n*n] "Jacobian"
   REAL tol "Tolerance of the calculation"
   INTEGER idum[20] "Work array"
   INTEGER info "Information message of the calculation"
   INTEGER ilast "Status of the calculation"
   INTEGER iopt "Option for specifying how the Jacobian is calculated"
   STRING str_error[4] = {"Convergence reached",
                       "Number of calls to FCN has reached or exceeded the maximum value",
                       "TOL is too small. No further improvement in the calculation is possible",
                       "Iteration is not making good progress."}        "Information and error messages"
	INTEGER k, iter	"Number of iterations"
BODY
   --Initialization of the calculation options and iteration variables
   iopt = 1 --The Jacobian calculated by forward-differencing
   ilast = -1 --Indicate the start of the calculation
   tol = 1e-12 --Tolerance
   xx[1] = 0.7// --Initialisation of iteration variable --> important! convergence sensitive to initialisation values
   xx[2] = 1.3
	EcoMachDep() --Function to calculate the machine precision
	
	-- Jacobian
	fjac[1] = 2*xx[1]								-- df1/dx1
	fjac[2] = E**(xx[2]) - 2*E**(2*xx[1])	-- df2/dx1
	fjac[3] = 2*xx[2]								-- df1/dx2
	fjac[4] = xx[1]*E**(xx[2])					-- df2/dx2
	
	   --Iteration calculation
   WHILE (ilast != 0)
	/*	WRITE("\n")
		WRITE("Iteration = %d \n", k)
		WRITE("\n")*/
	   k = k + 1
      EcoNonLinearEqnSolver(ilast,iopt,n,xx,fvec,fjac,tol,info,dum,ldum,idum,0)
      x = xx[1]
		 y = xx[2]
		fjac[1] = 2*xx[1]                      -- df1/dx1
		fjac[2] = E**(xx[2]) - 2*E**(2*xx[1])  -- df2/dx1
		fjac[3] = 2*xx[2]								-- df1/dx2
		fjac[4] = xx[1]*E**(xx[2])					-- df2/dx2
      fvec[1] = x**2 + y**2 -5 --closing equation
		fvec[2] = x*E**y - E**(2*x)--closing equation
		//WRITE("x = %g\n  fjac[1] = %g\n  fjac[2] = %g\n  fvec[1] = %g\n   info[1] =%d\n", x, fjac[1],fjac[2], fvec[1], info)
		//WRITE("y = %g\n  fjac[3] = %g\n  fjac[4] = %g\n  fvec[2] = %g\n   info[2] =%d\n", y, fjac[3],fjac[4], fvec[2], info)
   END WHILE
	  iter = k-1
		WRITE("\n")
		WRITE("Total number of iterations = %d \n", iter)
		WRITE("\n")
   --Checking whether the convergence has been sucessfull
   IF(info > 1 AND info < 5) THEN
      ASSERT(FALSE) ERROR str_error[info]
   ELSEIF(info == 0) THEN
      ASSERT(FALSE) ERROR "Improper input parameters (wrong initialization)"
   END IF

END FUNCTION

-- Component to call the previous function
COMPONENT example_2NonLinearEqnSolver
DECLS
   REAL x, y 
	REAL error1, error2
CONTINUOUS
   fun_solve_2NonLinearEqn(x,y)
	error1 = x**2 + y**2 -5
	error2 = x*E**y - E**(2*x)
END COMPONENT


--------------------------------------------------------------------------------
-- Third Example: 3 Non linear equations with 3 unknows
-- Non linear system: a equation of a circle, a parabola and of a straight line
-- Used EcoNonLinearSolver function with IOPT = 1 (analytical Jacobian)
/*		y - (x**2 -3) + z -1 = 0
		y - (3x - 5)+ z -1 = 0
		x^2 + y^2 - 5 + z -1= 0
Solution1: x = 2; y = 1; z = 1   
Solution2: x = 1; y = 3; z = -4
*/
--------------------------------------------------------------------------------
-- The function where the system is solved by iteration calling to EcoNonLinearSolver function.
FUNCTION NO_TYPE func_solve_3eqn (OUT REAL x, OUT REAL y, OUT REAL z)
DECLS

   CONST INTEGER n = 3 "Size of the non-linear system"
   CONST INTEGER ldum = 20 + (n**2+13*n)/2 "Length of the work array"
   REAL xx[n] "Values of the iteration variables"
   REAL fvec[n] "Residue functions"
   REAL dum[ldum] "Work array"
   REAL fjac[n*n] "Jacobian"
   REAL tol "Tolerance of the calculation"
   INTEGER idum[20] "Work array"
   INTEGER info "Information message of the calculation"
   INTEGER ilast "Status of the calculation"
   INTEGER iopt "Option for specifying how the Jacobian is calculated"
   STRING str_error[4] = {"Convergence reached",
                       "Number of calls to FCN has reached or exceeded the maximum value",
                       "TOL is too small. No further improvement in the calculation is possible",
                       "Iteration is not making good progress."}        "Information and error messages"
	INTEGER k, iter	"Number of iterations"
BODY
   --Initialization of the calculation options and iteration variables
   iopt = 1 --The Jacobian calculated by forward-differencing
   ilast = -1 --Indicate the start of the calculation
   tol = 1e-12 --Tolerance
	-- Initialization to find solution1 = {2, 1, 1}: {1.7, 1.1, 0.9}
	-- Initialization to find solution2 = {1, 3, -4}: {1, 1.7, 0.8}
   xx[1] = 1.7//1.// --Initialisation of iteration variable 
   xx[2] = 1.1//1.7
	xx[3] = 0.9//0.8
	EcoMachDep() --Function to calculate the machine precision
	
	-- Jacobian
		fjac[1] = -2*xx[1]			-- df1/dx1
		fjac[2] = -3					-- df2/dx1
		fjac[3] = 2*xx[1]				-- df3/dx1
		
		fjac[4] = 1						-- df1/dx2
		fjac[5] = 1						-- df2/dx2
		fjac[6] = 2*xx[2]				-- df3/dx2
		
		fjac[7] = 1						-- df1/dx3
		fjac[8] = 1						-- df2/dx3
		fjac[9] = 1						-- df3/dx3
	
	   --Iteration calculation
   WHILE (ilast != 0)
	/*	WRITE("\n")
		WRITE("Iteration = %d \n", k)
		WRITE("\n")*/
	   k = k + 1
      EcoNonLinearEqnSolver(ilast,iopt,n,xx,fvec,fjac,tol,info,dum,ldum,idum,0)
      x = xx[1]
		y = xx[2]
		z = xx[3]
		fjac[1] = -2*xx[1]
		fjac[2] = -3
		fjac[3] = 2*xx[1]
		fjac[4] = 1
		fjac[5] = 1
		fjac[6] = 2*xx[2]
		fjac[7] = 1
		fjac[8] = 1
		fjac[9] = 1
				
      fvec[1] = y - (x**2 -3) + z - 1  	--closing equation
		fvec[2] = y - (3*x - 5) + z - 1		--closing equation
		fvec[3] = x**2 + y**2 - 5 + z - 1	--closing equation
	//	WRITE("x = %g\n  fjac[1] = %g\n  fjac[2] = %g\n  fjac[3] = %g\n  fvec[1] = %g\n   info[1] =%d\n", x, fjac[1],fjac[2], fjac[3],fvec[1], info)
	//	WRITE("y = %g\n  fjac[4] = %g\n  fjac[5] = %g\n  fjac[6] = %g\n  fvec[2] = %g\n   info[2] =%d\n", y, fjac[4],fjac[5],fjac[6],fvec[2], info)
	//	WRITE("y = %g\n  fjac[7] = %g\n  fjac[8] = %g\n  fjac[9] = %g\n  fvec[3] = %g\n   info[3] =%d\n", y, fjac[7],fjac[8],fjac[9],fvec[3], info)
   END WHILE
	  iter = k-1
		WRITE("\n")
		WRITE("Total number of iterations = %d \n", iter)
		WRITE("\n")
   --Checking whether the convergence has been sucessfull
   IF(info > 1 AND info < 5) THEN
      ASSERT(FALSE) ERROR str_error[info]
   ELSEIF(info == 0) THEN
      ASSERT(FALSE) ERROR "Improper input parameters (wrong initialization)"
   END IF
   --Return the calculated value
   --RETURN x
END FUNCTION

-- Component to call the previous function
COMPONENT example_3NonLinearEqnSolver
DECLS
   REAL x, y, z
	REAL error1, error2, error3
CONTINUOUS
   func_solve_3eqn(x,y,z)
	error1 = y - (x**2 -3) + z -1
	error2 = y - (3*x - 5)+ z -1
	error3 = x**2 + y**2 - 5+ z -1

END COMPONENT

