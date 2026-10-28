%{
#include "y.tab.h"
%}

%%

"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"for"       { return FOR; }

"=="        { return EQ; }
"!="        { return NE; }
"<="        { return LE; }
">="        { return GE; }
"&&"        { return AND; }
"||"        { return OR; }

[0-9]+      { return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*   { return ID; }

[ \t\n]+    ;

[();{}=+\-*/<>]   { return yytext[0]; }

.           { return yytext[0]; }

%%

int yywrap()
{
    return 1;
}