//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "./list.h"


void mini_list_grow (
  mini_List* const list,
  mini_size const  len,
  mini_size const  itemsize
) {
  list->len += len;
  if (!list->cap) {
    list->cap = len;
    list->len = len;
    list->ptr = malloc(list->cap * itemsize);
  } else if (list->len > list->cap) {
    list->cap *= 2;
    list->ptr = realloc(list->ptr, list->cap * itemsize);
  }
}

