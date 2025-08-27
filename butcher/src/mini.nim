#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps slate
import slate
# @deps mini.nim
import ./mini/types/base
import ./mini/types/tokenizer as tok
import ./mini/types/parser as par
import ./mini/types/ast
import ./mini/tokenizer
import ./mini/parser
import ./mini/codegen
from ./mini/compile as cc import nil
type Lexer     * = slate.Lex
type Tokenizer = tok.Tokenizer
type Parser    = par.Parser
type Ast       = ast.Ast

#_______________________________________
# @section API: Compiler as a Library
#_____________________________
export base
export cc
export tok
export par
export tokenizer
export parser
export codegen


#_______________________________________
# @section Parser: Entry Point
#_____________________________
func parse *(code :slate.source.Code) :Ast=
  # Lexer
  var L = mini.Lexer.create(code)
  defer: L.destroy()
  L.process()
  # Tokenizer
  var T = mini.Tokenizer.create(L)
  defer: T.destroy()
  T.process()
  # Parser
  var P = mini.Parser.create(T)
  defer: P.destroy()
  P.process()
  # Return the resulting AST
  result = P.ast
#___________________
proc parse *(file :string) :Ast=  mini.parse(code= file.readFile())

