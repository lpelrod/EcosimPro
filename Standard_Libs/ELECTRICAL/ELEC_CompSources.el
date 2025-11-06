
-- Libraries
USE MATH 
USE PORTS_LIB 

COMPONENT Ramp 
    "Control component to generate ramp signals"
     PORTS
        OUT analog_signal (n=1) s_out
     DATA
        REAL height  = 1.   UNITS no_units   "Heights of ramp"
        REAL duration = 1.  UNITS u_s   		"Durations of ramps"
        REAL offset   = 0.  UNITS no_units   "Offsets of output signals"
        REAL startTime = 0. UNITS u_s   		"Output = offset for time < startTime"

    DECLS
        REAL outsignal
        BOOLEAN state_off = TRUE
        BOOLEAN state_rise = FALSE
        BOOLEAN state_const = FALSE
    INIT
        state_off = FALSE AFTER startTime
        state_rise = TRUE AFTER startTime
        state_rise = FALSE AFTER startTime + duration
        state_const = TRUE AFTER startTime + duration
    CONTINUOUS
        outsignal = ZONE(state_off) offset
                ZONE(state_rise) offset + (TIME - startTime) * height / duration
                ZONE(state_const) offset + height
                OTHERS 0.
        s_out.signal[1] = outsignal
END COMPONENT


COMPONENT Sine 
    "Control component to generate sine signals"
     PORTS
        OUT analog_signal (n=1) s_out
    DATA
        REAL amplitude    = 1.   UNITS no_units 	"Amplitudes of sine waves"
        REAL freqHz       = 1.   UNITS u_Hz		 	"Frequencies of sine waves"
        REAL phase        = 0.   UNITS u_rad			"Phases of sine waves"
        REAL offset       = 0.   UNITS no_units		"Offsets of output signals"
        REAL startTime    = 0.   UNITS u_s		   "Output = offset for time < startTime"
    
    DECLS
        REAL outsignal
        BOOLEAN state_off = TRUE
       
    INIT
        state_off = FALSE AFTER startTime

    CONTINUOUS

        outsignal = ZONE(state_off) offset
                ZONE(NOT state_off)offset + amplitude * \
                    sin(2.*PI*freqHz*(TIME - startTime) + phase)
                OTHERS 0.
        s_out.signal[1] = outsignal
END COMPONENT

COMPONENT ExpSine 
    "Control component to generate exponentially damped sine signals"
     PORTS
        OUT analog_signal (n=1) s_out
    DATA
        REAL amplitude    = 1.   UNITS no_units	"Amplitudes of sine waves"
        REAL freqHz       = 1.   UNITS u_Hz		"Frequencies of sine waves"
        REAL phase        = 0.   UNITS u_rad		"Phases of sine waves"
        REAL damping      = 1.   UNITS no_units	"Damping coefficients of sine waves"
        REAL offset       = 0.   UNITS no_units	"Offsets of output signals"
        REAL startTime    = 0.   UNITS u_s		"Output = offset for time < startTime"
        
    DECLS
        REAL outsignal
        BOOLEAN state_off = TRUE
    INIT
        state_off = FALSE AFTER startTime

    CONTINUOUS

        outsignal = ZONE(state_off) offset
                ZONE(NOT state_off) offset + amplitude / \
                    exp((TIME - startTime) * damping) * \
                    sin(2.*PI*(freqHz*(TIME - startTime) + phase / 360.))
                OTHERS 0.
        s_out.signal[1] = outsignal
END COMPONENT

COMPONENT Trapezoid 
    "Control component to generate trapezoidal signals of type Real"
     PORTS
        OUT analog_signal (n=1) s_out
    DATA
        REAL amplitude    = 1.  UNITS no_units 	 "Amplitudes of waves"
        REAL rising       = 1.  UNITS u_s			 "Rising durations of trapezoids"
        REAL width        = 1.  UNITS u_s			 "Widths of pulses"
        REAL falling      = 1.  UNITS u_s		    "Falling durations of trapezoids"
        REAL period       = 3.  UNITS u_s			 "Times for one period"
        REAL nperiod      = 0.  UNITS no_units   "Number of periods (0 ==> no limit)"
        REAL offset       = 0.  UNITS no_units	 "Offsets of output signals"
        REAL startTime    = 0.  UNITS no_units	 "Output = offset for time < startTime"
    

    DECLS

        REAL nper = -1   UNITS no_units  "Number of complete periods"
        REAL tin         UNITS u_s		  "Time inside cycle"
        REAL outsignal     "Output value"

        BOOLEAN state_off = TRUE
        BOOLEAN state_rise = FALSE
        BOOLEAN state_plain = FALSE
        BOOLEAN state_fall = FALSE
        BOOLEAN trapez = FALSE
    INIT
        ASSERT (rising + width + falling <= period) FATAL "Period < rising + width + falling"
        trapez = TRUE AFTER startTime
            IF (nperiod > 0)THEN
            trapez = FALSE AFTER (startTime + nperiod * period)
        END IF

    DISCRETE

        WHEN (trapez AND state_off AND TIME >= startTime AND (tin >= period OR nper < 0))THEN
            state_off = FALSE
            state_rise = TRUE
            nper = nper + 1
        END WHEN
        WHEN (trapez AND state_rise AND TIME >= startTime AND tin >= rising)THEN
            state_rise = FALSE
            state_plain = TRUE
        END WHEN
        WHEN (trapez AND state_plain AND TIME >= startTime AND tin >= rising + width)THEN
            state_plain = FALSE
            state_fall = TRUE
        END WHEN
        WHEN (trapez AND state_fall AND TIME >= startTime AND tin >= rising + width + falling)THEN
            state_fall = FALSE
            state_off = TRUE
        END WHEN
        WHEN (NOT trapez)THEN
            state_off = TRUE
            state_rise = FALSE
            state_plain = FALSE
            state_fall = FALSE
        END WHEN

    CONTINUOUS
        tin = TIME - startTime - period * nper

        outsignal = ZONE(state_off)offset
                ZONE(state_rise)offset + amplitude/rising * tin
                ZONE(state_plain)offset + amplitude
                ZONE(state_fall)offset + amplitude - amplitude/falling * \
                    (tin - rising - width)
                OTHERS 0.
 
        s_out.signal[1] = outsignal
