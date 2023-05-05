%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<math.h>
#define YYSTYPE char*
extern void yyerror(const char* message);
extern int yylex();
extern FILE* yyin;
extern FILE* yyout;
%}

%token DATA END LET REM STOP PRINT DEF_FN GOTO GOSUB IF THEN RETURN ID DIM FOR TO STEP INPUT NEXT RO LO NUM
%token STRING COMMA ASSIGN INT_ID SINGLE_ID DOUBLE_ID STRING_ID QUOTE SEMICOLON
%token INT DOUBLE PLUS MINUS DIV MUL OBRAK CBRAK POWER
%left PLUS MINUS
%left DIV MUL 
%%
program:    
    stmt_list program
    | stmt_list
    ;

stmt_list:
    data_stmt
    | def_fnx_stmt
    | dim_stmt
    | for_stmt
    | gosub_stmt
    | goto_stmt
    | if_stmt
    | print_stmt
    | return_stmt
    | end_stmt
    | let_stmt
    | rem_stmt
    | stop_stmt
    ;

data_stmt:
    INT DATA data_list
    ;

data_list:
    data_item
    | data_item COMMA data_list
    ;

data_item:
    INT
    | DOUBLE
    | STRING
    ;


def_fnx_stmt:
    DEF_FN ID '=' expr
    | DEF_FN ID '('ID')' '=' expr
    ;

dim_stmt:
    DIM ID '('INT')' dim_cont   {fprintf(stdout,"DIM %s (%s) ",$2, $4);}
    | DIM ID '('INT','INT')' dim_cont  {fprintf(stdout,"DIM %s (%s, %s) ",$2, $4, $6);}
    ;

dim_cont:
    ',' ID '('INT')' dim_cont  {fprintf(stdout,"DIM %s (%s)\n",$2, $4);}
    | ',' ID '('INT','INT')' dim_cont  {fprintf(stdout,"DIM %s (%s, %s)\n",$2, $4, $6);}
    |
    ;

for_stmt:
    FOR ID '=' expr TO expr STEP expr opt_step
                        {fprintf(stdout, "FOR loop from %d to %d with step %d, index variable %s\n", $4, $6, $8, $2); }
    stmt_list
    NEXT ID
            { fprintf(stdout, "NEXT loop with index variable %s\n", $2); }
    ;

opt_step:
    STEP expr
    |
    ;

gosub_stmt:
    GOSUB INT
            {fprintf(stdout, "GOSUB to %d\n", $2); }
    ;

goto_stmt:
    GOTO INT
            {fprintf(stdout, "GOTO to %d\n", $2); }
    ;        

if_stmt:
    IF cond_expr THEN INT        {fprintf(stdout, "IF condition satisfies, then goto line number %d\n", $4);}
    ;

cond_expr:
    expr RO expr
    ;

let_stmt:
    LET ID '=' expr          {fprintf(stdout,"LET %s=%d",$2, $4);}
    | LET ID '=' '"' STRING '"'
    | LET ID '=' expr
    ;

print_stmt:
    PRINT
    | PRINT expr delimiter
    ;

delimiter:
    ',' STRING delimiter
    | ',' expr delimiter
    | ';' STRING delimiter
    | ';' expr delimiter
    |
    ;

return_stmt:
    RETURN
    ;

expr:
    ID
    | INT
    | DOUBLE
    | expr PLUS expr
    | expr MINUS expr 
    | expr DIV expr
    | expr MUL expr
    | expr POWER expr
    | OBRAK expr CBRAK
    ;

rem_stmt:
    REM
    ;

stop_stmt:
    STOP    {fprintf(stdout,"STOP PROGRAM");}
    ;

end_stmt:
    END     {fprintf(stdout,"END PROGRAM\n");}
    ;


%%

int main(int argc , char** argv){
    if(argc < 2){
		printf("For,mat of input is %s <filename>\n", argv[0]);
		return 0;
	}
	yyin = fopen(argv[1], "r");
	yyout = fopen("Lexer.txt", "w");
	stdout = fopen("Parser.txt", "w");
	yyparse();
}

void yyerror(const char* message)
{
	printf("\nPROGRAM IS SYNTATICALLY INCORRECT\n");
}
