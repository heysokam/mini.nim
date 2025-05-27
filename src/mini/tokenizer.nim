#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strformat import `&`
from std/strutils  import `%`, join
import std/tables
# @deps slate
import slate
# @deps mini.nim
import ./base
import ./rules as mini

#_______________________________________
# @section Tokenizer: Types
#_____________________________
type Sz  * = base.Sz
type Pos * = slate.source.Pos

type token_Id = mini.Id

type Tk * = object
  id   *:token_Id
  loc  *:slate.source.Loc
type List * = seq[Tk]
type token_List = tokenizer.List

type Tok * = object
  pos  *:tokenizer.Pos= 0
  buf  *:slate.lexer.List= @[]
  src  *:slate.source.Code= ""
  res  *:token_List= @[]

#_______________________________________
# @section Tokenizer: Errors
#_____________________________
type TokenizerError = object of CatchableError
type UnknownFirstLexemeError = object of TokenizerError
type UnknownParenLexemeError = object of TokenizerError
#___________________
template fail *(Err :typedesc[CatchableError]; msg :varargs[string, `$`])=
  ## @descr
  ##  Marks a block of code as an unrecoverable fatal error. Raises an exception when entering the block.
  ##  For debugging unexpected errors on the buildsystem.
  const inst = instantiationInfo()
  const info = "$#($#,$#): " % [inst.fileName, $inst.line, $inst.column]
  {.cast(noSideEffect).}: raise newException(Err, info & "\n " & msg.join(" "))


#_______________________________________
# @section Tokenizer: Data Management
#_____________________________
func destroy *(T :var Tok) :void= T = Tok()
func create *(_:typedesc[Tok]; L :slate.Lex) :Tok=
  result = Tok()
  result.src = L.src
  result.buf = L.res
#___________________
func pos_next *(T :Tok, pos :tokenizer.Pos) :tokenizer.Pos {.inline.}=
  result = T.pos+pos
  if result >= T.buf.len.Sz: result = T.buf.len-1
#___________________
func next *(T :Tok, pos :tokenizer.Pos) :slate.Lx {.inline.}= T.buf[T.pos_next(pos)]
#___________________
func lx *(T :Tok) :slate.Lx {.inline.}= T.next(0)
#___________________
func add *(T :var Tok; id :mini.Id; loc :source.Loc) :void {.inline.}= T.res.add Tk(id: id, loc: loc)
func add *(T :var Tok; id :mini.Id) :void {.inline.}= T.add id, T.lx.loc


#_______________________________________
# @section Single Lexemes: Singles
#_____________________________
func number *(T :var Tok) :void=  T.add b_number
func star   *(T :var Tok) :void=  T.add op_star
func colon  *(T :var Tok) :void=  T.add sp_colon
func equal  *(T :var Tok) :void=  T.add sp_equal
#___________________
func keyword *(T :var Tok) :void=
  let kw = T.lx.loc.From(T.src)
  T.add mini.Keywords[kw]
#___________________
func ident *(T :var Tok) :void=
  if T.lx.From(T.src) in mini.Keywords: T.keyword(); return
  T.add b_ident

#_______________________________________
# @section Single Lexemes: Groups
#_____________________________
func paren *(T :var Tok) :void=
  case T.lx.id
  of slate.lexer.Id.paren_L   : T.add sp_paren_L
  of slate.lexer.Id.paren_R   : T.add sp_paren_R
  of slate.lexer.Id.brace_L   : T.add sp_brace_L
  of slate.lexer.Id.brace_R   : T.add sp_brace_R
  of slate.lexer.Id.bracket_L : T.add sp_bracket_L
  of slate.lexer.Id.bracket_R : T.add sp_bracket_R
  else                        : tokenizer.fail UnknownParenLexemeError, &"Tokenizing lexeme `{T.lx}` as a Parenthesis is incorrect."

#_______________________________________
# @section Multi Lexemes
#_____________________________
func space *(T :var Tok) :void=
  var loc = T.lx.loc
  T.pos.inc
  while T.pos < T.buf.len.Sz:
    if T.lx.id != slate.lexer.Id.space: T.pos.dec; break
    loc.add T.lx.loc
    T.pos.inc
  T.add wht_space, loc


#_______________________________________
# @section Tokenizer: Entry Point
#_____________________________
func process *(T :var Tok) :void=
  while T.pos < T.buf.len.Sz:
    case T.lx.id
    of slate.lexer.Id.space     : T.space()
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
    else                        : tokenizer.fail UnknownFirstLexemeError, &"TODO: Tokenizing lexeme `{T.lx}` not implemented."
    T.pos.inc

