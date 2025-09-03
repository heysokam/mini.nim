//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "./errors.h"


void mini_parser_expect_any (
  mini_Parser* const         P,
  mini_size                  list_len,
  mini_token_Id const* const list_ptr
) {
  mini_Token tk = P->buf.ptr[P->pos];
  for (mini_size id = 0; id < list_len; ++id) {
    if (list_ptr[id] == tk.id) return;  // Found
  }
  // Not Found
  mini_parser_error(P, "Unexpected token found when parsing.");
}

