//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
const confy = @import("confy");


//______________________________________
// @section Dependencies
//____________________________
const slate    = confy.dependency("slate",    "https://github.com/heysokam/slate",    .{.src= "src/C"});
const minitest = confy.dependency("minitest", "https://github.com/heysokam/minitest", .{});


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
  try mini.run();
}


//______________________________________
// @section Dependencies
//____________________________
fn tests_run () !void {
  var cfg = confy.Cfg.defaults();
  cfg.dir.src = "tests";
  var target = try confy.UnitTest("001.general.c", .{
    .trg  = "t_general",
    .cfg  = cfg,
    .deps = &.{slate, minitest},
  });
  try target.build();
  try target.run();
}

