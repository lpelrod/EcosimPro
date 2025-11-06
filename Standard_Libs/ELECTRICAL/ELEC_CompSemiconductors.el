
-- Libraries
USE MATH 
USE PORTS_LIB 

--This file contains semiconductor devices:

COMPONENT Diode IS_A OnePort 
    "Semiconductor diode" 
    DATA
        REAL Ids=1.e-6  UNITS u_A    "Saturation current"
        REAL Vt=0.04    UNITS u_V    "Voltage equivalent of temperature =kT/qn"
        REAL R=1.e8     UNITS u_Ohm  "Parallel ohmic resistance"

    CONTINUOUS
        i =   Ids*(expLin(v/Vt) - 1) + v/R
END COMPONENT
  
COMPONENT PMOS 
   "Simple MOS Transistor"
    PORTS 
        IN elec e_D "Drain" 
        IN elec e_G "Gate" 
        IN elec e_S "Source"
        IN elec e_B "Bulk"

    DATA
        REAL  W    = 20.0e-6  UNITS u_m 		"Width (m)"
        REAL  L    = 6.0e-6   UNITS u_m 		"Length (m)"
        REAL  Beta = 0.0105   UNITS "A/V^2" 	"Transconductance parameter"
        REAL  Vt   =  -1.0    UNITS u_V 		"Zero bias threshold voltage"
        REAL  K2   =  0.41    UNITS no_units "Bulk threshold parameter"
        REAL  K5   =  0.839   UNITS no_units "Reduction of pinch-off region"
        REAL  dW   =  -2.5e-6 UNITS u_m		 "Narrowing of channel"
        REAL  dL   =  -2.1e-6 UNITS u_m		 "Shortening of channel "
    
    DECLS
        REAL v
        REAL uds
        REAL ubs
        REAL ugst
        REAL ud
        REAL us
        REAL id
    DISCRETE
        ASSERT (L + dL > 0) ERROR "Effective length must be positive"
        ASSERT (W + dW > 0) ERROR "Effective width  must be positive"
    CONTINUOUS


        v = Beta*(W + dW)/(L + dL)

        ud = ZONE(e_D.v > e_S.v) e_S.v 
             OTHERS          e_D.v

        us = ZONE (e_D.v > e_S.v) e_D.v 
             OTHERS e_S.v

        uds = ud - us

        ubs = ZONE(e_B.v < us) 0 
              OTHERS         e_B.v - us

        ugst = (e_G.v - us - Vt + K2*ubs)*K5
 
        id = ZONE (ugst >= 0)   v*uds*1.e-7 
             ZONE(ugst < uds)  -v*uds*(ugst - uds/2 - 1.e-7) 
             OTHERS            -v*(ugst*ugst/2 - uds*1.e-7)
        e_G.i = 0

        e_D.i = ZONE (e_D.v > e_S.v) -id 
              OTHERS            id

        e_S.i = ZONE (e_D.v > e_S.v)  id 
              OTHERS           -id

        e_B.i = 0
END COMPONENT

COMPONENT NMOS 
    "Simple MOS Transistor" 
 
    PORTS
        IN elec e_D "Drain" 
        IN elec e_G "Gate"
        IN elec e_S "Source" 
        IN elec e_B "Bulk"
    DATA
        REAL W    = 20.e-6 	UNITS u_m		"Width"
        REAL L    = 6.e-6  	UNITS u_m		"Length"
        REAL Beta = 0.041  	UNITS "A/V^2"	"Transconductance parameter"
        REAL Vt   =0.8 			UNITS u_V		"Zero bias threshold voltage"
        REAL K2   =1.144 		UNITS no_units	"Bulk threshold parameter"
        REAL K5   =0.7311  	UNITS no_units	"Reduction of pinch-off region"
        REAL dW   = -2.5e-6 	UNITS u_m		"Narrowing of channel"
        REAL dL   = -1.5e-6 	UNITS u_m		"Shortening of channel"
    DECLS 
        REAL v
        REAL uds
        REAL ubs
        REAL ugst
        REAL ud

        REAL us
        REAL id
    DISCRETE 
        ASSERT (L + dL > 0) ERROR "Effective length must be positive"
        ASSERT (W + dW > 0) ERROR "Effective width  must be positive"
    CONTINUOUS
        v = Beta*(W + dW)/(L + dL)
        --ud = max(e_S.v, e_D.v)
        --us = min(e_S.v, e_D.v)
        ud = ZONE(e_D.v > e_S.v) e_D.v 
             OTHERS          e_S.v

        us = ZONE (e_D.v > e_S.v) e_S.v 
             OTHERS e_D.v

        uds = ud - us

        ubs =   ZONE (e_B.v > us)  0 
                OTHERS           e_B.v - us

        ugst = (e_G.v - us - Vt + K2*ubs)*K5

        id    = ZONE (ugst <= 0)   v*uds*1.e-7 
                ZONE (ugst > uds)  v*uds*(ugst - uds/2 + 1.e-7) 
                OTHERS             v*(ugst*ugst/2 + uds*1.e-7)

        e_G.i = 0
        e_D.i = ZONE (e_D.v < e_S.v)  -id 
                OTHERS                 id

        e_S.i = ZONE (e_D.v < e_S.v)  id 
                OTHERS               -id
        e_B.i = 0
END COMPONENT
  
