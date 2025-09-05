//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "../list.h"
#include "../cli.h"


void mini_cli_validate (
  mini_CLI const* const cli
) {
  if (cli->command != mini_cli_codegen) /* clang-format off */ { mini_error(mini_cli_InvalidArguments,
    "Only the Codegen command has been implemented.\n"
    "  Use the `cc` command instead:\n"
    "  mini cc input.nim output_dir"
  );} /* clang-format on */
  if (cli->args.len == 0) mini_error(mini_cli_InvalidArguments, "First compile argument, after the command, must be the input file.");
  if (cli->args.len == 1) mini_error(mini_cli_InvalidArguments, "Second compile argument, after the command, must be the target output folder.");
}


void mini_cli_args_add (
  mini_cli_Args* const list,
  mini_cstring const   arg
) {
  mini_list_grow((mini_List*)list, 1, sizeof(mini_cstring));
  list->ptr[list->len - 1] = arg;
}


mini_cli_Command mini_cli_command_fromArg (
  mini_cstring const arg
) {
  if (mini_cstring_equal(arg, "cc")) return mini_cli_codegen;
  else if (mini_cstring_equal(arg, "c")) return mini_cli_compile;
  else return mini_cli_UnknownCommand;
}


mini_CLI mini_cli_create (
  int const                argc,
  char const* const* const argv
) {
  mini_CLI result = (mini_CLI){
    .raw = { .ptr = argv, .len = (mini_size)argc }
  };
  // Parse all args
  for (mini_size id = 0; id < result.raw.len; ++id) {
    if (id == 0) continue;  // Skip appName
    mini_cstring const current = result.raw.ptr[id];
    // TODO:  opts.long  opts.short
    if (current[0] == '-') mini_error(mini_cli_InvalidArguments, "Parsing CLI arguments with starting with `-` is not implemented yet. Found:  `%s`", current);
    if (id == 1) {
      result.command = mini_cli_command_fromArg(current);
      continue;
    }
    mini_cli_args_add(&result.args, current);
  }
  return result;
}


mini_cstring mini_cli_targetFile (
  mini_cstring const dir,
  mini_cstring const file
) {
  mini_cstring name   = mini_path_to_C(file);
  mini_cstring result = mini_path_join(dir, name);
  printf("join    %s\n", result);
  free((void*)name);
  return result;
}

