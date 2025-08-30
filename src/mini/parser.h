//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_parser
#define H_mini_parser


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_parser
#endif  // mini_Implementation
#ifdef mini_Implementation_parser
#include "./parser.c"
#endif  // mini_Implementation_parser


#endif  // H_mini_parser

