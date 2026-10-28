%{
#include <stdio.h>
%}

/* Regular Definitions */
DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       {LETTER}({LETTER}|{DIGIT})*
NUMBER   {DIGIT}+
FLOAT    {DIGIT}+"."{DIGIT}*

%%

"//".*                  { printf("COMMENT: %s\n", yytext); }
"/*"([^*]|\*+[^*/])*\*+"/" { printf("MULTI-LINE COMMENT\n"); }

"int"|"float"|"void"|"char"|"return"|"if"|"else"|"while"|"for"|"do" { printf("KEYWORD: %s\n", yytext); }

{ID}                    { printf("IDENTIFIER: %s\n", yytext); }
{NUMBER}                { printf("INTEGER: %s\n", yytext); }
{FLOAT}                 { printf("FLOAT: %s\n", yytext); }

"+"|"-"|"*"|"/"|"%"     { printf("ARITHMETIC OPERATOR: %s\n", yytext); }
"="                     { printf("ASSIGNMENT OPERATOR: %s\n", yytext); }
"=="|"<"|">"|"<="|">="|"!=" { printf("RELATIONAL OPERATOR: %s\n", yytext); }
"&&"|"||"|"!"           { printf("LOGICAL OPERATOR: %s\n", yytext); }

";"|","|"("|")"|"{"|"}"|"["|"]" { printf("PUNCTUATION: %s\n", yytext); }

[ \t\n\r]+              { /* Ignore whitespace */ }
.                       { printf("UNKNOWN CHARACTER: %s\n", yytext); }

%%

/* The yywrap function is called by lex when input is exhausted */
int yywrap() {
    return 1;
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Could not open %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    printf("Starting Lexical Analysis...\n");
    printf("----------------------------\n");
    yylex();
    printf("----------------------------\n");
    printf("Lexical Analysis Complete.\n");
    return 0;
}
