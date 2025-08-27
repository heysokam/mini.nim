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
  Dependency.new("mini",     "https://github.com/heysokam/mini.nim", "src"),
  Dependency.new("minitest", "https://github.com/heysokam/minitest", "src"),
]


#_______________________________________
# @section Build the Compiler
#_____________________________
# Program.new("mini.nim", deps= mini_deps).build.run
let wip = Program.new("scope.nim", deps= mini_deps)


#_______________________________________
# @section Run all Unit Tests
#_____________________________
proc tests=
  let srcDir = confy.cfg.dirs.src
  confy.cfg.dirs.src = "tests"
  for file in "./tests".walkDirRec(relative=true).toSeq.reversed:
    if not file.splitFile.name.startsWith("t"): continue
    var target = UnitTest.new(file)
    target.deps = tests_deps
    target.args.add @["--path:./src", "--warning:UnusedImport:off"]
    target.build.run
  confy.cfg.dirs.src = srcDir

when isMainModule:
  # wip.build.run
  build.tests()

