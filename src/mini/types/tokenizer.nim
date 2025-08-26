#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps slate
import slate except Pos
# @deps mini.nim
import ./base
import ../rules as mini

#_______________________________________
# @section Tokenizer: Types
#_____________________________
type TokenID * = mini.Id

type Token * = object
  id     *:TokenID
  loc    *:slate.source.Loc
  depth  *:slate.Depth
type TokenList * = seq[Token]

type Depth * = object
  lvl  *:slate.depth.Level= 0 ## Current indentation level to assign to tokens.
  chg  *:bool= off            ## Should we update depth_level (are we in a newline)

type Tokenizer * = object
  pos    *:Pos= 0
  buf    *:slate.lexer.List= @[]
  src    *:slate.source.Code= ""
  res    *:TokenList= @[]
  depth  *:tokenizer.Depth

