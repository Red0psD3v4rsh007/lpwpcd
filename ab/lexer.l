%{
#include <stdio.h>
%}

%%
\n                               { printf("\n"); }

^#.*                             { printf("PREPROCESSOR "); }
\/\/.*                           { printf("COMMENT "); }
\/\*([^*]|\*+[^*/])*\*+\/         { printf("COMMENT "); }


(int|char|float|double|void|long|short|signed|unsigned|bool) { printf("DT "); }

(if|else|for|while|do|switch|case|break|continue|return|struct|default) { printf("KEY "); }

\"[a-zA-Z0-9 ]*\"                { printf("STR "); }
\'[a-zA-Z0-9]\'                  { printf("CHAR "); }

[+-]?([0-9]+)?\.[0-9]+([eE][+-]?[0-9]+)? { printf(" FLOAT", yytext); } 
[-+]?[0-9]+                           { printf("INT "); }

[a-zA-Z_][a-zA-Z0-9_]{0,7}       { printf("ID "); }

"++"                             { printf("INC "); }
"--"                             { printf("DEC "); }
"=="                             { printf("EQ "); }
"!="                             { printf("NE "); }
"<="                             { printf("LE "); }
">="                             { printf("GE "); }
"<"                              { printf("LT "); }
">"                              { printf("GT "); }

"="                              { printf("ASSIGN "); }

"+"                              { printf("PLUS "); }
"-"                              { printf("MINUS "); }
"*"                              { printf("MUL "); }
"/"                              { printf("DIV "); }
"%"                              { printf("MOD "); }

"&&"                             { printf("AND "); }
"||"                             { printf("OR "); }
"!"                              { printf("NOT "); }

[\(\)\{\}\[\],]                  { printf("DELIM "); }
";"                              { printf("SEMICOLON "); }

[@$^~]                           { printf("SPECIAL "); }

[ \t]+                           ;
.                                { printf("UNKNOWN "); }

%%

int yywrap()
{
    return 1;
}

int main()
{
    yylex();
    return 0;
}