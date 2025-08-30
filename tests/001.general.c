#include "./base.h"
// clang-format off

it("must do simple thing for C", t001, {
  check(true, "Always pass");
})

it("must fail simple thing for C", t002, {
  check(false, "Always fail");
})

describe("mini.nim | General Cases", {
  t001();
  t002();
})

