#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps mini.nim
import ../ast as mini
import ./types
type Module = types.Module

func generate *(
    ast : mini.Ast;
  ) :zig.Module=
  result = zig.Module()
  result.code = "Zig Codegen is not implemented yet."

