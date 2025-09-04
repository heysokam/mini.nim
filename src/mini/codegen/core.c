//:____________________________________________________________
//  mini.nim  |  Copyright (C) Ivan Mar (sOkam!)  |  MPL-2.0  :
//:____________________________________________________________
#include "../list.h"
#include "../codegen.h"

//______________________________________
// @section Code generator: Helpers
//____________________________

static void mini_string_add (
  mini_string* const str,
  mini_cstring const value
) {
  mini_size const len = strlen(value);
  mini_list_grow((mini_List*)str, len, sizeof(*str->ptr));
  mini_size const start = str->len - len;
  memcpy((void*)&str->ptr[start], value, len);
}


void mini_module_report (
  mini_Module const* const code
) {
  printf("[mini.Module] Contents ........................\n");
  printf("%s\n", code->src.ptr);
  printf(".. .h Source Code .......................\n");
  printf("%s\n", code->h.ptr);
  printf(".. .c Source Code .......................\n");
  printf("%s\n", code->c.ptr);
  printf("..................................................\n");
}

mini_cstring mini_node_kind_toString (
  mini_node_Kind const id
) {
  switch (id) {
    case mini_node_proc : return "proc";
    case mini_node_var  : return "var";
    default             : return "UnknownNodeKind";
  };
}

mini_cstring mini_statement_kind_toString (
  mini_statement_Kind const id
) {
  switch (id) {
    case mini_statement_var    : return "proc";
    case mini_statement_return : return "return";
    case mini_statement_assign : return "assign";
    default                    : return "UnknownStatementKind";
  };
}

mini_cstring mini_expression_kind_toString (
  mini_expression_Kind const id
) {
  switch (id) {
    case mini_expression_literal    : return "literal";
    case mini_expression_identifier : return "identifier";
    default                         : return "UnknownExpressionKind";
  };
}

mini_cstring mini_literal_kind_toString (
  mini_literal_Kind const id
) {
  switch (id) {
    case mini_literal_number : return "number";
    // case mini_literal_char   : return "char";
    default                  : return "UnknownLiteralKind";
  };
}


//______________________________________
// @section Code generator: C
//____________________________

static mini_cstring const mini_codegen_c_templ_Header = "#pragma once\n";

static void mini_codegen_c_header_init (
  mini_Codegen* const C
) {
  mini_string_add(&C->res.h, mini_codegen_c_templ_Header);
}


static void mini_codegen_c_expression_literal_number (
  mini_Codegen* const          C,
  mini_Expression const* const expression
) {
  mini_string_add(&C->res.c, slate_source_location_from(&expression->data.literal.data.number.value, C->ast.src.ptr));
}

static void mini_codegen_c_expression_literal (
  mini_Codegen* const          C,
  mini_Expression const* const expression
) {
  switch (expression->data.literal.kind) {
    case mini_literal_number : mini_codegen_c_expression_literal_number(C, expression); break;
    default                  : mini_codegen_error(C, "Unknown Literal Kind: %02zu:%s", C->pos, mini_literal_kind_toString(expression->data.literal.kind)); break;
  }
}

static void mini_codegen_c_expression_identifier (
  mini_Codegen* const          C,
  mini_Expression const* const expression
) {
  (void)C;
  (void)expression;
}

static void mini_codegen_c_expression (
  mini_Codegen* const          C,
  mini_Expression const* const expression
) {
  switch (expression->kind) {
    case mini_expression_literal    : mini_codegen_c_expression_literal(C, expression); break;
    case mini_expression_identifier : mini_codegen_c_expression_identifier(C, expression); break;
    default                         : mini_codegen_error(C, "Unknown Expression Kind: %02zu:%s", C->pos, mini_expression_kind_toString(expression->kind)); break;
  }
}

static void mini_codegen_c_statement_var (
  mini_Codegen* const         C,
  mini_Statement const* const statement
) {
  mini_Var const     var  = statement->data.var;
  mini_cstring const type = slate_source_location_from(&var.type, C->ast.src.ptr);
  mini_string_add(&C->res.c, type);
  mini_string_add(&C->res.c, " ");
  if (!var.Mutable) mini_string_add(&C->res.c, "const ");
  mini_cstring name = slate_source_location_from(&var.name, C->ast.src.ptr);
  mini_string_add(&C->res.c, name);
  mini_string_add(&C->res.c, " = ");
  mini_codegen_c_expression(C, &var.value);
}

static void mini_codegen_c_statement_return (
  mini_Codegen* const         C,
  mini_Statement const* const Return
) {
  mini_string_add(&C->res.c, "return");
  if (Return->data.Return.empty) return;
  mini_string_add(&C->res.c, " ");
  mini_codegen_c_expression(C, &Return->data.Return.value);
}

