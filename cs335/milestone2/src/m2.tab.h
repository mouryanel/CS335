/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_M2_TAB_H_INCLUDED
# define YY_YY_M2_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    BOOL = 258,                    /* BOOL  */
    UNKNOWN = 259,                 /* UNKNOWN  */
    NUMBER = 260,                  /* NUMBER  */
    LIST = 261,                    /* LIST  */
    RANGE = 262,                   /* RANGE  */
    SELF = 263,                    /* SELF  */
    ARROW = 264,                   /* ARROW  */
    NONE = 265,                    /* NONE  */
    PRIMITIVES = 266,              /* PRIMITIVES  */
    NEWLINE = 267,                 /* NEWLINE  */
    STRING = 268,                  /* STRING  */
    ENDMARKER = 269,               /* ENDMARKER  */
    NAME = 270,                    /* NAME  */
    INDENT = 271,                  /* INDENT  */
    DEDENT = 272,                  /* DEDENT  */
    AT = 273,                      /* AT  */
    RB = 274,                      /* RB  */
    LB = 275,                      /* LB  */
    RP = 276,                      /* RP  */
    LP = 277,                      /* LP  */
    LF = 278,                      /* LF  */
    RF = 279,                      /* RF  */
    DEF = 280,                     /* DEF  */
    SCOL = 281,                    /* SCOL  */
    COL = 282,                     /* COL  */
    EQ = 283,                      /* EQ  */
    SS = 284,                      /* SS  */
    COM = 285,                     /* COM  */
    PE = 286,                      /* PE  */
    ME = 287,                      /* ME  */
    SE = 288,                      /* SE  */
    DE = 289,                      /* DE  */
    MODE = 290,                    /* MODE  */
    ANDE = 291,                    /* ANDE  */
    BOE = 292,                     /* BOE  */
    BXE = 293,                     /* BXE  */
    BX = 294,                      /* BX  */
    BO = 295,                      /* BO  */
    BA = 296,                      /* BA  */
    LSE = 297,                     /* LSE  */
    RSE = 298,                     /* RSE  */
    SSE = 299,                     /* SSE  */
    FFE = 300,                     /* FFE  */
    PRINT = 301,                   /* PRINT  */
    RS = 302,                      /* RS  */
    DEL = 303,                     /* DEL  */
    BREAK = 304,                   /* BREAK  */
    CONTINUE = 305,                /* CONTINUE  */
    RETURN = 306,                  /* RETURN  */
    RAISE = 307,                   /* RAISE  */
    FROM = 308,                    /* FROM  */
    AS = 309,                      /* AS  */
    GLOBAL = 310,                  /* GLOBAL  */
    EXEC = 311,                    /* EXEC  */
    IN = 312,                      /* IN  */
    ASSERT = 313,                  /* ASSERT  */
    IF = 314,                      /* IF  */
    ELIF = 315,                    /* ELIF  */
    WHILE = 316,                   /* WHILE  */
    ELSE = 317,                    /* ELSE  */
    FOR = 318,                     /* FOR  */
    TRY = 319,                     /* TRY  */
    FINALLY = 320,                 /* FINALLY  */
    WITH = 321,                    /* WITH  */
    EXCEPT = 322,                  /* EXCEPT  */
    OR = 323,                      /* OR  */
    AND = 324,                     /* AND  */
    NOT = 325,                     /* NOT  */
    LT = 326,                      /* LT  */
    GT = 327,                      /* GT  */
    EE = 328,                      /* EE  */
    LE = 329,                      /* LE  */
    GE = 330,                      /* GE  */
    NE = 331,                      /* NE  */
    LG = 332,                      /* LG  */
    NI = 333,                      /* NI  */
    IS = 334,                      /* IS  */
    INOT = 335,                    /* INOT  */
    PLUS = 336,                    /* PLUS  */
    MINUS = 337,                   /* MINUS  */
    STAR = 338,                    /* STAR  */
    DIV = 339,                     /* DIV  */
    MOD = 340,                     /* MOD  */
    FF = 341,                      /* FF  */
    NEG = 342,                     /* NEG  */
    BT = 343,                      /* BT  */
    FS = 344,                      /* FS  */
    LS = 345,                      /* LS  */
    CLASS = 346,                   /* CLASS  */
    YIELD = 347,                   /* YIELD  */
    lower = 348,                   /* lower  */
    low = 349,                     /* low  */
    high = 350                     /* high  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 372 "m2.y"

  struct{
        int node_id;
        int Isobj;
        char lexeme[1000]; // storing lexemes for non terminals
        int cnt; /* size of list */
        int size; /* data size  */
        int ndim;
        int nelem; /* storing number of parameters in function */
        // char* argstring;
        // char* arrtype;
        vector<string>* abc;
        char type[1000]; // storing lexemes for non terminals
        char data_type[1000]; // storing data types
        // char* tempvar;
  }attr;


#line 178 "m2.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE YYLTYPE;
struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
};
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


extern YYSTYPE yylval;
extern YYLTYPE yylloc;

int yyparse (void);


#endif /* !YY_YY_M2_TAB_H_INCLUDED  */
