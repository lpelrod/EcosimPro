USE MATH 

-- Ports

--------------------------------------------------------------------------------
-- Ports analog_signal and bool_signal
--------------------------------------------------------------------------------
-- Note:
--    "SINGLE IN" in the declaration of the signal port types means that
--    multiple connections to signal input ports are forbidden. However, it
--    is possible to make multiple connection from an outlet signal port,
--    i.e it is possible to broadcast an outlet signal.
--------------------------------------------------------------------------------
PORT analog_signal (INTEGER n = 1 UNITS no_units	"Number of outputs")   SINGLE IN  "Analog signals 1D port"
   EQUAL OUT REAL signal[n]       UNITS no_units	"Analog signal values"
END PORT

PORT bool_signal (INTEGER n = 1   UNITS no_units	"Number of outputs"  ) SINGLE IN  "Boolean signals 1D port"
   EQUAL OUT BOOLEAN signal[n]    UNITS no_units	"Boolean signal values"
END PORT


--------------------------------------------------------------------------------
-- Port mech_rot (Rotational port)
--------------------------------------------------------------------------------
PORT mech_rot "1D rotational flange"
   SUM   REAL T			UNITS u_Nm		"Torque "
   EQUAL REAL omega		UNITS u_rad_s	"Absolute angular velocity"
         REAL n			UNITS u_rpm		"Angular velocity"

   CONTINUOUS
	omega = n * (2*MATH.PI/60)
END PORT

--------------------------------------------------------------------------------
-- Port mech_trans (Translational port)
--------------------------------------------------------------------------------
PORT mech_trans "1D translational flange"
   SUM   REAL F			UNITS u_N		"Force"
   EQUAL REAL s			UNITS u_m		"Absolute position"
END PORT


--------------------------------------------------------------------------------
-- Port elec (Electricalport)
--------------------------------------------------------------------------------
PORT elec    "Electrical pin" 
    EQUAL REAL v 		UNITS u_V		"Potential at pin"   
    SUM   REAL i 		UNITS	u_A		"Current flowing into the pin"
END PORT


--------------------------------------------------------------------------------
--    Thermal port for heat exchanges in array of nodes.
--------------------------------------------------------------------------------
PORT thermal (INTEGER n = 1 UNITS no_units	"Size of thermal port arrays")   "1D thermal port"
   EQUAL REAL Tk[n] =  293.15   UNITS u_K			RANGE  0,TMAX   	"Kelvin  Temperature Array"
   EQUAL REAL Tc[n] =   20.     UNITS u_C									"Celsius Temperature Array"
   SUM   REAL  q[n]             UNITS u_W									"Heat Flow Array"
CONTINUOUS
    EXPAND (j IN 1, n)
        Tc[j] = Tk[j] - TZERO
END PORT
