//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "./base.h"
// clang-format off

it("must generate the expected C code for the Hello42 case", t01, {
  mini_test_codegen_create(Hello42);
  mini_test_codegen_destroy();
  check(true, "Code Generated Correctly");
  check(false, "TODO");
})


/*
it("must generate the expected C code for the HelloVar", t02, {
  mini_test_codegen_create(HelloVar_nim);
  mini_test_codegen_destroy();
  check(true, "Code Generated Correctly");
})


it("must generate the expected C code for the HelloVarStatement", t03, {
  mini_test_codegen_create(HelloVarStatement_nim);
  mini_test_codegen_destroy();
  check(true, "Code Generated Correctly");
})


it("must generate the expected C code for the HelloIndentation", t04, {
  mini_test_codegen_create(HelloIndentation_nim);
  mini_test_codegen_destroy();
  check(true, "Code Generated Correctly");
})
*/

describe("mini.nim | Codegen Cases", { return !(
  // t01() &&
  // t02() &&
  // t03() &&
  // t04()
  t01()
);})

