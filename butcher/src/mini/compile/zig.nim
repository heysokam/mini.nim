#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps ndk
from ./confy import nil
# @deps mini.nim
from ../codegen/types as codegen import nil

#_______________________________________
# @section Compile: Zig Entry Point
#_____________________________
func compile *(
    code : codegen.Module;
  ) :confy.BuildTarget {.discardable.}=
  result = confy.BuildTarget()
  debugEcho code
