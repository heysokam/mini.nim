//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_tokenizer
#define H_mini_tokenizer
#include <slate/depth.h>
#include "./lexer.h"
#include "./rules.h"



#define mini_tokenizer_error(T, fmt, ...)                                                                   \
  do {                                                                                                      \
    mini_tokenizer_report(T);                                                                               \
    printf("[mini.Tokenizer] %s %s %d " fmt "\n", __func__, __FILE__, __LINE__ __VA_OPT__(, ) __VA_ARGS__); \
    exit(-1);                                                                                               \
  } while (0);


mini_cstring mini_token_toString (mini_token_Id const id);

void mini_token_list_grow (mini_token_List* const list, mini_size const len);

mini_Tokenizer mini_tokenizer_create (mini_Lexer const* const L);
void           mini_tokenizer_destroy (mini_Tokenizer* const T);
void           mini_tokenizer_add (mini_Tokenizer* const T, mini_token_Id const id, mini_source_Location const loc);
void           mini_tokenizer_report (mini_Tokenizer const* const T);
void           mini_tokenizer_process (mini_Tokenizer* const T);

mini_bool mini_tokenizer_isKeyword (mini_Tokenizer const* const T, mini_Lexeme const* const lx);


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_tokenizer
#endif  // mini_Implementation
#ifdef mini_Implementation_tokenizer
#include "./tokenizer.c"
#endif  // mini_Implementation_tokenizer


#endif  // H_mini_tokenizer

