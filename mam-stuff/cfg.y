%{
#include <stdio.h>
int yylex(void);
void yyerror(const char *s);
%}

%token ID NUM INVALID

%%
input:
    E '\n' { printf("Valid expression\n"); }
    ;

E:
      E '+' T
    | T
    ;

T:
      T '*' F
    | F
    ;

F:
      '(' E ')'
    | ID
    | NUM
    ;
%%

void yyerror(const char *s)
{
    printf("Invalid expression\n");
}

int main(void)
{
    printf("Enter expression: ");
    return yyparse();
}
