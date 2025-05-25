#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps slate
import slate
# @deps mini.nim
import ./tok
import ./par
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
  P.process()
  debugEcho P.buf
  # Return the resulting AST
  result = P.ast


#_______________________________________
# @section Entry Point
#_____________________________
proc run=
  let hello42 = mini.parse("proc main *() :int= return 42\n")
  echo hello42
  doAssert hello42.nodes.len == 1
#___________________
when isMainModule: run()

