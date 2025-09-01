//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "./base.h"
// clang-format off


it("must parse the Hello42 case without errors", t01, {
  mini_test_parser_create(Hello42_nim);
  mini_test_parser_destroy();
  check(true, "Parsed Correctly");
})


it("must parse the HelloVar case without errors", t02, {
  mini_test_parser_create(HelloVar_nim);
  mini_test_parser_destroy();
  check(true, "Parsed Correctly");
})


it("must parse the HelloVarStatement case without errors", t03, {
  mini_test_parser_create(HelloVarStatement_nim);
  mini_test_parser_destroy();
  check(true, "Parsed Correctly");
})


it("must parse the HelloIndentation case without errors", t04, {
  mini_test_parser_create(HelloIndentation_nim);
  mini_test_parser_destroy();
  check(true, "Parsed Correctly");
})


describe("mini.nim | Parser Cases", { return !(
  t01() &&
  t02() &&
  t03() &&
  t04()
);})

