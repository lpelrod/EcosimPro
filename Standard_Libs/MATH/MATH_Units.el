/*-----------------------------------------------------------------------------------------
 LIBRARY: MATH
 FILE: MATH_Units
 AUTHOR: EA
 COMPANY: EA
 DESCRIPTION: Variables to define Units for variables of libraries 
 CREATION DATE: 15/12/21
-----------------------------------------------------------------------------------------*/
PRIVATE CONST STRING no_units                            =  "-"                     "Adimensional"

PRIVATE CONST STRING u_m                                 =  "m"                     "metre" 
PRIVATE CONST STRING u_kg                                =  "kg"                    "kilograme" 
PRIVATE CONST STRING u_s                                 =  "s"                     "second" 
PRIVATE CONST STRING u_A                                 =  "A"                     "Ampere" 
PRIVATE CONST STRING u_K                                 =  "K"                     "Kelvin" 
PRIVATE CONST STRING u_mol                               =  "mol"                   "mole" 
PRIVATE CONST STRING u_cd                                =  "cd"                    "candela" 
PRIVATE CONST STRING u_rad                               =  "rad"                   "radian" 
PRIVATE CONST STRING u_sr                                =  "sr"                    "steradian" 

PRIVATE CONST STRING u_Hz                                =  "Hz"                    "Hertz" 
PRIVATE CONST STRING u_1_s                               =  "1/s"                   "inverse second"
PRIVATE CONST STRING u_1_h                               =  "1/h"                   "inverse hour"
PRIVATE CONST STRING u_1_s2                              =  "1/s^2"                 "squared inverse second"
PRIVATE CONST STRING u_N                                 =  "N"                     "Newton" 
PRIVATE CONST STRING u_Pa                                =  "Pa"                    "Pascal" 
PRIVATE CONST STRING u_1_Pa                              =  "1/Pa"                  "inverse Pascal"
PRIVATE CONST STRING u_J                                 =  "J"                     "Joule" 
PRIVATE CONST STRING u_W                                 =  "W"                     "Watt" 
PRIVATE CONST STRING u_Coulomb                           =  "C"                     "Coulomb" 
PRIVATE CONST STRING u_V                                 =  "V"                     "Volt" 
PRIVATE CONST STRING u_Farad                             =  "F"                     "Farad"
PRIVATE CONST STRING u_Ohm                               =  "Ohm"                   "Ohm" 
PRIVATE CONST STRING u_S                                 =  "S"                     "Siemens" 
PRIVATE CONST STRING u_Wb                                =  "Wb"                    "Weber" 
PRIVATE CONST STRING u_T                                 =  "T"                     "Tesla" 
PRIVATE CONST STRING u_H                                 =  "H"                     "Henry" 
PRIVATE CONST STRING u_lm                                =  "lm"                    "lumen" 
PRIVATE CONST STRING u_lx                                =  "lx"                    "lux" 
PRIVATE CONST STRING u_Bq                                =  "Bq"                    "Becquerel" 
PRIVATE CONST STRING u_Gy                                =  "Gy"                    "Gray"
PRIVATE CONST STRING u_dB                                =  "dB"                    "deciBell"

--[T]
PRIVATE CONST STRING u_min                               =  "min"                   "minute"
PRIVATE CONST STRING u_h                                 =  "h"                     "hour"
PRIVATE CONST STRING u_month                             =  "month"                 "Month"
PRIVATE CONST STRING u_y                                 =  "year"                  "Year"
PRIVATE CONST STRING u_century                           =  "century"               "Century"
PRIVATE CONST STRING u_day                               =  "day"                   "Day"

PRIVATE CONST STRING u_1_min                             =  "1/min"                 "inverse minute"
PRIVATE CONST STRING u_1_day                             =  "1/day"                 "inverse day"

--[T·Theta]
PRIVATE CONST STRING u_Ks                                =  "K*s"                   "kelvin - second"

--[T2·Theta·L2/(M·L)]
PRIVATE CONST STRING u_m2C_W                             =  "m2·degC/W"             "Square metre - Celsius degree per watt"
PRIVATE CONST STRING u_m2K_W                             =  "m2·K/W"                "Square metre - Kelvin per watt"

--[M]
PRIVATE CONST STRING u_g                                 =  "g"                     "gram"
PRIVATE CONST STRING u_mg                                =  "mg"                    "miligram"
PRIVATE CONST STRING u_lbm                               =  "lbm"                   "pound-mass"

PRIVATE CONST STRING u_kmol                              =  "kmol"                  "kilomole"

PRIVATE CONST STRING u_pct                               =  "%"                     "percentage"
PRIVATE CONST STRING u_ppm                               =  "ppm"                   "parts per million"

PRIVATE CONST STRING u_ug                                =  "ug"                    "micrograms"
PRIVATE CONST STRING u_ng                                =  "ng"                    "nanograms"

PRIVATE CONST STRING u_1_kg                              =  "1/kg"                  "reciprocal kg"
PRIVATE CONST STRING u_1_mol                             =  "1/mol"                 "reciprocal mol"


--[Theta]
PRIVATE CONST STRING u_C                                 =  "degC"                  "Celsius degree"
PRIVATE CONST STRING u_F                                 =  "degF"                  "Fahrenheit degree"
PRIVATE CONST STRING u_R                                 =  "degR"                  "Reamour degree"

PRIVATE CONST STRING u_1_K                               =  "1/K"                   "Inverse Kelvin"  
PRIVATE CONST STRING u_1_C                               =  "1/degC"                "Inverse Celsius"

--[Theta/L]
PRIVATE CONST STRING u_K_m                               =  "K/m"                   "Kelvin per meter"

--[Theta/T]
PRIVATE CONST STRING u_C_s                               =  "degC/s"                "Celsius per second"
PRIVATE CONST STRING u_K_s                               =  "K/s"                   "Kelvin per second"

--[Theta·T3/(M·L3)]
PRIVATE CONST STRING u_K_W                               =  "K/W"                   "Kelvin per Watt"

