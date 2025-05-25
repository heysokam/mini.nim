#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps slate
import slate


#_______________________________________
# @section AST: Types
#_____________________________
type Type * = object
  name  *:string

#_______________________________________
# @section AST: Expressions
#_____________________________
type ExpressionKind *{.pure.}= enum Literal
#___________________
type Expression * = object
  case kind *:ast.ExpressionKind
  of Literal :  value *:string

#_______________________________________
# @section AST: Statements
#_____________________________
type StatementKind *{.pure.}= enum Return
#___________________
type Statement * = object
  case kind *:ast.StatementKind
  of Return :  value *:ast.Expression
#___________________
type StatementList * = seq[ast.Statement]


#_______________________________________
# @section AST: Procedures
#_____________________________
type Proc_Body * = ast.StatementList


#_______________________________________
# @section AST: Toplevel Nodes
#_____________________________
type NodeKind *{.pure.}= enum Proc, Var
#___________________
type Node * = object
  name    *:string
  public  *:bool= false
  case kind *:NodeKind
  of Proc :
    proc_retT  *:string= "void"
    proc_body  *:ast.Proc_Body
  of Var  : discard
#___________________
type TopLevel * = seq[ast.Node]


#_______________________________________
# @section AST: Data
#_____________________________
type Lang *{.pure.}= enum C, Zig
#___________________
type Ast * = object
  lang   *:ast.Lang= C
  nodes  *:ast.TopLevel= @[]

