//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "../tokenizer.h"
#include "../parser/errors.h"
#include "../passes.h"
#include <slate/depth.h>


//______________________________________
// @section Parser.scope: Column Position
//____________________________

static void mini_parser_scope_columnize (
  mini_Parser* const P
) {
  mini_size column = 0;
  for (mini_size id = 0; id < P->buf.len; ++id) {
    mini_Token const tk         = P->buf.ptr[id];
    P->buf.ptr[id].depth.column = column;     // Assign to this token
    column += tk.loc.end - tk.loc.start + 1;  // Add the current len to the column value
    if (tk.id == mini_token_wht_newline) column = 0;
  }
}


//______________________________________
// @section Parser.scope: Indentation Level
//____________________________

static void mini_parser_scope_indentate_untilNewline (
  mini_Parser* const      P,
  slate_depth_Level const indentation
) {
  while (P->pos < P->buf.len) {
    mini_Token const tk                  = P->buf.ptr[P->pos];
    P->buf.ptr[P->pos].depth.indentation = indentation;
    P->pos += 1;
    if (tk.id == mini_token_sp_semicolon) break;
    if (tk.id == mini_token_wht_newline) break;
  }
  P->pos -= 1;
}

static void mini_parser_scope_indentate_whitespace (
  mini_Parser* const P
) {
  while (P->pos < P->buf.len) {
    mini_Token const tk                  = P->buf.ptr[P->pos];
    P->buf.ptr[P->pos].depth.indentation = 0;
    P->pos += 1;
    if (tk.id != mini_token_wht_newline || tk.id != mini_token_wht_space) break;
  }
  P->pos -= 1;
}

static void mini_parser_scope_indentate_var (
  mini_Parser* const P
) {
  mini_parser_scope_indentate_untilNewline(P, 0);
}

static void mini_parser_scope_indentate_statementList (
  mini_Parser* const P
) {
  // We could start at \n or ` `. Skip \n
  mini_bool oneline = P->buf.ptr[P->pos].id != mini_token_wht_newline;
  if (!oneline) P->pos += 1;
  // Store the indentation of the current line
  slate_depth_Level indent_start = mini_token_len(&P->buf.ptr[P->pos]);
  slate_depth_Level indent_curr  = indent_start;
  // For every line
  while (P->pos < P->buf.len) {
    // Assume we start the line with a space
    indent_curr = mini_token_len(&P->buf.ptr[P->pos]);
    if (indent_curr < indent_start) break;
    // Indent tag every token in this line
    mini_parser_scope_indentate_untilNewline(P, indent_curr);
    // We are now in a new line
    P->pos += 1;
  }
}

static void mini_parser_scope_indentate_proc (
  mini_Parser* const P
) {
  slate_depth_Level level = P->buf.ptr[P->pos].depth.column;
  while (P->pos < P->buf.len) {
    mini_Token const tk = P->buf.ptr[P->pos];
    // Apply proc indentation to the token, and move
    P->buf.ptr[P->pos].depth.indentation = level;
    P->pos += 1;
    if (tk.id == mini_token_sp_equal) break;
  }
  mini_parser_scope_indentate_statementList(P);
  P->pos -= 1;
}

static void mini_parser_scope_indentate (
  mini_Parser* const P
) {
  while (P->pos < P->buf.len) {
    mini_Token const tk = P->buf.ptr[P->pos];
    switch (tk.id) {
      // case mini_token_wht_newline : break;
      case mini_token_kw_proc     : mini_parser_scope_indentate_proc(P); break;
      case mini_token_kw_var      : mini_parser_scope_indentate_var(P); break;
      case mini_token_wht_space   : /* fall-through */
      case mini_token_wht_newline : mini_parser_scope_indentate_whitespace(P); break;
      default                     : mini_parser_error(P, "Unknown TopLevel Token: %02zu:%s", P->pos, mini_token_toString(tk.id)); break;
    }
    P->pos += 1;
  }
  P->pos = 0;
}


//______________________________________
// @section Parser.scope: Scope Identity
//____________________________

typedef struct mini_parser_scope_Stack {
  slate_depth_Scope* ptr;
  mini_size          len;
  mini_size          cap;
  slate_depth_Scope  last_id;
} mini_parser_scope_Stack;

static void mini_parser_scope_stack_destroy (
  mini_parser_scope_Stack* const S
) {
  S->cap = 0;
  S->len = 0;
  if (S->ptr) free(S->ptr);
}

static void mini_parser_scope_stack_grow (
  mini_parser_scope_Stack* const S,
  mini_size const                len
) {
  mini_size const count = (S->len + len) - S->len;
  S->len += len;
  if (!S->cap) {
    S->cap = len;
    S->len = len;
    S->ptr = (slate_depth_Scope*)malloc(S->cap * sizeof(*S->ptr));
  } else if (S->len > S->cap) {
    S->cap *= 2;
    S->ptr = (slate_depth_Scope*)realloc(S->ptr, S->cap * sizeof(*S->ptr));
  }
  for (mini_size id = 0; id < count; ++id) S->ptr[S->len - id] = slate_depth_scope_None;
}

static void mini_parser_scope_stack_shrink (
  mini_parser_scope_Stack* const S,
  mini_size const                len
) {
  if (!S->len || !S->cap) return;
  mini_size const count = S->len - (S->len - len);
  for (mini_size id = 0; id < count; ++id) S->ptr[S->len - id] = slate_depth_scope_None;
  S->len -= len;
}

#define mini_parser_scope_stack_last(sc) sc.ptr[sc.len - 1]

static slate_depth_Scope mini_parser_scope_stack_next (
  mini_parser_scope_Stack* const S
) {
  slate_depth_Scope result = (S->last_id == slate_depth_scope_None) ? 0 : (S->last_id + 1);
  S->last_id               = result;
  return result;
}

static void mini_parser_scope_stack_add (
  mini_parser_scope_Stack* const S
) {
  mini_parser_scope_stack_grow(S, 1);
  S->ptr[S->len - 1] = mini_parser_scope_stack_next(S);
}

static slate_depth_Scope mini_parser_scope_stack_remove (
  mini_parser_scope_Stack* const S
) {
  slate_depth_Scope result = S->ptr[S->len - 1];
  mini_parser_scope_stack_shrink(S, 1);
  return result;
}

static void mini_parser_scope_identify (
  mini_Parser* const P
) {
  // Initialize the scopes list
  mini_parser_scope_Stack scopes = (mini_parser_scope_Stack){ .last_id = slate_depth_scope_None };
  mini_parser_scope_stack_add(&scopes);
  slate_depth_Level indent_last = P->buf.ptr[P->pos].depth.indentation;
  // Apply scope to all tokens
  while (P->pos < P->buf.len) {
    mini_Token const tk = P->buf.ptr[P->pos];
    if (tk.depth.indentation > indent_last) mini_parser_scope_stack_add(&scopes);
    else if (tk.depth.indentation < indent_last) mini_parser_scope_stack_remove(&scopes);
    indent_last                    = tk.depth.indentation;
    P->buf.ptr[P->pos].depth.scope = mini_parser_scope_stack_last(scopes);
    P->pos += 1;
  }
  P->pos -= 1;
  // Cleanup when done
  mini_parser_scope_stack_destroy(&scopes);
}


//______________________________________
// @section Parser.scope: Entry Point
//____________________________

void mini_parser_scope (
  mini_Parser* const P
) {
  mini_parser_scope_columnize(P);
  mini_parser_scope_indentate(P);
  mini_parser_scope_identify(P);
}

