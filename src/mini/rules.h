//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_rules
#define H_mini_rules
#include "./base.h"


typedef enum mini_token_Id {
  // (@note: must respect array indexing)
  // Keywords
  mini_token_kw_proc,
  mini_token_kw_var,
  mini_token_kw_return,
  mini_Keywords_len,  // Max length of the Keywords array
  // Delimiters
  mini_token_parenthesis_left,   // (
  mini_token_parenthesis_right,  // )
  mini_token_bracket_left,       // [
  mini_token_bracket_right,      // ]
  mini_token_brace_left,         // {
  mini_token_brace_right,        // }
  // Specials
  mini_token_sp_star,       // *
  mini_token_sp_colon,      // :
  mini_token_sp_semicolon,  // ;
  mini_token_sp_comma,      // ,
  mini_token_sp_dot,        // .
  mini_token_sp_equal,      // =
  // Operators
  // Whitespace
  mini_token_wht_space,    // ` ` \t
  mini_token_wht_newline,  // \r \n
  // Base
  mini_token_b_identifier,
  mini_token_b_number,
  // clang-format off
  mini_token_Id_Force32 = 0x7FFFFFFF,
  // clang-format on
} mini_token_Id;

extern mini_cstring const mini_Keywords_ptr[mini_Keywords_len];


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_rules
#endif  // mini_Implementation
#ifdef mini_Implementation_rules
#include "./rules.c"
#endif  // mini_Implementation_rules


#endif  // H_mini_rules

