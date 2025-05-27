#:_______________________________________________________________________
#  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  GNU GPLv3 or later  :
#:_______________________________________________________________________
# @deps std
from std/os import splitFile
# @deps ndk
import minitest
# @deps mini.nim
import mini
import ./cases


describe "General Cases":
  it "must parse, compile and run the Hello42 case from a code string without errors":
    const Input_code = cases.Hello42
    const Input_file = cases.Hello42_nim
    const Expected_h = cases.Hello42_h.staticRead()
    const Expected_c = cases.Hello42_c.staticRead()
    # Parse
    let result_ast = mini.parse(code=Input_code)
    check result_ast.nodes.len == 1
    # Codegen
    let result_c = result_ast.generate(C, dir=cases.dir, name=Input_file.splitFile.name)
    check result_c.header == Expected_h
    check result_c.code   == Expected_c
    # Compile & Run
    cc.run(result_C, result_ast.lang)

  it "must parse, compile and run the Hello42 case from a file without errors":
    const Input      = cases.Hello42_nim
    const Expected_h = cases.Hello42_h.staticRead()
    const Expected_c = cases.Hello42_c.staticRead()
    # Parse
    let result_ast = mini.parse(file=Input)
    check result_ast.nodes.len == 1
    # Codegen
    let result_c = result_ast.generate(C, dir=cases.dir, name=Input.splitFile.name)
    check result_c.header == Expected_h
    check result_c.code   == Expected_c
    # Compile & Run
    cc.run(result_C, result_ast.lang)

  it "must parse, compile and run the HelloVar case from a file without errors":
    const Input      = cases.HelloVar_nim
    const Expected_h = cases.HelloVar_h.staticRead()
    const Expected_c = cases.HelloVar_c.staticRead()
    # Parse
    let result_ast = mini.parse(file=Input)
    check result_ast.nodes.len == 2
    # Codegen
    let result_c = result_ast.generate(C, dir=cases.dir, name=Input.splitFile.name)
    check result_c.header == Expected_h
    check result_c.code   == Expected_c
    # Compile & Run
    cc.run(result_c, result_ast.lang)

  it "must parse, compile and run the HelloVarStatement case from a file without errors":
    const Input      = cases.HelloVarStatement_nim
    const Expected_h = cases.HelloVarStatement_h.staticRead()
    const Expected_c = cases.HelloVarStatement_c.staticRead()
    # Parse
    let result_ast = mini.parse(file=Input)
    echo "_________________________________"
    echo result_ast
    check result_ast.nodes.len == 1
    # Codegen
    let result_c = result_ast.generate(C, dir=cases.dir, name=Input.splitFile.name)
    check result_c.header == Expected_h
    check result_c.code   == Expected_c
    # Compile & Run
    cc.run(result_c, result_ast.lang)

