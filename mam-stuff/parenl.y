%{
#include <stdio.h>

int yylex(void);
void yyerror(const char *s);

int pairs = 0;
%}

%token CHAR

%%
input:
    sequence '\n'
    {
        printf("Valid: %d pair(s)\n", pairs);
    }
    ;

sequence:
      /* empty */
    | sequence item
    ;

item:
      CHAR
    | '(' sequence ')' { pairs++; }
    ;
%%

void yyerror(const char *s)
{
    printf("Invalid expression\n");
}

int main(void)
{
    printf("Enter expression: ");
    yyparse();
    return 0;
}