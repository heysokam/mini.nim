//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_lexer
#define H_mini_lexer


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_lexer
#endif  // mini_Implementation
#ifdef mini_Implementation_lexer
#define slate_Implementation
#endif  // mini_Implementation_lexer
//______________________________________
#include <slate/lexer.h>
#include "./types.h"


//______________________________________
// @section Lexer Aliases
//____________________________

#define mini_lexer_create  slate_lexer_create
#define mini_lexer_process slate_lexer_process
#define mini_lexer_report  slate_lexer_report
#define mini_lexer_destroy slate_lexer_destroy


#endif  // H_mini_lexer

