//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_list
#define H_mini_list
#include "./types.h"


void mini_list_grow (mini_List* const list, mini_size const len, mini_size const itemsize);


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_list
#endif  // mini_Implementation
#ifdef mini_Implementation_list
#include "./list.c"
#endif  // mini_Implementation_list


#endif  // H_mini_list