--[Theta·T3/(M·L2)]
PRIVATE CONST STRING u_Km_W                              =  "K_Wm"                  "Kelvin per Watt meter"

-- [1/(Theta·T)]
PRIVATE CONST STRING u_1_hC                              =  "1/(hºC)"               "inverse hours-Celsius degree "

-- [1/(Theta2·T)]
PRIVATE CONST STRING u_1_hC2                             =  "1/(hºC2)"              "inverse hours-suare Celsius degree "

--[L]
PRIVATE CONST STRING u_km                                =  "km"                    "kilometre"
PRIVATE CONST STRING u_cm                                =  "cm"                    "centimetre"
PRIVATE CONST STRING u_mm                                =  "mm"                    "milimetre"
PRIVATE CONST STRING u_ft                                =  "ft"                    "foot"
PRIVATE CONST STRING u_in                                =  "in"                    "inch"

PRIVATE CONST STRING u_1_m                               =  "1/m"                   "reciprocal meter"

--[L2]
PRIVATE CONST STRING u_m2                                =  "m^2"                   "square metre"
PRIVATE CONST STRING u_km2                               =  "km^2"                  "square kilometre"
PRIVATE CONST STRING u_cm2                               =  "cm^2"                  "square centimetre"
PRIVATE CONST STRING u_mm2                               =  "mm^2"                  "square milimetre"
PRIVATE CONST STRING u_ft2                               =  "ft^2"                  "square foot"
PRIVATE CONST STRING u_in2                               =  "in^2"                  "square inch"
--[L3]
PRIVATE CONST STRING u_m3                                =  "m^3"                   "cubic metre"
PRIVATE CONST STRING u_dm3                               =  "dm^3"                  "cubic decimetre"
PRIVATE CONST STRING u_cm3                               =  "cm^3"                  "cubic centimetre"
PRIVATE CONST STRING u_ft3                               =  "ft^3"                  "cubic foot"
PRIVATE CONST STRING u_in3                               =  "in^3"                  "cubic inch"
PRIVATE CONST STRING u_l                                 =  "l"                     "liters"
PRIVATE CONST STRING u_ml                                =  "ml"                    "mililiters"

--[L5]
PRIVATE CONST STRING u_m5                                =  "m5"                    "meters to the power of 5"

--[1/(L3)]
PRIVATE CONST STRING u_1_m3                              =  "1/m^3"                 "inverse cubic meter"

--[1/(L4)]
PRIVATE CONST STRING u_1_m4                              =  "1/m^4"                 "inverse meter to the power of 4"

--[L/T]
PRIVATE CONST STRING u_m_s                               =  "m/s"                   "metres per second"
PRIVATE CONST STRING u_km_h                              =  "km/h"                  "kilometres per hour"
PRIVATE CONST STRING u_km_s                              =  "km/s"                  "kilometres per second"
PRIVATE CONST STRING u_cm_s                              =  "cm/s"                  "centimetres per second"
PRIVATE CONST STRING u_mm_s                              =  "mm/s"                  "milimetres per second"
PRIVATE CONST STRING u_ft_s                              =  "ft/s"                  "feet per second"
PRIVATE CONST STRING u_ft_min                            =  "ft/min"                "feet per minute"
PRIVATE CONST STRING u_ft_h                              =  "ft/h"                  "feet per hour"
PRIVATE CONST STRING u_in_s                              =  "in/s"                  "inches per second"
PRIVATE CONST STRING u_in_min                            =  "in/min"                "inches per minute"

PRIVATE CONST STRING u_m3_sm2                            =  "m3/(s·m^2)"            "cubic metres per second and square metre"
PRIVATE CONST STRING u_ft3_sft2                          =  "ft3/(s·ft^2)"          "cubic feet per second and square feet"
PRIVATE CONST STRING u_ft3_minft                         =  "ft3/(min·ft^2)"        "cubic feet per minute and square feet"

--[L/T2]
PRIVATE CONST STRING u_m_s2                              =  "m/s^2"                 "metres per square second"
PRIVATE CONST STRING u_cm_s2                             =  "cm/s^2"                "centimetres per square second"
PRIVATE CONST STRING u_ft_s2                             =  "ft/s^2"                "feet per square second"

--[L2/T]
PRIVATE CONST STRING u_m2_s                              =  "m^2/s"                 "square metres per second"
PRIVATE CONST STRING u_mm2_s                             =  "mm^2/s"                "square milimetres per second"
PRIVATE CONST STRING u_m3_sm                             =  "m3/(s·m)"              "metres per second and metre"
PRIVATE CONST STRING u_ft2_s                             =  "ft^2/s"                "square feet per second"
PRIVATE CONST STRING u_in2_s                             =  "in^2/s"                "square inches per second"
PRIVATE CONST STRING u_UKgal_hin                         =  "UKgal/(h·in)"          "Imperial gallon per hour and inch"
PRIVATE CONST STRING u_UKgal_hft                         =  "UKgal/(h·ft)"          "Imperial gallon per hour and foot"

--[L2/M]
PRIVATE CONST STRING u_m2_g                              =  "m2/g"                  "square meter per gram"

--[L2/(T2·Theta)]
PRIVATE CONST STRING u_m2_s2K                            =  "m^2/(s^2·K)"           "squared meter per squared second and Kelvin"
PRIVATE CONST STRING u_J_Wh                              =  "J/(W·h)"               "Joules per Watt and hour"

