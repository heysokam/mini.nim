#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strformat import `&`
from std/strutils  import `%`, join
# @deps slate
import slate
# @deps mini.nim
import ./tok
import ./ast
import ./rules as mini


#_______________________________________
# @section Parser: Types
#_____________________________
type Pos * = tok.Pos
type token_Id = mini.Id
#___________________
type Par * = object
  pos  *:par.Pos=  0
  src  *:slate.source.Code= ""
  buf  *:tok.List= @[]
  ast  *:Ast

#_______________________________________
# @section Parser: Errors
#_____________________________
type ParserError               = object of CatchableError
type UnknownToplevelTokenError = object of ParserError
type UnexpectedTokenError      = object of ParserError
#___________________
template fail *(Err :typedesc[CatchableError]; msg :varargs[string, `$`])=
  ## @descr
  ##  Marks a block of code as an unrecoverable fatal error. Raises an exception when entering the block.
  ##  For debugging unexpected errors on the buildsystem.
  const inst = instantiationInfo()
  const info = "$#($#,$#): " % [inst.fileName, $inst.line, $inst.column]
  {.cast(noSideEffect).}: raise newException(Err, info & "\n " & msg.join(" "))

#_______________________________________
# @section Parser: Data Management
#_____________________________
func destroy *(P :var Par) :void= P = Par.default
func create  *(_:typedesc[Par]; T :Tok) :Par=
  result.src = T.src
  result.buf = T.res
  result.ast = Ast.default
#___________________
func pos_next *(P :Par, pos :par.Pos) :par.Pos {.inline.}=
  result = P.pos+pos
  if result >= P.buf.len.Sz: result = P.buf.len-1
#___________________
func next *(P :Par, pos :par.Pos) :Tk {.inline.}= P.buf[P.pos_next(pos)]
#___________________
func tk *(P :Par) :Tk {.inline.}= P.next(0)
#___________________
func move *(P :var Par; pos :source.Pos) :void {.inline.}= P.pos = P.pos_next(pos)
#___________________
func skip *(P :var Par; list :varargs[token_Id]) :void=
  while P.tk.id in list: P.move(1)
#___________________
func indentation *(P :var Par; list :varargs[token_Id]) :void=
  P.skip wht_space


#_______________________________________
# @section Parser: Data Validation
#_____________________________
func expect *(P :Par; list :varargs[token_Id]) :void=
  if P.tk.id notin list: par.fail UnexpectedTokenError, &"Found token `{P.tk}`, but expected one of {list}"


#_______________________________________
# @section Parse: Expressions
#_____________________________
func literal *(P :var Par) :ast.Expression=
  P.expect token_Id.b_number
  result.value = P.tk.loc.From(P.src)
  P.move(1)
  P.indentation()


#_______________________________________
# @section Parse: Statements
#_____________________________
func statement *(P :var Par) :ast.Statement=
  P.expect token_Id.kw_return
  P.move(1)
  P.indentation()
  result = ast.Statement(kind: Return)
  result.value = P.literal()


#_______________________________________
# @section Parse: proc
#_____________________________
func Proc_args *(P :var Par) :ast.Proc_Args=
  P.expect token_Id.sp_paren_L
  P.move(1)
  P.indentation()
  # FIX: Add arguments
  P.expect token_Id.sp_paren_R
  P.move(1)
  P.indentation()
#_____________________________
func Proc_body *(P :var Par) :ast.Proc_Body=
  P.expect token_Id.sp_equal
  P.move(1)
  P.indentation()
  result.add P.statement()
#_____________________________
func Proc_retT *(P :var Par) :ast.Type=
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
# @section Parser: Entry Point
#_____________________________
func process *(P :var Par) :void=
  while P.pos < P.buf.len.Sz:
    case P.tk.id
    of token_Id.kw_proc: P.Proc()
    else : par.fail UnknownToplevelTokenError, &"Parsing token `{P.tk}` at the Toplevel is not implemented."
    P.pos.inc
  discard

