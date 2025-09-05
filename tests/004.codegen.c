//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "./base.h"
// clang-format off


it("must generate the expected C code for the Hello42 case", t01, {
  mini_test_codegen_create(Hello42);
  mini_test_codegen_check(Hello42);
  mini_test_codegen_destroy();
})


it("must generate the expected C code for the HelloVar case", t02, {
  mini_test_codegen_create(HelloVar);
  mini_test_codegen_check(HelloVar);
  mini_test_codegen_destroy();
})


it("must generate the expected C code for the HelloVarStatement case", t03, {
  mini_test_codegen_create(HelloVarStatement);
  mini_test_codegen_check(HelloVarStatement);
  mini_test_codegen_destroy();
})


it("must generate the expected C code for the HelloIndentation case", t04, {
  mini_test_codegen_create(HelloIndentation);
  mini_test_codegen_check(HelloIndentation);
  mini_test_codegen_destroy();
})


it("must generate the expected C code for the ExprIdentifier case", t05, {
  mini_test_codegen_create(ExprIdentifier);
  mini_test_codegen_check(ExprIdentifier);
  mini_test_codegen_destroy();
})


describe("mini.nim | Codegen Cases", { return !(
  t01() &&
  t02() &&
  t03() &&
  t04() &&
  t05()
);})

