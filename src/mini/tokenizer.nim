#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strformat import `&`
from std/strutils  import `%`, join
import std/tables
# @deps slate
import slate except fail, Pos
# @deps mini.nim
import ./types/base
import ./types/tokenizer as tok
import ./rules as mini
import ./errors


#_______________________________________
# @section Tokenizer: Data Management
#_____________________________
func destroy *(T :var Tokenizer) :void= T = Tokenizer()
func create *(_:typedesc[Tokenizer]; L :slate.Lex) :Tokenizer=
  result = Tokenizer()
  result.src = L.src
  result.buf = L.res
#___________________
func pos_next *(T :Tokenizer, pos :Pos) :Pos {.inline.}=
  result = T.pos+pos
  if result >= T.buf.len.Sz: result = T.buf.len-1
#___________________
func next *(T :Tokenizer, pos :Pos) :slate.Lx {.inline.}= T.buf[T.pos_next(pos)]
#___________________
func lexeme *(T :Tokenizer) :slate.Lx {.inline.}= T.next(0)
#___________________
func add *(T :var Tokenizer; id :TokenID; loc :source.Loc) :void {.inline.}= T.res.add Token(id: id, loc: loc, ind: T.depth.lvl)
func add *(T :var Tokenizer; id :TokenID) :void {.inline.}= T.add id, T.lexeme.loc


#_______________________________________
# @section Single Lexemes: Singles
#_____________________________
func number  *(T :var Tokenizer) :void=  T.add b_number
func star    *(T :var Tokenizer) :void=  T.add op_star
func colon   *(T :var Tokenizer) :void=  T.add sp_colon
func equal   *(T :var Tokenizer) :void=  T.add sp_equal
func newline *(T :var Tokenizer) :void=
  T.add wht_newline
  T.depth.chg = on
  T.depth.lvl = 0
#___________________
func keyword *(T :var Tokenizer) :void=
  let kw = T.lexeme.loc.From(T.src)
  T.add mini.Keywords[kw]
#___________________
func ident *(T :var Tokenizer) :void=
  if T.lexeme.From(T.src) in mini.Keywords: T.keyword(); return
  T.add b_ident

#_______________________________________
# @section Single Lexemes: Groups
#_____________________________
func paren *(T :var Tokenizer) :void=
  case T.lexeme.id
  of slate.lexer.Id.paren_L   : T.add sp_paren_L
  of slate.lexer.Id.paren_R   : T.add sp_paren_R
  of slate.lexer.Id.brace_L   : T.add sp_brace_L
  of slate.lexer.Id.brace_R   : T.add sp_brace_R
  of slate.lexer.Id.bracket_L : T.add sp_bracket_L
  of slate.lexer.Id.bracket_R : T.add sp_bracket_R
  else                        : UnknownParenLexemeError.fail &"Tokenizing lexeme `{T.lexeme}` as a Parenthesis is incorrect."

#_______________________________________
# @section Multi Lexemes
#_____________________________
func space *(T :var Tokenizer) :void=
  var loc = T.lexeme.loc
  T.pos.inc
  while T.pos < T.buf.len.Sz:
    if T.lexeme.id != slate.lexer.Id.space: T.pos.dec; break
    loc.add T.lexeme.loc
    T.pos.inc
    #_____________________________
    # @note
    # First whitespace in a line should be indent 0, not 1.
    # Couldn't figure out the logic to achieve that
    if T.depth.chg: T.depth.lvl.inc
    #_____________________________
  T.add wht_space, loc
  if T.depth.chg: T.depth.chg = off


#_______________________________________
# @section Tokenizer: Entry Point
#_____________________________
func process *(T :var Tokenizer) :void=
  while T.pos < T.buf.len.Sz:
    case T.lexeme.id
    of slate.lexer.Id.space     : T.space()
    of slate.lexer.Id.newline   : T.newline()
    of slate.lexer.Id.ident     : T.ident()
    of slate.lexer.Id.number    : T.number()
    of slate.lexer.Id.star      : T.star()
    of slate.lexer.Id.colon     : T.colon()
    of slate.lexer.Id.equal     : T.equal()
    of slate.lexer.Id.paren_L,
       slate.lexer.Id.paren_R,
       slate.lexer.Id.brace_L,
       slate.lexer.Id.brace_R,
       slate.lexer.Id.bracket_L,
       slate.lexer.Id.bracket_R : T.paren()
    else                        : UnknownFirstLexemeError.fail &"TODO: Tokenizing lexeme `{T.lexeme}` not implemented."
    T.pos.inc

