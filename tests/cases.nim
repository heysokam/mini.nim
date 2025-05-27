#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
##! @fileoverview Unified Test Cases Configuration
#___________________________________________________|
# @deps std
from std/os import parentDir, `/`, addFileExt


#_______________________________________
# @section Cases: Configuration
#_____________________________
const dir * = currentSourcePath().parentDir()/"cases"


#_______________________________________
# @section Hello42
#_____________________________
const Hello42_base * = dir/"01_hello42"
const Hello42_nim  * = Hello42_base.addFileExt("nim")
const Hello42_c    * = Hello42_base.addFileExt("c")
const Hello42_h    * = Hello42_base.addFileExt("h")
const Hello42      * = Hello42_nim.staticRead()


#_______________________________________
# @section HelloVar
#_____________________________
const HelloVar_base * = dir/"02_helloVar"
const HelloVar_nim  * = HelloVar_base.addFileExt("nim")
const HelloVar_c    * = HelloVar_base.addFileExt("c")
const HelloVar_h    * = HelloVar_base.addFileExt("h")
const HelloVar      * = HelloVar_nim.staticRead()


#_______________________________________
# @section HelloVarStatement
#_____________________________
const HelloVarStatement_base * = dir/"03_helloVarStatement"
const HelloVarStatement_nim  * = HelloVarStatement_base.addFileExt("nim")
const HelloVarStatement_c    * = HelloVarStatement_base.addFileExt("c")
const HelloVarStatement_h    * = HelloVarStatement_base.addFileExt("h")
const HelloVarStatement      * = HelloVarStatement_nim.staticRead()

