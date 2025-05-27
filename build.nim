#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
import std/[ os, strutils, sequtils, algorithm ]
import confy

#_______________________________________
# @section Project Setup
#_____________________________
const mini_deps = Dependencies.new(
  Dependency.new("slate", "https://github.com/heysokam/slate", "src/nim"),
  Dependency.new("nstd",  "https://github.com/heysokam/nstd"),
  Dependency.new("confy", "https://github.com/heysokam/confy"),
)
const tests_deps = mini_deps & @[
  Dependency.new("minitest", "https://github.com/heysokam/minitest", "src"),
]


#_______________________________________
# @section Build the Compiler
#_____________________________
# Program.new("mini.nim", deps= mini_deps).build.run


#_______________________________________
# @section Run all Unit Tests
#_____________________________
confy.cfg.dirs.src = "tests"
for file in "./tests".walkDirRec(relative=true).toSeq.reversed:
  if not file.splitFile.name.startsWith("t"): continue
  var target = UnitTest.new(file)
  target.deps = tests_deps
  target.args.add @["--path:./src"]
  target.build.run

