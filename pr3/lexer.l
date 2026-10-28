%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_SYMBOLS 100

struct Symbol {
    char name[100];
    char type[50];
    int address;
};

struct Symbol sym_table[MAX_SYMBOLS];
int sym_count = 0;
int current_address = 0x1000;
char current_type[50] = "";

void insert_symbol(const char* name) {
    // Check if symbol already exists in table
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(sym_table[i].name, name) == 0) {
            return; // Already exists, do not insert duplicates
        }
    }
    
    // Add new symbol
    if (sym_count < MAX_SYMBOLS) {
        strcpy(sym_table[sym_count].name, name);
        if (strlen(current_type) > 0) {
            strcpy(sym_table[sym_count].type, current_type);
        } else {
            strcpy(sym_table[sym_count].type, "unknown (undeclared)");
        }
        sym_table[sym_count].address = current_address;
        
        sym_count++;
        current_address += 4; // Simulate 4-byte memory increments
    }
}
%}

%option yylineno
%option noyywrap

/* Regular Definitions */
DIGIT    [0-9]
LETTER   [a-zA-Z_]
ID       {LETTER}({LETTER}|{DIGIT})*
NUMBER   {DIGIT}+("."{DIGIT}+)?

%%

"//".*                  { /* Ignore single-line comments */ }
"/*"([^*]|\*+[^*/])*\*+"/" { /* Ignore multi-line comments */ }

"int"|"float"|"char"    { strcpy(current_type, yytext); printf("DATATYPE: %s\n", yytext); }

"if"                    { printf("CONTROL: if\n"); }
"else"                  { printf("CONTROL: else\n"); }
"while"                 { printf("LOOP: while\n"); }

"+"                     { printf("ARITHMETIC_OP: +\n"); }
"-"                     { printf("ARITHMETIC_OP: -\n"); }

"="                     { printf("ASSIGN_OP: =\n"); }
"<"|">"                 { printf("RELATIONAL_OP: %s\n", yytext); }
";"|"{"|"}"             { strcpy(current_type, ""); printf("PUNCTUATION: %s\n", yytext); }
"("|")"|","             { printf("PUNCTUATION: %s\n", yytext); }

{ID}                    { insert_symbol(yytext); printf("IDENTIFIER: %s\n", yytext); }
{NUMBER}                { printf("NUMBER: %s\n", yytext); }

[ \t\n\r]+              { /* Ignore whitespace */ }

.                       { printf("LEXICAL ERROR [Line %d]: Unrecognized character '%s'\n", yylineno, yytext); }

%%

void print_symbol_table() {
    printf("\n");
    printf("========================================================\n");
    printf("                     SYMBOL TABLE                       \n");
    printf("========================================================\n");
    printf("%-20s | %-20s | %-10s\n", "Identifier Name", "Data Type", "Address");
    printf("---------------------|----------------------|-----------\n");
    for (int i = 0; i < sym_count; i++) {
        printf("%-20s | %-20s | 0x%X\n", sym_table[i].name, sym_table[i].type, sym_table[i].address);
    }
    printf("========================================================\n");
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
    
    print_symbol_table();
    return 0;
}
