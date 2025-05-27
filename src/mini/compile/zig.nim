#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps mini.nim
from ../codegen/types as codegen import nil

#_______________________________________
# @section Compile: C Entry Point
#_____________________________
func compile *(
    code : codegen.Module;
  ) :string {.discardable.}=
  result = ""
  debugEcho code

