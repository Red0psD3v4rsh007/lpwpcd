%{
#include <stdio.h>
#include <string.h>

char name[100][50];
char kind[100][20];
int c=0;

%}

%%
"int"|"float"|"double"|"char"|"bool" { printf("DT"); }
"include"|"stdio.h"|"if"|"else"|"for"|"while"|"do"|"switch"|"case"|"break"|"continue"|"return" { printf("KW"); }
[0-9]+(\.[0-9]+) {printf("FLOAT"); }
[0-9]+     { printf("INT"); }
\'[^']\'    { printf("CHR"); }
\"[^"]*\"    { printf("STR"); }
[_a-zA-Z][_a-zA-Z0-9]*[\(] { printf("FUNC"); 
    char s[100];
    int j=0;
    while(yytext[j] != '(')
    {
	if(yytext[j]=='(')break;
        s[j] = yytext[j];
        j++;
    }
    s[j] = '\0';    
    int x=0;
    for(int i=0;i<c;i++){
	if(strcmp(name[i], s) == 0)x=1;
    }
    if(x==0){        
      strcpy(name[c], s);
      strcpy(kind[c], "Function");
      c++;
    }
    printf("(");

}

[_a-zA-Z][_a-zA-Z0-9]*  { printf("ID"); 
    int x=0;
    for(int i=0;i<c;i++){
	if(strcmp(name[i], yytext) == 0)x=1;
    }
    if(x==0){        
      strcpy(name[c], yytext);
      strcpy(kind[c], "Identifier");
      c++;
    }

}
"("|")"|"{"|"}"|"["|"]" { printf("%s", yytext); }    
"=="|"!="|"<="|">="|"<"|">"|"=" { printf("CMP"); } 
"+"|"-"|"*"|"/"|"%"|"++"|"--"    { printf("OPS"); }
";"|","      { printf("%s", yytext); }
[ \t\r]+       { printf("%s", yytext); }
"//".* ;
"/*"([^*]|\*+[^*/])*\*+"/" ;
\n { printf("\n"); }

%%

int yywrap()
{
    return 1;
}

int main()
{
    yylex();

    printf("\nSymbol Table-----\n");
    for(int i=0;i<c;i++)
    printf("%s\t\t%s\n",name[i],kind[i]);

    return 0;
}