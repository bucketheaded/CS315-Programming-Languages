%token START END LCB RCB LP RP NL SEMICOLON COMMA CONNECTION_TYPE CONST IDENTIFIER IF ELSE INTEGER INT_TYPE DIV MINUS MULT PLUS WHILE LOOP AND OR XOR NOT_OP ASSIGN_OP
%token PRIMITIVE_SWITCHES BINARY_DIGIT FUNCTION_NAME DOT TIME CREATE_CONNECTION URL SEND_TO RECEIVE_FROM READ_TEMPERATURE READ_HUMIDITY READ_AIR_PRESSURE
%token READ_AIR_QUALITY READ_LIGHT READ_SOUND_LEVEL40 READ_SOUND_LEVEL200 READ_SOUND_LEVEL400 READ_SOUND_LEVEL1000 READ_SOUND_LEVEL4000 BLOCK_COMMENT LINE_COMMENT
%token TRUE FALSE RETURN SHOW TAKE TEXT_OUTPUT CONST_NAME FINISH SMALLER_THAN GREATER_THAN SMALLER_OR_EQUAL GREATER_OR_EQUAL IS_EQUAL NOT_EQUAL mIsTAkE
%%
start: program				;
program: START block FINISH	;
block: LCB stmts RCB | LCB empty RCB | LCB NL RCB ;
stmts: stmt | stmt stmts | NL stmts ;
stmt:  matched | unmatched ;
matched: IF LP logic_expr RP NL matched ELSE NL matched | non_if_stmt	;
unmatched: IF LP logic_expr RP NL stmt | IF LP logic_expr RP NL matched ELSE unmatched 	;
non_if_stmt: while_stmt | loop_stmt | declaration_stmt | assignment_stmt | function_definition | function_stmt | primitive_funct_stmt | output_stmt | input_stmt | return_stmt | comment ;
while_stmt: WHILE LP logic_expr RP block NL	;
loop_stmt: LOOP LP assignment SEMICOLON logic_expr SEMICOLON assignment RP block NL ;
declaration: variable_declaration | constant_declaration	;
constant_declaration: CONST var_type CONST_NAME	;
variable_declaration: var_type ident_list	;
declaration_stmt: declaration NL ;
declaration_assignment: declaration ASSIGN_OP art_expr ;
ident_list: IDENTIFIER | IDENTIFIER COMMA ident_list	;
var_type: INT_TYPE | CONNECTION_TYPE	;
logic_expr: logic_expr OR comp_expr | logic_expr XOR comp_expr | comp_expr	;
comp_expr: comp_expr AND comp_stmt | comp_stmt	;
comp_stmt: bool_cons | NOT_OP comp_stmt | LP logic_expr RP | art_expr relation_op art_expr 	;  
bool_cons: TRUE | FALSE	;
relation_op: SMALLER_THAN | GREATER_THAN | SMALLER_OR_EQUAL | GREATER_OR_EQUAL | IS_EQUAL | NOT_EQUAL ;
numeric: IDENTIFIER | INTEGER | BINARY_DIGIT | function_call | primitive_funct_call | CONST_NAME | PRIMITIVE_SWITCHES	;
assignment: id_assignment | switch_assignment | const_assignment | declaration_assignment	;
assignment_stmt: assignment NL;
const_assignment: CONST_NAME ASSIGN_OP art_expr ;
id_assignment: IDENTIFIER ASSIGN_OP art_expr ;
art_expr: art_expr PLUS term | art_expr MINUS term | term	;
term: term MULT factor | term DIV factor | factor	;
factor: LP art_expr RP | numeric	;
return_stmt: RETURN art_expr NL ;
switch_assignment: PRIMITIVE_SWITCHES ASSIGN_OP BINARY_DIGIT ;
function_call: FUNCTION_NAME LP argument_list RP | IDENTIFIER DOT FUNCTION_NAME LP argument_list RP ;
function_stmt: function_call NL ;
primitive_funct_call: TIME LP RP | CREATE_CONNECTION LP URL RP | IDENTIFIER DOT SEND_TO LP numeric RP | IDENTIFIER DOT RECEIVE_FROM LP RP | READ_TEMPERATURE LP RP | READ_HUMIDITY LP RP | READ_AIR_PRESSURE LP RP | READ_AIR_QUALITY LP RP | READ_LIGHT LP RP | READ_SOUND_LEVEL40 LP RP | READ_SOUND_LEVEL200 LP RP |READ_SOUND_LEVEL400 LP RP | READ_SOUND_LEVEL1000 LP RP | READ_SOUND_LEVEL4000 LP RP ;
primitive_funct_stmt: primitive_funct_call NL ;
argument_list: empty | argument | argument SEMICOLON argument_list ; 
empty: ;
argument: art_expr ;
function_definition: function_header block NL ;
function_header:  SMALLER_THAN return_type GREATER_THAN FUNCTION_NAME LP parameter_type_list RP ;
parameter_type_list: empty | var_type IDENTIFIER | var_type IDENTIFIER SEMICOLON parameter_type_list ;
return_type: empty | var_type ; 
comment: LINE_COMMENT NL | BLOCK_COMMENT NL ;
output_stmt: SHOW LP output RP NL ;
output: empty | TEXT_OUTPUT | art_expr | logic_expr ;
input_stmt: TAKE LP IDENTIFIER RP NL ;
%%
#include "lex.yy.c"
int yyerror(char *s) {
	fprintf(stderr, "Syntax error on line %d.\n", yylineno);
	return 1;
}
int main(void){
	yyparse();
	if(yynerrs < 1){
		printf("Input program is valid.\n");
	}
	return 0;
}
