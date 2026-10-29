%{
#include "y.tab.h"
%}

%%
[a-zA-Z_][a-zA-Z0-9_]* { return ID; }
[0-9]+                 { return NUM; }
"+"                    { return '+'; }
"*"                    { return '*'; }
"("                    { return '('; }
")"                    { return ')'; }
\n                     { return '\n'; }
[ \t\r]+               ;
.                      { return INVALID; }
%%

int yywrap(void) { return 1; }
