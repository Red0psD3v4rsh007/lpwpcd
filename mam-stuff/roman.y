%{
#include <stdio.h>
int yylex(void);
void yyerror(const char *s);
%}

%union {
    int ival;
}

%token M D C L X V I INVALID
%type <ival> numeral thousands hundreds tens units

%%
input:
      numeral '\n'
      {
          if ($1 >= 1 && $1 <= 3999)
              printf("Decimal = %d\n", $1);
          else
              printf("Invalid Roman numeral\n");
      }
    ;

numeral:
      thousands hundreds tens units
      { $$ = $1 + $2 + $3 + $4; }
    ;

thousands:
      /* empty */ { $$ = 0; }
    | M           { $$ = 1000; }
    | M M         { $$ = 2000; }
    | M M M       { $$ = 3000; }
    ;

hundreds:
      /* empty */ { $$ = 0; }
    | C           { $$ = 100; }
    | C C         { $$ = 200; }
    | C C C       { $$ = 300; }
    | C D         { $$ = 400; }
    | D           { $$ = 500; }
    | D C         { $$ = 600; }
    | D C C       { $$ = 700; }
    | D C C C     { $$ = 800; }
    | C M         { $$ = 900; }
    ;

tens:
      /* empty */ { $$ = 0; }
    | X           { $$ = 10; }
    | X X         { $$ = 20; }
    | X X X       { $$ = 30; }
    | X L         { $$ = 40; }
    | L           { $$ = 50; }
    | L X         { $$ = 60; }
    | L X X       { $$ = 70; }
    | L X X X     { $$ = 80; }
    | X C         { $$ = 90; }
    ;

units:
      /* empty */ { $$ = 0; }
    | I           { $$ = 1; }
    | I I         { $$ = 2; }
    | I I I       { $$ = 3; }
    | I V         { $$ = 4; }
    | V           { $$ = 5; }
    | V I         { $$ = 6; }
    | V I I       { $$ = 7; }
    | V I I I     { $$ = 8; }
    | I X         { $$ = 9; }
    ;
%%

void yyerror(const char *s)
{
    printf("Invalid Roman numeral\n");
}

int main(void)
{
    printf("Enter a Roman numeral: ");
    yyparse();
    return 0;
}

