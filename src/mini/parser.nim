#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strformat import `&`
from std/strutils  import `%`, join
# @deps slate
import slate
# @deps mini.nim
import ./rules as mini
import ./tokenizer as tok
import ./ast


#_______________________________________
# @section Parser: Types
#_____________________________
type Pos * = tok.Pos
type token_Id = mini.Id
#___________________
type Par * = object
  pos  *:parser.Pos=  0
  src  *:slate.source.Code= ""
  buf  *:tok.List= @[]
  ast  *:Ast

#_______________________________________
# @section Parser: Errors
#_____________________________
type ParserError                = object of CatchableError
type UnknownToplevelTokenError  = object of ParserError
type UnexpectedTokenError       = object of ParserError
type UnknownStatementTokenError = object of ParserError
#___________________
template fail *(Err :typedesc[CatchableError]; msg :varargs[string, `$`])=
  ## @descr
  ##  Marks a block of code as an unrecoverable fatal error. Raises an exception when entering the block.
  ##  For debugging unexpected errors on the buildsystem.
  const inst = instantiationInfo()
  const info = "$#($#,$#): " % [inst.fileName, $inst.line, $inst.column]
  {.cast(noSideEffect).}: raise newException(Err, info & "\n " & msg.join(" "))
#___________________
template error_toplevel (P :var Par)=
  P.src.insert("⭸", P.tk.loc.start.Natural)
  parser.fail UnknownToplevelTokenError,
    &"Parsing token `{P.tk.id}` at the Toplevel is not implemented.\n\n Token: {P.tk}\n Lexemes:\n  {P.buf}\n\n Source:\n`{P.src}`"


#_______________________________________
# @section Parser: Data Management
#_____________________________
func destroy *(P :var Par) :void= P = Par.default
func create  *(_:typedesc[Par]; T :Tok) :Par=
  result = Par()
  result.src = T.src
  result.buf = T.res
  result.ast = Ast.default
#___________________
func pos_next *(P :Par, pos :parser.Pos) :parser.Pos {.inline.}=
  result = P.pos+pos
  if result >= P.buf.len.Sz: result = P.buf.len-1
#___________________
func next *(P :Par, pos :parser.Pos) :Tk {.inline.}= P.buf[P.pos_next(pos)]
#___________________
func tk *(P :Par) :Tk {.inline.}= P.next(0)
#___________________
func move *(P :var Par; pos :source.Pos) :void {.inline.}= P.pos = P.pos_next(pos)
#___________________
func skip *(P :var Par; list :varargs[token_Id]) :void=
  while P.tk.id in list: P.move(1)
#___________________
func newline *(P :var Par) :void=
  # TODO: Shouldn't ignore empty newlines. They matter for meaningful indentation
  P.skip wht_newline
#___________________
func indentation *(P :var Par; list :varargs[token_Id]) :void=
  # TODO: Meaningful indentation
  P.skip wht_space


#_______________________________________
# @section Parser: Data Validation
#_____________________________
func expect *(P :Par; list :varargs[token_Id]) :void=
  if P.tk.id notin list: parser.fail UnexpectedTokenError, &"Found token `{P.tk}`, but expected one of {list}"


#_______________________________________
# @section Parse: Expressions
#_____________________________
func literal *(P :var Par) :ast.Expression=
  result = ast.Expression(kind: Literal)
  P.expect token_Id.b_number
  result.lit_value = P.tk.loc.From(P.src)
#_____________________________
func expression *(P :var Par) :ast.Expression=
  result = P.literal()


#_______________________________________
# @section Parse: Statements
#_____________________________
func statement_return *(P :var Par) :ast.Statement=
  P.expect token_Id.kw_return
  P.move(1)
  P.indentation()
  result = ast.Statement(kind: Return)
  result.ret_value = P.expression()
#___________________
func statement_variable *(P :var Par) :ast.Statement=
  P.expect token_Id.kw_var
  P.move(1)
  P.indentation()
  result = ast.Statement(kind: Variable)
  # Name
  P.expect token_Id.b_ident
  result.var_name = P.tk.loc.From(P.src)
  P.move(1)
  P.indentation()
  # Type
  # FIX: Parse Type
  # Value
  P.expect token_Id.sp_equal, token_Id.sp_semicolon
  P.move(1)
  P.indentation()
  result.var_value = P.expression()
