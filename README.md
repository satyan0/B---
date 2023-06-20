TO compile, create a .bmm file and then enter 


lex bmm.l
yacc -d bmm.y
cc lex.yy.c y.tab.c
./a.out <filename>.bmm

NO LOWERCASE LETTERS ALLOWED
