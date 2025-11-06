--------------------------------------------------------------------------------
--		EA Internacional 2008   EcosimPro Simulation Source Code
--
--		FILE NAME:		FunFreeConvec.el
--		FILE TYPE:		Functions of the THERMAL library
--		DESCRIPTION:	Defines natural convection correlations
--		NOTES:			Library THERMAL works in Kelvin
--		AUTHOR:			Stefano Naclerio
--		CREATION DATE:	18-Jan-2008
--------------------------------------------------------------------------------
USE MATH 

INTEGER setRaleighWarnings = 1 "Put this variable to 1 to test validity ranges" 


-- Correlations used by natural_convection_plate component 

FUNCTION REAL NusseltWall
	(
		IN REAL Pr			"Prandt Number", 
		IN REAL Ra			"Rayleigh Number"
	)
	"Natural convection correlation for a vertical plate"
	DECLS
		REAL Nu
		REAL Nu1
		REAL Nu2
		REAL limit = 1.E9
		REAL deviation = 0.1
		REAL upper_limit_correlation = 1.E12
	BODY
		ASSERT (Ra <upper_limit_correlation OR setRaleighWarnings==0) WARNING "Raleigh Number in Natural Convection Correlation for Wall is out of limit"
		IF Ra<limit*(1-deviation) THEN
			--Ra < 10E9
			Nu = 0.68+0.67*Ra**(1./4.)/(1.+(0.492/Pr)**(9./16.))**(4./9.)
		ELSEIF Ra>=limit*(1+deviation) THEN
		--Ra > 10E9
			Nu= (0.825+0.387*Ra**(1./6.)/(1.+(0.492/Pr)**(9./16.))**(8./27.))**2
		ELSE
			Nu1=0.68+0.67*Ra**(1./4.)/(1.+(0.492/Pr)**(9./16.))**(4./9.)
			Nu2= (0.825+0.387*Ra**(1./6.)/(1.+(0.492/Pr)**(9./16.))**(8./27.))**2
			Nu = (Nu2 + Nu1) / 2 + (Nu2 - Nu1) / 2 * tanh((Ra - limit) / limit) / abs(tanh(deviation))
		END IF
		RETURN Nu
END FUNCTION

FUNCTION REAL NusseltFloor
	(
		IN REAL Ra		"Rayleigh Number", 
		IN REAL Ts		"Solid Temperature (K)", 
		IN REAL Tf		"Fluid Temperature (K)"
	)
	"Natural convection correlation for a horizontal plate where the fluid is placed over the plate"
	DECLS
		REAL Nu
		REAL Nu1
		REAL Nu2
		REAL limit1 = 200.
		REAL limit2 = 1.E4
		REAL limit3 = 8.E6
		REAL deviation = 0.1
		REAL upper_limit_correlation1 = 1.E11
		REAL upper_limit_correlation2 = 1.5E11
	BODY
		IF Ts<Tf THEN
			ASSERT (Ra <upper_limit_correlation2 OR setRaleighWarnings==0) WARNING \
			"Raleigh Number in Natural Convection Correlation for Floor is out of limit for upper surface of cooled plate"
			Nu = 0.27*Ra**(1./4.)
		ELSE
			ASSERT (Ra <upper_limit_correlation1 OR setRaleighWarnings==0) WARNING \
			"Raleigh Number in Natural Convection Correlation for Floor is out of limit for upper surface of heated plate"
			IF Ra<limit1*(1-deviation) THEN
				Nu = 0.96*Ra**(1./6.)
			ELSEIF Ra>=limit1*(1-deviation) AND Ra<limit1*(1+deviation) THEN
				Nu1 = 0.96*Ra**(1./6.)
				Nu2 = 0.59*Ra**(1./4.)
				Nu = (Nu1 + Nu2) / 2 + (Nu2 - Nu1) / 2 * tanh((Ra - limit1) / limit1) / abs(tanh(deviation))
			ELSEIF Ra>=limit1*(1+deviation) AND Ra<limit2*(1-deviation) THEN
				Nu = 0.59*Ra**(1./4.)
			ELSEIF Ra>=limit2*(1-deviation) AND Ra<limit2*(1+deviation) THEN
				Nu1 = 0.59*Ra**(1./4.)
				Nu2 = 0.54*Ra**(1./4.)
				Nu = (Nu2 + Nu1) / 2 + (Nu2 - Nu1) / 2 * tanh((Ra - limit2) / limit2) / abs(tanh(deviation))
			ELSEIF Ra>=limit2*(1+deviation) AND Ra<limit3*(1-deviation) THEN
				Nu = 0.54*Ra**(1./4.)
			ELSEIF Ra>=limit3*(1-deviation) AND Ra<limit3*(1+deviation) THEN
				Nu1 = 0.54*Ra**(1./4.)
				Nu2 = 0.15*Ra**(1./3.)
				Nu = (Nu2 + Nu1) / 2 + (Nu2 - Nu1) / 2 * tanh((Ra - limit3) / limit3) / abs(tanh(deviation))
			ELSE
				Nu = 0.15*Ra**(1./3.)
			END IF
	END IF
	RETURN Nu
END FUNCTION

