#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps mini.nim
from ./base as mini import nil
from ./codegen/types as codegen import nil
from ./compile/c import nil
from ./compile/zig import nil
type Lang = mini.Lang

proc compile *(
    code : codegen.Module;
    lang : mini.Lang;
  ) :string {.discardable.}= result = case lang
  of Lang.C   : c.compile(code)
  of Lang.Zig : zig.compile(code)

