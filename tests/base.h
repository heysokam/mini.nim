//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include <minitest.h>
#define mini_Implementation
#include "../src/mini.h"
#include "./cases/includes.h"


//______________________________________
// @section Tests Helpers: Tokenizer
//____________________________
#define mini_test_tokenizer_create(case) /* clang-format off */ \
  mini_cstring const src = case##_nim;            \
  mini_Lexer L = mini_lexer_create(src);          \
  mini_lexer_process(&L);                         \
  mini_Tokenizer T = mini_tokenizer_create(&L); { \
  mini_tokenizer_process(&T);                     \
  }  // clang-format on

#define mini_test_tokenizer_destroy()    /* clang-format off */ do { \
  mini_tokenizer_destroy(&T);              \
  mini_lexer_destroy(&L);                  \
  } /* clang-format on */ while (0)


//______________________________________
// @section Tests Helpers: Parser
//____________________________
#define mini_test_parser_create(case)    /* clang-format off */ \
  mini_cstring const src = case##_nim;           \
  mini_Lexer L = mini_lexer_create(src);         \
  mini_lexer_process(&L);                        \
  mini_Tokenizer T = mini_tokenizer_create(&L);  \
  mini_tokenizer_process(&T);                    \
  mini_Parser P = mini_parser_create(&T);        \
  mini_parser_process(&P);                       \
  (void)0  // clang-format on

#define mini_test_parser_destroy()       /* clang-format off */ do { \
  mini_parser_destroy(&P);              \
  mini_tokenizer_destroy(&T);           \
  mini_lexer_destroy(&L);               \
  } /* clang-format on */ while (0)


//______________________________________
// @section Tests Helpers: Codegen
//____________________________
#define mini_test_codegen_create(case)   /* clang-format off */ \
  mini_cstring const src = case##_nim;           \
  mini_Lexer L = mini_lexer_create(src);         \
  mini_lexer_process(&L);                        \
  mini_Tokenizer T = mini_tokenizer_create(&L);  \
  mini_tokenizer_process(&T);                    \
  mini_Parser P = mini_parser_create(&T);        \
  mini_parser_process(&P);                       \
  mini_Codegen C = mini_codegen_create(&P);      \
  mini_codegen_process(&C);                      \
  mini_Module const result = C.res;              \
  mini_cstring const expected_c = case##_c;      \
  mini_cstring const expected_h = case##_h;      \
  (void)0  // clang-format on

#define mini_test_codegen_destroy()      /* clang-format off */ do { \
  mini_codegen_destroy(&C);             \
  mini_parser_destroy(&P);              \
  mini_tokenizer_destroy(&T);           \
  mini_lexer_destroy(&L);               \
  } /* clang-format on */ while (0)

#define mini_test_codegen_check(test_case)                                                                                   \
  mini_bool const h_equal = mini_cstring_equal(result.h.ptr, expected_h);                                                    \
  if (!h_equal) printf(".............. Expected:\n%s\n............ Result:\n%s\n.............\n", expected_h, result.h.ptr); \
  check(h_equal, ".h code for the " #test_case " case could not be generated correctly");                                    \
  mini_bool const c_equal = mini_cstring_equal(result.c.ptr, expected_c);                                                    \
  if (!c_equal) printf(".............. Expected:\n%s\n............ Result:\n%s\n.............\n", expected_c, result.c.ptr); \
  check(c_equal, ".c code for the " #test_case " case could not be generated correctly");

