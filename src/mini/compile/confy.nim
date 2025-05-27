#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
##! @fileoverview
##!  Wrapper for confy to expose the compile tools we need all in one spot
#__________________________________________________________________________|
import confy/target       ; export target
import confy/types/base   ; export base.PathLike
import confy/types/build  ; export build.BuildTarget
import confy/types/config ; export config.Config
import confy/systm        ; export systm.binary
