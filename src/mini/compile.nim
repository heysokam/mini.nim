#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps ndk
from ./compile/confy import nil
# @deps mini.nim
from ./base as mini import nil
from ./codegen/types as codegen import nil
from ./compile/c import nil
from ./compile/zig import nil
type Lang = mini.Lang


#_______________________________________
# @section Compile: Multi-lang Entry Points
#_____________________________
proc compile *(
    code : codegen.Module;
    lang : mini.Lang;
  ) :confy.BuildTarget {.discardable.}= result = case lang
  of Lang.C   : c.compile(code)
  of Lang.Zig : zig.compile(code)
#___________________
proc run *(
    code : codegen.Module;
    lang : mini.Lang;
  ) :confy.BuildTarget {.discardable.}= confy.run(code.compile(lang))

