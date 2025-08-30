const confy = @import("confy");
pub fn main() !void {
  var mini = try confy.Program("entry.c", .{.trg="mini"});
  try mini.build();
  try mini.run();
}

