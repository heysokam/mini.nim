//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_codegen
#define H_mini_codegen
#include "./types.h"


#define mini_codegen_error(C, fmt, ...)                                                                   \
  do {                                                                                                    \
    mini_module_report(&C->res);                                                                          \
    printf("[mini.Codegen] %s %s %d " fmt "\n", __func__, __FILE__, __LINE__ __VA_OPT__(, ) __VA_ARGS__); \
    exit(-1);                                                                                             \
  } while (0);

mini_Codegen mini_codegen_create (mini_Parser const* const P);
void         mini_codegen_destroy (mini_Codegen* const C);
void         mini_codegen_process (mini_Codegen* const P);
void         mini_module_report (mini_Module const* const code);


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_codegen
#endif  // mini_Implementation
#ifdef mini_Implementation_codegen
#include "./codegen/core.c"
#endif  // mini_Implementation_codegen


#endif  // H_mini_codegen

