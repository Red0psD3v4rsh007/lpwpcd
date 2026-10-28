%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(const char *s);

#define MAX_SYMBOLS 100

/* Type values */
#define TYPE_ERROR  0
#define TYPE_INT    1
#define TYPE_FLOAT  2
#define TYPE_CHAR   3


/* =====================================================
   SYMBOL TABLE
   ===================================================== */

typedef struct
{
    char name[50];
    char type[20];
} Symbol;

Symbol symbolTable[MAX_SYMBOLS];

int symbolCount = 0;


/* =====================================================
   CONVERT TYPE NUMBER TO STRING
   ===================================================== */

char *typeName(int type)
{
    switch(type)
    {
        case TYPE_INT:
            return "int";

        case TYPE_FLOAT:
            return "float";

        case TYPE_CHAR:
            return "char";

        default:
            return "error";
    }
}


/* =====================================================
   LOOKUP VARIABLE
   Returns:
       index if found
       -1 if not found
   ===================================================== */

int lookup(char *name)
{
    int i;

    for(i = 0; i < symbolCount; i++)
    {
        if(strcmp(symbolTable[i].name, name) == 0)
        {
            return i;
        }
    }

    return -1;
}


/* =====================================================
   INSERT VARIABLE INTO SYMBOL TABLE
   ===================================================== */

void insert(char *name, char *type)
{
    /* Check redeclaration */
    if(lookup(name) != -1)
    {
        printf(
            "Semantic Error: Redeclaration of variable '%s'\n",
            name
        );

        return;
    }

    /* Check table size */
    if(symbolCount >= MAX_SYMBOLS)
    {
        printf("Semantic Error: Symbol table is full\n");
        return;
    }

    /* Insert name */
    strcpy(symbolTable[symbolCount].name, name);

    /* Insert data type */
    strcpy(symbolTable[symbolCount].type, type);

    symbolCount++;
}


/* =====================================================
   GET TYPE OF VARIABLE
   Also checks undeclared variable
   ===================================================== */

int getVariableType(char *name)
{
    int index;

    index = lookup(name);

    /* Variable not found */
    if(index == -1)
    {
        printf(
            "Semantic Error: Undeclared variable '%s'\n",
            name
        );

        return TYPE_ERROR;
    }

    /* Convert stored string type to type number */

    if(strcmp(symbolTable[index].type, "int") == 0)
    {
        return TYPE_INT;
    }

    if(strcmp(symbolTable[index].type, "float") == 0)
    {
        return TYPE_FLOAT;
    }

    if(strcmp(symbolTable[index].type, "char") == 0)
    {
        return TYPE_CHAR;
    }

    return TYPE_ERROR;
}


/* =====================================================
   DISPLAY SYMBOL TABLE
   ===================================================== */

void displaySymbolTable()
{
    int i;

    printf("\n");
    printf("========================================\n");
    printf("             SYMBOL TABLE               \n");
    printf("========================================\n");

    printf("%-15s %-15s\n", "Name", "Type");

    printf("----------------------------------------\n");

    for(i = 0; i < symbolCount; i++)
    {
        printf(
            "%-15s %-15s\n",
            symbolTable[i].name,
            symbolTable[i].type
        );
    }

    printf("========================================\n");
}

%}


/* =====================================================
   SEMANTIC VALUE TYPES
   ===================================================== */

%union
{
    char *str;
    int type;
}


/* =====================================================
   TOKENS
   ===================================================== */

/* Identifier carries a string */
%token <str> ID

/* Keywords */
%token INT
%token FLOAT
%token CHAR

/* Numbers carry a type */
%token <type> INT_NUM
%token <type> FLOAT_NUM


/* =====================================================
   NON-TERMINAL TYPES
   ===================================================== */

/*
   expression produces a TYPE_INT, TYPE_FLOAT,
   TYPE_CHAR or TYPE_ERROR.
*/
%type <type> expression


/* =====================================================
   GRAMMAR
   ===================================================== */

%%


/* =====================================================
   PROGRAM
   ===================================================== */

program
    : statements
    ;


/* =====================================================
   MULTIPLE STATEMENTS
   ===================================================== */

statements
    : statements statement
    | statement
    ;


/* =====================================================
   STATEMENT
   ===================================================== */

statement
    : declaration
    | assignment
    | expression ';'
    ;


/* =====================================================
   DECLARATION
   ===================================================== */

/*
   Examples:

   int a;
   int a,b,c;

   float x,y;

   char p,q;
*/

declaration
    : INT int_list ';'
    | FLOAT float_list ';'
    | CHAR char_list ';'
    ;


/* =====================================================
   INTEGER VARIABLE LIST
   ===================================================== */

/*
   int a,b,c;

   int_list:

   a
   a,b
   a,b,c
*/

int_list
    : ID
      {
          /*
             $1 = ID

             Example:
             int a;

             $1 = "a"
          */

          insert($1, "int");
      }

    | int_list ',' ID
      {
          /*
             Rule:

             int_list ',' ID
                $1    $2  $3

             $3 is the new identifier.

             Example:

             int a,b;

             When processing b:

             $3 = "b"
          */

          insert($3, "int");
      }
    ;