COMPONENT NPN 
    "Bipolar NPN Junction Transistor component"
  PORTS 
    IN elec e_C "Collector"
    IN elec e_B "Base" 
    IN elec e_E "Emitter"
  DATA 
     REAL Bf=50         UNITS no_units	"Forward beta"
     REAL Br=0.1        UNITS no_units	"Reverse beta"
     REAL Is=1.e-16     UNITS u_A		"Transport saturation current"
     REAL Vak=0.02      UNITS u_1_V		"Early voltage inverse"
     REAL Tauf=0.12e-9  UNITS u_s		"Ideal forward transit time"
     REAL Taur=5e-9     UNITS u_s		"Ideal reverse transit time"
     REAL Ccs=1e-12     UNITS u_Farad		"Collector-substrat ground capacitance"
     REAL Cje=0.4e-12   UNITS u_Farad		"Base-emitter zero bias depletion capacitance"
     REAL Cjc=0.5e-12   UNITS u_Farad		"Base-coll. zero bias depletion capacitance"
     REAL Phie=0.8      UNITS u_V		"Base-emitter diffusion voltage"
     REAL Me=0.4        UNITS no_units	"Base-emitter gradation exponent"
     REAL Phic=0.8      UNITS u_V		"Base-collector diffusion voltage"
     REAL Mc=0.333      UNITS no_units	"Base-collector gradation exponent"
     REAL Gbc=1e-15     UNITS u_S		"Base-collector conductance"
     REAL Gbe=1e-15     UNITS u_S		"Base-emitter conductance"
     REAL Vt=0.02585    UNITS u_V		"Voltage equivalent of temperature"


  DECLS 

    REAL vbc     UNITS u_V     "Voltage difference from collector to base"
    REAL vbe     UNITS u_V     "Voltage difference from emitter to base"
    REAL qbk
    REAL ibc
    REAL ibe
    REAL cbc
    REAL cbe
    REAL Capcje
    REAL Capcjc

  CONTINUOUS


    vbc = e_B.v - e_C.v
    vbe = e_B.v - e_E.v
    qbk = 1 - vbc*Vak
    
    ibc = Is*(expLin(vbc/Vt) - 1) + vbc*Gbc
    ibe = Is*(expLin(vbe/Vt) - 1) + vbe*Gbe

    Capcjc =  JunctionCap(Cjc, vbc, Phic, Mc, 0.)      
    Capcje =   JunctionCap(Cje, vbe, Phie, Me, 0.) 

    cbc = Taur*Is/Vt*expLin(vbc/Vt) + Capcjc
    cbe = Tauf*Is/Vt*expLin(vbe/Vt) + Capcje

    e_C.i = (ibe - ibc)*qbk - ibc/Br - cbc*vbc' + Ccs*e_C.v'
    e_B.i = ibe/Bf + ibc/Br + cbc*vbc' + cbe*vbe'
    e_E.i = -e_B.i - e_C.i + Ccs*e_C.v'

END COMPONENT
  
COMPONENT PNP 
    "Bipolar PNP Junction Transistor component"

    
    PORTS
        IN elec e_C "Collector" 
        IN elec e_B "Base" 
        IN elec e_E "Emitter"
    DATA 
        REAL Bf=50        UNITS no_units	"Forward beta"
        REAL Br=0.1       UNITS no_units	"Reverse beta"
        REAL Is=1.e-16    UNITS u_A			"Transport saturation current"
        REAL Vak=0.02     UNITS u_1_V		"Early voltage inverse"
        REAL Tauf=0.12e-9 UNITS u_s			"Ideal forward transit time"
        REAL Taur=5e-9    UNITS u_s			"Ideal reverse transit time"
        REAL Ccs=1e-12    UNITS u_Farad	"Collector-substrat(ground) capacitance"
        REAL Cje=0.4e-12  UNITS u_Farad	"Base-emitter zero bias depletion capacitance"
        REAL Cjc=0.5e-12  UNITS u_Farad	"Base-coll. zero bias depletion capacitance"
        REAL Phie=0.8     UNITS u_V			"Base-emitter diffusion voltage"
        REAL Me=0.4       UNITS no_units	"Base-emitter gradation exponent"
        REAL Phic=0.8     UNITS u_V			"Base-collector diffusion voltage"
        REAL Mc=0.333     UNITS no_units	"Base-collector gradation exponent "
        REAL Gbc=1e-15    UNITS u_S			"Base-collector conductance"
        REAL Gbe=1e-15    UNITS u_S			"Base-emitter conductance"
        REAL Vt=0.02585   UNITS u_V			"Voltage equivalent of temperature"

    DECLS
        REAL vbc     UNITS u_V     "Voltage difference from collector to base"
        REAL vbe     UNITS u_V     "Voltage difference from emitter to base"
        REAL qbk
        REAL ibc
        REAL ibe
        REAL cbc
        REAL cbe

        REAL Capcje
        REAL Capcjc


    CONTINUOUS

        vbc = e_C.v - e_B.v
        vbe = e_E.v - e_B.v

        qbk = 1 - vbc*Vak
    
        ibc = Is*(expLin(vbc/Vt) - 1) + vbc*Gbc
    
        ibe = Is*(expLin(vbe/Vt) - 1) + vbe*Gbe
    
        Capcjc =  JunctionCap(Cjc, vbc, Phic, Mc, 0.) 
     
        Capcje =  JunctionCap(Cje, vbe, Phie, Me, 0.) 

        cbc = Taur*Is/Vt*expLin(vbc/Vt) + Capcjc

        cbe = Tauf*Is/Vt*expLin(vbe/Vt) + Capcje

        e_C.i = -((ibe - ibc)*qbk - ibc/Br - cbc*vbc' - Ccs*e_C.v')
        e_B.i = -(ibe/Bf + ibc/Br + cbc*vbc' + cbe*vbe')
        e_E.i = -e_B.i - e_C.i + Ccs*e_C.v'


END COMPONENT
