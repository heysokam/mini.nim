#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strformat import `&`
from std/strutils import `%`, join
# @deps slate
from pkg/slate/depth import `$`
# @deps mini.nim
import ./types/tokenizer
import ./types/parser


#_______________________________________
# @section Generic Fail
#_____________________________
template fail *(Err :typedesc[CatchableError]; msg :varargs[string, `$`])=
  ## @descr
  ##  Marks a block of code as an unrecoverable fatal error. Raises an exception when entering the block.
  ##  For debugging unexpected errors on the buildsystem.
  const inst = instantiationInfo()
  const info = "$#($#,$#): " % [inst.fileName, $inst.line, $inst.column]
  {.cast(noSideEffect).}: raise newException(Err, info & "\n " & msg.join(" "))


#_______________________________________
# @section Tokenizer Errors
#_____________________________
type TokenizerError          * = object of CatchableError
type UnknownFirstLexemeError * = object of TokenizerError
type UnknownParenLexemeError * = object of TokenizerError


#_______________________________________
# @section Parser Errors
#_____________________________
type ParserError                * = object of CatchableError
type UnexpectedPositionError    * = object of ParserError
type UnknownToplevelTokenError  * = object of ParserError
type UnexpectedTokenError       * = object of ParserError
type UnknownStatementTokenError * = object of ParserError


#_______________________________________
# @section Parser: Data Validation
#_____________________________
template error_toplevel *(P :var Parser)=
  P.err = P.src
  P.err.insert("⭸", P.token.loc.start.Natural)
  UnknownToplevelTokenError.fail &"Parsing token `{P.token.id}` at the Toplevel is not implemented.\n\n Token: {P.pos} : {P.token}\n {P}"
#___________________
func expect *(P :Parser; list :varargs[TokenID]) :void=
  if P.token.id notin list: UnexpectedTokenError.fail &"Found token `{P.token}`, but expected one of {list}"

