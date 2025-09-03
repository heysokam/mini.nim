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

char const Hello42_nim[] = {
#embed "./01_hello42.nim"
};

char const Hello42_c[] = {
#embed "./01_hello42.c"
};


char const Hello42_h[] = {
#embed "./01_hello42.h"
};

//______________________________________
// @section HelloVar
//____________________________

char const HelloVar_nim[] = {
#embed "./02_helloVar.nim"
};

char const HelloVar_c[] = {
#embed "./02_helloVar.c"
};


char const HelloVar_h[] = {
#embed "./02_helloVar.h"
};

//______________________________________
// @section HelloVarStatement
//____________________________

char const HelloVarStatement_nim[] = {
#embed "./03_helloVarStatement.nim"
};

char const HelloVarStatement_c[] = {
#embed "./03_helloVarStatement.c"
};


char const HelloVarStatement_h[] = {
#embed "./03_helloVarStatement.h"
};

//______________________________________
// @section HelloIndentation
//____________________________

char const HelloIndentation_nim[] = {
#embed "./04_helloIndentation.nim"
};

char const HelloIndentation_c[] = {
#embed "./04_helloIndentation.c"
};


char const HelloIndentation_h[] = {
#embed "./04_helloIndentation.h"
};

#pragma GCC diagnostic pop
#endif  // H_tests_cases_includes

