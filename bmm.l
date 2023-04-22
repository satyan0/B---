%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define YYSTYPE char*
#include "y.tab.h"
%}

%%
DATA            {yylval = strdup(yytext); printf("%s ", yylval);return DATA;}
LET             {yylval = strdup(yytext); printf("%s ", yylval); return LET;}
STOP            {yylval = strdup(yytext);  printf("%s ", yylval);return STOP;}
END             {yylval = strdup(yytext); printf("%s ", yylval); return END;}
REM.*\n             {yylval = strdup(yytext); printf("%s ", yylval); return REM;}
[A-Z][0-9]?     {yylval = strdup(yytext); printf("%s ", yylval); return INT_ID;}
[A-Z][0-9]?!    {yylval = strdup(yytext); printf("%s ", yylval); return SINGLE_ID;}
[A-Z][0-9]?#    {yylval = strdup(yytext); printf("%s ", yylval); return DOUBLE_ID;}
[A-Z][0-9]?[\$]   {yylval = strdup(yytext); printf("%s ", yylval); return STRING_ID;} //edit this fucker
=               {yylval = strdup(yytext); printf("%s ", yylval); return ASSIGN;}
[0-9]+          {yylval = atoi(yytext); printf("%d ", yylval); return INT;}
[0-9]*\.[0-9]+  {yylval = atoi(yytext); printf("%d ", yylval); return DOUBLE;}//this too
\,              {yylval =strdup(yytext); printf("%s ", yylval); return COMMA;}
\"              {yylval = strdup(yytext); printf("%s ", yylval); return QUOTE;}
[A-Z]*          {yylval = strdup(yytext); printf("%s ", yylval); return STRING;}
"+"             {yylval = strdup(yytext); printf("%s ", yylval); return PLUS;}
"-"             {yylval = strdup(yytext); printf("%s ", yylval); return MINUS;}
"*"             {yylval = strdup(yytext); printf("%s ", yylval); return MUL;}
"/"             {yylval = strdup(yytext); printf("%s ", yylval); return DIV;}
"^"             {yylval = strdup(yytext); printf("%s ", yylval); return POWER;}
"("             {yylval = strdup(yytext); printf("%s ", yylval); return OBRAK;}
")"             {yylval = strdup(yytext); printf("%s ", yylval); return CBRAK;}
.           
%%

int yywrap(void){
    return 1;
}