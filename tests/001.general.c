//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "./base.h"
// clang-format off

it("must pass the Dummy test", t01, {
  check(true, "Dummy Test");
})

describe("mini.nim | General Cases", { return !(
  t01()
);})

