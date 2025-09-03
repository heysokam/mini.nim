//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
const confy = @import("confy");


//______________________________________
// @section Dependencies
//____________________________
const slate = confy.dependency("slate", "https://github.com/heysokam/slate", .{.src= "src/C"});


//______________________________________
// @section Builder Entry Point
//____________________________
pub fn main() !void {
  var mini = try confy.Program("entry.c", .{
    .trg  = "mini",
    .deps = &.{slate},
  });

  try tests_run();
  try mini.build();
  // try mini.run();
}


//______________________________________
// @section Unit Tests
//____________________________
// Dependencies
const minitest = confy.dependency("minitest", "https://github.com/heysokam/minitest", .{});
//__________________
// Build+Run the tests
fn tests_run () !void {
  var cfg     = confy.Cfg.defaults();
  cfg.dir.src = "tests";
  const deps  = &.{minitest, slate};
  //__________________
  var t001 = try confy.UnitTest("001.general.c", .{
    .trg= "t001", .cfg= cfg, .deps= deps,
  }); try t001.build(); try t001.run();
  //__________________
  var t002 = try confy.UnitTest("002.tokenizer.c", .{
    .trg= "t002", .cfg= cfg, .deps= deps,
  }); try t002.build(); try t002.run();
  //__________________
  var t003 = try confy.UnitTest("003.parser.c", .{
    .trg= "t003", .cfg= cfg, .deps= deps,
  }); try t003.build(); try t003.run();
  //__________________
  var t004 = try confy.UnitTest("004.codegen.c", .{
    .trg= "t004", .cfg= cfg, .deps= deps,
  }); try t004.build(); try t004.run();
}

