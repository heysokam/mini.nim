#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps slate
import slate except Pos
# @deps mini.nim
import ./base
import ./ast
import ./tokenizer


#_______________________________________
# @section Parser: Types
#_____________________________
type Parser * = object
  pos  *:Pos=  0
  src  *:slate.source.Code= ""
  buf  *:TokenList= @[]
  ast  *:Ast

