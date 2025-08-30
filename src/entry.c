//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#define mini_Implementation
#include "./mini.h"

mini_cstring const Hello42 = "proc main *() :int= return 42";

int main () {
  mini_Lexer L = mini_lexer_create(Hello42);
  mini_lexer_process(&L);
  mini_lexer_report(&L);

  mini_Tokenizer T = mini_tokenizer_create(&L);
  mini_tokenizer_process(&T);
  mini_tokenizer_report(&T);

  mini_tokenizer_destroy(&T);
  mini_lexer_destroy(&L);
  return 42;
}

