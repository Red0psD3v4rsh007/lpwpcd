%{
#include <stdio.h>
%}

%option yylineno
%option noyywrap

/* Regular Definitions */
DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       {LETTER}({LETTER}|{DIGIT})*
NUMBER   {DIGIT}+

%%

"//".*                  { /* Ignore single-line comments */ }
"/*"([^*]|\*+[^*/])*\*+"/" { /* Ignore multi-line comments */ }

"if"                    { printf("CONTROL: if\n"); }
"else"                  { printf("CONTROL: else\n"); }
"while"                 { printf("LOOP: while\n"); }

"+"                     { printf("ARITHMETIC_OP: +\n"); }
"-"                     { printf("ARITHMETIC_OP: -\n"); }

"="                     { printf("ASSIGN_OP: =\n"); }
"<"|">"                 { printf("RELATIONAL_OP: %s\n", yytext); }
";"|"("|")"|"{"|"}"     { printf("PUNCTUATION: %s\n", yytext); }

{ID}                    { printf("IDENTIFIER: %s\n", yytext); }
{NUMBER}                { printf("NUMBER: %s\n", yytext); }

[ \t\n\r]+              { /* Ignore whitespace */ }

.                       { printf("LEXICAL ERROR [Line %d]: Unrecognized character '%s'\n", yylineno, yytext); }

%%

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
