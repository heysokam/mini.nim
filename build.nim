#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
import confy
let slate = Dependency.new("slate", "https://github.com/heysokam/slate", "src/nim")
Program.new("mini.nim", deps= @[slate]).build.run
