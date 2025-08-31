//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_parser_errors
#define H_mini_parser_errors
#include "./report.h"


#define mini_parser_error(P, fmt, ...)                                                                   \
  do {                                                                                                   \
    mini_parser_report(P);                                                                               \
    printf("[mini.Parser] %s %s %d " fmt "\n", __func__, __FILE__, __LINE__ __VA_OPT__(, ) __VA_ARGS__); \
    exit(-1);                                                                                            \
  } while (0);


#endif  // H_mini_parser_errors

