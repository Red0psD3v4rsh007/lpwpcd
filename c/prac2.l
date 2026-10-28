%{
#include <stdio.h>

int lines = 1;
FILE *yyin;
%}

%%

"int"|"float"|"double"|"char"|"bool" { printf("DT"); }
"include"|"stdio.h"|"if"|"else"|"for"|"while"|"do"|"switch"|"case"|"break"|"continue"|"return" { printf("KW"); }
[0-9]+(\.[0-9]+) {printf("FLOAT"); }
[0-9]+     { printf("INT"); }
\'[^\']\'    { printf("CHR"); }
\"[^\"]*\"    { printf("STR"); }
[_a-zA-Z][_a-zA-Z0-9]*  { printf("ID"); }

"=="|"!="|"<="|">="|"<"|">"|"=" { printf("CMP"); }
"+"|"-"|"*"|"/"|"%"|"++"|"--"    { printf("OPS"); }

";"|","      { printf("%s", yytext); }
[ \t]+       { printf("%s", yytext); }

"//".* ;
"/*"([^*]|\*+[^*/])*\*+"/" ;

\n { lines++; printf("\n"); }

. {
    printf("\nInvalid token at line %d: %s\n", lines, yytext);
}

%%

int main()
{
    yylex();
    return 0;
}

int yywrap(void)
{
    return 1;
}