static void mini_codegen_c_statement_assign (
  mini_Codegen* const         C,
  mini_Statement const* const assign
) {
  mini_string_add(&C->res.c, "TODO:assign");
}

static void mini_codegen_c_statement (
  mini_Codegen* const         C,
  mini_Statement const* const statement
) {
  switch (statement->kind) {
    case mini_statement_var    : mini_codegen_c_statement_var(C, statement); break;
    case mini_statement_return : mini_codegen_c_statement_return(C, statement); break;
    case mini_statement_assign : mini_codegen_c_statement_assign(C, statement); break;
    default                    : mini_codegen_error(C, "Unknown Statement Kind: %02zu:%s", C->pos, mini_statement_kind_toString(statement->kind)); break;
  }
  mini_string_add(&C->res.c, ";");
}

static void mini_codegen_c_proc_body (
  mini_Codegen* const C
) {
  mini_Proc const proc           = C->ast.nodes.ptr[C->pos].data.proc;
  mini_size const statements_len = proc.body.len;
  mini_bool const oneline        = statements_len == 1;
  mini_string_add(&C->res.c, "{");
  if (!oneline) mini_string_add(&C->res.c, "\n");
  for (mini_size id = 0; id < statements_len; ++id) {
    mini_string_add(&C->res.c, oneline ? " " : "  ");
    mini_codegen_c_statement(C, &proc.body.ptr[id]);
    mini_string_add(&C->res.c, oneline ? " " : "\n");
  }
  mini_string_add(&C->res.c, "}\n");
}

static void mini_codegen_c_proc (
  mini_Codegen* const C
) {
  mini_Proc const    proc    = C->ast.nodes.ptr[C->pos].data.proc;
  mini_cstring const returnT = slate_source_location_from(&proc.return_type, C->ast.src.ptr);
  mini_string_add(&C->res.c, returnT);
  mini_string_add(&C->res.c, " ");
  mini_cstring const name = slate_source_location_from(&proc.name, C->ast.src.ptr);
  mini_string_add(&C->res.c, name);
  mini_string_add(&C->res.c, " ");
  mini_string_add(&C->res.c, "()");  // TODO: Args
  mini_string_add(&C->res.c, " ");
  mini_codegen_c_proc_body(C);
}

static void mini_codegen_c_var (
  mini_Codegen* const C
) {
  mini_Var const var = C->ast.nodes.ptr[C->pos].data.var;
  if (var.visibility == mini_private) mini_string_add(&C->res.c, "static ");
  mini_cstring const type = slate_source_location_from(&var.type, C->ast.src.ptr);
  mini_string_add(&C->res.c, type);
  mini_string_add(&C->res.c, " ");
  if (!var.Mutable) mini_string_add(&C->res.c, "const ");
  mini_cstring const name = slate_source_location_from(&var.name, C->ast.src.ptr);
  mini_string_add(&C->res.c, name);
  mini_string_add(&C->res.c, " = ");
  mini_codegen_c_expression(C, &var.value);
  mini_string_add(&C->res.c, ";\n");
}

static void mini_codegen_c (
  mini_Codegen* const C
) {
  C->res = (mini_Module){ .src= {
    .ptr = C->ast.src.ptr,
    .len = C->ast.src.len,
  }};
  mini_codegen_c_header_init(C);
  while (C->pos < C->ast.nodes.len) {
    mini_Node node = C->ast.nodes.ptr[C->pos];
    switch (node.kind) {
      case mini_node_proc : mini_codegen_c_proc(C); break;
      case mini_node_var  : mini_codegen_c_var(C); break;
      default             : mini_codegen_error(C, "Unknown TopLevel Node: %02zu:%s", C->pos, mini_node_kind_toString(node.kind)); break;
    }
    C->pos += 1;
  }
  C->pos = 0;
}


//______________________________________
// @section Code generator: Core & Entry Point
//____________________________

mini_Codegen mini_codegen_create (
  mini_Parser const* const P
) {
  mini_Codegen result = (mini_Codegen){
    .pos = 0,
    .ast = P->ast,
  };
  return result;
}

void mini_codegen_destroy (
  mini_Codegen* const C
) {
  C->ast.src.len = 0;
  C->ast.src.ptr = NULL;
  C->res.c.len   = 0;
  C->res.c.cap   = 0;
  if (C->res.c.ptr) free(C->res.c.ptr);
  C->res.h.len = 0;
  C->res.h.cap = 0;
  if (C->res.h.ptr) free(C->res.h.ptr);
}

void mini_codegen_process (
  mini_Codegen* const C
) {
  if (C->ast.lang != mini_lang_C) assert(false && "Code generation is only implemented for C.");
  mini_codegen_c(C);
}

