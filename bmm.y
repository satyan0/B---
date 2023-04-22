%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define YYSTYPE char*
extern void yyerror(const char* message);
extern int yylex();
%}

%token DATA END LET REM STOP
%token STRING COMMA ASSIGN INT_ID SINGLE_ID DOUBLE_ID STRING_ID QUOTE
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
    | end_stmt
    | let_stmt
    | rem_stmt
    | stop_stmt
    ;

data_stmt:
    DATA data_list
    ;

data_list:
    data_item
    | data_item COMMA data_list

data_item:
    INT
    | DOUBLE
    | STRING
    ;

let_stmt:
    LET INT_ID ASSIGN expr
    | LET STRING_ID ASSIGN QUOTE STRING QUOTE
    | LET DOUBLE_ID ASSIGN expr
    ;

expr:
    INT
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
    STOP    {exit(1);}
    ;

end_stmt:
    END     {return 0;}
    ;
%%

int main(void){
    yyparse();
}

void yyerror(const char* message)
{
    printf("%s\n",message);
}