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
  kw_include,   # include
  kw_while,     # while
  kw_array,     # array
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
  op_minus,     # -
  op_plus,      # +
  op_equal,     # ==
  op_notEqual,  # !=
  # Whitespace
  wht_space,    # ` `

const Keywords * = {
  "proc"    : kw_proc,
  "var"     : kw_var,
  "return"  : kw_return,
  "include" : kw_include,
  "while"   : kw_while,
  "array"   : kw_array,
}.toTable

