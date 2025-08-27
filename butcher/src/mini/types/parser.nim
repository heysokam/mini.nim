#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
from std/strformat import `&`
# @deps slate
import slate except Pos, fail
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
  err  *:slate.source.Code= ""
  buf  *:TokenList= @[]
  ast  *:Ast


#_______________________________________
# @section Parser: Type tools
#_____________________________
func destroy *(P :var Parser) :void= P = Parser.default
func create  *(_:typedesc[Parser]; T :Tokenizer) :Parser=
  result = Parser()
  result.src = T.src
  result.buf = T.res
  result.ast = Ast.default
#___________________
func last *(P :Parser) :bool= P.pos.int >= P.buf.len-1
#___________________
func pos_next *(P :Parser, pos :Pos) :Pos {.inline.}=
  result = P.pos+pos
  if result >= P.buf.len.Sz: result = P.buf.len-1
#___________________
func next *(P :Parser, pos :Pos) :Token {.inline.}= P.buf[P.pos_next(pos)]
#___________________
func token *(P :Parser) :Token {.inline.}= P.next(0)
#___________________
func move *(P :var Parser; pos :source.Pos) :void {.inline.}= P.pos = P.pos_next(pos)
#___________________
func skip *(P :var Parser; list :varargs[TokenID]) :void=
  while P.token.id in list: P.move(1)
#___________________
func `$` *(P :Parser) :string=
  result = ""
  result.add "Tokens:\n"
  for id,token in P.buf.pairs:
    result.add &"  {id:02} : {token} -> `{token.loc.From(P.src)}`\n"
  result.add &"\n Source:\n`{P.err}`"

