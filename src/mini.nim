#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
import slate
import ./tok
type Tok = tok.Tok

#_______________________________________
# @section Entry Point
#_____________________________
proc run=
  echo "Hello mini.nim"
  let src = "proc main *() :int= return 42\n"
  var L = slate.Lex.create(src)
  defer: L.destroy()
  L.process()

  var P = mini.Tok.create(L)
  defer: P.destroy()
  P.process()
  echo P.res

#___________________
when isMainModule: run()

