#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/oids import genOid, `$`
from std/os import addFileExt, `/`, getCurrentDir
# @deps ndk
import slate
from nstd/shell import md
import ./confy
# @deps mini.nim
from ../codegen/types as codegen import nil


#_______________________________________
# @section Compile: Builder Setup
#_____________________________
proc builder *(
    entry   : confy.PathLike;
    rootDir : confy.PathLike;
    srcDir  : confy.PathLike;
    binDir  : confy.PathLike;
  ) :confy.BuildTarget=
  var config = confy.Config()
  config.prefix    = "「」mini.nim |"
  config.dirs.root = rootDir
  config.dirs.src  = srcDir
  config.dirs.bin  = binDir
  config.verbose   = false
  result = Program.new(entry, cfg=config)


#_______________________________________
# @section Compile: C Entry Point
#_____________________________
proc compile *(
    module : codegen.Module;
  ) :string {.discardable.}=
  # Create the temporary file
  let id = $genOid()
  let rootDir = "."/"bin"/".cache"/"mini"/id
  let srcDir  = rootDir/"src"
  let binDir  = rootDir/"bin"
  let file    = "entry.c"
  md rootDir
  md srcDir
  md binDir
  system.writeFile(srcDir/file, module.code)
  # Build the target with confy
  let target = c.builder(file, rootDir, srcDir, binDir).build.run
  debugEcho module

