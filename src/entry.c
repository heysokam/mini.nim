//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#define mini_Implementation
#include "./mini.h"
#include "./mini/cli.h"


static mini_Codegen mini_command_codegen (
  mini_cstring const src
) {
  mini_Lexer L = mini_lexer_create(src);
  mini_lexer_process(&L);
  mini_Tokenizer T = mini_tokenizer_create(&L);
  mini_tokenizer_process(&T);
  mini_Parser P = mini_parser_create(&T);
  mini_parser_process(&P);
  mini_Codegen C = mini_codegen_create(&P);
  mini_codegen_process(&C);
  return C;
}


// mini cc input.nim output/
int main (
  int const                argc,
  char const* const* const argv
) {
  mini_CLI const cli = mini_cli_create(argc, argv);
  mini_cli_validate(&cli);
  mini_cstring const src_file = cli.args.ptr[0];
  mini_cstring const trg_dir  = cli.args.ptr[1];
  mini_cstring const src_code = mini_file_read(src_file);
  if (!src_code) mini_error(mini_cli_InputError, "Couldn't read the contents of the input file.\n  Path:  %s", src_file);
  mini_Codegen const code = mini_command_codegen(src_code);
  for (mini_size id = 0; id < cli.args.len; ++id) printf("CLI.Arg #%zu:  %s\n", id, cli.args.ptr[id]);
  printf("Code.c  %s\n", code.res.c.ptr);
  mini_cstring const trg_file = mini_cli_targetFile(trg_dir, src_file);
  mini_file_write(trg_file, code.res.c.ptr);
  return mini_cli_Ok;
}

