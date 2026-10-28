%{
#include <stdio.h>
void yyerror(char *s);
%}
%token IF Num ELSE
%%
IFST : IF '(' E ')' ST A1;
A1   :  ELSE ST      
     |          
     ;
BLK : '{' STS '}'
ST   : BLK
     | IFST
     | E ';'
     ;
STS : STS ST
    | ST
E   : E '+' Num
    | Num
    ;
%%
void yyerror(char *str)
{
    printf("syntax error\n");
}
int main()
{
yyparse();
return 0;
}
