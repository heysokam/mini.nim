#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps mini.nim
import ./types/parser
import ./passes/scope
import ./passes/syntax


#_______________________________________
# @section Parser: Entry Point
#_____________________________
func process *(P :var Parser) :void=
  # Apply Pre-Passes to the TokenList
  scope.pass(P)  # Scope pass
  # Parse the TokenList
  syntax.pass(P)

