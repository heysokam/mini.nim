#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
import slate/lexer/lex as slate

#_______________________________________
# @section Entry Point
#_____________________________
proc run=
  echo "Hello mini.nim"
  let src = "proc main *() :int= return 42\n"
  var L = slate.Lex.create(src)
  L.process()
  echo L.res
  L.destroy()
#___________________
when isMainModule: run()

