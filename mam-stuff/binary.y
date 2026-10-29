%{
#include <stdio.h>
#include <math.h>

int yylex(void);
void yyerror(const char *s);
%}

%token <ival> BIT
%token INVALID

%union {
    int ival;
    double dval;
}

%type <dval> N F

%%
input:
      N '\n'       { printf("Decimal = %g\n", $1); }
    | N '.' F '\n' { printf("Decimal = %g\n", $1 + $3); }
    ;

N:
      N BIT { $$ = $1 * 2 + $2; }
    | BIT   { $$ = $1; }
    ;

F:
      BIT F { $$ = ($1 + $2) / 2.0; }
    | BIT   { $$ = $1 / 2.0; }
    ;
%%

void yyerror(const char *s)
{
    printf("Invalid binary number\n");
}

int main(void)
{
    printf("Enter binary number (e.g. 101 or 101.101):\n");
    yyparse();
    return 0;
}