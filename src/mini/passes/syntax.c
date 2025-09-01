//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "../tokenizer.h"
#include "../parser/errors.h"
#include "../passes.h"


static void mini_parser_syntax_var (
  mini_Parser* const P
) {
  (void)P;
}

static void mini_parser_syntax_proc (
  mini_Parser* const P
) {
  (void)P;
}

static void mini_parser_syntax_whitespace (
  mini_Parser* const P
) {
  (void)P;
}


void mini_parser_syntax (
  mini_Parser* const P
) {
  while (P->pos < P->buf.len) {
    mini_Token const tk = P->buf.ptr[P->pos];
    switch (tk.id) {
      case mini_token_kw_proc     : mini_parser_syntax_proc(P); break;
      case mini_token_kw_var      : mini_parser_syntax_var(P); break;
      case mini_token_wht_space   : /* fall-through */
      case mini_token_wht_newline : mini_parser_syntax_whitespace(P); break;
      default                     : mini_parser_error(P, "Unknown TopLevel Token: %02zu:%s", P->pos, mini_token_toString(tk.id)); break;
    }
    P->pos += 1;
  }
  P->pos = 0;
}

