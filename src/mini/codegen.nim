#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
import ./ast as mini
import ./codegen/c
import ./codegen/zig
const C = c.generate
const Zig = zig.generate

func generate *(
    ast  : mini.Ast;
    lang : mini.Lang = ast.lang;
  ) :string= result = case lang
  of C   : codegen.C(ast)
  of Zig : codegen.Zig(ast)

