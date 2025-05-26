#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
import confy
Program.new("mini.nim", deps= Dependencies.new(
  Dependency.new("slate", "https://github.com/heysokam/slate", "src/nim"),
  Dependency.new("nstd",  "https://github.com/heysokam/nstd"),
  Dependency.new("confy", "https://github.com/heysokam/confy"),
)).build.run
