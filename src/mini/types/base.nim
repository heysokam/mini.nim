#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps slate
from slate import nil

#_______________________________________
# @section General: Types
#_____________________________
type Sz   * = uint
type Lang *{.pure.}= enum C, Zig
type Pos  * = slate.source.Pos

