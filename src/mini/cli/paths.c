//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "../cli.h"


mini_cstring mini_file_read (
  mini_cstring const src
) {
  FILE* file = fopen(src, "r");
  if (!file) return NULL;
  // Get file size
  fseek(file, 0, SEEK_END);
  mini_size const size = ftell(file);
  fseek(file, 0, SEEK_SET);
  // Allocate memory and read
  char* result = malloc(size + 1);
  fread(result, 1, size, file);
  result[size] = '\0';
  // Cleanup and Return
  fclose(file);
  return result;
}


void mini_file_write (
  mini_cstring const trg,
  mini_cstring const data
) {
  FILE* file = fopen(trg, "w");
  if (!file) mini_error(mini_cli_FileAccessError, "Couldn't open the output file for writing.\n  Path:  %s", trg);
  fputs(data, file);
  fclose(file);
}


mini_cstring mini_path_join (
  mini_cstring const A,
  mini_cstring const B
) {
  mini_size const len_A  = strlen(A);
  mini_size const len_B  = strlen(B);
  mini_size const len_S  = 1;  // strlen(mini_path_Separator)
  mini_size const len    = len_A + len_B + len_S + 1;
  char*           result = (char*)malloc(len);
  for (mini_size id = 0; id < len_A; ++id) result[id] = A[id];
  for (mini_size id = 0; id < len_S; ++id) result[len_A + id] = mini_path_Separator;
  for (mini_size id = 0; id < len_B; ++id) result[len_A + len_S + id] = B[id];
  result[len] = 0;
  return result;
}


mini_cstring mini_path_to_C (
  mini_cstring const path
) {
  // NOTE:
  // This function is an absolute giant mess.
  // But I don't want to write full `path.basename` and `path.name` functions
  // just for a single `CLI.targetFile` operation.
  mini_size const path_len = strlen(path);
  mini_size       last     = 0;
  mini_size const sep_len  = 1;  // strlen(mini_path_Separator);
  for (mini_size id = 0; id < path_len; ++id) {
    if (path[id] == mini_path_Separator) last = id;
  }
  mini_size const len    = path_len - last - 5 + 2;                              // Total len minus .nim plus .c
  char*           result = (char*)malloc(len + 1);                               // len + null term
  for (mini_size id = 0; id < path_len; ++id) result[id] = path[last + 1 + id];  // Next to last + current.pos
  result[len - 2] = '.';
  result[len - 1] = 'c';
  result[len - 0] = 0;
  return result;
}

