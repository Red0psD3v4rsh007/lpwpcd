%{
#include <stdio.h>
int lines = 1;

%}

%%

"int"|"float"|"double"|"char"|"bool" { printf("DT"); }
"include"|"stdio.h"|"if"|"else"|"for"|"while"|"do"|"switch"|"case"|"break"|"continue"|"return" { printf("KW"); }
[0-9]+(\.[0-9]+) {printf("FLOAT"); }
[0-9]+     { printf("INT"); }
\'[^']\'    { printf("CHR"); }
\"[^"]*\"    { printf("STR"); }
[_a-zA-Z][_a-zA-Z0-9]*  { printf("ID"); }
"("|")"|"{"|"}"|"["|"]" { printf("%s", yytext); }    

"=="|"!="|"<="|">="|"<"|">"|"=" { printf("CMP"); }  'h'
"+"|"-"|"*"|"/"|"%"|"++"|"--"    { printf("OPS"); }

";"|","      { printf("%s", yytext); }
[ \t\r]+       { printf("%s", yytext); }

"//".* ;
"/*"([^*]|\*+[^*/])*\*+"/" ;

\n { lines++; printf("\n"); }



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