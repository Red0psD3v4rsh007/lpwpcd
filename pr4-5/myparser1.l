%{
#include "y.tab.h"

%}
%%
"if"	{return IF;}
"else"  {return ELSE;}
[0-9]+	{return Num;}
[();+{}]	{return yytext[0];}
%%
int yywrap()
{
    return 1;
}
