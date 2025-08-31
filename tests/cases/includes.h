//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_tests_cases_includes
#define H_tests_cases_includes
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpre-c23-compat"
#pragma GCC diagnostic ignored "-Wc23-extensions"


char const Hello42_nim[] = {
#embed "./01_hello42.nim"
};

char const HelloVar_nim[] = {
#embed "./02_helloVar.nim"
};

char const HelloVarStatement_nim[] = {
#embed "./03_helloVarStatement.nim"
};

#pragma GCC diagnostic pop
#endif  // H_tests_cases_includes

