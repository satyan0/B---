%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define YYSTYPE char*
#include "y.tab.h"
%}

%%
([ ]+)              ;
(\"([A-Z0-9,* ])*\")     {yylval=strdup(yytext); fprintf(yyout, "STRING: %s\n", yylval);return STRING;}
(REM([A-Z0-9,* ])*\n)         {fprintf(yyout,"%s\n", yytext);return REM;}       
([A-Z][0-9]?!)    {yylval=strdup(yytext);fprintf(yyout,"ID: 1%s\n",yytext);return FLOAT_ID;}
([A-Z][0-9]?#)    {yylval=strdup(yytext);fprintf(yyout,"ID: 2%s\n",yytext);return DOUBLE_ID;}
([A-Z][0-9]?$)    {yylval=strdup(yytext);fprintf(yyout,"ID: 3%s\n",yytext);return STRING_ID;}
([\(])              {fprintf(yyout,"Parenthesis : LEFT_BRACKET\n");return yytext[0];}
([\)])              {fprintf(yyout,"Parenthesis : RIGHT_BRACKET\n");return yytext[0];}
([\^])              {yylval=strdup(yytext); fprintf(yyout,"EXPONENT : %%\n");return yytext[0];}
([\*])              {yylval=strdup(yytext); fprintf(yyout,"PRODUCT : *\n");return yytext[0];}
([\/])              {yylval=strdup(yytext); fprintf(yyout,"DIVIDE : /\n");return yytext[0];}
([\+])              {yylval=strdup(yytext); fprintf(yyout,"PLUS : +\n");return yytext[0];}
([\-])              {yylval=strdup(yytext); fprintf(yyout,"SUBTRACT : -\n");return yytext[0];}   
([\,])              {yylval=strdup(yytext); fprintf(yyout,", ");return yytext[0];}  
([\;])              {yylval=strdup(yytext); fprintf(yyout,";\n");return yytext[0];}
([=])               {yylval=strdup(yytext); fprintf(yyout,"ASSIGN : \n");return yytext[0];}
(\<\>)              {yylval=strdup(yytext); fprintf(yyout,"RELATIONAL OPERATOR: %s\n",yytext);yylval=malloc(strlen(yytext));strcpy(yylval,yytext);return NE;}
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
(STOP)              {fprintf(yyout,"STOP\n",yytext);return STOP;}//([A-Z0-9\!\@\#\$\%\^\&\*\(\)\-\+\=_\[\]\<\> ]*\n)            {yylval=strdup(yytext);fprintf(yyout,"COMMENT %s\n",yytext);return COMMENT;}   // ([A-Z][0-9]?)       {yylval=strdup(yytext);fprintf(yyout,"ID: 4%s\n",yytext);return INT_ID;} // ([A-Z])             {yylval=strdup(yytext);fprintf(yyout,"ID: 5%s\n",yytext);return ID;}
[0-9]+                       { yylval = strdup(yytext);fprintf(yyout,"INT : %s\n",yylval); return INT; }//[A-Z0-9 ]+        {yylval=strdup(yytext);fprintf(yyout,"STRING: %s\n",yytext);return STRING;}
[0-9]+\.[0-9]+               { yylval = strdup(yytext);fprintf(yyout,"FLOAT : %s\n",yylval); return FLOAT; }
[0-9]+[Ee][+-]?[0-9]+        { yylval = strdup(yytext);fprintf(yyout,"DOUBLE : %s\n",yylval); return DOUBLE; } 
[A-Z]                        {yylval = strdup(yytext);fprintf(yyout, "ID: %s\n", yylval); return ID;}
.           { fprintf(stderr, "Invalid character: %c\n", *yytext); return ERROR; }
%%

int yywrap(void){
    return 1;
}
