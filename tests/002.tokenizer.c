//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "./base.h"
// clang-format off


it("must tokenize the Hello42 case without errors", t01, {
  mini_test_tokenizer_create(Hello42_nim);
  mini_test_tokenizer_destroy();
  // TODO: Check Output
  check(true, "Tokenized Correctly");
})


it("must tokenize the HelloVar case without errors", t02, {
  mini_test_tokenizer_create(HelloVar_nim);
  mini_test_tokenizer_destroy();
  // TODO: Check Output
  check(true, "Tokenized Correctly");
})


it("must tokenize the HelloVarStatement case without errors", t03, {
  mini_test_tokenizer_create(HelloVarStatement_nim);
  mini_test_tokenizer_destroy();
  // TODO: Check Output
  check(true, "Tokenized Correctly");
})


it("must tokenize the HelloIndentation case without errors", t04, {
  mini_test_tokenizer_create(HelloIndentation_nim);
  mini_test_tokenizer_destroy();
  // TODO: Check Output
  check(true, "Tokenized Correctly");
})


describe("mini.nim | Tokenizer Cases", { return !(
  t01() &&
  t02() &&
  t03() &&
  t04()
);})

