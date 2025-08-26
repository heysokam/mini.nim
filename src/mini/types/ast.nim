#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps mini.nim
import ./base


#_______________________________________
# @section AST Types: Types
#_____________________________
type Type * = object
  name  *:string


#_______________________________________
# @section AST Types: Value Data Types
#_____________________________
type Data * = object
  name   *:string
  typ    *:ast.Type
  value  *:string


#_______________________________________
# @section AST Types: Expressions
#_____________________________
type ExpressionKind *{.pure.}= enum Literal
#___________________
type Expression * = object
  case kind *:ast.ExpressionKind
  of Literal:
    lit_value *:string


#_______________________________________
# @section AST Types: Variables
#_____________________________
type Var_value * = ast.Expression
type Var_type  * = ast.Type


#_______________________________________
# @section AST Types: Statements
#_____________________________
type StatementKind *{.pure.}= enum Return, Variable
#___________________
type Statement * = object
  case kind *:ast.StatementKind
  of Return:
    ret_value  *:ast.Expression
  of Variable:
    var_name   *:string
    var_type   *:ast.Type
    var_value  *:ast.Var_value
#___________________
type StatementList * = seq[ast.Statement]


#_______________________________________
# @section AST Types: Procedures
#_____________________________
type Proc_Body * = ast.StatementList
type Proc_Arg  * = ast.Data
type Proc_Args * = seq[ast.Proc_Arg]


#_______________________________________
# @section AST Types: Toplevel Nodes
#_____________________________
type NodeKind *{.pure.}= enum Proc, Var
#___________________
type Node * = object
  name    *:string
  public  *:bool= false
  case kind *:ast.NodeKind
  of Proc:
    proc_args  *:ast.Proc_Args = @[]
    proc_retT  *:ast.Type      = Type(name: "void")
    proc_body  *:ast.Proc_Body = @[]
  of Var:
    var_type   *:ast.Type
    var_value  *:ast.Var_value
#___________________
type TopLevel * = seq[ast.Node]


#_______________________________________
# @section AST Types: Data
#_____________________________
type Ast * = object
  lang   *:Lang= C
  nodes  *:ast.TopLevel= @[]


