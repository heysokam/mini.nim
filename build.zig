const confy = @import("confy");
pub fn main() !void {
  var mini = try confy.Program("hello.c", .{});
  try mini.build();
  try mini.run();
}

