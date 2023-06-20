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
int endcount=0;
int currentline=0;
float temp;
%}

%token DATA END LET REM STOP PRINT DEF_FN GOTO GOSUB IF THEN RETURN ID DIM FOR TO STEP INPUT NEXT RO LO NUM INT FLOAT
%token STRING ASSIGN INT_ID DOUBLE_ID STRING_ID FLOAT_ID COMMENT
%token DOUBLE ERROR NE
%left '+' '-'
%left '*' '/'
%left '^'

%%
program:    
    INT stmt_list program   {currentline = atoi($1);if(endcount>1)fprintf(stderr, "MORE THAN ONE END DETECTED");}
    | INT stmt_list         {currentline = atoi($1);if(endcount>1)fprintf(stderr, "MORE THAN ONE END DETECTED");}
    | FLOAT                 {temp=atof($1);fprintf(stdout, "%f", temp);}
    | ID              {fprintf(stdout, "%s", $1);}
    ;

stmt_list:
    data_stmt       
    | def_fnx_stmt  
    | dim_stmt      
    | for_stmt      
    | gosub_stmt
    | goto_stmt
    | if_stmt
    | input_stmt
    | print_stmt
    | return_stmt
    | end_stmt
    | let_stmt       
    | stop_stmt      
    | rem_stmt   
    | next_stmt    
    ;

data_stmt:
    DATA data_list      {fprintf(stdout," :DATA STATEMENT");}
    ;

data_list:
    data_item   
    | data_item ',' data_list 
    ;

data_item:
    INT         {fprintf(stdout,"%s ", $1);}
    | FLOAT     {fprintf(stdout,"%s ", $1);}
    | DOUBLE    {fprintf(stdout,"%s ", $1);}
    | STRING {fprintf(stdout,"%s ", $1);}
    ;


def_fnx_stmt:
    DEF_FN ID '=' expr      {fprintf(stdout, "\nDEF FN %s = %s\n", $2, $4);}
    | DEF_FN ID '('ID')' '=' expr  {fprintf(stdout, "\nDEF FN %s (%s) = %s\n", $2,$4, $7);}
    ;

dim_stmt:
    DIM ID '('INT')' dim_cont   {fprintf(stdout,"\nDIM %s (%s) ",$2, $4);}
    | DIM ID '('INT','INT')' dim_cont  {fprintf(stdout,"\nDIM %s (%s, %s) ",$2, $4, $6);}
    ;

dim_cont:
    ',' ID '('INT')' dim_cont  {fprintf(stdout,"\nDIM %s (%s)\n",$2, $4);}
    | ',' ID '('INT','INT')' dim_cont  {fprintf(stdout,"\nDIM %s (%s, %s)\n",$2, $4, $6);}
    |
    ;

for_stmt:
    FOR id_list '=' expr TO expr opt_step
                        {fprintf(stdout, "\nFOR loop from %s to %s with step, index variable %s\n", $4, $6, $2); }
    program
           { fprintf(stdout, "\nNEXT loop with index variable %s\n", $2); }
    ;

next_stmt:
    NEXT id_list    { fprintf(stdout, "\nRe-iterate loop with index variable %s\n", $2); }
    ;

id_list:
    INT_ID
    | FLOAT_ID
    | DOUBLE_ID
    | ID
    ;

opt_step:
    STEP expr
    |
    ;

gosub_stmt:
    GOSUB INT
            {fprintf(stdout, "\nGOSUB to %s\n", $2); }
    ;

goto_stmt:
    GOTO INT
            {fprintf(stdout, "\nGOTO to %s\n", $2); }
    ;        

if_stmt:
    IF expr RO expr THEN INT        {fprintf(stdout, "\nIF condition satisfies, then goto line number %s\n", $6);}
    | IF string '=' string THEN INT     {fprintf(stdout, "\nIF condition satisfies, then goto line number %s\n", $6);}
    | IF string NE string THEN INT        {fprintf(stdout, "\nIF condition satisfies, then goto line number %s\n", $6);}
    ;

string:
    STRING
    | STRING_ID
    ;

input_stmt:
    INPUT ID {fprintf(stdout,"\nINPUT: %s ", $2);}
    | INPUT FLOAT_ID {fprintf(stdout,"\nINPUT: %s ", $2);}
    | INPUT DOUBLE_ID {fprintf(stdout,"\nINPUT: %s ", $2);}
    | INPUT STRING_ID {fprintf(stdout,"\nINPUT: %s ", $2);}
    | INPUT INT_ID    {fprintf(stdout,"\nINPUT: %s ", $2);}
    ;


let_stmt:
    LET ID '=' expr          {fprintf(stdout,"\nLET %s = %s", $2, $4);}
    | LET ID '=' '"' STRING '"'
    ;

print_stmt:
    PRINT                   {fprintf(stdout, "\nPRINT NEWLINE");} 
    | PRINT expr ';'  {fprintf(stdout, "\nPRINT: %s", $2);}
    | PRINT expr delimiter  {fprintf(stdout, "\nPRINT: %s", $2);}
    | PRINT STRING ';'    {fprintf(stdout, "\nPRINT: %s", $2);}
    | PRINT STRING delimiter    {fprintf(stdout, "\nPRINT: %s", $2);}
    ;


delimiter:
    ',' STRING delimiter
    | ',' expr delimiter
    | ';'
    ;

return_stmt:
    RETURN  {fprintf(stdout, "RETURN\n");}
    ;

expr:
    expr '-' term
    | expr '+' term
    | term

term:
    term '/' fac
    | term '*' fac
    | fac
    ;

fac:
    | fac '^' ide
    | ide
    ;

ide:
    | '(' expr ')'
    | FLOAT
    | FLOAT_ID
    | DOUBLE
    | DOUBLE_ID
    | INT
    | INT_ID
    | ID
    ;

rem_stmt:
    REM
    ;

stop_stmt:
    STOP    {fprintf(stdout,"STOP PROGRAM");}
    ;

end_stmt:
    END     {fprintf(stdout,"END PROGRAM\n");endcount++;}
    ;


%%

int main(int argc , char** argv){
    if(argc < 2){
		printf("Format of input is %s <filename>\n", argv[0]);
		return 0;
	}
	yyin = fopen(argv[1], "r");
	yyout = fopen("Lexer.txt", "w");
	stdout = fopen("Parser.txt", "w");
	yyparse();
    if(endcount>1){
        printf("MORE THAN 1 ENDS DETECTED");
    }
}

void yyerror(const char* message)
{
	printf("\nPROGRAM IS SYNTATICALLY INCORRECT\n");
}
