%token PROPER_SET TRUE FALSE NL FUNC_DEC FUNCTION_CALL SET_OF_DOUBLES SET_OF_LETTERS SET_OF_INTEGERS SET_OF_CHARS INTEGER_TYPE STRING_TYPE DOUBLE_TYPE CHARACTER_TYPE BOOLEAN_TYPE FOR IF ELSE WHILE ARITH_OP BOOL_OP ASSIG_OP LESS LESS_EQ MORE MORE_EQ NOT_EQ EQ NOT VOID RETURN INCREMENT DECREMENT UNION INTERSECTION SUBTRACTION SUBSET SUPERSET LEFT_B RIGHT_B CURLY_LEFT_B CURLY_RIGHT_B SQUARE_LEFT_B SQUARE_RIGHT_B INTEGER_INPUT CHAR_INPUT BOOL_INPUT DOUBLE_INPUT STRING_INPUT INTEGER_OUT CHAR_OUT BOOLEAN_OUT STRING_OUT DOUBLE_OUT VARIABLE_ID SET_ID NUMBER DOUBLE_NUMBER STRING CHAR COMMENT MULTI_COMMENT SEMI_COL DOUBLE_NUMBER SET

%%
start : program {printf("ok\n");}
      
program : COMMENT NL program
        | COMMENT NL
        | func_def NL program
        | func_def NL
        ;
func_def : function_dec
         | declaration_g
         | void_dec
         ;
function_dec : FUNC_DEC CURLY_LEFT_B stmts CURLY_RIGHT_B
             | FUNC_DEC CURLY_LEFT_B stmts RETURN term SEMI_COL CURLY_RIGHT_B
             | FUNC_DEC CURLY_LEFT_B stmts RETURN term SEMI_COL stmts CURLY_RIGHT_B
             | FUNC_DEC CURLY_LEFT_B RETURN term SEMI_COL CURLY_RIGHT_B
             ;
void_dec : VOID func_id LEFT_B declaration_f RIGHT_B CURLY_LEFT_B stmts CURLY_RIGHT_B
         ;
stmts : stmt
      | stmt stmts
      ;
stmt : FUNCTION_CALL SEMI_COL
     | expr SEMI_COL
     | set_expr SEMI_COL
     | if_stmt
     | for_loop
     | while_loop
     | COMMENT NL
     | MULTI_COMMENT NL
     | input SEMI_COL
     | output SEMI_COL
     | declaration_g
     ;
expr : VARIABLE_ID ASSIG_OP term
     | VARIABLE_ID ASSIG_OP term ARITH_OP term
     | VARIABLE_ID INCREMENT
     | VARIABLE_ID DECREMENT
     | INCREMENT VARIABLE_ID
     | DECREMENT VARIABLE_ID
     ;
input : BOOL_INPUT VARIABLE_ID
      | STRING_INPUT VARIABLE_ID
      | INTEGER_INPUT VARIABLE_ID
      | CHAR_INPUT VARIABLE_ID
      | DOUBLE_INPUT VARIABLE_ID
      ;
output : BOOLEAN_OUT VARIABLE_ID
       | STRING_OUT VARIABLE_ID
       | DOUBLE_OUT VARIABLE_ID
       | CHAR_OUT VARIABLE_ID
       | INTEGER_OUT VARIABLE_ID
       ;
set_expr : set_dec
         | set_dec ASSIG_OP set_op
         | set_dec ASSIG_OP set
         ;
set_dec : type SET_ID
        ;
term : VARIABLE_ID 
     | NUMBER
     | DOUBLE_NUMBER
     | FUNCTION_CALL
     | STRING
     | CHAR
     | set
     ;
if_stmt : matched
        | unmatched
        ;
matched : IF LEFT_B bool_expr RIGHT_B matched ELSE matched
        | CURLY_LEFT_B stmts CURLY_RIGHT_B
        ;
unmatched : IF LEFT_B bool_expr RIGHT_B matched CURLY_LEFT_B stmts CURLY_RIGHT_B
          | IF LEFT_B bool_expr RIGHT_B matched ELSE unmatched
          ;
logic_expr : term cond term 
           | term
           | set_rel
           ;
bool_expr : logic_expr BOOL_OP bool_expr
          | logic_expr
          ;
cond : LESS
     | MORE
     | EQ
     | LESS_EQ
     | MORE_EQ
     | NOT
     ;
for_loop : FOR LEFT_B declaration_g bool_expr SEMI_COL expr RIGHT_B CURLY_LEFT_B stmts CURLY_RIGHT_B
         ;
while_loop : WHILE LEFT_B bool_expr RIGHT_B CURLY_LEFT_B stmts CURLY_RIGHT_B
           ;
set : SET_OF_INTEGERS
    | SET_OF_LETTERS
    | SET_OF_DOUBLES
    | SET_OF_CHARS
    ;
set_op : set op set_op
       | set op set
       | SET_ID op SET_ID 
       ;
op : UNION
   | INTERSECTION
   | SUBTRACTION
   ;
set_rel : set rel set_rel
        | set rel set
        | SET_ID rel set_rel
        | SET_ID rel SET_ID
        ;
rel : SUBSET
    | SUPERSET
    | PROPER_SET
    ;
type : INTEGER_TYPE
     | STRING_TYPE
     | DOUBLE_TYPE
     | CHARACTER_TYPE
     | BOOLEAN_TYPE
     ;
func_id : VARIABLE_ID
        ;
declaration_f : type VARIABLE_ID ',' declaration_f
              | type VARIABLE_ID
              | empty
              ;
declaration_g : type declaration_recursive 
              ;
declaration_recursive : VARIABLE_ID ',' declaration_recursive
                      | VARIABLE_ID SEMI_COL
                      | expr ',' declaration_recursive
                      | expr SEMI_COL
                      ;
empty :  
      | NL
      ;
%%
#include "lex.yy.c"
yyerror(char *s){
  fprintf(stderr, "%s Error at line: %d\n", s, lineno);
}

main(){
  return yyparse();
}
