#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps slate
import slate
# @deps mini.nim
import ./mini/base
import ./mini/tokenizer as tok
import ./mini/parser as par
import ./mini/ast
import ./mini/codegen
from ./mini/compile as cc import nil
type Tok = tok.Tok
type Par = par.Par
type Ast = ast.Ast

#_______________________________________
# @section API: Compiler as a Library
#_____________________________
export base
export cc
export mini.Tok
export mini.Par
export mini.Ast
export codegen

#_______________________________________
# @section Parser: Entry Point
#_____________________________
func parse *(code :slate.source.Code) :Ast=
  # Lexer
  var L = slate.Lex.create(code)
  defer: L.destroy()
  L.process()
  # Tokenizer
  var T = mini.Tok.create(L)
  defer: T.destroy()
  T.process()
  # Parser
  var P = mini.Par.create(T)
  defer: P.destroy()
  P.process()
  # Return the resulting AST
  result = P.ast
#___________________
proc parse *(file :string) :Ast=  mini.parse(code= file.readFile())

