//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#ifndef H_mini_types
#define H_mini_types
#include <slate.h>
#include <stdbool.h>


//______________________________________
// @section Base Types
//____________________________

typedef bool mini_bool;
enum { mini_false, mini_true };
typedef void*                 mini_pointer;
typedef slate_size            mini_size;
typedef slate_cstring         mini_cstring;
typedef slate_source_Location mini_source_Location;
typedef struct mini_List {
  mini_pointer ptr;
  mini_size    len;
  mini_size    cap;
} mini_List;


//______________________________________
// @section Lexer Types
//____________________________

typedef slate_Lexeme      mini_Lexeme;
typedef slate_lexeme_List mini_lexeme_List;
typedef slate_Lexer       mini_Lexer;


//______________________________________
// @section Token Types
//____________________________

typedef enum mini_token_Id {
  // (@note: must respect array indexing)
  // Keywords
  mini_token_kw_proc,
  mini_token_kw_var,
  mini_token_kw_return,
  mini_Keywords_len,  // Max length of the Keywords array
  // Delimiters
  mini_token_parenthesis_left,   // (
  mini_token_parenthesis_right,  // )
  mini_token_bracket_left,       // [
  mini_token_bracket_right,      // ]
  mini_token_brace_left,         // {
  mini_token_brace_right,        // }
  // Specials
  mini_token_sp_star,       // *
  mini_token_sp_colon,      // :
  mini_token_sp_semicolon,  // ;
  mini_token_sp_comma,      // ,
  mini_token_sp_dot,        // .
  mini_token_sp_equal,      // =
  // Operators
  // Whitespace
  mini_token_wht_space,    // ` ` \t
  mini_token_wht_newline,  // \r \n
  // Base
  mini_token_b_identifier,
  mini_token_b_number,
  // clang-format off
  mini_token_Id_Force32 = 0x7FFFFFFF,
  // clang-format on
} mini_token_Id;

typedef slate_Depth mini_token_Scope;
#define mini_depth_empty() (mini_token_Scope){.scope= slate_depth_scope_None }

typedef struct mini_Token {
  mini_token_Id        id;
  mini_source_Location loc;
  mini_token_Scope     depth;
} mini_Token;

typedef struct mini_token_List {
  mini_Token* ptr;
  mini_size   len;
  mini_size   cap;
} mini_token_List;


//______________________________________
// @section Tokenizer Types
//____________________________

typedef mini_size mini_tokenizer_Pos;

typedef struct mini_Tokenizer {
  struct {
    mini_size    len;
    mini_cstring ptr;
  } src;
  mini_lexeme_List   buf;
  mini_tokenizer_Pos pos;
  mini_token_List    res;
} mini_Tokenizer;


//______________________________________
// @section Parser Types
//____________________________

typedef mini_size mini_parser_Pos;

typedef char mini_Node; // FIX: TODO

typedef struct mini_node_List {
  mini_Node* ptr;
  mini_size  len;
  mini_size  cap;
} mini_node_List;

typedef struct mini_Ast {
  mini_node_List nodes;
} mini_Ast;

typedef struct mini_Parser {
  struct {
    mini_size    len;
    mini_cstring ptr;
  } src;
  mini_token_List buf;
  mini_parser_Pos pos;
  mini_Ast        ast;
} mini_Parser;


#endif  // H_mini_types

