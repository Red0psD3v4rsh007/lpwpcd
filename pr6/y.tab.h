#ifndef _yy_defines_h_
#define _yy_defines_h_

#define ID 257
#define INT 258
#define FLOAT 259
#define CHAR 260
#define INT_NUM 261
#define FLOAT_NUM 262
#ifdef YYSTYPE
#undef  YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
#endif
#ifndef YYSTYPE_IS_DECLARED
#define YYSTYPE_IS_DECLARED 1
typedef union YYSTYPE
{
    char *str;
    int type;
} YYSTYPE;
#endif /* !YYSTYPE_IS_DECLARED */
extern YYSTYPE yylval;

#endif /* _yy_defines_h_ */
