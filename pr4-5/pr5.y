%{
#include <stdio.h>

void yyerror(char *s);
int yylex();

extern int line_no;

int error_count = 0;
%}

%token IF ELSE WHILE FOR
%token ID NUM
%token LE GE EQ NE
%token AND OR


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

/* Statements + PANIC MODE ERROR RECOVERY */
ST : IFST
   | WHILEST
   | FORST
   | BLK
   | E ';'
   |

   | error ';'
     {
         printf("Error recovered at line %d\n", line_no);
         yyerrok;
     }
   ;

IFST : IF '(' E ')' ST 
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

  | E ID
    {
        printf("Syntax Error at line %d: Missing operator\n", line_no);
        error_count++;
    }

  | E NUM
    {
        printf("Syntax Error at line %d: Missing operator\n", line_no);
        error_count++;
    }
  ;

%%

void yyerror(char *s)
{
    printf("Syntax Error at line %d\n", line_no);
    error_count++;
}

int main()
{
    printf("Enter the program:\n");

    yyparse();

    if (error_count == 0)
        printf("Valid Syntax\n");
    else
        printf("Parsing completed with %d error(s)\n", error_count);

    return 0;
}
