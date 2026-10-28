%{
#include <stdio.h>

static int currentLine = 1;

void showToken(const char *category, const char *text)
{
    printf("%-15s : %s\n", category, text);
}

void reportError(const char *text)
{
    printf("%-15s : %s  [Line %d]\n",
           "Lexical Error", text, currentLine);
}
%}

LETTER      [A-Za-z_]
DIGIT       [0-9]
NAME        {LETTER}({LETTER}|{DIGIT})*
INTEGER     {DIGIT}+

%%

"int"|"float"|"char"|"if"|"else"|"while"|"for"|"return" { showToken("Keyword", yytext); }

{NAME}      { showToken("Identifier", yytext); }

{INTEGER}   { showToken("Number", yytext); }

[+\-*/=]    { showToken("Operator", yytext); }

[;,(){}]    { showToken("Delimiter", yytext); }

"//"[^\n]*  { /* skip single-line comments */ }

[ \t\r]+    { /* ignore whitespace */ }

\n          { ++currentLine; }

.           { reportError(yytext); }

%%

int yywrap(void)
{
    return 1;
}

int main(void)
{


    yylex();


    return 0;
}
