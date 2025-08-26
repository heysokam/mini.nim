from std/strformat import `&`
import slate except fail
import ./mini
import ./mini/rules
import ./mini/errors
import ./mini/log
import ./mini/types/tokenizer as tok
import ./mini/types/parser as par
import ./mini/tokenizer
import ./mini/parser


#_______________________________________
# @section Scope Pass: Data Validation
#_____________________________
func expect *(P :mini.Parser; list :varargs[TokenID]) :void=
  if P.token.id notin list: UnexpectedTokenError.fail &"Found token `{P.token}`, but expected one of {list}"


#_______________________________________
# @section Parser: Data Validation
#_____________________________
func parse *(code :slate.source.Code) :auto=
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
  return P
  # Return the resulting AST
  # result = P.ast

##______________________________________
## Scoping Cases: TODO
##____________________________
## -> While Cases
##__________________
## while .... : some_block
##   0: `while .... :`
##   1: ` some_block`
##
##____________________________
## -> Procs Cases
##__________________
## proc .... = return
##   0: `proc .... =`
##   1: ` return\n`               <--- Statement
##__________________
## proc .... = discard 42; return
##   0: `proc .... =`
##   1: ` discard 42; return\n`   <--- Statement List
##__________________
## ```nim
## proc .... =
##   return
## ```
## 0: `proc .... =\n`
## 1: `  return\n`     <--- Statement List


const code = """
proc main () :int= return 42
"""

const Expected :auto= @[
  #[ 0]# (id: kw_proc,      indent: 0, scope: ScopeId(0)),
  #[ 1]# (id: wht_space,    indent: 0, scope: ScopeId(0)),
  #[ 2]# (id: b_ident,      indent: 0, scope: ScopeId(0)),
  #[ 3]# (id: wht_space,    indent: 0, scope: ScopeId(0)),
  #[ 4]# (id: sp_paren_L,   indent: 0, scope: ScopeId(0)),
  #[ 5]# (id: sp_paren_R,   indent: 0, scope: ScopeId(0)),
  #[ 6]# (id: wht_space,    indent: 0, scope: ScopeId(0)),
  #[ 7]# (id: sp_colon,     indent: 0, scope: ScopeId(0)),
  #[ 8]# (id: b_ident,      indent: 0, scope: ScopeId(0)),
  #[ 9]# (id: sp_equal,     indent: 0, scope: ScopeId(0)),
  #[10]# (id: wht_space,    indent: 0, scope: ScopeId(1)),
  #[11]# (id: kw_return,    indent: 0, scope: ScopeId(1)),
  #[12]# (id: wht_space,    indent: 0, scope: ScopeId(1)),
  #[13]# (id: b_number,     indent: 0, scope: ScopeId(1)),
  #[14]# (id: wht_newline,  indent: 0, scope: ScopeId(1)),
]


when isMainModule:
  var output = code.parse()

  # Log Expected for clarity
  dbg "Expected: ......................"
  for entry in Expected: dbg entry
  dbg "................................"
  # Compare Result with Expected
  for id,entry in output.buf.pairs:
    doAssert(entry.depth.scope == Expected[id].scope and entry.depth.indent.int == Expected[id].indent,
      &"\nentry #{id} ->\n  expected : ({Expected[id].indent},{Expected[id].scope})\n  found    : ({entry.depth.indent},{entry.depth.scope})\n")
  dbg "Result: ........................"
  for entry in output.buf: dbg $entry
  dbg "................................"


