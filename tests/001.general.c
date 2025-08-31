//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "./base.h"
// clang-format off

it("must parse the Hello42 case without errors", t001, {
  // Setup
  mini_cstring const src = Hello42_nim;

  // Process
  mini_Lexer L = mini_lexer_create(src);
  mini_lexer_process(&L);
  // mini_lexer_report(&L);

  mini_Tokenizer T = mini_tokenizer_create(&L);
  mini_tokenizer_process(&T);
  // mini_tokenizer_report(&T);

  mini_Parser P = mini_parser_create(&T);
  mini_parser_process(&P);
  // mini_parser_report(&P);

  // Check
  check(true, "Always pass");

  // Cleanup
  mini_parser_destroy(&P);
  mini_tokenizer_destroy(&T);
  mini_lexer_destroy(&L);
})


describe("mini.nim | General Cases", {
  return t001();
})