/* =====================================================
   FLOAT VARIABLE LIST
   ===================================================== */

float_list
    : ID
      {
          insert($1, "float");
      }

    | float_list ',' ID
      {
          insert($3, "float");
      }
    ;


/* =====================================================
   CHAR VARIABLE LIST
   ===================================================== */

char_list
    : ID
      {
          insert($1, "char");
      }

    | char_list ',' ID
      {
          insert($3, "char");
      }
    ;


/* =====================================================
   ASSIGNMENT
   ===================================================== */

/*
   Example:

   a = 10;

   Grammar:

   ID '=' expression ';'
    $1    $2      $3      $4

   Therefore:

   $1 = a
   $2 = =
   $3 = type of expression
   $4 = ;
*/

assignment
    : ID '=' expression ';'
      {
          int leftType;

          /*
             Check whether left-side variable
             has been declared.
          */

          leftType = getVariableType($1);

          /*
             If both sides are valid,
             perform type checking.
          */

          if(leftType != TYPE_ERROR &&
             $3 != TYPE_ERROR)
          {
              /*
                 Same types are valid.

                 Example:
                 int a;
                 a = 10;

                 int = int
              */

              if(leftType != $3)
              {
                  printf(
                      "Semantic Error: Type mismatch in assignment to '%s' "
                      "(expected %s, got %s)\n",
                      $1,
                      typeName(leftType),
                      typeName($3)
                  );
              }
          }
      }
    ;


/* =====================================================
   EXPRESSIONS
   ===================================================== */

expression
    : ID
      {
          /*
             ID is a variable.

             $1 = variable name

             $$ = type of that variable
          */

          $$ = getVariableType($1);
      }


    | INT_NUM
      {
          /*
             Integer constant.

             Example:
             10

             $$ = int
          */

          $$ = TYPE_INT;
      }


    | FLOAT_NUM
      {
          /*
             Floating-point constant.

             Example:
             6.7

             $$ = float
          */

          $$ = TYPE_FLOAT;
      }


    /* =================================================
       ADDITION
       ================================================= */

    | expression '+' expression
      {
          /*
             Grammar:

             expression '+' expression
                   $1       $2       $3

             $1 = left expression type
             $2 = +
             $3 = right expression type

             $$ = result type

             int + int       -> int
             int + float     -> float
             float + int     -> float
             float + float   -> float
          */

          if($1 == TYPE_ERROR || $3 == TYPE_ERROR)
          {
              $$ = TYPE_ERROR;
          }
          else if($1 == TYPE_FLOAT || $3 == TYPE_FLOAT)
          {
              $$ = TYPE_FLOAT;
          }
          else
          {
              $$ = TYPE_INT;
          }
      }


    /* =================================================
       SUBTRACTION
       ================================================= */

    | expression '-' expression
      {
          if($1 == TYPE_ERROR || $3 == TYPE_ERROR)
          {
              $$ = TYPE_ERROR;
          }
          else if($1 == TYPE_FLOAT || $3 == TYPE_FLOAT)
          {
              $$ = TYPE_FLOAT;
          }
          else
          {
              $$ = TYPE_INT;
          }
      }


    /* =================================================
       MULTIPLICATION
       ================================================= */

    | expression '*' expression
      {
          if($1 == TYPE_ERROR || $3 == TYPE_ERROR)
          {
              $$ = TYPE_ERROR;
          }
          else if($1 == TYPE_FLOAT || $3 == TYPE_FLOAT)
          {
              $$ = TYPE_FLOAT;
          }
          else
          {
              $$ = TYPE_INT;
          }
      }


    /* =================================================
       DIVISION
       ================================================= */

    | expression '/' expression
      {
          if($1 == TYPE_ERROR || $3 == TYPE_ERROR)
          {
              $$ = TYPE_ERROR;
          }
          else if($1 == TYPE_FLOAT || $3 == TYPE_FLOAT)
          {
              $$ = TYPE_FLOAT;
          }
          else
          {
              $$ = TYPE_INT;
          }
      }


    /* =================================================
       MODULO
       ================================================= */

    | expression '%' expression
      {
          /*
             IMPORTANT:

             % requires BOTH operands to be integers.

             Valid:

             5 % 2

             Invalid:

             5 % 6.7
             int % float
          */

          if($1 == TYPE_ERROR || $3 == TYPE_ERROR)
          {
              $$ = TYPE_ERROR;
          }

          else if($1 != TYPE_INT || $3 != TYPE_INT)
          {
              printf(
                  "Semantic Error: Modulo operator '%%' "
                  "requires integer operands\n"
              );

              $$ = TYPE_ERROR;
          }

          else
          {
              /*
                 int % int -> int
              */

              $$ = TYPE_INT;
          }
      }

    ;


%%


/* =====================================================
   SYNTAX ERROR
   ===================================================== */

void yyerror(const char *s)
{
    printf("Syntax Error: %s\n", s);
}


/* =====================================================
   MAIN
   ===================================================== */

int main()
{
    printf("========================================\n");
    printf("          SEMANTIC ANALYZER             \n");
    printf("========================================\n");

    printf("\nEnter the program:\n");

    yyparse();

    displaySymbolTable();

    return 0;
}