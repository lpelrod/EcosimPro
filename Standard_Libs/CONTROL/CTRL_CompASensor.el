--------------------------------------------------------------------------------
-- EA Internacional 2011   EcosimPro Simulation Source Code
--
--    FILE NAME:  CTRL_CompASensor.el
--    FILE TYPE:  Abstract components of the CONTROL library
--    DESCRIPTION:  Defines the sensor abstract component for the CONTROL library
--    AUTHOR:  Ramon Perez Vara
--    CREATION DATE:  Feb-2005
--------------------------------------------------------------------------------
USE MATH 

-- Abstract Components
--------------------------------------------------------------------------------
-- Component ASensor
--------------------------------------------------------------------------------
-- Purpose:
--    An abstract class for definition of sensors.
--------------------------------------------------------------------------------
ABSTRACT COMPONENT ASensor IS_A MO "This component is used for deriving sensors by inheritance"

   DATA
      REAL gain[n_out] = 1.     UNITS no_units "Gain"
      REAL bias[n_out] = 0.     UNITS no_units "Bias"

   DECLS
      REAL var[n_out]           UNITS no_units	"Measured variable"

   CONTINUOUS
      EXPAND (i IN 1,n_out)
         s_out.signal[i] = gain[i] * var[i] + bias[i]

END COMPONENT