#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strutils import `%`, join


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
type UnknownToplevelTokenError  * = object of ParserError
type UnexpectedTokenError       * = object of ParserError
type UnknownStatementTokenError * = object of ParserError


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

