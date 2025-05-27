#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps mini.nim
from ./base import nil
import ./ast as mini
from ./codegen/types import nil
from ./codegen/c import nil
from ./codegen/zig import nil
const C     = c.generate
const Zig   = zig.generate
type Module = types.Module
type Lang   = base.Lang

func generate *(
    ast  : mini.Ast;
    lang : codegen.Lang = ast.lang;
  ) :codegen.Module= result = case lang
  of Lang.C   : codegen.C(ast)
  of Lang.Zig : codegen.Zig(ast)

