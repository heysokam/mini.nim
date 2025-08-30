//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_base
#define H_mini_base
#include <slate.h>
#include <stdbool.h>

typedef bool mini_bool;
enum { mini_false, mini_true };
typedef slate_size            mini_size;
typedef slate_cstring         mini_cstring;
typedef slate_source_Location mini_source_Location;
#define mini_source_location_equal slate_source_location_equal
#define mini_source_location_from slate_source_location_from

#endif  // H_mini_base