END COMPONENT

ABSTRACT COMPONENT Exponentials 
    "Control component to generate a rising and falling exponential signal"
     PORTS
        OUT analog_signal (n=1) s_out
    DATA
        REAL outMax         = 1.  UNITS no_units  "Height of output for infinite riseTime"
        REAL riseTime       = 1.  UNITS u_s		  "Rise time"
        REAL riseTimeConst= 0.1   UNITS u_s 		  "Rise time constant"
        REAL fallTimeConst= 0.1   UNITS u_s  	  "Fall time constant"
        REAL offset        = 0.   UNITS no_units  "Offset of output signal (-)"
        REAL startTime    = 0.    UNITS u_s  	  "Output = offset for time < startTime" 

    DECLS

        REAL y_riseTime   "Output value at the end of the rise time"
        REAL outsignal    "Output value"
        BOOLEAN state_off = TRUE
        BOOLEAN state_rise = FALSE
        BOOLEAN state_fall = FALSE
      INIT 
            state_off = FALSE AFTER startTime
            state_rise = TRUE AFTER startTime
            state_rise = FALSE AFTER startTime + riseTime
            state_fall = TRUE AFTER startTime + riseTime

    CONTINUOUS

        y_riseTime = outMax * (1 - exp(-riseTime/riseTimeConst))

        outsignal = ZONE(state_off) offset
                ZONE(state_rise) offset + outMax * (1.- exp(-(TIME - startTime)/riseTimeConst))
                ZONE(state_fall) offset + y_riseTime * exp(-(TIME - startTime - riseTime) / fallTimeConst)
                OTHERS 0.
        s_out.signal[1] = outsignal
END COMPONENT

COMPONENT VoltageConstant IS_A OnePort
    "Source for constant voltage" 
    DATA
        REAL V=1 UNITS u_V		"Value of constant voltage"
    CONTINUOUS
        v = V
END COMPONENT

COMPONENT VoltageSignal IS_A OnePort
    "Generic voltage source using the input signal as source voltage"
    PORTS
        IN analog_signal s_in     
    CONTINUOUS
        s_in.signal[1] = v
END COMPONENT
  
COMPONENT VoltageSine IS_A OnePort
     "Sine Voltage Source"
     DATA
        REAL Vpeak     = 1.  UNITS u_V  "Voltage amplitude"
        REAL Voffset    = 0. UNITS u_V  "Voltage offset"
        REAL freqHz    = 1.  UNITS u_Hz  "Frequencies of sine waves"
        REAL phase     = 0.  UNITS u_rad  "Phases of sine waves"
        REAL startTime = 0.  UNITS u_s  "Output = offset for time < startTime"
    
    TOPOLOGY
        VoltageSignal voltage 
        Sine source (
            amplitude = Vpeak, 
            freqHz = freqHz, 
            phase = phase,
            offset = Voffset,
            startTime = startTime)
 
        CONNECT source.s_out TO voltage.s_in
        CONNECT e_p TO voltage.e_p
        CONNECT e_n TO voltage.e_n
END COMPONENT
  
COMPONENT CurrentConstant IS_A OnePort
    "Source for constant Current" 
    DATA
        REAL I=1 	UNITS u_A		"Value of constant Current"
    CONTINUOUS
        i = I
END COMPONENT

COMPONENT CurrentSignal IS_A OnePort
    "Generic Current source using the input signal as source Current"
    PORTS
        IN analog_signal s_in     
    CONTINUOUS
        s_in.signal[1] = i
END COMPONENT
  
COMPONENT CurrentSine IS_A OnePort
    "Sine Current source" 
     DATA
        REAL Ipeak     = 1.  UNITS u_A   "Current amplitude "
        REAL Ioffset   = 0.  UNITS u_A   "Current offset "
        REAL freqHz    = 1.  UNITS u_Hz  "Frequencies of sine waves "
        REAL phase     = 0.  UNITS u_rad "Phases of sine waves"
        REAL startTime = 0.  UNITS u_s   "Output = offset for time < startTime" 
    	  
    TOPOLOGY
        CurrentSignal current 
        Sine source (
            amplitude = Ipeak, 
            freqHz = freqHz, 
            phase = phase,
            offset = Ioffset,
            startTime = startTime)
 
        CONNECT source.s_out TO current.s_in
        CONNECT e_p TO current.e_p
        CONNECT e_n TO current.e_n
END COMPONENT
  




