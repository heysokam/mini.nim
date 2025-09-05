//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_tests_cases_includes
#define H_tests_cases_includes
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpre-c23-compat"
#pragma GCC diagnostic ignored "-Wc23-extensions"


//______________________________________
// @section Hello42
//____________________________


// clang-format off
char const Hello42_nim[] = {
#embed "./01_hello42.nim" suffix(,)
0};
char const Hello42_c[] = {
#embed "./01_hello42.c" suffix(,)
0};
char const Hello42_h[] = {
#embed "./01_hello42.h" suffix(,)
0};
// clang-format on


//______________________________________
// @section HelloVar
//____________________________

// clang-format off
char const HelloVar_nim[] = {
#embed "./02_helloVar.nim" suffix(,)
0};
char const HelloVar_c[] = {
#embed "./02_helloVar.c" suffix(,)
0};
char const HelloVar_h[] = {
#embed "./02_helloVar.h" suffix(,)
0};
// clang-format on


//______________________________________
// @section HelloVarStatement
//____________________________

// clang-format off
char const HelloVarStatement_nim[] = {
#embed "./03_helloVarStatement.nim" suffix(,)
0};
char const HelloVarStatement_c[] = {
#embed "./03_helloVarStatement.c" suffix(,)
0};
char const HelloVarStatement_h[] = {
#embed "./03_helloVarStatement.h" suffix(,)
0};
// clang-format on


//______________________________________
// @section HelloIndentation
//____________________________

// clang-format off
char const HelloIndentation_nim[] = {
#embed "./04_helloIndentation.nim" suffix(,)
0};
char const HelloIndentation_c[] = {
#embed "./04_helloIndentation.c" suffix(,)
0};
char const HelloIndentation_h[] = {
#embed "./04_helloIndentation.h" suffix(,)
0};
// clang-format on


//______________________________________
// @section ExprIdentifier
//____________________________

// clang-format off
char const ExprIdentifier_nim[] = {
#embed "./05_exprIdentifier.nim" suffix(,)
0};
char const ExprIdentifier_c[] = {
#embed "./05_exprIdentifier.c" suffix(,)
0};
char const ExprIdentifier_h[] = {
#embed "./05_exprIdentifier.h" suffix(,)
0};
// clang-format on


#pragma GCC diagnostic pop
#endif  // H_tests_cases_includes

