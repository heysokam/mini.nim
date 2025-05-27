#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from unittest import check
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


#_______________________________________
# @section Test Cases
#_____________________________
const Hello42    * = "proc main *() :int= return 42\n"
const Hello42_C  * = "int main () { return 42; }\n"
const HelloVar   * = "var hello * = 42\n"  & Hello42
const HelloVar_C * = "int hello = 42;\n" & Hello42_C


#_______________________________________
# @section Entry Point
#_____________________________
proc run=
  let hello42_ast = mini.parse(code=Hello42)
  echo "_________________________________"
  echo hello42_ast
  check hello42_ast.nodes.len == 1
  let hello42_C = hello42_ast.generate(C)
  check hello42_C.code == Hello42_C
  cc.compile(hello42_C, hello42_ast.lang)

  let helloVar_ast = mini.parse(code=HelloVar)
  echo "_________________________________"
  echo helloVar_ast
  check helloVar_ast.nodes.len == 2
  let helloVar_C = helloVar_ast.generate(C)
  check helloVar_C.code == HelloVar_C
  cc.compile(helloVar_C, helloVar_ast.lang)
#___________________
when isMainModule: run()

