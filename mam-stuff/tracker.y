%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%
[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+(\.[0-9]+)? { return NUMBER; }

[ \t\r]+ ;
\n      { return '\n'; }

.       { return yytext[0]; }
%%

int yywrap(void)
{
    return 1;
}