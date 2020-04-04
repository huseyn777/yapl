%{
     int lineno=0;
%}
int_ty 		int
void_ty 	void
str_ty  	string
double_ty 	double
char_ty  	char
bool_ty  	bool
type   		{int_ty}|{void_ty}|{str_ty}|{double_ty}|{char_ty}|{bool_ty}
letter      	[A-Za-z_$]
setLetters 	{space}(\,)?{space}(\")[ \t]*[A-Za-z_$]+{space}(\"){space}(\,)?
digit       	[+-]?[0-9]
setDigit    	{space}(\,)?{space}[+-]?[0-9]+{space}(\,)?
double      	[+-]?[0-9]*(\.)[0-9]+
setDouble   	{space}(\,)?{space}[+-]?[0-9]*(\.)[0-9]+{space}(\,)?
var         	({letter}|{digit})
charAll     	({letter}|{digit}|{double})
setChar     	{space}(\,)?{space}(\'){space}{var}{space}(\'){space}(\,)?
lett	 	[A-Za-z_$,]|[ \t]|lett
varId 		({lett}|{lett}*)
arith_op    	[+-/*]
curly_start 	(\{)
curly_end   	(\})
bracket_st 	(\()
bracket_end 	(\))
newLine         (\n)
comment_ln      (.)*
comment_multi   (.)*|{newLine}*|[ \t]*
funcCall        ({space}(\,)?{space}{letter}{var}*{space}(\,)?{space}|{setLetters}|{setDigit}|{setDouble}|{setChar})
space 		[ \t]*
arg_list 	{space}*{type}{space}*{varId}{space}*(\,)?{space}*{space}*
%%
{type}{varId}{space}*{bracket_st}{arg_list}*{bracket_end} 	{ return FUNC_DEC;}
{letter}{var}*{space}*\({funcCall}*\)           { return FUNCTION_CALL;}
{curly_start}{setDouble}*{curly_end}            { return SET_OF_DOUBLES;}
{curly_start}{setLetters}*{curly_end}           { return SET_OF_LETTERS;}
{curly_start}{setDigit}*{curly_end}             { return SET_OF_INTEGERS;}
{curly_start}{setChar}*{curly_end}              { return SET_OF_CHARS;}
{int_ty}                			{ return INTEGER_TYPE;}
{str_ty}              			        { return STRING_TYPE;}
{double_ty}              			{ return DOUBLE_TYPE;}
{char_ty}                			{ return CHARACTER_TYPE;}
{bool_ty}              				{ return BOOLEAN_TYPE;}
true               				{ return TRUE;}
false              				{ return FALSE;}
for                 				{ return FOR;}
if                  				{ return IF;}
else                				{ return ELSE;}
while               				{ return WHILE;}
{arith_op}          				{ return ARITH_OP;}
\|                 				{ return BOOL_OP;}
\&\&                				{ return BOOL_OP;}
\=                  				{ return ASSIG_OP;}
\<                  				{ return LESS;}
\<\=                				{ return LESS_EQ;}
\>                  				{ return MORE;}
\>\=                				{ return MORE_EQ;}
\!\=                				{ return NOT_EQ;}
\=\=                				{ return EQ;}
\!                  				{ return NOT;}
void                				{ return VOID;}
return              				{ return RETURN;}
\+\+                				{ return INCREMENT;}
\-\-                				{ return DECREMENT;}
uni                 				{ return UNION;}
intsec              				{ return INTERSECTION;}
subt                				{ return SUBTRACTION;}
\<\<                  				{ return SUBSET;}
\>\>                  				{ return SUPERSET;}
\-\>                 				{ return PROPER_SET;}
\(                  				{ return LEFT_B;}
\)                  				{ return RIGHT_B;}
\{                  				{ return CURLY_LEFT_B;}
\}                  				{ return CURLY_RIGHT_B;}
\[                  				{ return SQUARE_LEFT_B;}
\]                  				{ return SQUARE_RIGHT_B;}
iin:                				{ return INTEGER_INPUT;}
cin:               				{ return CHAR_INPUT;}
bin:               				{ return BOOL_INPUT;}
din:                				{ return DOUBLE_INPUT;}
sin:                				{ return STRING_INPUT;}
iout:               				{ return INTEGER_OUT;}
cout:               				{ return CHAR_OUT;}
bout:               				{ return BOOLEAN_OUT;}
sout:               				{ return STRING_OUT;}
dout:               				{ return DOUBLE_OUT;}
{letter}{var}*      				{ return VARIABLE_ID;}
\&{letter}{var}*      				{ return SET_ID;}
{digit}*           				{ return NUMBER;}
{double}*           				{ return DOUBLE_NUMBER;}
\"{space}{charAll}*{space}\"      		{ return STRING;}
\'{space}{var}{space}\'          		{ return CHAR;}
\/\/{comment_ln}   	    			{ return MULTI_COMMENT;}
\/\*{comment_multi}*\*\/          		{ return COMMENT;}
\;                                              { return SEMI_COL;}
{newLine}					{ lineno++;
						  return NL;
						}
{space}                               		{}
.   						{ return yytext[0];}
%%
int yywrap()  					{ return 1;}