--[L3/T]
PRIVATE CONST STRING u_m3_s                              =  "m^3/s"                 "cubic metres per second"
PRIVATE CONST STRING u_m3_h                              =  "m^3/h"                 "cubic metres per hour"
PRIVATE CONST STRING u_dm3_s                             =  "dm^3/s"                "cubic decimetres per second"
PRIVATE CONST STRING u_l_s                               =  "l/s"                   "litres per second"
PRIVATE CONST STRING u_ft3_s                             =  "ft^3/s"                "cubic feet per second"
PRIVATE CONST STRING u_ft3_min                           =  "ft^3/min"              "cubic feet per minute"
PRIVATE CONST STRING u_ft3_h                             =  "ft^3/h"                "cubic feet per hour"
PRIVATE CONST STRING u_cm3_s                             =  "cm^3/s"                "cubic centimeters per second"
PRIVATE CONST STRING u_l_h                               =  "l/h"                   "litres per hour"
PRIVATE CONST STRING u_l_min                             =  "l/min"                 "litres per minute"
PRIVATE CONST STRING u_ml_h                              =  "ml/h"                  "mililitres per hour"
PRIVATE CONST STRING u_ml_min                            =  "ml/min"                "mililitres per minute"
PRIVATE CONST STRING u_ul_min                            =  "ul/min"                "microliters per minute"
PRIVATE CONST STRING u_ml_s                              =  "ml/s"                  "mililitres per second"

--[L3/(T2)]
PRIVATE CONST STRING u_m3_s2                             = "m^3/s^2"                "cubic meters per square meters"
PRIVATE CONST STRING u_km3_s2                            = "km^3/s^2"               "cubic kilometers per square meters"

--[L3/T/M]
PRIVATE CONST STRING u_ml_minkg                          =  "ml/(min·kg)"           "mililitres per minute - kg"
PRIVATE CONST STRING u_l_hkg                             =  "l/(h·kg)"              "litres per hour - kg"

--[L3/T/N]
PRIVATE CONST STRING u_ul_minpmol                        =  "ul/(min·pmoles)"       "microliters per minute - picomol"

--[L3/L3]
PRIVATE CONST STRING u_m3_m3                             =  "m^3/m^3"               "cubic metres per cubic metre"
PRIVATE CONST STRING u_dm3_dm3                           =  "dm^3/dm^3"             "cubic decimetres per cubic decimetre"
PRIVATE CONST STRING u_cm3_cm3                           =  "cm^3/cm^3"             "cubic centimetres per cubic centimetre"
PRIVATE CONST STRING u_ft3_ft3                           =  "ft^3/ft^3"             "cubic feet per cubic foot"

--[L3/M]
PRIVATE CONST STRING u_m3_kg                             =  "m^3/kg"                "cubic metres per kilogram"
PRIVATE CONST STRING u_ft3_lbm                           =  "ft^3/lbm"              "cubic feet per pound-mass"
PRIVATE CONST STRING u_m3_g                              =  "m^3/g"                 "cubic metres per gram"
PRIVATE CONST STRING u_dm3_kg                            =  "dm^3/kg"               "cubic decimetres per kilogram"
PRIVATE CONST STRING u_ml_kg                             =  "ml_kg"                 "ml_kg"

--[L3/N]
PRIVATE CONST STRING u_m3_kmol                           =  "m^3/kmol"              "cubic metres per kilomole"
PRIVATE CONST STRING u_dm3_kmol                          =  "dm^3/kmol"             "cubic decimetres per kilomole"
PRIVATE CONST STRING u_ft3_lbmol                         =  "ft^3/lbmol"            "cubic feet per pound-mole"

--[L3/N·T]
PRIVATE CONST STRING u_m3_mols                           =  "m3/(mol·s)"            "cubic meter per mole and second"

--[L4/N·T]
PRIVATE CONST STRING u_m4_mols                           =  "m4/(mol·s)"            "meter to the power 4 per mole and second"

--[M/L3]
PRIVATE CONST STRING u_kg_m3                             =  "kg/m^3"                "kilograms per cubic metre"
PRIVATE CONST STRING u_g_cm3                             =  "g/cm^3"                "grams per cubic centimetre"
PRIVATE CONST STRING u_g_m3                              =  "g/m^3"                 "grams per cubic metre"
PRIVATE CONST STRING u_mg_m3                             =  "mg/m^3"                "miligrams per cubic metre"
PRIVATE CONST STRING u_lbm_ft3                           =  "lbm/ft^3"              "pounds-mass per cubic foot"
PRIVATE CONST STRING u_ng_l                              =  "ng/l"                  "nanograms per liter"
PRIVATE CONST STRING u_ng_ml                             =  "ng/ml"                 "nanograms per mililiter"
PRIVATE CONST STRING u_ug_l                              =  "ug/l"                  "micrograms per liter"
PRIVATE CONST STRING u_ug_ml                             =  "ug/ml"                 "micrograms per mililiter"
PRIVATE CONST STRING u_mg_l                              =  "mg/l"                  "miligrams per liter"
PRIVATE CONST STRING u_mg_ml                             =  "mg/ml"                 "miligrams per mililiter"
PRIVATE CONST STRING u_mg_dl                             =  "mg/dl"                 "miligrams per deciliter"
PRIVATE CONST STRING u_g_dl                              =  "g/dl"                  "grams per deciliter"
PRIVATE CONST STRING u_kg_ml                             =  "kg/ml"                 "kg per mililiter"
PRIVATE CONST STRING u_kg_l                              =  "kg/l"                  "kg per liter"

--[M/(L3·Theta)]
PRIVATE CONST STRING u_kg_m3C                            =  "kg/(m^3·degC)"         "kilogram per cubic meter and Celsius degree"
PRIVATE CONST STRING u_kg_m3K                            =  "kg/(m^3·K)"            "kilogram per cubic meter and Kelvin"

--[M/M]
PRIVATE CONST STRING u_kg_kg                             =  "kg/kg"                 "kilograms per kilogram"
PRIVATE CONST STRING u_g_kg                              =  "g/kg"                  "grams per kilogram"
PRIVATE CONST STRING u_mg_kg                             =  "mg/kg"                 "miligrams per kilogram"
PRIVATE CONST STRING u_ug_kg                             =  "ug/kg"                 "micrograms per kilogram"

--[M/(M·T)]
PRIVATE CONST STRING u_kg_skg                            =  "kg/(kg_total·s)"       "kinetic equation of each reaction (kg/kg_total s)"


