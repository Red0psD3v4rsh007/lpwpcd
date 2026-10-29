%{
#include "y.tab.h"
%}

%%
[01]    { yylval = yytext[0] - '0'; return BIT; }
"."     { return '.'; }
\n      { return '\n'; }
[ \t\r]+ ;
.       { return INVALID; }
%%

int yywrap(void)
{
    return 1;
}