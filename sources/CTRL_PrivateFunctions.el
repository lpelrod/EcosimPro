---------------------------------------------------------------------------------
-- EA Internacional 2005   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL2_Functions.el
--    FILE TYPE:  Functions of the CONTROL library
--    DESCRIPTION:  Defines functions for the CONTROL library
--    NOTES:  Based on EcosimPro CONTROL library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
USE MATH 

--Functions

--------------------------------------------------------------------------------
-- Function quantzr
--------------------------------------------------------------------------------
-- Purpose: To discretize an input at a specified interval or step    
--------------------------------------------------------------------------------
FUNCTION REAL quantzr
   (
   IN REAL step_size,
   IN REAL x
   )

   DECLS
      INTEGER i

   BODY
      i = x / step_size + 0.5

      RETURN  i * step_size

END FUNCTION

--------------------------------------------------------------------------------
-- Function Coeff_from_factorized
--------------------------------------------------------------------------------
-- Purpose: To define a function which returns the coefficients of a polinomial
--		from the factorized way. It admits n inputs, 
--		and the zeros may be complex
--------------------------------------------------------------------------------
FUNCTION NO_TYPE Coeff_from_factorized
   (
	IN INTEGER n  	"Number of factors",
	IN REAL z[n,2] 	"Values of the zeros on real-imaginary part form",
	OUT REAL p[n+1] 	"Real coefficients of the polinomial"
   )

   DECLS
	REAL pcomplex[3] "Polinomial coefficients of a complex zero and its conjugate"
	REAL pzero[2]    "Polinomial coefficients of a real zero"
      REAL zr, zi      "Imaginary part and real part of a non paired zero"
	INTEGER used[n]  "Marks which zeros are used"
	INTEGER h,l,r,k  "Auxiliary integers"      
      BOOLEAN conjugate_found = FALSE "Marks TRUE when conjugated zero is found"

   BODY
	
	p[1] = 1

		-- Initializes the used vector to 0 = no used
	FOR (i IN 1, n)
		used[i] = 0
	END FOR
	
	h=1		
	k = 0

	FOR (j IN 1,n)

		IF (z[j,2] !=0 AND used[j] == 0) THEN
			used[j] = 1

                  k = j+1
                  conjugate_found = FALSE
			WHILE (k <= n AND conjugate_found==FALSE)
				IF (abs(z[k,2] + z[j, 2]) < 1e-6 AND abs(z[k,1] - z[j,1]) < 1e-6 AND used[k] == 0) THEN
                              conjugate_found = TRUE
					used[k] = 1

					pcomplex[3] = 1
					pcomplex[2] = - 2 * z[k,1]

					pcomplex[1] = z[k,1]**2 + z[k,2]**2
			
					
					IF (h == 1) THEN
						p[3] = pcomplex[3] * p[1]
						p[2] = pcomplex[2] * p[1]
						p[1] = pcomplex[1] * p[1]
						h = h + 2
					ELSEIF (h == 2) THEN
						p[4] = p[2] * pcomplex[3]
						p[3] = p[1] * pcomplex[3] + p[2] * pcomplex[2]
						p[2] = p[1] * pcomplex[2] + p[2] * pcomplex[1]
						p[1] = p[1] * pcomplex[1]
						h = h + 2
					ELSE
						p[h+2] = p[h] * pcomplex[3]  			
						p[h+1] = pcomplex[3] * p[h-1] + p[h] * pcomplex[2]
						FOR (l=h; l>=3; l = l - 1)
							p[l] = pcomplex[1] * p[l] + pcomplex[2] * p[l-1] + p[l-2] * pcomplex[3]
						END FOR
						p[2] = p[2] * pcomplex[1] + p[1] * pcomplex[2]
						p[1] = pcomplex[1] * p[1]	
						h = h + 2		
                             	END IF
 				END IF
				
				k = k + 1
			END WHILE		
			ASSERT (conjugate_found == TRUE) ERROR("Zero or pole does not have its conjugate")
                  IF (conjugate_found == FALSE) THEN
				zr = z[j,1]
				zi = z[j,2]
				PRINT ("Zero or pole is $zr + $zi *j") 
            	END IF

		ELSEIF(used[j] == 0) THEN
			pzero[2] = 1
			pzero[1] = - z[j,1]

				IF (h == 1) THEN
					p[2] = p[1] * pzero[2]
					p[1] = p[1] * pzero[1]
					h = h + 1
				ELSE
					p[h+1] = p[h] * pzero[2]
						FOR (r = h; r >= 2; r = r - 1)
							p[r] = pzero[1] * p[r] + p[r-1] * pzero[2] 
						END FOR
					p[1] = p[1] * pzero[1]
					h = h + 1
				END IF
		END IF

	END FOR

END FUNCTION	



	