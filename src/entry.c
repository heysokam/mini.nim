#define slate_Implementation
#include <slate/lexer.h>

slate_cstring const Hello42 = "proc main *() :int= return 42";

int main () {
  slate_Lexer L = slate_lexer_create(Hello42);
  slate_lexer_process(&L);
  slate_lexer_report(&L);

  slate_lexer_destroy(&L);
  return 42;
}

