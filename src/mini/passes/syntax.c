//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "../list.h"
#include "../tokenizer.h"
#include "../parser/errors.h"
#include "../passes.h"


static void mini_parser_add (
  mini_Parser* const     P,
  mini_Node const* const node
) {
  mini_list_grow((mini_List*)&P->ast.nodes, 1, sizeof(*P->ast.nodes.ptr));
  P->ast.nodes.ptr[P->ast.nodes.len - 1] = *node;
}

static void mini_parser_syntax_statement_list_add (
  mini_statement_List* const  list,
  mini_Statement const* const statement
) {
  mini_list_grow((mini_List*)list, 1, sizeof(*list->ptr));
  list->ptr[list->len - 1] = *statement;
}


//______________________________________
// @section Parse Syntax: Expressions
//____________________________

static mini_Expression mini_parser_syntax_expression_literal (
  mini_Parser* const P
) {
  mini_parser_expect_any(P, 1, (mini_token_Id[]){ mini_token_b_number });
  mini_Expression result = (mini_Expression) /* clang-format off */ {
    .kind    = mini_expression_literal,
    .data    = (mini_expression_Data){.literal= (mini_Literal){.number= (mini_literal_Number){
      .value = P->buf.ptr[P->pos].loc,
    }}}
  };  // clang-format on
  P->pos += 1;
  if (P->buf.ptr[P->pos].id == mini_token_wht_space) P->pos += 1;
  if (P->buf.ptr[P->pos].id == mini_token_sp_semicolon) P->pos += 1;
  if (P->buf.ptr[P->pos].id == mini_token_wht_space) P->pos += 1;
  if (P->buf.ptr[P->pos].id == mini_token_wht_newline) P->pos += 1;
  return result;
}

static mini_Expression mini_parser_syntax_expression (
  mini_Parser* const P
) {
  mini_parser_expect_any(P, 1, (mini_token_Id[]){ mini_token_b_number, mini_token_b_identifier });
  mini_Token const tk = P->buf.ptr[P->pos];
  switch (tk.id) {
    case mini_token_b_number : return mini_parser_syntax_expression_literal(P); break;
    // case mini_token_b_identifier : mini_parser_syntax_expression_identifier(P); break;
    default                  : mini_parser_error(P, "Unknown First Token for Expression: %02zu:%s", P->pos, mini_token_toString(tk.id)); break;
  }
}


//______________________________________
// @section Parse Syntax: statement
//____________________________

static mini_Var mini_parser_syntax_statement_var (
  mini_Parser* const P
) {
  mini_parser_expect(P, mini_token_kw_var);
  P->pos += 1;
  // Create the result
  mini_Var result = (mini_Var){ 0 };
  // Continue parsing the var
  mini_parser_expect(P, mini_token_wht_space);
  P->pos += 1;
  // Assign Name
  mini_parser_expect(P, mini_token_b_identifier);
  result.name = P->buf.ptr[P->pos].loc;
  P->pos += 1;
  if (P->buf.ptr[P->pos].id == mini_token_wht_space) P->pos += 1;
  // Assign Visibility
  if (P->buf.ptr[P->pos].id == mini_token_sp_star) {
    result.visibility = mini_public;
    P->pos += 1;
  }
  if (P->buf.ptr[P->pos].id == mini_token_wht_space) P->pos += 1;
  // Type
  mini_parser_expect(P, mini_token_sp_colon);
  P->pos += 1;
  if (P->buf.ptr[P->pos].id == mini_token_wht_space) P->pos += 1;
  mini_parser_expect(P, mini_token_b_identifier);
  result.type = P->buf.ptr[P->pos].loc;
  P->pos += 1;
  if (P->buf.ptr[P->pos].id == mini_token_wht_space) P->pos += 1;
  // Value
  mini_parser_expect(P, mini_token_sp_equal);
  P->pos += 1;
  mini_parser_expect(P, mini_token_wht_space);
  P->pos += 1;
  result.value = mini_parser_syntax_expression(P);
  return result;
}

static mini_Return mini_parser_syntax_statement_return (
  mini_Parser* const P
) {
  mini_parser_expect(P, mini_token_kw_return);
  P->pos += 1;
  mini_parser_expect(P, mini_token_wht_space);
  P->pos += 1;
  mini_Return result = (mini_Return){ 0 };
  result.value       = mini_parser_syntax_expression(P);
  return result;
}

