%{
#include "y.tab.h"
%}

%%
"("     { return '('; }
")"     { return ')'; }
\n      { return '\n'; }
[ \t\r]+ ;
.       { return CHAR; }
%%

int yywrap(void)
{
    return 1;
}