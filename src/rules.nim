#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
import std/tables

type Id * = enum
  b_ident, b_number,
  # Keywords
  kw_proc,      # proc
  kw_var,       # var
  kw_return,    # return
  # Special Characters
  sp_paren_L,   # (
  sp_paren_R,   # )
  sp_brace_L,   # {
  sp_brace_R,   # }
  sp_bracket_L, # [
  sp_bracket_R, # ]
  sp_colon,     # :
  sp_semicolon, # ;
  sp_equal,     # =
  # Operators
  op_star,      # *
  # Whitespace
  wht_space,    # ` `

const Keywords * = {
  "proc"   : kw_proc,
  "var"    : kw_var,
  "return" : kw_return,
}.toTable

