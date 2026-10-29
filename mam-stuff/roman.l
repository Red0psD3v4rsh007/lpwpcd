%{
#include "y.tab.h"
%}

%%
"M"     { return M; }
"D"     { return D; }
"C"     { return C; }
"L"     { return L; }
"X"     { return X; }
"V"     { return V; }
"I"     { return I; }

\n      { return '\n'; }
[ \t\r]+ ;
.       { return INVALID; }
%%

int yywrap(void)
{
    return 1;
}