//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_parser
#define H_mini_parser
#include "./passes.h"


mini_Parser mini_parser_create (mini_Tokenizer const* const T);
void        mini_parser_destroy (mini_Parser* const P);
void        mini_parser_process (mini_Parser* const P);


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_parser
#endif  // mini_Implementation
#ifdef mini_Implementation_parser
#include "./parser/core.c"
#include "./parser/errors.c"
#endif  // mini_Implementation_parser


#endif  // H_mini_parser

