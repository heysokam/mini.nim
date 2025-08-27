#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strformat import `&`
# @deps slate
import slate
# @deps mini.nim
import ../types/base as mini

#_______________________________________
#_____________________________
type Module * = object
  dir     *:string
  name    *:string
  lang    *:mini.Lang
  header  *:slate.source.Code
  code    *:slate.source.Code
#___________________
func add *(A :var Module; B :Module) :var Module {.discardable.}=
  doAssert A.lang == B.lang, &"Tried to add one code Module to another, but their languages are different:\n  {A}\n  {B}"
  A.header = A.header & B.header
  A.code   = A.code & B.code
  result = A

