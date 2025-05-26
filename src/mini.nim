#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strutils import dedent
# @deps slate
import slate
# @deps mini.nim
import ./tokenizer as tok
import ./parser as par
import ./ast
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
  debugEcho "_________________________________"
  debugEcho P.buf
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
const HelloVar   * = "var hello = 42\n"  & Hello42
const HelloVar_C * = "int hello = 42;\n" & Hello42_C


#_______________________________________
# @section Entry Point
#_____________________________
proc run=
  let hello42_ast = mini.parse(code=Hello42)
  echo hello42_ast
  doAssert hello42_ast.nodes.len == 1

  let helloVar_ast = mini.parse(code=HelloVar)
  echo helloVar_ast
  doAssert helloVar_ast.nodes.len == 2
#___________________
when isMainModule: run()