static mini_statement_List mini_parser_syntax_statement_list (
  mini_Parser* const P
) {
  mini_parser_expect_any(P, 2, (mini_token_Id[]){ mini_token_wht_space, mini_token_wht_newline });
  P->pos += 1;
  mini_statement_List result        = (mini_statement_List){ 0 };
  mini_token_Scope    depth_current = P->buf.ptr[P->pos].depth;
  while (P->pos < P->buf.len) {  // FIX: Stop when we exit the scope
    if (P->buf.ptr[P->pos].id == mini_token_wht_newline) {
      P->pos += 1;               // Skip empty lines
      continue;
    }
    // Stop if we changed scope
    if (P->buf.ptr[P->pos].depth.scope != depth_current.scope) break;
    depth_current = P->buf.ptr[P->pos].depth;
    // Skip whitespace at the start of the next line
    if (P->buf.ptr[P->pos].id == mini_token_wht_space) P->pos += 1;
    // Start parsing
    mini_parser_expect_any(P, 2, (mini_token_Id[]){ mini_token_kw_var, mini_token_kw_return });
    mini_Statement   statement = (mini_Statement){ 0 };
    mini_Token const tk        = P->buf.ptr[P->pos];
    switch (tk.id) {
      case mini_token_kw_var : {
        statement.kind = mini_statement_var;
        statement.data = (mini_statement_Data){ .var = mini_parser_syntax_statement_var(P) };
        break;
      }
      case mini_token_kw_return : {
        statement.kind = mini_statement_return;
        statement.data = (mini_statement_Data){ .Return = mini_parser_syntax_statement_return(P) };
        break;
      }
      default : mini_parser_error(P, "Unknown First Token for Statement: %02zu:%s", P->pos, mini_token_toString(tk.id)); break;
    }
    mini_parser_syntax_statement_list_add(&result, &statement);
  }
  return result;
}


//______________________________________
// @section Parse Syntax: var
//____________________________

static void mini_parser_syntax_var (
  mini_Parser* const P
) {
  mini_parser_expect(P, mini_token_kw_var);
  mini_Node result = (mini_Node){
    .kind = mini_node_var,
    .data = mini_parser_syntax_statement_var(P),
  };
  // Add Node to the AST
  mini_parser_add(P, &result);
  P->pos -= 1;
}


//______________________________________
// @section Parse Syntax: proc
//____________________________

static void mini_parser_syntax_proc (
  mini_Parser* const P
) {
  mini_parser_expect(P, mini_token_kw_proc);
  P->pos += 1;
  // Create the result
  mini_Node result = (mini_Node){
    .kind = mini_node_proc,
    .data = (mini_node_Data){ .proc = (mini_Proc){ 0 } },
  };
  // Continue parsing the proc
  mini_parser_expect(P, mini_token_wht_space);
  P->pos += 1;
  // Assign Name
  mini_parser_expect(P, mini_token_b_identifier);
  result.data.proc.name = P->buf.ptr[P->pos].loc;
  P->pos += 1;
  mini_parser_expect(P, mini_token_wht_space);
  P->pos += 1;
  // Assign Visibility
  if (P->buf.ptr[P->pos].id == mini_token_sp_star) {
    result.data.proc.visibility = mini_public;
    P->pos += 1;
  }
  // Proc Arguments
  mini_parser_expect(P, mini_token_parenthesis_left);
  P->pos += 1;
  // FIX: Parse the Arguments
  mini_parser_expect(P, mini_token_parenthesis_right);
  P->pos += 1;
  mini_parser_expect(P, mini_token_wht_space);
  P->pos += 1;
  // Return Type
  mini_parser_expect(P, mini_token_sp_colon);
  P->pos += 1;
  mini_parser_expect(P, mini_token_b_identifier);
  result.data.proc.return_type = P->buf.ptr[P->pos].loc;
  P->pos += 1;
  mini_parser_expect(P, mini_token_sp_equal);
  P->pos += 1;
  // Proc Body
  result.data.proc.body = mini_parser_syntax_statement_list(P);
  // Add Node to the AST
  mini_parser_add(P, &result);
  P->pos -= 1;
}


//______________________________________
// @section Parser.syntax: Entry Point
//____________________________

void mini_parser_syntax (
  mini_Parser* const P
) {
  while (P->pos < P->buf.len) {
    mini_Token const tk = P->buf.ptr[P->pos];
    switch (tk.id) {
      case mini_token_kw_proc     : mini_parser_syntax_proc(P); break;
      case mini_token_kw_var      : mini_parser_syntax_var(P); break;
      case mini_token_wht_space   :         /* fall-through */
      case mini_token_wht_newline : break;  // FIX: mini_parser_syntax_whitespace(P);
      default                     : mini_parser_error(P, "Unknown TopLevel Token: %02zu:%s", P->pos, mini_token_toString(tk.id)); break;
    }
    P->pos += 1;
  }
  P->pos = 0;
}