#___________________
func statement *(P :var Par) :ast.Statement=
  P.expect token_Id.kw_return, token_Id.kw_var
  result = case P.tk.id
  of kw_return : P.statement_return()
  of kw_var    : P.statement_variable()
  else         : parser.fail UnknownStatementTokenError, &"Parsing token `{P.tk}` as a statement is not implemented."; ast.Statement()


#_______________________________________
# @section Parse: proc
#_____________________________
func Proc_args *(P :var Par) :ast.Proc_Args=
  result = @[]
  P.expect token_Id.sp_paren_L
  P.move(1)
  P.indentation()
  # FIX: Add arguments
  P.expect token_Id.sp_paren_R
  P.move(1)
  P.indentation()
#_____________________________
func Proc_body *(P :var Par) :ast.Proc_Body=
  result = @[]
  P.expect token_Id.sp_equal
  P.move(1)
  P.indentation()
  # Might have a newline at the start of the body
  if P.tk.id == token_Id.wht_newline:
    P.move(1)
    P.indentation()
  # End each statement with a newline
  while P.tk.id != token_Id.wht_newline:
    P.indentation()
    result.add P.statement()
    P.move(1)
    P.indentation()
#_____________________________
func Proc_retT *(P :var Par) :ast.Type=
  result = ast.Type()
  P.expect token_Id.sp_colon
  P.move(1)
  P.indentation()
  P.expect token_Id.b_ident
  result.name = P.tk.loc.From(P.src)
  P.move(1)
  P.indentation()
#_____________________________
func Proc *(P :var Par) :void=
  var res = ast.Node(kind: Proc)
  # Skip Keyword
  P.expect token_Id.kw_proc
  P.move(1)
  P.indentation()
  # Get the name
  P.expect token_Id.b_ident
  res.name = P.tk.loc.From(P.src)
  P.move(1)
  P.indentation()
  # Make public when marked with *
  if P.tk.id == op_star:
    res.public = true
    P.move(1)
    P.indentation()
  # Get the Args
  P.expect token_Id.sp_paren_L
  res.proc_args = P.Proc_args()
  # Get the Return Type
  P.expect token_Id.sp_colon
  res.proc_retT = P.Proc_retT()
  # Get the body
  P.expect token_Id.sp_equal, token_Id.sp_semicolon
  if P.tk.id == token_Id.sp_equal:
    res.proc_body = P.Proc_body()
  elif P.tk.id == token_Id.sp_semicolon:
    P.move(1)
    P.indentation()
  # Add the proc node to the AST
  P.ast.nodes.add res

#_______________________________________
# @section Parse: var
#_____________________________
func Var_type *(P :var Par) :ast.Var_type=
  result = ast.Var_type()
  result.name = "int"
#___________________
func Var_value *(P :var Par) :ast.Var_value=
  P.expect token_Id.sp_equal
  P.move(1)
  P.indentation()
  result = P.literal()
#___________________
func variable *(P :var Par) :void=
  var res = ast.Node(kind: Var)
  # Skip Keyword
  P.expect token_Id.kw_var
  P.move(1)
  P.indentation()
  # Get the name
  P.expect token_Id.b_ident
  res.name = P.tk.loc.From(P.src)
  P.move(1)
  P.indentation()
  # Make public when marked with *
  if P.tk.id == op_star:
    res.public = true
    P.move(1)
    P.indentation()
  # TODO: Get the Value Type
  res.var_type = P.Var_type()
  # Get the Value
  P.expect token_Id.sp_equal, token_Id.sp_semicolon
  if P.tk.id == token_Id.sp_equal:
    res.var_value = P.Var_value()
    P.move(1)
  elif P.tk.id == token_Id.sp_semicolon:
    P.move(1)
    P.indentation()
  # Expect a newline at the end of the statement
  P.expect token_Id.wht_newline
  P.move(1)
  # Add the var node to the AST
  P.ast.nodes.add res


#_______________________________________
# @section Parser: Entry Point
#_____________________________
func process *(P :var Par) :void=
  while P.pos < P.buf.len.Sz:
    case P.tk.id
    of token_Id.kw_proc     : P.Proc()
    of token_Id.kw_var      : P.variable()
    of token_Id.wht_newline : P.newline()
    else                    : P.error_toplevel()
    P.pos.inc
  discard

