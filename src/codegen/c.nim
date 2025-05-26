#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps mini.nim
import ../ast as mini

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
  ) :string=
  result = expression.value
#___________________
func gen_expression *(
    ast        : mini.Ast;
    expression : mini.Expression;
    statement  : mini.Statement;
    node       : mini.Node;
  ) :string= result = case expression.kind
  of Literal : ast.gen_literal(expression, statement, node)


#_______________________________________
# @section Codegen: Statements
#_____________________________
func gen_return *(
    ast       : mini.Ast;
    statement : mini.Statement;
    node      : mini.Node;
  ) :string=
  result.add $c.Keyword.Return
  result.add " "
  result.add ast.gen_expression(statement.value, statement, node)
  result.add ";"
#___________________
func gen_statement *(
    ast       : mini.Ast;
    statement : mini.Statement;
    node      : mini.Node;
  ) :string= result = case statement.kind
  of Return : ast.gen_return(statement, node)


#_______________________________________
# @section Codegen: Variable
#_____________________________
func gen_var *(
    ast  : mini.Ast;
    node : mini.Node;
  ) :string=
  # Attributes
  if not node.public:
    result.add $c.Keyword.Static
    result.add " "
  # Type
  result.add node.var_type.name
  result.add " "
  # Name
  result.add node.name
  # Value
  if node.var_value.value != "":
    result.add " = "
    result.add node.var_value.value
  # Terminate the Statement
  result.add ";\n"


#_______________________________________
# @section Codegen: Procedure
#_____________________________
func gen_proc_body *(
    ast  : mini.Ast;
    node : mini.Node;
  ) :string=
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
  ) :string=
  # Attributes
  if not node.public:
    result.add $c.Keyword.Static
    result.add " "
  # Type
  result.add node.proc_retT.name
  result.add " "
  # Name
  result.add node.name
  result.add " "
  # Args
  result.add "("
  # FIX: Codegen Aguments
  result.add ")"
  result.add " "
  # Body
  result.add ast.gen_proc_body(node)
  result.add "\n"


#_______________________________________
# @section Codegen: C Entry Point
#_____________________________
func generate *(
    ast : mini.Ast;
  ) :string=
  for node in ast.nodes:
    case node.kind
    of Proc : result.add ast.gen_proc(node)
    of Var  : result.add ast.gen_var(node)

