#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/strformat import `&`
# @deps ndk
import pkg/slate
# @deps mini.nim
import pkg/mini


proc check_scope *(
    code     : slate.source.Code;
    Expected : auto;
  ) :void=
  # Lexer
  var L = mini.Lexer.create(code)
  defer: L.destroy()
  L.process()
  # Tokenizer
  var T = mini.Tokenizer.create(L)
  T.process()
  # Parser
  var P = mini.Parser.create(T)
  defer: P.destroy()
  P.process()
  # Check the Scopes
  for id,entry in P.buf.pairs:
    let condition =
      entry.id               == Expected[id].id and
      entry.depth.indent.int == Expected[id].indent and
      entry.depth.scope      == Expected[id].scope
    if not condition:
      for id,entry in P.buf.pairs: debugEcho &"{id} : {entry} -> `{entry.loc.From(code)}`"
    doAssert(condition,
      &"\nentry #{id} ->\n  expected : ({Expected[id].id},{Expected[id].indent},{Expected[id].scope})\n  found    : ({entry.id},{entry.depth.indent},{entry.depth.scope})\n")

