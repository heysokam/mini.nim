#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strformat import `&`
from std/strutils  import `%`, join
# @deps slate
import slate except fail, Pos
# @deps mini.nim
import ../types/base
import ../types/parser
import ../types/tokenizer
import ../types/ast
import ../rules as mini
import ../errors


#_______________________________________
# @section Parser: Whitespace & Newlines
#_____________________________
func newline *(P :var Parser) :void=
  # TODO: Shouldn't ignore empty newlines. They matter for meaningful indentation
  # P.skip wht_newline
  P.move(1)
#___________________
func indentation *(P :var Parser; list :varargs[TokenID]) :void=
  # TODO: Meaningful indentation
  P.skip wht_space


#_______________________________________
# @section Parse: Expressions
#_____________________________
func literal *(P :var Parser) :ast.Expression=
  result = ast.Expression(kind: Literal)
  P.expect TokenID.b_number
  result.lit_value = P.token.loc.From(P.src)
#_____________________________
func expression *(P :var Parser) :ast.Expression=
  result = P.literal()


#_______________________________________
# @section Parse: Statements
#_____________________________
const StatementIDs * = {TokenID.kw_return, TokenID.kw_var}
#___________________
func statement_return *(P :var Parser) :ast.Statement=
  P.expect TokenID.kw_return
  P.move(1)
  P.indentation()
  result = ast.Statement(kind: Return)
  result.ret_value = P.expression()
#___________________
func statement_variable *(P :var Parser) :ast.Statement=
  P.expect TokenID.kw_var
  P.move(1)
  P.indentation()
  result = ast.Statement(kind: Variable)
  # Name
  P.expect TokenID.b_ident
  result.var_name = P.token.loc.From(P.src)
  P.move(1)
  P.indentation()
  # Type
  # FIX: Parse Type
  # Value
  P.expect TokenID.sp_equal, TokenID.sp_semicolon
  P.move(1)
  P.indentation()
  result.var_value = P.expression()
#___________________
func statement *(P :var Parser) :ast.Statement=
  P.expect TokenID.kw_return, TokenID.kw_var
  result = case P.token.id
  of kw_return : P.statement_return()
  of kw_var    : P.statement_variable()
  else         : UnknownStatementTokenError.fail &"Parsing token `{P.token}` as a statement is not implemented."; Statement()


#_______________________________________
# @section Parse: proc
#_____________________________
func Proc_args *(P :var Parser) :ast.Proc_Args=
  result = @[]
  P.expect TokenID.sp_paren_L
  P.move(1)
  P.indentation()
  # FIX: Add arguments
  P.expect TokenID.sp_paren_R
  P.move(1)
  P.indentation()
#_____________________________
func Proc_body *(P :var Parser; proc_depth :slate.Depth) :Proc_Body=
  result = @[]
  P.expect TokenID.sp_equal
  P.move(1)
  P.indentation()
  # Might have a newline at the start of the body
  if P.token.id == TokenID.wht_newline:
    P.move(1)
    P.indentation()
  # Parse all statements
  while proc_depth in P.token.depth:
    P.indentation()
    result.add P.statement()
    P.move(1)
    P.indentation()
    if P.last: break
#_____________________________
func Proc_retT *(P :var Parser) :ast.Type=
  result = ast.Type()
  P.expect TokenID.sp_colon
  P.move(1)
  P.indentation()
  P.expect TokenID.b_ident
  result.name = P.token.loc.From(P.src)
  P.move(1)
  P.indentation()
#_____________________________
func Proc *(P :var Parser) :void=
  var res = ast.Node(kind: Proc)
  # Skip Keyword
  P.expect TokenID.kw_proc
  let proc_depth = P.token.depth
  P.move(1)
  P.indentation()
  # Get the name
  P.expect TokenID.b_ident
  res.name = P.token.loc.From(P.src)
  P.move(1)
  P.indentation()
  # Make public when marked with *
  if P.token.id == op_star:
    res.public = true
    P.move(1)
    P.indentation()
  # Get the Args
  P.expect TokenID.sp_paren_L
  res.proc_args = P.Proc_args()
  # Get the Return Type
  P.expect TokenID.sp_colon
  res.proc_retT = P.Proc_retT()
  # Get the body
  P.expect TokenID.sp_equal, TokenID.sp_semicolon
  if P.token.id == TokenID.sp_equal:
    res.proc_body = P.Proc_body(proc_depth)
  elif P.token.id == TokenID.sp_semicolon:
    P.move(1)
    P.indentation()
  # Add the proc node to the AST
  P.ast.nodes.add res

#_______________________________________
# @section Parser: var
#_____________________________
func Var_type *(P :var Parser) :ast.Var_type=
  result = ast.Var_type()
  result.name = "int"
#___________________
func Var_value *(P :var Parser) :ast.Var_value=
  P.expect TokenID.sp_equal
  P.move(1)
  P.indentation()
  result = P.literal()
#___________________
func variable *(P :var Parser) :void=
  var res = ast.Node(kind: Var)
  # Skip Keyword
  P.expect TokenID.kw_var
  P.move(1)
  P.indentation()
  # Get the name
  P.expect TokenID.b_ident
  res.name = P.token.loc.From(P.src)
  P.move(1)
  P.indentation()
  # Make public when marked with *
  if P.token.id == op_star:
    res.public = true
    P.move(1)
    P.indentation()
  # TODO: Get the Value Type
  res.var_type = P.Var_type()
  # Get the Value
  P.expect TokenID.sp_equal, TokenID.sp_semicolon
  if P.token.id == TokenID.sp_equal:
    res.var_value = P.Var_value()
    P.move(1)
  elif P.token.id == TokenID.sp_semicolon:
    P.move(1)
    P.indentation()
  # Expect a newline at the end of the statement
  P.expect TokenID.wht_newline
  # P.move(1)  # @note: Do not move to the next token, the main while loop will do that
  # Add the var node to the AST
  P.ast.nodes.add res


func pass *(P :var Parser) :void=
  ## @descr
  ## Entry point of the Syntax Parser pass.
  ## Will process the TokenList of the Parser into the resulting AST.
  while P.pos < P.buf.len.Sz:
    case P.token.id
    of kw_proc     : P.Proc()
    of kw_var      : P.variable()
    of wht_newline : P.newline()
    else           : P.error_toplevel()
    P.pos.inc

