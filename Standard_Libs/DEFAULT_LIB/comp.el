/*-----------------------------------------------------------------------------------------
 LIBRARY: DEFAULT_LIB
 FILE: comp
 AUTHOR: 
 COMPANY: 
 DESCRIPTION: 
 CREATION DATE: 02/07/2025
-----------------------------------------------------------------------------------------*/

COMPONENT comp
   DECLS
      REAL x
      REAL y
      
   CONTINUOUS
      x = y
      x = sin(TIME)
   
END COMPONENT
