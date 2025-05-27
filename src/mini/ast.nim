#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps slate
# import slate
# @deps mini.nim
import ./base
type Lang = base.Lang


#_______________________________________
# @section AST: Types
#_____________________________
type Type * = object
  name  *:string


#_______________________________________
# @section AST: Value Data Types
#_____________________________
type Data * = object
  name   *:string
  typ    *:ast.Type
  value  *:string


#_______________________________________
# @section AST: Expressions
#_____________________________
type ExpressionKind *{.pure.}= enum Literal
#___________________
type Expression * = object
  case kind *:ast.ExpressionKind
  of Literal:
    lit_value *:string


#_______________________________________
# @section AST: Variables
#_____________________________
type Var_value * = ast.Expression
type Var_type  * = ast.Type


#_______________________________________
# @section AST: Statements
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
# @section AST: Procedures
#_____________________________
type Proc_Body * = ast.StatementList
type Proc_Arg  * = ast.Data
type Proc_Args * = seq[ast.Proc_Arg]


#_______________________________________
# @section AST: Toplevel Nodes
#_____________________________
type NodeKind *{.pure.}= enum Proc, Var
#___________________
type Node * = object
  name    *:string
  public  *:bool= false
  case kind *:NodeKind
  of Proc:
    proc_args  *:ast.Proc_Args = @[]
    proc_retT  *:ast.Type      = ast.Type(name: "void")
    proc_body  *:ast.Proc_Body = @[]
  of Var:
    var_type   *:ast.Type
    var_value  *:ast.Var_value
#___________________
type TopLevel * = seq[ast.Node]


#_______________________________________
# @section AST: Data
#_____________________________
type Ast * = object
  lang   *:ast.Lang= C
  nodes  *:ast.TopLevel= @[]

