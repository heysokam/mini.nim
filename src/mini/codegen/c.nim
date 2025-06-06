#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strformat import `&`, fmt
# @deps slate
import slate
# @deps mini.nim
import ../ast as mini
from ./types import add
type Module = types.Module

type Keyword *{.pure.}= enum
  Static = "static",
  Return = "return",
  While  = "while",

const MainNames * = @["main", "WinMain"]
const Templ_H * = """
#pragma once
"""
const Templ_C * = """
#include "./{result.name}.h"
"""

#_______________________________________
# @section Codegen: Expressions
#_____________________________
func gen_literal *(
    ast        : mini.Ast;
    expression : mini.Expression;
    statement  : mini.Statement;
    node       : mini.Node;
  ) :slate.source.Code=
  result = expression.lit_value
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
  result = ""
  result.add $c.Keyword.Return
  result.add " "
  result.add ast.gen_expression(statement.ret_value, statement, node)
  result.add ";"
#___________________
func gen_variable *(
    ast       : mini.Ast;
    statement : mini.Statement;
    node      : mini.Node;
  ) :slate.source.Code=
  result = " "
  # Type
  result.add statement.var_type.name
  result.add " "
  # Name
  result.add statement.var_name
  result.add " "
  # Value
  let value = statement.var_value.lit_value # FIX: Codegen expression
  if value != "":
    result.add " = "
    result.add value
  # Terminate the Statement
  result.add ";\n"
#___________________
func gen_statement *(
    ast       : mini.Ast;
    statement : mini.Statement;
    node      : mini.Node;
  ) :slate.source.Code= result = case statement.kind
  of Return   : ast.gen_return(statement, node)
  of Variable : ast.gen_variable(statement, node)


#_______________________________________
# @section Codegen: Variable
#_____________________________
func gen_var *(
    ast  : mini.Ast;
    node : mini.Node;
  ) :c.Module=
  result = c.Module(lang: ast.lang)
  # Attributes
  if not node.public:
    result.code.add $c.Keyword.Static
    result.code.add " "
  # Type
  result.code.add node.var_type.name
  result.code.add " "
  # Name
  result.code.add node.name
  # Declaration
  if node.public: result.header.add &"extern {result.code};\n"
  # Value
  let value = node.var_value.lit_value # FIX: Codegen expression
  if value != "":
    result.code.add " = "
    result.code.add value
  # Terminate the Statement
  result.code.add ";\n"


#_______________________________________
# @section Codegen: Procedure
#_____________________________
func gen_proc_body *(
    ast  : mini.Ast;
    node : mini.Node;
  ) :slate.source.Code=
  result = ""
  if node.proc_body.len == 0: return ";\n"
  result.add " "
  result.add "{"
  if node.proc_body.len == 1 : result.add " "
  else                       : result.add "\n  "
  for statement in node.proc_body: result.add ast.gen_statement(statement, node)
  if node.proc_body.len == 1: result.add " "
  result.add "}"
  result.add "\n"
#___________________
func gen_proc *(
    ast  : mini.Ast;
    node : mini.Node;
  ) :c.Module=
  result = c.Module(lang: ast.lang)
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
  # Declaration
  if node.name notin c.MainNames and node.public: result.header.add result.code & ";\n"
  # Body
  result.code.add ast.gen_proc_body(node)


#_______________________________________
# @section Codegen: C Entry Point
#_____________________________
func generate *(
    ast  : mini.Ast;
    dir  : string = ".";
    name : string = "entry";
  ) :c.Module=
  result = c.Module(
    lang : ast.lang,
    dir  : dir,
    name : name,)
  result.header = fmt c.Templ_H
  result.code   = fmt c.Templ_C
  for node in ast.nodes:
    case node.kind
    of Proc : result.add ast.gen_proc(node)
    of Var  : result.add ast.gen_var(node)

