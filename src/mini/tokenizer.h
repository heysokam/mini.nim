//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_tokenizer
#define H_mini_tokenizer


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

