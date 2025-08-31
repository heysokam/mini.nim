//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "../passes.h"


//______________________________________
// @section Parser.scope: Column Position
//____________________________

static void mini_parser_scope_columnize (
  mini_Parser* const P
) {
  mini_size column = 0;
  for (mini_size id = 0; id < P->buf.len; ++id) {
    mini_Token const tk         = P->buf.ptr[id];
    P->buf.ptr[id].depth.column = column;     // Assign to this token
    column += tk.loc.end - tk.loc.start + 1;  // Add the current len to the column value
    if (tk.id == mini_token_wht_newline) column = 0;
  }
}


//______________________________________
// @section Parser.scope: Indentation Level
//____________________________

static void mini_parser_scope_indentate (
  mini_Parser* const P
) {
  (void)P;
}


//______________________________________
// @section Parser.scope: Scope Identity
//____________________________

static void mini_parser_scope_identify (
  mini_Parser* const P
) {
  (void)P;
}


//______________________________________
// @section Parser.scope: Entry Point
//____________________________

void mini_parser_scope (
  mini_Parser* const P
) {
  mini_parser_scope_columnize(P);
  mini_parser_scope_indentate(P);
  mini_parser_scope_identify(P);
}

