%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define YYSTYPE char*
#include "y.tab.h"
%}

%%
([ ]+)              {}
(REM([^a-z])\n)     {}
([A-Z][!#$]?[0-9]?) {yylval=strdup(yytext);fprintf(yyout,"ID: %s\n",yytext);return ID;}
([\(])              {fprintf(yyout,"Parenthesis : LEFT_BRACKET\n");return yytext[0];}
([\)])              {fprintf(yyout,"Parenthesis : RIGHT_BRACKET\n");return yytext[0];}
([\^])              {yylval=strdup(yytext); fprintf(yyout,"EXPONENT : %%\n");return yytext[0];}
([\*])              {yylval=strdup(yytext); fprintf(yyout,"PRODUCT : *\n");return yytext[0];}
([\/])              {yylval=strdup(yytext); fprintf(yyout,"DIVIDE : /\n");return yytext[0];}
([\+])              {yylval=strdup(yytext); fprintf(yyout,"PLUS : +\n");return yytext[0];}
([\-])              {yylval=strdup(yytext); fprintf(yyout,"SUBTRACT : -\n");return yytext[0];}   
([\,])              {yylval=strdup(yytext); fprintf(yyout,", ");return yytext[0];}  
([\"])              {yylval=strdup(yytext); fprintf(yyout,"\"");return yytext[0];}
([\;])              {yylval=strdup(yytext); fprintf(yyout,";");return yytext[0];}
([0-9]*)            {yylval=atoi(yytext); fprintf(yyout,"INT : %d\n",yylval);return INT;} 
([=])               {yylval=strdup(yytext); fprintf(yyout,"ASSIGN : =\n");return yytext[0];}
(<[=>]?|>[=]?)      {yylval=strdup(yytext); fprintf(yyout,"RELATIONAL OPERATOR: %s\n",yytext);yylval=malloc(strlen(yytext));strcpy(yylval,yytext);return RO;}             
(NOT|AND|OR|XOR)    {yylval=strdup(yytext); fprintf(yyout,"LOGICAL OPERATOR: %s\n",yytext);return LO;}    
(DATA)              {fprintf(yyout,"DATA STATEMENT: \n",yytext);return DATA;}
("DEF FN")          {fprintf(yyout,"DEF FNX STATEMENT: \n",yytext);return DEF_FN;}
(DIM)               {fprintf(yyout,"DIM STATEMENT\n",yytext);return DIM;}
(END)               {fprintf(yyout,"END \n",yytext);return END;}               
(FOR)               {fprintf(yyout,"FOR STATEMENT\n",yytext);return FOR;}
(TO)                {fprintf(yyout,"TO ",yytext);return TO;}
(STEP)              {fprintf(yyout,"STEP ",yytext);return STEP;}
(NEXT)              {fprintf(yyout,"NEXT ",yytext);return NEXT;}
(GOSUB)             {fprintf(yyout,"GOSUB STATEMENT: \n",yytext);return GOSUB;}
(GOTO)              {fprintf(yyout,"GOTO STATEMENT: \n",yytext);return GOTO;}
(IF)                {fprintf(yyout,"IF STATEMENT: \n",yytext);return IF;}
(THEN)              {fprintf(yyout,"THEN ",yytext);return THEN;}
(LET)               {fprintf(yyout,"LET STATEMENT: \n",yytext);return LET;}
(INPUT)             {fprintf(yyout,"INPUT: \n",yytext);return INPUT;}
(PRINT)             {fprintf(yyout,"PRINT STATEMENT\n",yytext);return PRINT;}
(RETURN)            {fprintf(yyout,"RETURN \n",yytext);return RETURN;}
(STOP)              {fprintf(yyout,"STOP\n",yytext);return STOP;}
%%

int yywrap(void){
    return 1;
}
