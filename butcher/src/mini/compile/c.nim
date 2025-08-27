#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/oids import genOid, `$`
from std/os import addFileExt, `/`, getCurrentDir
# @deps ndk
# import slate
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
  ) :confy.BuildTarget {.discardable.}=
  # Create the temporary file
  let id = $genOid()
  let rootDir = "."/"bin"/".cache"/"mini"/id
  let srcDir  = rootDir/"src"
  let binDir  = rootDir/"bin"
  let file_c  = module.name.addFileExt("c")
  let file_h  = module.name.addFileExt("h")
  md rootDir
  md srcDir
  md binDir
  system.writeFile(srcDir/file_h, module.header)
  system.writeFile(srcDir/file_c, module.code)
  # Build the target with confy
  result = c.builder(file_c, rootDir, srcDir, binDir).build

