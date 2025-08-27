#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
##! @fileoverview
##! Parser: Early Scope Designation pass.
##! Designates a scope level for every Token in the entire parser,
##! based on the layouting rules of the language,
##! @important Modifies the `depth.scope` value to each token in-place.
#________________________________________________________________________|
# @deps std
from std/strformat import `&`
# @deps slate
import slate except Pos, fail
# @deps mini.nim
import ../types/base as mini
import ../types/parser
import ../rules
import ../errors


iterator lines_from_current *(P :var Parser) :tuple[start :mini.Pos, End :mini.Pos]=
  ## @descr
  ## Returns the (start,end) position of every line in the given `P` parser.
  ## Iteration starts from `P.pos`, and each line will end when a token from `rules.Tokens_NewlineStart` is found.
  while true:
    var result :tuple[start :mini.Pos, End :mini.Pos]= (0,0)
    result.start = P.pos
    result.End   = result.start
    while P.buf[result.End].id notin rules.Tokens_NewlineStart: result.End.inc
    yield result
    if P.buf[result.End].id in rules.Tokens_NewlineStart: break


func stmt_list (P :var Parser) :void=
  ## @descr
  ## Iterates every line in the statement list,
  ## and assigns a new scope_id to every token found.
  let scope_id = P.token.depth.scope.next
  for line in P.lines_from_current:
    for id in line.start..line.End:
      P.buf[id].depth.scope = scope_id
    P.pos = line.End+1  # Done with this line. Move the parser to the start of the next line


func Proc (P :var Parser) :void=
  ##____________________________
  ## Notes:
  ## - Arguments do not have default values.
  ##   `=` is used as the statement list block starter.
  ##____________________________
  P.expect kw_proc
  # Assign initial scope to everything between `proc` and `=`, both included
  let scope_id = P.token.depth.scope.next
  while P.token.id != sp_equal:
    P.buf[P.pos].depth.scope = scope_id
    P.pos.inc
  P.expect sp_equal
  P.buf[P.pos].depth.scope = scope_id  # Assign current scope to the `=` too
  P.pos.inc
  # Initialize the first statement token scope to be the current scope  (aka. remove .none marker)
  P.buf[P.pos].depth.scope = scope_id  # FIX: Hacky, there should be a better way
  # Start Scope: Body
  scope.stmt_list(P)


func variable (P :var Parser) :void=
  while P.token.id != wht_newline: P.pos.inc
  # @note Leaves parser at the end of the line

func newline (P :var Parser) :void=
  while P.token.id in {wht_newline, wht_space}: P.pos.inc


func pass *(P :var Parser) :void=
  ## @descr
  ## Entry point of the Scope designation early parser pass.
  ## Will tag every token in the entire Parser with its corresponding ScopeID
  while P.pos < P.buf.len.Sz:
    case P.token.id
    of kw_proc     : P.Proc()
    of kw_var      : P.variable()
    of wht_newline : P.newline()
    else           : P.error_toplevel()
    P.pos.inc
  if P.pos.int < P.buf.len: UnexpectedPositionError.fail &"The Scope designation pass couldn't reach the end of the TokenList. Stopped at position: ({P.pos}/{P.buf.len-1})"
  P.pos = 0 # Reset position when done