FUNCTION REAL NusseltCeiling
	(
		IN REAL Ra		"Rayleigh Number", 
		IN REAL Ts		"Solid Temperature (K)", 
		IN REAL Tf		"Fluid Temperature (K)"
	)
	"Natural convection correlation for a horizontal plate where the fluid is placed under the plate"
	DECLS
		REAL Nu
		REAL Nu1
		REAL Nu2
		REAL limit1 = 200.
		REAL limit2 = 1.E4
		REAL limit3 = 8.E6
		REAL deviation = 0.1
		REAL upper_limit_correlation1 = 1.E11
		REAL upper_limit_correlation2 = 1.5E11
	BODY
		IF Ts>Tf THEN
			ASSERT (Ra <upper_limit_correlation2 OR setRaleighWarnings==0) WARNING \
			"Raleigh Number in Natural Convection Correlation for Ceiling is out of limit for lower surface of heated plate"

			Nu = 0.27*Ra**(1./4.)
		ELSE
			ASSERT (Ra <upper_limit_correlation1 OR setRaleighWarnings==0) WARNING \
			"Raleigh Number in Natural Convection Correlation for Ceiling is out of limit for lower surface of cooled plate"

			IF Ra<limit1*(1-deviation) THEN
				Nu = 0.96*Ra**(1./6.)

			ELSEIF Ra>=limit1*(1-deviation) AND Ra<limit1*(1+deviation) THEN
				Nu1 = 0.96*Ra**(1./6.)
				Nu2 = 0.59*Ra**(1./4.)
				Nu = (Nu1 + Nu2) / 2 + (Nu2 - Nu1) / 2 * tanh((Ra - limit1) / limit1) / abs(tanh(deviation))
			ELSEIF Ra>=limit1*(1+deviation) AND Ra<limit2*(1-deviation) THEN
				Nu = 0.59*Ra**(1./4.)
			ELSEIF Ra>=limit2*(1-deviation) AND Ra<limit2*(1+deviation) THEN
				Nu1 = 0.59*Ra**(1./4.)
				Nu2 = 0.54*Ra**(1./4.)
				Nu = (Nu2 + Nu1) / 2 + (Nu2 - Nu1) / 2 * tanh((Ra - limit2) / limit2) / abs(tanh(deviation))
			ELSEIF Ra>=limit2*(1+deviation) AND Ra<limit3*(1-deviation) THEN
				Nu = 0.54*Ra**(1./4.)
			ELSEIF Ra>=limit3*(1-deviation) AND Ra<limit3*(1+deviation) THEN
				Nu1 = 0.54*Ra**(1./4.)
				Nu2 = 0.15*Ra**(1./3.)
				Nu = (Nu2 + Nu1) / 2 + (Nu2 - Nu1) / 2 * tanh((Ra - limit3) / limit3) / abs(tanh(deviation))
			ELSE
				Nu = 0.15*Ra**(1./3.)
			END IF
		END IF
		RETURN Nu
END FUNCTION


FUNCTION REAL NusseltCylinder
	(
		IN REAL Pr		"Prandt Number",
		IN REAL Ra		"Rayleigh Number"
	)
	"Natural convection correlation for a horizontal plate"
	DECLS
		REAL Nu
		REAL lower_limit_correlation = 1.E9
		REAL upper_limit_correlation = 1.E13
	BODY
		ASSERT (Ra <= upper_limit_correlation OR setRaleighWarnings==0) WARNING "Raleigh Number in Natural Convection Correlation for Cylinder is out of upper limit"
		ASSERT (Ra >= lower_limit_correlation OR setRaleighWarnings==0) WARNING "Raleigh Number in Natural Convection Correlation for Cylinder is out of lower limit"

		Nu = ( 0.6 + (0.387*Ra**(1/6))/(1 + (0.559/Pr)**(9/16))**(8/27) )**2

		RETURN Nu
END FUNCTION


FUNCTION REAL NusseltWireHorizontal
	(
		IN REAL Pr		"Prandt Number", 
		IN REAL Ra		"Rayleigh Number"--, 
--		IN REAL d		"Diameter (m)"
	)
	"Natural convection correlation for a horizontal wire"
	DECLS
		REAL Nu
		REAL c
		REAL n
		REAL lower_limit_correlation = 1.E-8
		REAL upper_limit_correlation = 1.E6
	BODY
		ASSERT (Ra <= upper_limit_correlation OR setRaleighWarnings==0) NOTE "Raleigh Number in Natural Convection Correlation for Horizontal Wire is out of upper limit"
		ASSERT (Ra >= lower_limit_correlation OR setRaleighWarnings==0) NOTE "Raleigh Number in Natural Convection Correlation for Horizontal Wire is out of lower limit"

		c = 0.671/(1 + (0.492/Pr)**(9/16))**(4/9)
		n = 0.25 + 1/(10 + 5*(Ra)**(0.175) )

		Nu = 2/log(1 + 3.3/(c*Ra**n))

		RETURN Nu
END FUNCTION

FUNCTION REAL NusseltWireVertical
	(
		IN REAL Pr		"Prandt number",
		IN REAL Ra		"Rayleigh number", 
		IN REAL d		"Diameter (m)", 
		IN REAL L		"Length of the wire (m)"
	)
	"Natural convection correlation for a vertical wire"
	DECLS
		REAL Nu
		REAL c
		REAL n
		REAL lower_limit_correlation = 2.E-3
	BODY

		c = 0.671/(1 + (0.492/Pr)**(9/16))**(4/9)

		ASSERT (c*(Ra*d/L)**0.25 > lower_limit_correlation OR setRaleighWarnings==0) WARNING "Raleigh Number in Natural Convection Correlation for Vertical Wire is out of lower limit"

		n = 0.25 + 1/(10 + 5*(Ra)**(0.175) )

		Nu = c*(Ra*d/L)**0.25 + 0.763*c**(1/6)*(Ra*d/L)**(1/24)

		RETURN Nu
END FUNCTION
