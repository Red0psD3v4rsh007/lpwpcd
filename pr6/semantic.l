%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Type values used by lexer */
#define TYPE_ERROR  0
#define TYPE_INT    1
#define TYPE_FLOAT  2
#define TYPE_CHAR   3
%}

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }

[0-9]+\.[0-9]+  {
                    yylval.type = TYPE_FLOAT;
                    return FLOAT_NUM;
                }

[0-9]+          {
                    yylval.type = TYPE_INT;
                    return INT_NUM;
                }

[a-zA-Z_][a-zA-Z0-9_]*  {
                    yylval.str = strdup(yytext);
                    return ID;
                }

"="         { return '='; }
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"%"         { return '%'; }

","         { return ','; }
";"         { return ';'; }

[ \t\n]+    ;

.           {
                printf("Lexical Error: Invalid character '%s'\n", yytext);
            }

%%