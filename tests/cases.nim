#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
##! @fileoverview Unified Test Cases Configuration
#___________________________________________________|
# @deps std
from std/os import parentDir, `/`, addFileExt
# @deps mini.nim
from pkg/slate import ScopeId
from pkg/mini/rules import Id


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
const Hello42_Scope *:auto= @[
  #[ 0]# (id: kw_proc,      indent: 0, scope: ScopeId(0)),
  #[ 1]# (id: wht_space,    indent: 0, scope: ScopeId(0)),
  #[ 2]# (id: b_ident,      indent: 0, scope: ScopeId(0)),
  #[ 3]# (id: wht_space,    indent: 0, scope: ScopeId(0)),
  #[ 4]# (id: op_star,      indent: 0, scope: ScopeId(0)),
  #[ 5]# (id: sp_paren_L,   indent: 0, scope: ScopeId(0)),
  #[ 6]# (id: sp_paren_R,   indent: 0, scope: ScopeId(0)),
  #[ 7]# (id: wht_space,    indent: 0, scope: ScopeId(0)),
  #[ 8]# (id: sp_colon,     indent: 0, scope: ScopeId(0)),
  #[ 9]# (id: b_ident,      indent: 0, scope: ScopeId(0)),
  #[10]# (id: sp_equal,     indent: 0, scope: ScopeId(0)),
  #[11]# (id: wht_space,    indent: 0, scope: ScopeId(1)),
  #[12]# (id: kw_return,    indent: 0, scope: ScopeId(1)),
  #[13]# (id: wht_space,    indent: 0, scope: ScopeId(1)),
  #[14]# (id: b_number,     indent: 0, scope: ScopeId(1)),
  #[15]# (id: wht_newline,  indent: 0, scope: ScopeId(1)),
]


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

