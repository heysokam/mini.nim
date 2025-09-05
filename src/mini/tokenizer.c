//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "./source.h"
#include "./list.h"
#include "./tokenizer.h"


mini_Tokenizer mini_tokenizer_create (
  mini_Lexer const* const L
) {
  mini_Tokenizer result = (mini_Tokenizer){
    .pos = 0,
    .src = { .ptr = L->src.ptr, .len = L->src.len },
    .buf = { .ptr = NULL, .len = L->res.len, .cap = L->res.cap },
  };
  mini_size size = result.buf.cap * sizeof(*L->res.ptr);
  result.buf.ptr = malloc(size);
  result.buf.ptr = memcpy(result.buf.ptr, L->res.ptr, size);
  return result;
}


void mini_tokenizer_destroy (
  mini_Tokenizer* const T
) {
  T->pos     = 0;
  T->src.len = 0;
  T->src.ptr = NULL;
  T->res.len = 0;
  T->res.cap = 0;
  if (T->res.ptr) free(T->res.ptr);
  T->res.ptr = NULL;
  T->buf.len = 0;
  T->buf.cap = 0;
  if (T->buf.ptr) free(T->buf.ptr);
  T->buf.ptr = NULL;
}


void mini_tokenizer_add (
  mini_Tokenizer* const      T,
  mini_token_Id const        id,
  mini_source_Location const loc
) {
  mini_list_grow((mini_List*)&T->res, 1, sizeof(*T->res.ptr));
  T->res.ptr[T->res.len - 1] = (mini_Token){ .id = id, .loc = loc, .depth = mini_depth_empty() };
}


mini_bool mini_tokenizer_isKeyword (
  mini_Tokenizer const* const T,
  mini_Lexeme const* const    lx
) {
  for (mini_size id = 0; id < mini_Keywords_len; ++id) {
    if (mini_source_location_equal(&lx->loc, T->src.ptr, mini_Keywords_ptr[id])) return mini_true;
  }
  return mini_false;
}


mini_size mini_token_len (
  mini_Token const* const tk
) {
  return tk->loc.end - tk->loc.start + 1;
}


mini_cstring mini_token_toString (
  mini_token_Id const id
) {
  switch (id) {
    // Keywords
    case mini_token_kw_proc           : return "kw_proc";
    case mini_token_kw_var            : return "kw_var";
    case mini_token_kw_return         : return "kw_return";
    // Delimiters
    case mini_token_parenthesis_left  : return "parenthesis_left";
    case mini_token_parenthesis_right : return "parenthesis_right";
    case mini_token_bracket_left      : return "bracket_left";
    case mini_token_bracket_right     : return "bracket_right";
    case mini_token_brace_left        : return "brace_left";
    case mini_token_brace_right       : return "brace_right";
    // Specials
    case mini_token_sp_star           : return "sp_star";
    case mini_token_sp_colon          : return "sp_colon";
    case mini_token_sp_semicolon      : return "sp_semicolon";
    case mini_token_sp_comma          : return "sp_comma";
    case mini_token_sp_dot            : return "sp_dot";
    case mini_token_sp_equal          : return "sp_equal";
    // Operators
    case mini_token_op_plus           : return "op_plus";
    case mini_token_op_minus          : return "op_minus";
    case mini_token_op_star           : return "op_star";
    case mini_token_op_slash          : return "op_slash";
    case mini_token_op_dot            : return "op_dot";
    case mini_token_op_equal          : return "op_equal";
    // Base
    case mini_token_b_identifier      : return "identifier";
    case mini_token_b_number          : return "number";
    // Whitespace
    case mini_token_wht_space         : return "space";
    case mini_token_wht_newline       : return "newline";
    // Unknown Values
    case mini_Keywords_len            : /* fall-through */
    default                           : return "UnknownTokenID";
  };
}


void mini_tokenizer_report (
  mini_Tokenizer const* const T
) {
  printf("[mini.Tokenizer] Contents ........................\n");
  printf("%s\n", T->src.ptr);
  printf("..............................\n");
  for (mini_size id = 0; id < T->res.len; ++id) {  // clang-format off
    mini_cstring code = mini_source_location_from(&T->res.ptr[id].loc, T->src.ptr);
    printf("%02zu : Token.Id.%s : `%s`\n", id, mini_token_toString(T->res.ptr[id].id), code);
    free((void*)code);
  }  // clang-format on
  printf("..................................................\n");
}


//____________________________________________
// Single Lexeme Tokens: Singles
// clang-format off
static void mini_tokenizer_colon (mini_Tokenizer* const T) { mini_tokenizer_add(T, mini_token_sp_colon, T->buf.ptr[T->pos].loc); }
static void mini_tokenizer_semicolon (mini_Tokenizer* const T) { mini_tokenizer_add(T, mini_token_sp_semicolon, T->buf.ptr[T->pos].loc); }
static void mini_tokenizer_newline (mini_Tokenizer* const T) { mini_tokenizer_add(T, mini_token_wht_newline, T->buf.ptr[T->pos].loc); }
// clang-format on


