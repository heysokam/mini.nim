//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_cli
#define H_mini_cli
#include "./types.h"


//______________________________________
// @section Path Management
//____________________________

#define mini_path_Separator '/'
mini_cstring mini_path_join (mini_cstring const A, mini_cstring const B);
mini_cstring mini_file_read (mini_cstring const src);
void         mini_file_write (mini_cstring const trg, mini_cstring const data);
mini_cstring mini_file_name (mini_cstring const src);
mini_cstring mini_path_to_C (mini_cstring const path);


//______________________________________
// @section CLI: Error Management
//____________________________
typedef enum mini_cli_Result { mini_cli_Ok, mini_cli_InvalidArguments, mini_cli_FileAccessError, mini_cli_InputError } mini_cli_Result;

#define mini_error(code, fmt, ...)                                       \
  do {                                                                   \
    printf("[mini.nim] ERROR:\n  " fmt "\n" __VA_OPT__(, ) __VA_ARGS__); \
    exit(code);                                                          \
  } while (0);

//______________________________________
// @section Compiler: Command Line Interface
//____________________________

typedef enum mini_cli_Command { mini_cli_compile, mini_cli_codegen, mini_cli_UnknownCommand } mini_cli_Command;
typedef struct mini_cli_args_Raw {
  mini_cstring const* const ptr;
  mini_size const           len;
} mini_cli_args_Raw;
typedef struct mini_cli_Args {
  mini_cstring* ptr;
  mini_size     len;
  mini_size     cap;
} mini_cli_Args;

typedef struct mini_CLI {
  mini_cli_args_Raw raw;
  mini_cli_Command  command;
  mini_cli_Args     args;
} mini_CLI;


void             mini_cli_validate (mini_CLI const* const cli);
mini_cstring     mini_cli_targetFile (mini_cstring const dir, mini_cstring const file);
void             mini_cli_args_add (mini_cli_Args* const list, mini_cstring const arg);
mini_cli_Command mini_cli_command_fromArg (mini_cstring const arg);
mini_CLI         mini_cli_create (int const argc, char const* const* const argv);


//______________________________________
// @section Single Header Support
//____________________________
#ifdef mini_Implementation
#define mini_Implementation_cli
#endif  // mini_Implementation
#ifdef mini_Implementation_cli
#include "./cli/paths.c"
#include "./cli/core.c"
#endif  // mini_Implementation_cli


#endif  // H_mini_cli

