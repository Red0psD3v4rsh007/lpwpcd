%{
#include <stdio.h>
void yyerror(char *s);
int yylex();
%}

%token IF ELSE WHILE FOR
%token ID NUM
%token LE GE EQ NE
%token AND OR

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%left OR
%left AND
%left '<' '>' LE GE EQ NE
%left '+' '-'
%left '*' '/'
%right '='

%%

PROGRAM : STS
        ;

STS : STS ST
    | ST
    ;

ST : IFST
   | WHILEST
   | FORST
   | BLK
   | E ';'
   ;

IFST : IF '(' E ')' ST %prec LOWER_THAN_ELSE
     | IF '(' E ')' ST ELSE ST
     ;

WHILEST : WHILE '(' E ')' ST
        ;

FORST : FOR '(' E ';' E ';' E ')' ST
      ;

BLK : '{' STS '}'
    ;

E : E '=' E
  | E '+' E
  | E '-' E
  | E '*' E
  | E '/' E
  | E '<' E
  | E '>' E
  | E LE E
  | E GE E
  | E EQ E
  | E NE E
  | E AND E
  | E OR E
  | '(' E ')'
  | ID
  | NUM
  ;

%%

void yyerror(char *s)
{
    printf("Syntax Error\n");
}

int main()
{
    printf("Enter the program:\n");

    if (yyparse() == 0)
        printf("Valid Syntax\n");

    return 0;
}