//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_codegen
#define H_mini_codegen
#include "./types.h"


mini_Module mini_codegen (mini_Parser const* const P);


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_codegen
#endif  // mini_Implementation
#ifdef mini_Implementation_codegen
#include "./codegen/codegen.c"
#endif  // mini_Implementation_codegen


#endif  // H_mini_codegen