--[M/N]
PRIVATE CONST STRING u_kg_kmol                           =  "kg/kmol"               "kilograms per kilomol"
PRIVATE CONST STRING u_kg_mol                            =  "kg/mol"                "kilogram per mol"
PRIVATE CONST STRING u_g_mol                             =  "g/mol"                 "grams per mol"


--[M/T]
PRIVATE CONST STRING u_kg_s                              =  "kg/s"                  "kilograms per second"
PRIVATE CONST STRING u_kg_h                              =  "kg/h"                  "kilograms per hour"
PRIVATE CONST STRING u_lbm_s                             =  "lbm/s"                 "pounds-mass per second"
PRIVATE CONST STRING u_lbm_h                             =  "lbm/h"                 "pounds-mass per hour"
PRIVATE CONST STRING u_g_h                               =  "g/h"                   "grams per hour"    
PRIVATE CONST STRING u_ug_h                              =  "ug/h"                  "micrograms per hour"
PRIVATE CONST STRING u_ug_min                            =  "ug/min"                "micrograms per minute"
PRIVATE CONST STRING u_ug_s                              =  "ug/s"                  "micrograms per second"  
PRIVATE CONST STRING u_mg_h                              =  "mg/h"                  "miligrams per hour"
PRIVATE CONST STRING u_ng_h                              =  "ng/h"                  "nanograms per hour"
PRIVATE CONST STRING u_mg_min                            =  "mg/min"                "miligrams per minute"
PRIVATE CONST STRING u_mg_s                              =  "mg/s"                  "miligrams per second"
PRIVATE CONST STRING u_kg_min                            =  "kg/min"                "kg per minute"
PRIVATE CONST STRING u_g_s                               =  "g/s"                   "grams per second"
PRIVATE CONST STRING u_g_d                               =  "g/d"                   "grams per day"

--[M/T2]
PRIVATE CONST STRING u_kg_s2                             =  "kg/(s^2)"              "kilogram squared second"

--[M/(T2·L·THETA)]
PRIVATE CONST STRING u_kg_Ks2m                           =  "kg/(Ks^2m)"            "kilogram per squared second"

--[M/TL]
PRIVATE CONST STRING u_kg_sm                             =  "kg/(s·m)"              "kilograms per metre per second"
PRIVATE CONST STRING u_lbm_sft                           =  "lbm/(s·ft)"            "pounds-mass per foot per second"
PRIVATE CONST STRING u_lbm_hft                           =  "lbm/(h·ft)"            "pounds-mass per foot per hour"

--[M/TL2]
PRIVATE CONST STRING u_kg_sm2                            =  "kg/(s·m^2)"            "kilograms per square metre per second"
PRIVATE CONST STRING u_lbm_sft2                          =  "lbm/(s·ft^2)"          "pounds-mass per square foot per second"
PRIVATE CONST STRING u_lbm_hft2                          =  "lbm/(h·ft^2)"          "pounds-mass per square foot per hour"
PRIVATE CONST STRING u_g_sm2                             =  "g/(s·m2)"              "grams per second and square meter"

--[M/(T·L3)]

PRIVATE CONST STRING u_kg_sm3                            =  "kg/(s·m^3)"            "kilograms per cubic metre per second"
PRIVATE CONST STRING u_mg_lh                             =  "mg/(l·h)"              "miligrams per liter and hour"
PRIVATE CONST STRING u_ng_mlh                            =  "ng/(ml·h)"             "nanograms per mililiter and hour"

PRIVATE CONST STRING u_kg_Ns                             =  "kg/(N·s)"              "kilograms per Newton and second"


--[M/L]
PRIVATE CONST STRING u_kg_m                              =  "kg/m"                  "kilograms per metre"
PRIVATE CONST STRING u_lbm_ft                            =  "lbm/ft"                "pounds-mass per foot"

--[M/L2]
PRIVATE CONST STRING u_kg_m2                             =  "kg/m^2"                "kilograms per square metre"
PRIVATE CONST STRING u_lbm_ft2                           =  "lbm/ft^2"              "pounds-mass per square foot"
PRIVATE CONST STRING u_mg_m2                             =  "mg/m^2"                "miligrams per square meter"

--[M/(L2·Theta)]
PRIVATE CONST STRING u_kg_m2K                            =  "kg/(m^2·K)"            "kilogram per squared meter and Kelvin"


--[ML/T]
PRIVATE CONST STRING u_kgm_s                             =  "kg·m/s"                "kilograms - metre per second"
PRIVATE CONST STRING u_lbmft_s                           =  "lbm·ft/s"              "pounds-mass - foot per second"

--[ML2]
PRIVATE CONST STRING u_kgm2                              =  "kg·m^2"                "kilograms - square metre"
PRIVATE CONST STRING u_lbmft2                            =  "lbm·ft^2"              "pounds-mass - square foot"


--[N/T]
PRIVATE CONST STRING u_mol_s                             =  "mol/s"                 "moles per second"
PRIVATE CONST STRING u_kmol_s                            =  "kmol/s"                "kilomole per second"
PRIVATE CONST STRING u_kmol_h                            =  "kmol/h"                "kilomole per hour"
PRIVATE CONST STRING u_lbmol_s                           =  "lbmol/s"               "pounds-mole per second"
PRIVATE CONST STRING u_lbmol_h                           =  "lbmol/h"               "pounds-mole per hour"

--[N/L3]
PRIVATE CONST STRING u_mol_m3                            =  "mol/m^3"               "mole per cubic metre"
PRIVATE CONST STRING u_kmol_m3                           =  "kmol/m^3"              "kilomole per cubic metre"
PRIVATE CONST STRING u_lbmol_ft3                         =  "lbmol/ft^3"            "pounds-mole per cubic foot"
PRIVATE CONST STRING u_nmol_l                            =  "nmoles/l"              "nanomoles per liter"
PRIVATE CONST STRING u_umol_l                            =  "umoles/l"              "micromoles per liter"
PRIVATE CONST STRING u_nmol_ml                           =  "nmoles/ml"             "nanomoles per mililiter"

