//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_passes
#define H_mini_passes
#include "./types.h"


void mini_parser_scope (mini_Parser* const P);
void mini_parser_syntax (mini_Parser* const P);


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_passes
#endif  // mini_Implementation
#ifdef mini_Implementation_passes
#include "./passes/syntax.c"
#include "./passes/scope.c"
#endif  // mini_Implementation_passes


#endif  // H_mini_passes

