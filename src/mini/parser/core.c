//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
// #include "../source.h"
// #include "../tokenizer.h"
#include "../parser.h"


mini_Parser mini_parser_create (
  mini_Tokenizer const* const T
) {
  (void)T;
  mini_Parser result = (mini_Parser){
    .pos = 0,
    .src = { .ptr = T->src.ptr, .len = T->src.len },
    .buf = { .ptr = NULL, .len = T->res.len, .cap = T->res.cap },
  };
  mini_size size = result.buf.cap * sizeof(*T->res.ptr);
  result.buf.ptr = malloc(size);
  result.buf.ptr = memcpy(result.buf.ptr, T->res.ptr, size);
  return result;
}


void mini_parser_destroy (
  mini_Parser* const P
) {
  P->pos           = 0;
  P->src.len       = 0;
  P->src.ptr       = NULL;
  P->ast.nodes.len = 0;
  P->ast.nodes.cap = 0;
  if (P->ast.nodes.ptr) free(P->ast.nodes.ptr);
  P->ast.nodes.ptr = NULL;
  P->buf.len       = 0;
  P->buf.cap       = 0;
  if (P->buf.ptr) free(P->buf.ptr);
  P->buf.ptr = NULL;
}


void mini_parser_report (
  mini_Parser* const P
) {
  printf("[mini.Parser] Contents ........................\n");
  printf("%s\n", P->src.ptr);
  printf(".. Tokens ....................\n");
  for (mini_size id = 0; id < P->buf.len; ++id) {  // clang-format off
    mini_Token const tk = P->buf.ptr[id];
    slate_source_Code code = slate_source_location_from(&tk.loc, P->src.ptr);
    printf("%02zu : Token.Id.%s : `%s`\t\t Depth(col:%zu, ind:%zu, id:%zu)\n",
      id, mini_token_toString(tk.id), code, tk.depth.column, tk.depth.indentation, tk.depth.scope);
    free((void*)code);
  }  // clang-format on
  printf(".. Nodes .....................\n");
  for (mini_size id = 0; id < P->ast.nodes.len; ++id) {  // clang-format off
    printf(".: TODO :.\n");
    // printf("%02zu : Token.Id.%s : `%s`\n",
    //   id, mini_token_toString(T->res.ptr[id].id), mini_source_location_from(&T->res.ptr[id].loc, T->src.ptr));
  }  // clang-format on
  printf("..................................................\n");
}


void mini_parser_process (
  mini_Parser* const P
) {
  mini_parser_scope(P);
  mini_parser_syntax(P);
}