//____________________________________________
// Single Lexeme Tokens: Groups

static void mini_tokenizer_identifier (
  mini_Tokenizer* const T
) {
  mini_Lexeme const lx = T->buf.ptr[T->pos];
  mini_token_Id     id = mini_token_b_identifier;
  if (mini_tokenizer_isKeyword(T, &lx)) {
    for (mini_size kw = 0; kw < mini_Keywords_len; ++kw) {
      if (mini_source_location_equal(&lx.loc, T->src.ptr, mini_Keywords_ptr[kw])) id = kw;
    }
  }
  mini_tokenizer_add(T, id, lx.loc);
}


static void mini_tokenizer_whitespace (
  mini_Tokenizer* const T
) {
  mini_source_Location loc = T->buf.ptr[T->pos].loc;
  while (T->buf.ptr[T->pos].id == slate_lexeme_whitespace) {  // Merge all whitespace into one token
    loc.end = T->buf.ptr[T->pos].loc.end;
    T->pos += 1;
  }
  mini_tokenizer_add(T, mini_token_wht_space, loc);
  T->pos -= 1;
}


static void mini_tokenizer_equal (
  mini_Tokenizer* const T
) {
  // FIX: Operator: Equal
  mini_tokenizer_add(T, mini_token_sp_equal, T->buf.ptr[T->pos].loc);
}

static void mini_tokenizer_star (
  mini_Tokenizer* const T
) {
  // FIX: Operator: Star
  mini_tokenizer_add(T, mini_token_sp_star, T->buf.ptr[T->pos].loc);
}

static void mini_tokenizer_plus (
  mini_Tokenizer* const T
) {
  mini_source_Location loc = T->buf.ptr[T->pos].loc;
  while (T->buf.ptr[T->pos].id == slate_lexeme_plus) {  // FIX: Arbitrary +{any} operators
    loc.end = T->buf.ptr[T->pos].loc.end;
    T->pos += 1;
  }
  mini_tokenizer_add(T, mini_token_op_plus, loc);
}

static void mini_tokenizer_minus (
  mini_Tokenizer* const T
) {
  // FIX: Arbitrary -{any} operators
  mini_tokenizer_add(T, mini_token_op_minus, T->buf.ptr[T->pos].loc);
}

static void mini_tokenizer_parenthesis (
  mini_Tokenizer* const T
) {
  mini_Lexeme const lx = T->buf.ptr[T->pos];
  if (lx.id == slate_lexeme_parenthesis_left) mini_tokenizer_add(T, mini_token_parenthesis_left, lx.loc);
  else if (lx.id == slate_lexeme_parenthesis_right) mini_tokenizer_add(T, mini_token_parenthesis_right, lx.loc);
  else mini_tokenizer_error(T, "Unknown Parenthesis Lexeme: %02zu:%s", T->pos, slate_lexeme_toString(lx.id));
}


static void mini_tokenizer_number (
  mini_Tokenizer* const T
) {
  mini_Lexeme const lx = T->buf.ptr[T->pos];
  mini_tokenizer_add(T, mini_token_b_number, lx.loc);
}


//______________________________________
// @section Tokenizer: Entry Point
//____________________________

void mini_tokenizer_process (
  mini_Tokenizer* const T
) {
  while (T->pos < T->buf.len) {
    mini_Lexeme lx = T->buf.ptr[T->pos];
    switch (lx.id) {
      case slate_lexeme_identifier        : mini_tokenizer_identifier(T); break;
      case slate_lexeme_number            : mini_tokenizer_number(T); break;
      case slate_lexeme_whitespace        : mini_tokenizer_whitespace(T); break;
      case slate_lexeme_newline           : mini_tokenizer_newline(T); break;
      case slate_lexeme_parenthesis_left  : /* fall-through */
      case slate_lexeme_parenthesis_right : mini_tokenizer_parenthesis(T); break;
      case slate_lexeme_colon             : mini_tokenizer_colon(T); break;
      case slate_lexeme_semicolon         : mini_tokenizer_semicolon(T); break;
      case slate_lexeme_equal             : mini_tokenizer_equal(T); break;
      // Operators
      case slate_lexeme_star              : mini_tokenizer_star(T); break;
      case slate_lexeme_plus              : mini_tokenizer_plus(T); break;
      case slate_lexeme_minus             : mini_tokenizer_minus(T); break;
      default                             : mini_tokenizer_error(T, "Unknown first Lexeme: %02zu:%s", T->pos, slate_lexeme_toString(lx.id)); break;
    }
    T->pos += 1;
  }
}