--[N/L2·T]
PRIVATE CONST STRING u_mol_m2s                           =  "mol/(m^2·s)"           "moles per square meter and second"

--[N/L3·T]
PRIVATE CONST STRING u_mol_m3s                           =  "mol/(m^3·s)"           "moles per cubic meter and second"
PRIVATE CONST STRING u_nmol_minml                        =  "nmoles/(min·ml)"       "nanomoles per minute and milileter"
PRIVATE CONST STRING u_mol_sm3                           =  "mol/(s·m^3)"           "mole per second and cubic meter"


--[N/N]
PRIVATE CONST STRING u_kmol_kmol                         =  "kmol/kmol"             "Molar fraction expressed in kilomole"
PRIVATE CONST STRING u_mol_mol                           =  "mol/mol"               "Molar fraction expressed in mole"

--[N/M]
PRIVATE CONST STRING u_mol_g                             =  "mol/g"                 "moles per gram"

--[M·L2/T]
PRIVATE CONST STRING u_kgm2_s                            =  "kg·m^2/s"              "kilograms-squared meters per second"

--[M·L/T2]
PRIVATE CONST STRING u_kgf                               =  "kgf"                   "kilogram-force"
PRIVATE CONST STRING u_dyn                               =  "dyn"                   "Dyne"
PRIVATE CONST STRING u_lbf                               =  "lbf"                   "pounds-force"

--[M·L/(T2·Theta)]
PRIVATE CONST STRING u_kcal_C                            =  "kcal/degC"             "kilocalories per celsius degree"        

--[T2/L2]
PRIVATE CONST STRING u_g_Wh                              =  "g/(W·h)"               "grams per Watt and hour"      
PRIVATE CONST STRING u_s2_m2                             =  "s^2/m^2"               "seconds-squared per meters-squared"

--[T2·M/(M·L·T)]
PRIVATE CONST STRING u_kg_kgfh                           =  "kg/(kgf·h)"            "kilograms per kilogram-force and hour"

--[T2·L2·M/(M·L·T)]
PRIVATE CONST STRING u_kg_Pas                            =  "kg/(Pa·s)"             "kilogram per Pascal and second"


--[M·L2/T2]
PRIVATE CONST STRING u_Nm                                =  "N·m"                   "Newton - metres"
PRIVATE CONST STRING u_kgfm                              =  "kgf·m"                 "kilograms-force - metres"
PRIVATE CONST STRING u_kgm2_s2                            =  "kg·m^2/s2"              "kilograms-squared meters per squared second"

--[M·L2/(T2·L)]
PRIVATE CONST STRING u_N_m                               =  "N/m"                   "Newton per metre"
PRIVATE CONST STRING u_mN_m                              =  "mN/m"                  "miliNewton per metre"
PRIVATE CONST STRING u_dyn_cm                            =  "dyn/cm"                "Dyne per centimetre"

--[M·L/(T2·L2)]
PRIVATE CONST STRING u_MPa                               =  "MPa"                   "MegaPascal"
PRIVATE CONST STRING u_kPa                               =  "kPa"                   "kiloPascal"
PRIVATE CONST STRING u_atm                               =  "atm"                   "Atmosphere"
PRIVATE CONST STRING u_bar                               =  "bar"                   "Bar"
PRIVATE CONST STRING u_mmHg                              =  "mmHg"                  "milimetres of mercury, torr"
PRIVATE CONST STRING u_N_m2                              =  "N/m^2"                 "Newton per squared meter"

--[M·L2/(T2·M·Theta)]
PRIVATE CONST STRING u_J_kgC                             =  "J/(kg·degC)"           "Joules per kilogram - Celsius"

--[M·L2/(T2·N·Theta)]
PRIVATE CONST STRING u_J_kmolK                           =  "J/(kmol·K)"            "Joules per kilomole - Kelvin"

--[M·L2/(T3·Theta)]
PRIVATE CONST STRING u_W_C                               =  "W/degC"                "Watts per Celsius"

--[M·L2/(T3·L·Theta)]
PRIVATE CONST STRING u_W_mC                              =  "W/(m·degC)"            "Watts per metre - Celsius"

--[M·L2/(T3·L2·Theta)]
PRIVATE CONST STRING u_W_m2C                             =  "W/(m^2·degC)"          "Watts per square metre - Celsius"
--[M·L/(T3·L2)]
PRIVATE CONST STRING u_Pa_s                              =  "Pa/s"                  "Pascal per second"
PRIVATE CONST STRING u_bar_s                             =  "bar/s"                 "bar per second"

-- [M·L3/T2·L]
PRIVATE CONST STRING u_atml                              =  "atm·l"                 "atmosphere liter"

