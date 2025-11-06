--------------------------------------------------------------------------------
-- (c) Empresarios Agrupados - EcosimPro Simulation Source Code
-- FILE NAME: aircraftGear.el
-- DESCRIPTION: Defines "aircraftGear" component example
-- NOTES:
-- AUTHOR: Ramon Perez Vara
-- CREATION DATE: 7/03/1999
--------------------------------------------------------------------------------
USE MATH 
-- Components
--------------------------------------------------------------------------------
-- Aircraft arrester gear system example: Simulation of one of the system used
-- to halt an aircraft landing on a runway (used for ZONE statement demonstration)
--------------------------------------------------------------------------------
COMPONENT aircraftGear
   "Aircraft arrester gear system example (used for ZONE statement demonstration)"

   DATA
      REAL m1 = 2042.6            UNITS u_kg		"Aircraft mass"
      REAL m2 = 660.6             UNITS u_kg		"Carriage mass"
      REAL m3 = 291.8             UNITS u_kg		"Squeezer mass"
      REAL k1 = 6170              UNITS u_N_m	"Spring coefficient 1"
      REAL k2 = 34310             UNITS u_N_m	"Spring coefficient 2"
      REAL h = 38.1               UNITS u_m		"Horizontal length of cable"

   DECLS
      TABLE_1D tab = {
            {0, 9.14, 18.29, 36.58, 45.72, 54.86, 64.01, 73.15, 82.30, 85.95, 89.61, 93.27, 95.10, 98.76},
            {398.56, 191.39, 76.56, 248.80, 248.80, 315.79, 397.13, 511.96, 765.55, 1004.78, 1339.71, 1961.72, 2392.34, 4306.22}
         } "Drag coefficient (N*s^2/m^2) vs 'y3' displacement (m)"

      REAL y1, y2, y3             UNITS u_m			"Displacements "
      REAL x                      UNITS u_m			"Horizontal distance aircraft arrester cable"
      REAL fk1, fk2               UNITS u_N			"Cable tensions"
      REAL sinetheta              UNITS no_units	"Sine of angle of cable under tension"
      REAL fdrag                  UNITS u_N			"Drag force"
      REAL temp                   UNITS "N*s^2/m^2"	"Drag coefficient"

   CONTINUOUS
      -- Geometry
      y1 = sqrt(x**2 + h**2) - h
      sinetheta = x / (h + y1)

      -- Calculats drag coefficient from the table
      temp = linearInterp1D(tab, y3)

      -- Drag force
      fdrag = temp * y3'**2

      -- Cable tensions
      fk1 = ZONE (y1 > 2 * y2) k1 * (y1 - 2 * y2)
            OTHERS             0.

      fk2 = ZONE (y2 > y3) k2 * (y2 - y3)
            OTHERS         0.

      -- Acceleration of masses
      y3'' = (fk2 - fdrag) / m3
      y2'' = (2. * fk1 - fk2) / m2
      x'' = -2. * fk1 * sinetheta / m1

END COMPONENT
