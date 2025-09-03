//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_parser_errors
#define H_mini_parser_errors
#include "./report.h"


#define mini_parser_error(P, fmt, ...)                                                                   \
  do {                                                                                                   \
    mini_parser_report(P);                                                                               \
    printf("[mini.Parser] %s %s %d " fmt "\n", __func__, __FILE__, __LINE__ __VA_OPT__(, ) __VA_ARGS__); \
    exit(-1);                                                                                            \
  } while (0);


// clang-format off
#define mini_parser_expect(P, tk_id)                                      \
  if (P->buf.ptr[P->pos].id != tk_id) {                                   \
    mini_parser_report(P);                                                \
    printf("[mini.Parser] %s %s %d " "\n", __func__, __FILE__, __LINE__); \
    assert(false && "Unexpected token found when parsing.");              \
    exit(-1);                                                             \
  }  // clang-format on


void mini_parser_expect_any ( // clang-format off
  mini_Parser* const         P,
  mini_size                  list_len,
  mini_token_Id const* const list_ptr
); // clang-format on


#endif  // H_mini_parser_errors