--[M·L·T/(T2·L2·L3)]
PRIVATE CONST STRING u_Pas_cm3                           =  "Pa·s/cm^3"             "Pascal - second per cubic centimeter" 
--[(T2·L2·L3/(M·L)]
PRIVATE CONST STRING u_cm3_Pa                            =  "cm^3/Pa"               "Cubic centimeter per Pascal"


--[M/(T·L)]
PRIVATE CONST STRING u_Pas                               =  "Pa·s"                  "Pascal - second"
PRIVATE CONST STRING u_dyns_cm2                          =  "dyn·s/cm^2"            "dyne - second per square centimetre"
PRIVATE CONST STRING u_cP                                =  "cP"                    "centiPoise"

--[M·L/(T2·L3)]
PRIVATE CONST STRING u_kPa_m                             =  "kPa/m"                 "kiloPascals per metre"
PRIVATE CONST STRING u_psi_ft                            =  "psi/ft"                "Pounds per square inch per foot"

--[M·L/(Theta·T3)]
PRIVATE CONST STRING u_kcal_hC                           =  "kcal/(h·degC)"         "kilocalories per hour and celsius degree"    

--[M·L/(Theta2·T3)]
CONST STRING         u_kcal_hC2                          =  "kcal/(h·degC2)"        "kilocalories per hour and square celsius degree"

--[M·L·M3/(T2·L2·N)]
PRIVATE CONST STRING u_Pam3_mol                          =  "Pa·m^3/mol"            "activation energy of the Arrhenius equation"

--[M·T/(L3)]
PRIVATE CONST STRING u_ngh_ml                            =  "ng·h/ml"               "nanograms hour per mililiter"
PRIVATE CONST STRING u_ugh_l                             =  "ug·h/l"                "micrograms hour per liter"

--[M·T2/(L5)]
PRIVATE CONST STRING u_kgs2_m5                           =  "kg·s2/m5"              "kilograms square seconds per meters to the power of 5"

--[M/L3·M]
PRIVATE CONST STRING u_ug_lmg                            =  "ug/(l·mg)"             "Micrograme divide liter divide miligrame"

--Energía:
PRIVATE CONST STRING u_kJ                                =  "kJ"                    "kiloJoule"
PRIVATE CONST STRING u_kWh                               =  "kW·h"                  "kiloWatt - hour"
PRIVATE CONST STRING u_Wh                                =  "W·h"                   "Watt - hour"
PRIVATE CONST STRING u_kcal                              =  "kcal"                  "kilocalories"
PRIVATE CONST STRING u_Btu                               =  "Btu"                   "British Thermal Unit"
PRIVATE CONST STRING u_therm                             =  "therm"                 "Therm"
PRIVATE CONST STRING u_eV                                =  "eV"                    "electron Volt"
PRIVATE CONST STRING u_MeV                               =  "MeV"                   "mega electron Volt"

--[M·L2/(T2·L3)]
PRIVATE CONST STRING u_J_m3                              =  "J/m^3"                 "Joule per cubic metre"
PRIVATE CONST STRING u_kJ_m3                             =  "kJ/m^3"                "kiloJoule per cubic metre"
PRIVATE CONST STRING u_kcal_m3                           =  "kcal/m^3"              "kilocalories per cubic metre"
PRIVATE CONST STRING u_Btu_ft3                           =  "Btu/ft^3"              "Btu per cubic foot"

--[M·L2/(T2·N)]
PRIVATE CONST STRING u_J_mol                             =  "J/mol"                 "Joules per mole"
PRIVATE CONST STRING u_J_kmol                            =  "J/kmol"                "Joules per kmole"
PRIVATE CONST STRING u_kJ_kmol                           =  "kJ/kmol"               "kiloJoules per kilomole"
PRIVATE CONST STRING u_kcal_gmol                         =  "kcal/gmol"             "kilocalories per gram-mole"
PRIVATE CONST STRING u_Btu_lbmol                         =  "Btu/lbmol"             "Btu per pound-mole"

--[M·L2/(T2·Theta)]
PRIVATE CONST STRING u_J_K                               =  "J/K"                   "Joule per Kelvin"
PRIVATE CONST STRING u_J_C                               =  "J/degC"                "Joules per Celsius"

--[M·L2/(T2·N·Theta)]
PRIVATE CONST STRING u_J_molK                            =  "J/(mol·K)"             "Joules per mole - Kelvin"
PRIVATE CONST STRING u_kJ_kmolK                          =  "kJ/(kmol·K)"           "kiloJoules per kilomole - Kelvin"
PRIVATE CONST STRING u_kJ_kmolC                          =  "kJ/(kmol·degC)"        "kiloJoule per kilomol and Celsius degree"
PRIVATE CONST STRING u_kJ_kgC                            =  "kJ/(kg·degC)"          "kiloJoule per kilogram and Celsius degree"

PRIVATE CONST STRING u_cal_gmolC                         =  "cal/(gmol·degC)"       "calories per gram-mole Celsius"
PRIVATE CONST STRING u_Btu_lbmolF                        =  "Btu/(lbmol·degF)"      "Btu per pound-mole Fahrenheit"


--[M·L2/(T2·M)]
PRIVATE CONST STRING u_J_kg                              =  "J/kg"                  "Joules per kilogram"
PRIVATE CONST STRING u_kJ_kg                             =  "kJ/kg"                 "kiloJoules per kilogram"  
PRIVATE CONST STRING u_cal_g                             =  "cal/g"                 "calories per gram"

--[M·T2/(M·L2)]
PRIVATE CONST STRING u_g_kcal                            =  "g/kcal"                "grams per kilocalorie"    

--[M·L2/(T2·M·Theta)]
PRIVATE CONST STRING u_J_kgK                             =  "J/(kg·K)"              "Joules per kilogram - Kelvin"
PRIVATE CONST STRING u_kJ_kgK                            =  "kJ/(kg·K)"             "kiloJoules per kilogram - Kelvin"
PRIVATE CONST STRING u_cal_gK                            =  "cal/(g·K)"             "calories per gram - Kelvin"
PRIVATE CONST STRING u_kcal_kgC                          =  "kcal/(kg·degC)"        "kilocalories per kilogram - Celsius"


--[M·L2·T/(T2·M·Theta)]
PRIVATE CONST STRING u_kJs_kgC                           =  "kJ·s/(kg·degC)"        "PRIVATE CONSTant for temperature calculation"

--[M·L2/(T2·L2)]
PRIVATE CONST STRING u_J_cm2                             =  "J/cm^2"                "Joules per square centimetre"
PRIVATE CONST STRING u_lbfft_in2                         =  "lbf·ft/in^2"           "foot-pound force per square inch"


--[M·L2/T3]
PRIVATE CONST STRING u_MW                                =  "MW"                    "Magawatts"
PRIVATE CONST STRING u_kW                                =  "kW"                    "kilowatts"
PRIVATE CONST STRING u_kcal_h                            =  "kcal/h"                "kilocalories per hour"
PRIVATE CONST STRING u_hhp                               =  "hhp"                   "hydraulic horsepower"
PRIVATE CONST STRING u_CV                                =  "CV"                    "Cheval vapeur"
PRIVATE CONST STRING u_Btu_s                             =  "Btu/s"                 "Btu per second"
PRIVATE CONST STRING u_Btu_min                           =  "Btu/min"               "Btu per minute"
PRIVATE CONST STRING u_Btu_h                             =  "Btu/h"                 "Btu per hour"
PRIVATE CONST STRING u_HP                                =  "HP"                    "horse power"
PRIVATE CONST STRING u_kJ_s                              =  " kJ/s"                 "heat transfer"
PRIVATE CONST STRING u_kJ_h                              =  "kJ/h"                  "supplied heat"


--[M·L/(T3·L)]
PRIVATE CONST STRING u_N_ms                              =  "N/(m·s)"               "Newton per metre and second"

--[M·L·T/(T2·L)]
PRIVATE CONST STRING u_Ns_m                              =  "N·s/m"                 "Newton second per metre"


--[M·L2/T3·L2]
PRIVATE CONST STRING u_W_m2                              =  "W/m^2"                 "Watts per square metre"
PRIVATE CONST STRING u_kW_m2                             =  "kW/m^2"                "kilowatts per square metre"
PRIVATE CONST STRING u_cal_scm2                          =  "cal/(s·cm^2)"          "calories per square centimetre per second"
PRIVATE CONST STRING u_cal_hcm2                          =  "cal/(h·cm^2)"          "calories per square centimetre per hour"
PRIVATE CONST STRING u_Btu_sft2                          =  "Btu/(s·ft^2)"          "Btu per square foot per second"
PRIVATE CONST STRING u_Btu_hft2                          =  "Btu/(h·ft^2)"          "Btu per square foot per hour"

--[M·L3/T3·L2·Theta]
PRIVATE CONST STRING u_W_mK                              =  "W/(m·K)"               "Watts per metre Kelvin"
PRIVATE CONST STRING u_calcm_scm2C                       =  "cal·cm/(s·cm^2·degC)"  "calories - centimetre per square centimetre per second - Celsius"
PRIVATE CONST STRING u_Btuft_hft2F                       =  "Btu·ft/(h·ft^2·degF)"  "Btu - foot per square foot per hour - Fahrenheit"
PRIVATE CONST STRING u_kW_m2C                            =  "kW/(m^2·degC)"         "overall heat transfer coefficient"

--[M·L2/T3·L3]
PRIVATE CONST STRING u_kW_m3                             =  "kW/m^3"                "kilowatts per cubic metre"
PRIVATE CONST STRING u_hp_ft3                            =  "hp/ft^3"               "horsepower per cubic foot"
PRIVATE CONST STRING u_Btu_sft3                          =  "Btu/(s·ft^3)"          "Btu per cubic metre per second"

--[M·L2/T3·L2·Theta]
PRIVATE CONST STRING u_kW_m2K                            =  "kW/(m^2·K)"            "kilowatts per square metre -kelvin"
PRIVATE CONST STRING u_kcal_hm2C                         =  "kcal/(h·m^2·degC)"     "kilocalorias per square metre per hour Celsius"
PRIVATE CONST STRING u_Btu_hft2F                         =  "Btu/(h·ft^2·degF)"     "Btu per square foot per hour Fahrenheit"
PRIVATE CONST STRING u_W_m2K                             =  "W/(m^2·K)"             "Watts per square metre Kelvin"

--[M·L2/T3·L3·Theta]
PRIVATE CONST STRING u_kW_m3K                            =  "kW/(m^3·K)"            "kilowatts per cubic metre -kelvin"
PRIVATE CONST STRING u_Btu_sft3F                         =  "Btu/(s·ft^3·degF)"     "Btu per cubic foot per second - Fahrenheit"

PRIVATE CONST STRING u_W_m2sr                            =  "W/(m^2·sr)"            "watts per square metre - steradian"
PRIVATE CONST STRING u_W_sr                              =  "W/sr"                  "watts per steradian"

--[M·L2/(T3·Theta)]
PRIVATE CONST STRING u_W_K                               =  "W/K"                   "Watts per Kelvin"
PRIVATE CONST STRING u_kW_C                              =  "kW/degC"               "kilowatts per Celsius"

--[M·L2/(T3·M·Theta)]
PRIVATE CONST STRING u_W_kgK                             =  "W/(kg·K)"              "watts per kilogram - kelvin"

--[M·L2/(T3·M)]
PRIVATE CONST STRING u_kJ_skg                            =  "kJ/(s·kg)"             "specific energy flow"


--[T/L]
PRIVATE CONST STRING u_s_m                               =  "s/m"                   "second per metre"
PRIVATE CONST STRING u_g_kNs                             =  "g/(kN·s)"              "grams per kiloNewton and second"
--[T/M]
PRIVATE CONST STRING u_s_kg                              =  "s/kg"                  "seconds per kilogram"

--[N·L(0.5)·T/L3·M(0.5)]
PRIVATE CONST STRING u_mol_m3Pa05                        =  "mol/(m^3·Pa^0.5)"      "moles per cubic meter and pascal to the power of 0.5"
--[N·T/L·M]
PRIVATE CONST STRING u_mol_m2Pas                         =  "mol/(m^2·Pa·s)"        "moles per square meter, pascal and second"

--[(T2·L2·L3/(M·L)]
PRIVATE CONST STRING u_m3_Pa                             =  "m^3/Pa"                "Cubic meter per Pascal"
PRIVATE CONST STRING u_daykgug_mlug                      =  "day·kg·ug/ml/ug"       "Day kilogram microgram per mililiter and microgram"

--[(M·T2)/(L·T2·M2)]
PRIVATE CONST STRING u_Pas2_kg2                          =  "Pa·s^2/kg^2"           "Pascal square second per square kilogram"

--[(T*M)/L]
CONST STRING         u_dayug_ml                          =  "day·ug/ml"             "day per micrograme divide ml"
CONST STRING         u_hug_l                             =  "h·ug/l"                "hour per micrograme divide litre"
CONST STRING         u_hug_lmg                           =  "h·ug/l/mg"             "hour per micrograme divide litre divide miligrame"

--[(M·T)/(L·T2·M)]
PRIVATE CONST STRING u_Pas_kg                            =  "Pa·s/kg"               "Pascal second per kilogram"

--[(M·T)/(L·T2·L3)]
PRIVATE CONST STRING u_Pas_m3                            =  "Pa·s/m3"               "Pascal second per cubic meter"

--[(M·T2)/(L·T2·L6)]
PRIVATE CONST STRING u_Pas2_m6                           =  "Pa·s^2/(m^3)^2"        "Pascal square second per square cubic meter"

--[(L3·L·T2)/(L2·T·M)]
PRIVATE CONST STRING u_m3_m2sPa                          =  "m3/(m2·s·Pa)"          "cubic meter per square meter second and Pascal"

--[1/M·T]
PRIVATE CONST STRING u_1_skg                             =  "1/(s·kg)"              "Reciprocal second-kilogram"
PRIVATE CONST STRING u_1_hmg                             =  "1/(h·mg)"              "Reciprocal hour-miligram"

--[L/M·T]
PRIVATE CONST STRING u_m_skg                             =  "m/(s·kg)"              "Meters per second-kilogram"

--[L3/M·T]
PRIVATE CONST STRING u_m3_skg                            =  "m^3/(s·kg)"            "Cubic meters per second-kilogram"
PRIVATE CONST STRING u_ml_hmg                            =  "ml/(h·mg)"             "Mililiter per hour-miligram"

-- [Pressure/Volumetric FLow]
PRIVATE CONST STRING u_mmHgmin_ml                        =  "mmHg/(ml/min)"         "Milimeters of Hg per mililiters/min"

-- Others
PRIVATE CONST STRING u_kBq                               =  "kBq"                   "kiloBecquerel" 
PRIVATE CONST STRING u_MBq                               =  "MBq"                   "megaBecquerel" 
PRIVATE CONST STRING u_GBq                               =  "GBq"                   "gigaBecquerel" 

--
PRIVATE CONST STRING u_Cm2h_kcal                         =  "degC·m^2·h/kcal"       "degree Celsius square metre hour per kilocalorie"
PRIVATE CONST STRING u_Km2_kW                            =  "K·m^2/kW"              "Kelvin square metre per kilowatt"

--
PRIVATE CONST STRING u_deg                               =  "deg"                   "degree"
PRIVATE CONST STRING u_deg_s                             =  "deg/s"                 "degrees per second"
PRIVATE CONST STRING u_deg_s2                            =  "deg/s2"                "degrees per second squared"
PRIVATE CONST STRING u_rad_s                             =  "rad/s"                 "radians per second"
PRIVATE CONST STRING u_rad_s2                            =  "rad/s^2"               "radians per second squared"
PRIVATE CONST STRING u_rpm                               =  "rpm"                   "revolutions per minute"
PRIVATE CONST STRING u_rps                               =  "rps"                   "revolutions per second"
PRIVATE CONST STRING u_rpm_s                             =  "rpm/s"                 "revolutions per minute per second"
PRIVATE CONST STRING u_Nm_rad                            =  "N·m/rad"               "Newton metre per radian"
PRIVATE CONST STRING u_Nms_rad                           =  "N·m·s/rad"             "Newton metre second per radian"
PRIVATE CONST STRING u_rad_m                             =  "rad/m"                 "radian per metre"

--Eléctricas
PRIVATE CONST STRING u_A_m                               =  "A/m"                   "Ampere per metre"
PRIVATE CONST STRING u_A_m2                              =  "A/m^2"                 "Ampere per square metre"
PRIVATE CONST STRING u_Am2                               =  "A·m^2"                 "Ampere - square metre"
PRIVATE CONST STRING u_A_skmol                           =  "A/(kmol·s)"            "Ampere per kilomole - second"
PRIVATE CONST STRING u_A_smol                            =  "A/(s·mol)"             "Ampere per mole - second"
PRIVATE CONST STRING u_C_m2                              =  "C/m^2"                 "Coulombs per square metre"
PRIVATE CONST STRING u_C_m3                              =  "C/m^3"                 "Coulombs per cubic metre"
PRIVATE CONST STRING u_C_mm3                             =  "C/mm^3"                "Coulombs per cubic milimetre"
PRIVATE CONST STRING u_VA                                =  "VA"                    "Volt-Ampere"
PRIVATE CONST STRING u_VAr                               =  "VAr"                   "Reactive Volt Ampere"
PRIVATE CONST STRING u_Ah                                =  "A·h"                   "Ampere hour"

PRIVATE CONST STRING u_mV                                =  "mV"                    "milivolts"
PRIVATE CONST STRING u_1_V                               =  "1/V"                   "Inverse volts"
PRIVATE CONST STRING u_V_m                               =  "V/m"                   "Volts per metre"
PRIVATE CONST STRING u_V_K                               =  "V/K"                   "Volts per Kelvin"

PRIVATE CONST STRING u_Farad_m                           =  "F/m"                   "Farad per metre"

PRIVATE CONST STRING u_H_m                               =  "H/m"                   "Henry per metre"

PRIVATE CONST STRING u_cd_m2                             =  "cd/m2"                 "candela per square metre"

PRIVATE CONST STRING u_S_m                               =  "S/m"                   "Siemens per metre"
PRIVATE CONST STRING u_S_V                               =  "S/V"                   "Siemens per Volt"

PRIVATE CONST STRING u_mWb                               =  "mWb"                   "miliweber"

PRIVATE CONST STRING u_Ohm_m                             =  "Ohm/m"                 "Ohm per meter"
PRIVATE CONST STRING u_Ohmm                              =  "Ohm·m"                 "Ohm meter"

PRIVATE CONST STRING u_bits                              =  "bits"                  "bits"

PRIVATE CONST STRING u_AU                                =  "AU"                    "Astronomical Unit"

PRIVATE CONST STRING u_AU_day2                           =  "AU/day^2"              "Astronomical Units per squared day"

PRIVATE CONST STRING u_AU3_day2                          =  "AU^3/day^2"            "Cubic Astronomical Units per squared day"

PRIVATE CONST STRING u_knots                             =  "knots"                 "knots"