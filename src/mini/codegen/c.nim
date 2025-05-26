#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps slate
import slate
# @deps mini.nim
import ../ast as mini
import ./types
type Module = types.Module

type Keyword *{.pure.}= enum
  Static = "static",
  Return = "return",
  While  = "while",


#_______________________________________
# @section Codegen: Expressions
#_____________________________
func gen_literal *(
    ast        : mini.Ast;
    expression : mini.Expression;
    statement  : mini.Statement;
    node       : mini.Node;
  ) :slate.source.Code=
  result = expression.value
#___________________
func gen_expression *(
    ast        : mini.Ast;
    expression : mini.Expression;
    statement  : mini.Statement;
    node       : mini.Node;
  ) :slate.source.Code= result = case expression.kind
  of Literal : ast.gen_literal(expression, statement, node)


#_______________________________________
# @section Codegen: Statements
#_____________________________
func gen_return *(
    ast       : mini.Ast;
    statement : mini.Statement;
    node      : mini.Node;
  ) :slate.source.Code=
  result.add $c.Keyword.Return
  result.add " "
  result.add ast.gen_expression(statement.value, statement, node)
  result.add ";"
#___________________
func gen_statement *(
    ast       : mini.Ast;
    statement : mini.Statement;
    node      : mini.Node;
  ) :slate.source.Code= result = case statement.kind
  of Return : ast.gen_return(statement, node)


#_______________________________________
# @section Codegen: Variable
#_____________________________
func gen_var *(
    ast  : mini.Ast;
    node : mini.Node;
  ) :c.Module=
  # Attributes
  if not node.public:
    result.code.add $c.Keyword.Static
    result.code.add " "
  # Type
  result.code.add node.var_type.name
  result.code.add " "
  # Name
  result.code.add node.name
  # Value
  if node.var_value.value != "":
    result.code.add " = "
    result.code.add node.var_value.value
  # Terminate the Statement
  result.code.add ";\n"


#_______________________________________
# @section Codegen: Procedure
#_____________________________
func gen_proc_body *(
    ast  : mini.Ast;
    node : mini.Node;
  ) :slate.source.Code=
  if node.proc_body.len == 0: return ";\n"
  result.add "{"
  if node.proc_body.len == 1 : result.add " "
  else                       : result.add "\n  "
  for statement in node.proc_body: result.add ast.gen_statement(statement, node)
  if node.proc_body.len == 1: result.add " "
  result.add "}"
#___________________
func gen_proc *(
    ast  : mini.Ast;
    node : mini.Node;
  ) :c.Module=
  result = c.Module()
  # Attributes
  if not node.public:
    result.code.add $c.Keyword.Static
    result.code.add " "
  # Type
  result.code.add node.proc_retT.name
  result.code.add " "
  # Name
  result.code.add node.name
  result.code.add " "
  # Args
  result.code.add "("
  # FIX: Codegen Arguments
  result.code.add ")"
  result.code.add " "
  # Body
  result.code.add ast.gen_proc_body(node)
  result.code.add "\n"


#_______________________________________
# @section Codegen: C Entry Point
#_____________________________
func generate *(
    ast : mini.Ast;
  ) :c.Module=
  result = c.Module()
  for node in ast.nodes:
    case node.kind
    of Proc : result.add ast.gen_proc(node)
    of Var  : result.add ast.gen_var(node)

