/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output, and Bison version.  */
#define YYBISON 30802

/* Bison version string.  */
#define YYBISON_VERSION "3.8.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "m2.y"

#include <bits/stdc++.h>
#include<fstream>
using namespace std;

// global variables declaration, used in grammar 
int nelem=0; // used for number of elements in function arguments list
 
#define YYERROR_VERBOSE 1

int cls=0;
map<int, string> node_names;

int sym_counts=0;

class Sym_Entry {
      public:
        string token;
        string type;
        string scope_name;

        int offset;
        int line;

        map<int,vector<int>> arrshape;

        Sym_Entry(string temp_toke, string temp_typ, int temp_offse, string scope_nam, int temp_lin, int argn){
          token = temp_toke;
          type = temp_typ;
          offset = temp_offse;
          scope_name = scope_nam;
          line = temp_lin;
          nelem=0;
        }
          Sym_Entry()
        { 

        }

        void print_entry(){
          cout << token << " " << type << " " << offset << " " << scope_name << " " << line  <<" "<<endl;
        }

        
    };

class Sym_Table {
    public:
    // vectors 
    vector<string> func_arg;
    vector<string> init_func_args;
    string table_name;

    //maps
    map<string, Sym_Entry> table;
    map<string, vector<string>> class_func_args; // class ke functions ke mapping between function and its parameters 

    // primitives
    int level_no;
    int sz=0;

        Sym_Table* parent;
    void insert(string lexeme, string token, string type, int offset, string scope_name, int line, int argno){
        // cout<<lexeme<<" "<<scope_name<<" "<<token<<"\n";
        if(table.find(lexeme) != table.end()){
            cout << "Error: Redeclaration of " << lexeme << " at line no : " << line << endl;  
            exit(0);
        }
        table[lexeme] = Sym_Entry(token, type, offset, scope_name, line, argno);

    }

    Sym_Table(Sym_Table* par){
        parent = par;
        if(par==NULL){
            // global symbol table
            level_no = 0;
        }
        else{
            // new symbol table 
            level_no = par->level_no + 1;
        }
    }
      Sym_Table()
    {

    }



    void print_table(){
        for(auto it=table.begin(); it!=table.end(); it++){
                cout<<it->first<<": ";
                it->second.print_entry();
        }
    }
    void print_csv_table(){
        string file_name="symbol_table_"+table_name+".csv";
        ofstream fout;
        fout.open(file_name);
        // if(!file.is_open())
        // {
        //         cerr<<" Failed to open file\n";
        //         exit(0);
        // }
        // cout<<file_name<<" ..";
        // cout<<"start csv printing*********\n";
        // cout<<"Lexeme , Token , Type, Line \n";
        fout<<"Lexeme , Token , Type, Line \n";
        for(auto it=table.begin(); it!=table.end(); it++){
        // cout<<it->first<<": ";
                // cout<<it->first<<" , "<<it->second.token << " , " << it->second.type << " , " << it->second.line <<endl;
                fout<<it->first<<" , "<<it->second.token << " , " ;
                if((it->second.type.size()>0)) fout<< it->second.type ;
                else fout<< it->second.token;
                fout<< " , " << it->second.line <<endl;
        }
        // cout<<"end csv printing*********\n";
        fout.close();
    }
};



// Global variables declaration here :

int list_size =0;
int offset = 0; // for offset purpose 
stack<string> scope_names; // stack machine for scope names
Sym_Table* curr_table = new Sym_Table(NULL); // present symbol table we are working on
stack<Sym_Table*> tables; // stack machine for tables 
string curr_scope = "Global"; // current scot element, and it->second gives the corresponding value.pe we are working on 
stack<int> offsets; // stack machine for offsets
map<string,Sym_Table*> class_name_map; /* keeping map of  [ class_name , symbol_table_pointer ] */
map<string, int> all_available_var; /* keeping track of all declared variables available for using i.e present scope can have access too asll those fellows */
map<string, vector<string> > func_decl_list ; // keeps trrack of the declar3ed functions (only normal functions not for class functions)
map<string, vector<string> > func_init_list ; // keeps trrack of the declar3ed functions (only normal functions not for class functions)
map<pair<string,string>, vector<string> > class_func_list ;
string class_name_present;
vector<Sym_Table*> list_of_Symbol_Tables(1, curr_table); // keeping track of all symbol tables (all symbol tables in a vector)
vector< pair<string,pair<string,int>> > funcparam; // keeping track of function parameters in a function
#define YYDEBUG 1 


extern int yylex();
extern int yyparse();
extern vector<int> indent;
extern FILE *yyin;
extern int yylineno;

int dfn;
vector<int> curr_dfn;
vector<string> curr_labels;

string dummy(string temp) {
        string temp2 = temp;
        return temp2;
}

void yyerror (char const *s)
{
        cout<<s<<" at line no "<<yylineno<<"\n";
}
void timeout_handler(int signum) {
    printf("Timeout: Parser execution took too long.\n");
    exit(EXIT_FAILURE);
}
void create_node(string lexeme,string label,int dfn){
        // cout<<"  ";
        // cout<< dfn<<" [label=\""<<label;
        if(label == "NAME" )
        {
                // cout<<" ( "  ;

                for(int i=0;i<lexeme.size();i++)
                {
                        if( (lexeme[i]>='a' && lexeme[i]<='z') 
                        || (lexeme[i]>='A' && lexeme[i]<='Z') 
                        || (lexeme[i]=='_')
                        || (lexeme[i]>='0' && lexeme[i]<='9')
                        ) { }
                        else break;
                }
                // cout<<" ) ";
        }
        else if(lexeme.length()){
        //       cout<<" ( "  ;

              for(int i=0;i<lexeme.length();i++){
                // if(lexeme[i]=='\"')cout<<'\\';
                // cout<<lexeme[i];
              }
        //       cout<<" ) ";
        }
        // cout<<"\"]\n";
}
void create_edge(vector<int> children,int parent){
//   cout<<"  ";
//   cout<<parent<<"->{";

  for(int i=0;i<children.size();i++){
//    cout<<children[i]<<(i<children.size()-1?",":"");
  }
//   cout<<"}\n";
  if(children.size()>1)
  {
//   cout<<"  ";  
//     cout<<"{rank=same; ";
    for(int i=0;i<children.size();i++){
//       cout<<children[i]<<(i<children.size()-1?"->":" [style=invis];}\n");
    }
  }
}

bool isSubstringPresent(string str, string substr) {
    // Find the substring in the main string
    size_t found = str.find(substr);
    
    // If found is not equal to string::npos, it means substring exists
    if (found != string::npos) {
        return true;
    }
    return false;
}

void printKeys(map<string, vector<string>>& myMap) {
    std::cout << "Keys in the map:" << std::endl;
    for (const auto& entry : myMap) {
        cout << entry.first << endl;
    }
}

void type_check_func(string a, string b){

        if((isSubstringPresent(a,"int") &&  isSubstringPresent(b,"float")) || (isSubstringPresent(b,"float") && isSubstringPresent(a,"int"))) return;
        if((a=="int" && b=="float") || (b=="int" && a=="float")) return;
        if(a!=b && isSubstringPresent(a,b)==false && isSubstringPresent(b,a)==false)
        {
                cout<<"Error : type conversion of "<< a <<" to " << b <<" at line number : "<<yylineno<<endl;
                exit(0);
        }
        return ;
 }
 string  In_BTW_BOXES(string tt){
        for(int i=0;i<(int)(tt.size());i++)
        {
                if(tt[i]=='[')
                {
                        string ans;
                        for(int j=i+1;j<(int)(tt.size()-1);j++) ans.push_back(tt[j]);
                        return ans;
                }
        }
        return tt;
 }


string substring_after_dot(string temp){
        for(int i=0;i<(int)temp.size();i++)
        {
                if(temp[i]=='.')
                {
                        string ans;
                        for(int j=i+1;j<(int)temp.size();j++) ans.push_back(temp[j]);
                        return ans;
                }
        }
        return temp;
}

int say_size_of_table(Sym_Table* headd){

        // cout<<"start hertre *********\n";
        // int sz=0;
        // for(auto it: headd->table)
        // {
        //         cout<<it.first<<" "<<it.second.offset<<"\n";
        //          sz+=(it.second.offset);
        // }
        // cout<<"ends hertre *********\n";
        return headd->sz;
}

int check_is_declared_or_not(string lexi){
        Sym_Table* go_upp=curr_table;
        while(go_upp!=NULL)
        {
                if(go_upp->table.find(lexi)!=go_upp->table.end()) return 1;
                go_upp=go_upp->parent;
        }
        return 0;
}

int say2(string lexi){
        if(lexi[0]=='"') return 5;
        if(lexi=="True" || lexi=="False") return 4;
        if(lexi[0]=='_' || (lexi[0]>='a' && lexi[0]<='z') || (lexi[0]>='A' && lexi[0]<='Z') ) return 1;
        for(int i=0;i<lexi.size();i++)
        {
                if(lexi[i]=='.') return 3;
        }
        return 2;

}

string say(string lexi){
        int n=say2(lexi);
        if(n==1)
        {
                // identifier or class 
                Sym_Table* go_upp=curr_table;
                while(go_upp!=NULL)
                {
                        if(go_upp->table.find(lexi)!=go_upp->table.end()) return go_upp->table[lexi].type;
                        go_upp=go_upp->parent;
                }
                return "";
        }
        else if(n==2)
        {
                // int constant
                return "int";
        }
        else if(n==3)
        {
                // float constant
                return "float";
        }
        else if(n==4)
        {
                // bool constant
                return "bool";
        }
        else if(n==5)
        {
                return "str";
        } return "";
}

string solve1(string t){
        /* case: .__init__( */
        string ans;
        for(int i=1;i<t.size()-1;i++) ans.push_back(t[i]);
        return ans;
}

string solve2(string t){
        string ans;
        for(int i=0;i<t.size();i++) ans.push_back(t[i]);
        return ans;
}

void before_parsing(){
        /* insert len function */
        /* 
               def len ( data : list[int]  ): 
        */ 
        func_decl_list["len"].push_back("list[int]");
}



#line 434 "m2.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

#include "m2.tab.h"
/* Symbol kind.  */
enum yysymbol_kind_t
{
  YYSYMBOL_YYEMPTY = -2,
  YYSYMBOL_YYEOF = 0,                      /* "end of file"  */
  YYSYMBOL_YYerror = 1,                    /* error  */
  YYSYMBOL_YYUNDEF = 2,                    /* "invalid token"  */
  YYSYMBOL_BOOL = 3,                       /* BOOL  */
  YYSYMBOL_UNKNOWN = 4,                    /* UNKNOWN  */
  YYSYMBOL_NUMBER = 5,                     /* NUMBER  */
  YYSYMBOL_LIST = 6,                       /* LIST  */
  YYSYMBOL_RANGE = 7,                      /* RANGE  */
  YYSYMBOL_SELF = 8,                       /* SELF  */
  YYSYMBOL_ARROW = 9,                      /* ARROW  */
  YYSYMBOL_NONE = 10,                      /* NONE  */
  YYSYMBOL_PRIMITIVES = 11,                /* PRIMITIVES  */
  YYSYMBOL_NEWLINE = 12,                   /* NEWLINE  */
  YYSYMBOL_STRING = 13,                    /* STRING  */
  YYSYMBOL_ENDMARKER = 14,                 /* ENDMARKER  */
  YYSYMBOL_NAME = 15,                      /* NAME  */
  YYSYMBOL_INDENT = 16,                    /* INDENT  */
  YYSYMBOL_DEDENT = 17,                    /* DEDENT  */
  YYSYMBOL_AT = 18,                        /* AT  */
  YYSYMBOL_RB = 19,                        /* RB  */
  YYSYMBOL_LB = 20,                        /* LB  */
  YYSYMBOL_RP = 21,                        /* RP  */
  YYSYMBOL_LP = 22,                        /* LP  */
  YYSYMBOL_LF = 23,                        /* LF  */
  YYSYMBOL_RF = 24,                        /* RF  */
  YYSYMBOL_DEF = 25,                       /* DEF  */
  YYSYMBOL_SCOL = 26,                      /* SCOL  */
  YYSYMBOL_COL = 27,                       /* COL  */
  YYSYMBOL_EQ = 28,                        /* EQ  */
  YYSYMBOL_SS = 29,                        /* SS  */
  YYSYMBOL_COM = 30,                       /* COM  */
  YYSYMBOL_PE = 31,                        /* PE  */
  YYSYMBOL_ME = 32,                        /* ME  */
  YYSYMBOL_SE = 33,                        /* SE  */
  YYSYMBOL_DE = 34,                        /* DE  */
  YYSYMBOL_MODE = 35,                      /* MODE  */
  YYSYMBOL_ANDE = 36,                      /* ANDE  */
  YYSYMBOL_BOE = 37,                       /* BOE  */
  YYSYMBOL_BXE = 38,                       /* BXE  */
  YYSYMBOL_BX = 39,                        /* BX  */
  YYSYMBOL_BO = 40,                        /* BO  */
  YYSYMBOL_BA = 41,                        /* BA  */
  YYSYMBOL_LSE = 42,                       /* LSE  */
  YYSYMBOL_RSE = 43,                       /* RSE  */
  YYSYMBOL_SSE = 44,                       /* SSE  */
  YYSYMBOL_FFE = 45,                       /* FFE  */
  YYSYMBOL_PRINT = 46,                     /* PRINT  */
  YYSYMBOL_RS = 47,                        /* RS  */
  YYSYMBOL_DEL = 48,                       /* DEL  */
  YYSYMBOL_BREAK = 49,                     /* BREAK  */
  YYSYMBOL_CONTINUE = 50,                  /* CONTINUE  */
  YYSYMBOL_RETURN = 51,                    /* RETURN  */
  YYSYMBOL_RAISE = 52,                     /* RAISE  */
  YYSYMBOL_FROM = 53,                      /* FROM  */
  YYSYMBOL_AS = 54,                        /* AS  */
  YYSYMBOL_GLOBAL = 55,                    /* GLOBAL  */
  YYSYMBOL_EXEC = 56,                      /* EXEC  */
  YYSYMBOL_IN = 57,                        /* IN  */
  YYSYMBOL_ASSERT = 58,                    /* ASSERT  */
  YYSYMBOL_IF = 59,                        /* IF  */
  YYSYMBOL_ELIF = 60,                      /* ELIF  */
  YYSYMBOL_WHILE = 61,                     /* WHILE  */
  YYSYMBOL_ELSE = 62,                      /* ELSE  */
  YYSYMBOL_FOR = 63,                       /* FOR  */
  YYSYMBOL_TRY = 64,                       /* TRY  */
  YYSYMBOL_FINALLY = 65,                   /* FINALLY  */
  YYSYMBOL_WITH = 66,                      /* WITH  */
  YYSYMBOL_EXCEPT = 67,                    /* EXCEPT  */
  YYSYMBOL_OR = 68,                        /* OR  */
  YYSYMBOL_AND = 69,                       /* AND  */
  YYSYMBOL_NOT = 70,                       /* NOT  */
  YYSYMBOL_LT = 71,                        /* LT  */
  YYSYMBOL_GT = 72,                        /* GT  */
  YYSYMBOL_EE = 73,                        /* EE  */
  YYSYMBOL_LE = 74,                        /* LE  */
  YYSYMBOL_GE = 75,                        /* GE  */
  YYSYMBOL_NE = 76,                        /* NE  */
  YYSYMBOL_LG = 77,                        /* LG  */
  YYSYMBOL_NI = 78,                        /* NI  */
  YYSYMBOL_IS = 79,                        /* IS  */
  YYSYMBOL_INOT = 80,                      /* INOT  */
  YYSYMBOL_PLUS = 81,                      /* PLUS  */
  YYSYMBOL_MINUS = 82,                     /* MINUS  */
  YYSYMBOL_STAR = 83,                      /* STAR  */
  YYSYMBOL_DIV = 84,                       /* DIV  */
  YYSYMBOL_MOD = 85,                       /* MOD  */
  YYSYMBOL_FF = 86,                        /* FF  */
  YYSYMBOL_NEG = 87,                       /* NEG  */
  YYSYMBOL_BT = 88,                        /* BT  */
  YYSYMBOL_FS = 89,                        /* FS  */
  YYSYMBOL_LS = 90,                        /* LS  */
  YYSYMBOL_CLASS = 91,                     /* CLASS  */
  YYSYMBOL_YIELD = 92,                     /* YIELD  */
  YYSYMBOL_lower = 93,                     /* lower  */
  YYSYMBOL_low = 94,                       /* low  */
  YYSYMBOL_high = 95,                      /* high  */
  YYSYMBOL_YYACCEPT = 96,                  /* $accept  */
  YYSYMBOL_start = 97,                     /* start  */
  YYSYMBOL_epsilon = 98,                   /* epsilon  */
  YYSYMBOL_single_input = 99,              /* single_input  */
  YYSYMBOL_file_input = 100,               /* file_input  */
  YYSYMBOL_NEWstmt = 101,                  /* NEWstmt  */
  YYSYMBOL_eval_input = 102,               /* eval_input  */
  YYSYMBOL_Nnew = 103,                     /* Nnew  */
  YYSYMBOL_decorator = 104,                /* decorator  */
  YYSYMBOL_line38 = 105,                   /* line38  */
  YYSYMBOL_line41 = 106,                   /* line41  */
  YYSYMBOL_decorated = 107,                /* decorated  */
  YYSYMBOL_line40 = 108,                   /* line40  */
  YYSYMBOL_decorators = 109,               /* decorators  */
  YYSYMBOL_funcdef = 110,                  /* funcdef  */
  YYSYMBOL_111_1 = 111,                    /* $@1  */
  YYSYMBOL_112_2 = 112,                    /* $@2  */
  YYSYMBOL_parameters = 113,               /* parameters  */
  YYSYMBOL_fpdef = 114,                    /* fpdef  */
  YYSYMBOL_fplist = 115,                   /* fplist  */
  YYSYMBOL_lines57 = 116,                  /* lines57  */
  YYSYMBOL_fpdefq = 117,                   /* fpdefq  */
  YYSYMBOL_range_func = 118,               /* range_func  */
  YYSYMBOL_stmt = 119,                     /* stmt  */
  YYSYMBOL_simple_stmt = 120,              /* simple_stmt  */
  YYSYMBOL_line57 = 121,                   /* line57  */
  YYSYMBOL_small_stmt = 122,               /* small_stmt  */
  YYSYMBOL_expr_stmt = 123,                /* expr_stmt  */
  YYSYMBOL_line61 = 124,                   /* line61  */
  YYSYMBOL_line62 = 125,                   /* line62  */
  YYSYMBOL_EQ_yield_expr_testlist = 126,   /* EQ_yield_expr_testlist  */
  YYSYMBOL_augassign = 127,                /* augassign  */
  YYSYMBOL_print_stmt = 128,               /* print_stmt  */
  YYSYMBOL_line67 = 129,                   /* line67  */
  YYSYMBOL_lines74 = 130,                  /* lines74  */
  YYSYMBOL_lines75 = 131,                  /* lines75  */
  YYSYMBOL_line68 = 132,                   /* line68  */
  YYSYMBOL_del_stmt = 133,                 /* del_stmt  */
  YYSYMBOL_flow_stmt = 134,                /* flow_stmt  */
  YYSYMBOL_break_stmt = 135,               /* break_stmt  */
  YYSYMBOL_continue_stmt = 136,            /* continue_stmt  */
  YYSYMBOL_return_stmt = 137,              /* return_stmt  */
  YYSYMBOL_lines84 = 138,                  /* lines84  */
  YYSYMBOL_yield_stmt = 139,               /* yield_stmt  */
  YYSYMBOL_raise_stmt = 140,               /* raise_stmt  */
  YYSYMBOL_lines87 = 141,                  /* lines87  */
  YYSYMBOL_lines88 = 142,                  /* lines88  */
  YYSYMBOL_lines89 = 143,                  /* lines89  */
  YYSYMBOL_dotted_name = 144,              /* dotted_name  */
  YYSYMBOL_FS_NAME = 145,                  /* FS_NAME  */
  YYSYMBOL_global_stmt = 146,              /* global_stmt  */
  YYSYMBOL_COM_NAME = 147,                 /* COM_NAME  */
  YYSYMBOL_exec_stmt = 148,                /* exec_stmt  */
  YYSYMBOL_lines110 = 149,                 /* lines110  */
  YYSYMBOL_assert_stmt = 150,              /* assert_stmt  */
  YYSYMBOL_prim = 151,                     /* prim  */
  YYSYMBOL_primitives = 152,               /* primitives  */
  YYSYMBOL_prime = 153,                    /* prime  */
  YYSYMBOL_declare_stmt = 154,             /* declare_stmt  */
  YYSYMBOL_compound_stmt = 155,            /* compound_stmt  */
  YYSYMBOL_if_stmt = 156,                  /* if_stmt  */
  YYSYMBOL_lines115 = 157,                 /* lines115  */
  YYSYMBOL_ELIF_test_COL_suite = 158,      /* ELIF_test_COL_suite  */
  YYSYMBOL_while_stmt = 159,               /* while_stmt  */
  YYSYMBOL_for_stmt = 160,                 /* for_stmt  */
  YYSYMBOL_try_stmt = 161,                 /* try_stmt  */
  YYSYMBOL_line105 = 162,                  /* line105  */
  YYSYMBOL_lines121 = 163,                 /* lines121  */
  YYSYMBOL_except_clause_COL_suite = 164,  /* except_clause_COL_suite  */
  YYSYMBOL_with_stmt = 165,                /* with_stmt  */
  YYSYMBOL_line108 = 166,                  /* line108  */
  YYSYMBOL_COM_with_item = 167,            /* COM_with_item  */
  YYSYMBOL_with_item = 168,                /* with_item  */
  YYSYMBOL_lines127 = 169,                 /* lines127  */
  YYSYMBOL_except_clause = 170,            /* except_clause  */
  YYSYMBOL_lines129 = 171,                 /* lines129  */
  YYSYMBOL_lines130 = 172,                 /* lines130  */
  YYSYMBOL_line112 = 173,                  /* line112  */
  YYSYMBOL_suite = 174,                    /* suite  */
  YYSYMBOL_stmt_ = 175,                    /* stmt_  */
  YYSYMBOL_testlist_safe = 176,            /* testlist_safe  */
  YYSYMBOL_lines135 = 177,                 /* lines135  */
  YYSYMBOL_COM_old_test = 178,             /* COM_old_test  */
  YYSYMBOL_old_test = 179,                 /* old_test  */
  YYSYMBOL_test = 180,                     /* test  */
  YYSYMBOL_lines142 = 181,                 /* lines142  */
  YYSYMBOL_or_test = 182,                  /* or_test  */
  YYSYMBOL_OR_and_test = 183,              /* OR_and_test  */
  YYSYMBOL_and_test = 184,                 /* and_test  */
  YYSYMBOL_AND_not_test = 185,             /* AND_not_test  */
  YYSYMBOL_not_test = 186,                 /* not_test  */
  YYSYMBOL_comparision = 187,              /* comparision  */
  YYSYMBOL_comp_op_expr = 188,             /* comp_op_expr  */
  YYSYMBOL_comp_op = 189,                  /* comp_op  */
  YYSYMBOL_expr = 190,                     /* expr  */
  YYSYMBOL_BO_xor_expr = 191,              /* BO_xor_expr  */
  YYSYMBOL_xor_expr = 192,                 /* xor_expr  */
  YYSYMBOL_BX_and_expr = 193,              /* BX_and_expr  */
  YYSYMBOL_and_expr = 194,                 /* and_expr  */
  YYSYMBOL_BA_shift_expr = 195,            /* BA_shift_expr  */
  YYSYMBOL_shift_expr = 196,               /* shift_expr  */
  YYSYMBOL_LSRS_arith_expr = 197,          /* LSRS_arith_expr  */
  YYSYMBOL_line137 = 198,                  /* line137  */
  YYSYMBOL_arith_expr = 199,               /* arith_expr  */
  YYSYMBOL_PLUSMINUS_term = 200,           /* PLUSMINUS_term  */
  YYSYMBOL_line140 = 201,                  /* line140  */
  YYSYMBOL_term = 202,                     /* term  */
  YYSYMBOL_STARDIVMODFF_factor = 203,      /* STARDIVMODFF_factor  */
  YYSYMBOL_line143 = 204,                  /* line143  */
  YYSYMBOL_factor = 205,                   /* factor  */
  YYSYMBOL_line145 = 206,                  /* line145  */
  YYSYMBOL_power = 207,                    /* power  */
  YYSYMBOL_atom_expr = 208,                /* atom_expr  */
  YYSYMBOL_trailer_ = 209,                 /* trailer_  */
  YYSYMBOL_atom = 210,                     /* atom  */
  YYSYMBOL_lines172 = 211,                 /* lines172  */
  YYSYMBOL_lines173 = 212,                 /* lines173  */
  YYSYMBOL_lines174 = 213,                 /* lines174  */
  YYSYMBOL_listmaker = 214,                /* listmaker  */
  YYSYMBOL_line151 = 215,                  /* line151  */
  YYSYMBOL_testlist_comp = 216,            /* testlist_comp  */
  YYSYMBOL_line153 = 217,                  /* line153  */
  YYSYMBOL_trailer = 218,                  /* trailer  */
  YYSYMBOL_lines183 = 219,                 /* lines183  */
  YYSYMBOL_subscriptlist = 220,            /* subscriptlist  */
  YYSYMBOL_line158 = 221,                  /* line158  */
  YYSYMBOL_COM_subscript = 222,            /* COM_subscript  */
  YYSYMBOL_subscript = 223,                /* subscript  */
  YYSYMBOL_sliceop = 224,                  /* sliceop  */
  YYSYMBOL_lines189 = 225,                 /* lines189  */
  YYSYMBOL_lines190 = 226,                 /* lines190  */
  YYSYMBOL_exprlist = 227,                 /* exprlist  */
  YYSYMBOL_line163 = 228,                  /* line163  */
  YYSYMBOL_COM_expr = 229,                 /* COM_expr  */
  YYSYMBOL_testlist = 230,                 /* testlist  */
  YYSYMBOL_line166 = 231,                  /* line166  */
  YYSYMBOL_COM_test = 232,                 /* COM_test  */
  YYSYMBOL_dictorsetmaker = 233,           /* dictorsetmaker  */
  YYSYMBOL_line169 = 234,                  /* line169  */
  YYSYMBOL_line170 = 235,                  /* line170  */
  YYSYMBOL_COM_test_COL_test = 236,        /* COM_test_COL_test  */
  YYSYMBOL_classdef = 237,                 /* classdef  */
  YYSYMBOL_238_3 = 238,                    /* $@3  */
  YYSYMBOL_lines202 = 239,                 /* lines202  */
  YYSYMBOL_arglist = 240,                  /* arglist  */
  YYSYMBOL_line175 = 241,                  /* line175  */
  YYSYMBOL_argument_COM = 242,             /* argument_COM  */
  YYSYMBOL_argument = 243,                 /* argument  */
  YYSYMBOL_lines209 = 244,                 /* lines209  */
  YYSYMBOL_list_iter = 245,                /* list_iter  */
  YYSYMBOL_list_for = 246,                 /* list_for  */
  YYSYMBOL_list_if = 247,                  /* list_if  */
  YYSYMBOL_lines214 = 248,                 /* lines214  */
  YYSYMBOL_comp_iter = 249,                /* comp_iter  */
  YYSYMBOL_comp_for = 250,                 /* comp_for  */
  YYSYMBOL_comp_if = 251,                  /* comp_if  */
  YYSYMBOL_lines219 = 252,                 /* lines219  */
  YYSYMBOL_testlist1 = 253,                /* testlist1  */
  YYSYMBOL_yield_expr = 254                /* yield_expr  */
};
typedef enum yysymbol_kind_t yysymbol_kind_t;




#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

/* Work around bug in HP-UX 11.23, which defines these macros
   incorrectly for preprocessor constants.  This workaround can likely
   be removed in 2023, as HPE has promised support for HP-UX 11.23
   (aka HP-UX 11i v2) only through the end of 2022; see Table 2 of
   <https://h20195.www2.hpe.com/V2/getpdf.aspx/4AA4-7673ENW.pdf>.  */
#ifdef __hpux
# undef UINT_LEAST8_MAX
# undef UINT_LEAST16_MAX
# define UINT_LEAST8_MAX 255
# define UINT_LEAST16_MAX 65535
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))


/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if 1

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* 1 */

#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL \
             && defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
  YYLTYPE yyls_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE) \
             + YYSIZEOF (YYLTYPE)) \
      + 2 * YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  134
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1176

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  96
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  159
/* YYNRULES -- Number of rules.  */
#define YYNRULES  338
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  536

/* YYMAXUTOK -- Last valid token kind.  */
#define YYMAXUTOK   350


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK                     \
   ? YY_CAST (yysymbol_kind_t, yytranslate[YYX])        \
   : YYSYMBOL_YYUNDEF)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95
};

#if YYDEBUG
/* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   402,   402,   403,   404,   406,   408,   409,   410,   412,
     413,   415,   416,   417,   418,   420,   421,   423,   424,   426,
     427,   429,   431,   432,   434,   436,   437,   439,   440,   442,
     442,   547,   547,   653,   654,   656,   660,   666,   667,   669,
     670,   672,   673,   675,   676,   677,   679,   680,   682,   683,
     685,   686,   688,   689,   690,   691,   692,   693,   694,   695,
     697,   698,   700,   701,   703,   704,   706,   707,   709,   710,
     711,   712,   713,   714,   715,   716,   717,   718,   719,   720,
     722,   724,   725,   727,   728,   730,   731,   733,   734,   736,
     738,   739,   740,   741,   742,   744,   746,   748,   750,   751,
     753,   755,   757,   758,   760,   761,   763,   764,   766,   767,
     769,   770,   772,   773,   775,   776,   778,   780,   781,   783,
     785,   786,   788,   789,   794,   795,   797,   878,   970,   971,
     972,   973,   974,   975,   976,   977,   979,   980,   982,   983,
     985,   986,   988,   990,   991,   993,   995,   996,   998,   999,
    1001,  1002,  1004,  1006,  1007,  1009,  1010,  1012,  1014,  1015,
    1017,  1019,  1020,  1022,  1023,  1025,  1026,  1028,  1029,  1031,
    1032,  1034,  1036,  1037,  1039,  1040,  1042,  1044,  1046,  1047,
    1049,  1050,  1052,  1053,  1055,  1056,  1058,  1059,  1061,  1062,
    1064,  1065,  1067,  1068,  1070,  1071,  1072,  1073,  1074,  1075,
    1076,  1077,  1078,  1079,  1080,  1082,  1083,  1085,  1086,  1088,
    1089,  1091,  1092,  1094,  1095,  1097,  1098,  1100,  1101,  1103,
    1104,  1106,  1107,  1109,  1110,  1112,  1113,  1115,  1116,  1118,
    1119,  1121,  1122,  1124,  1125,  1126,  1127,  1129,  1130,  1132,
    1133,  1134,  1136,  1137,  1143,  1333,  1335,  1341,  1343,  1344,
    1345,  1346,  1347,  1348,  1349,  1350,  1351,  1352,  1354,  1355,
    1356,  1358,  1359,  1361,  1362,  1364,  1366,  1367,  1368,  1370,
    1372,  1373,  1374,  1376,  1380,  1381,  1386,  1387,  1389,  1391,
    1392,  1394,  1395,  1397,  1398,  1399,  1401,  1403,  1404,  1406,
    1407,  1409,  1411,  1412,  1414,  1415,  1417,  1419,  1420,  1422,
    1423,  1425,  1426,  1428,  1429,  1430,  1432,  1433,  1434,  1436,
    1437,  1439,  1439,  1495,  1496,  1498,  1499,  1501,  1503,  1507,
    1511,  1512,  1514,  1515,  1517,  1518,  1520,  1522,  1524,  1525,
    1527,  1528,  1529,  1531,  1533,  1534,  1536,  1537,  1539
};
#endif

/** Accessing symbol of state STATE.  */
#define YY_ACCESSING_SYMBOL(State) YY_CAST (yysymbol_kind_t, yystos[State])

#if 1
/* The user-facing name of the symbol whose (internal) number is
   YYSYMBOL.  No bounds checking.  */
static const char *yysymbol_name (yysymbol_kind_t yysymbol) YY_ATTRIBUTE_UNUSED;

static const char *
yysymbol_name (yysymbol_kind_t yysymbol)
{
  static const char *const yy_sname[] =
  {
  "end of file", "error", "invalid token", "BOOL", "UNKNOWN", "NUMBER",
  "LIST", "RANGE", "SELF", "ARROW", "NONE", "PRIMITIVES", "NEWLINE",
  "STRING", "ENDMARKER", "NAME", "INDENT", "DEDENT", "AT", "RB", "LB",
  "RP", "LP", "LF", "RF", "DEF", "SCOL", "COL", "EQ", "SS", "COM", "PE",
  "ME", "SE", "DE", "MODE", "ANDE", "BOE", "BXE", "BX", "BO", "BA", "LSE",
  "RSE", "SSE", "FFE", "PRINT", "RS", "DEL", "BREAK", "CONTINUE", "RETURN",
  "RAISE", "FROM", "AS", "GLOBAL", "EXEC", "IN", "ASSERT", "IF", "ELIF",
  "WHILE", "ELSE", "FOR", "TRY", "FINALLY", "WITH", "EXCEPT", "OR", "AND",
  "NOT", "LT", "GT", "EE", "LE", "GE", "NE", "LG", "NI", "IS", "INOT",
  "PLUS", "MINUS", "STAR", "DIV", "MOD", "FF", "NEG", "BT", "FS", "LS",
  "CLASS", "YIELD", "lower", "low", "high", "$accept", "start", "epsilon",
  "single_input", "file_input", "NEWstmt", "eval_input", "Nnew",
  "decorator", "line38", "line41", "decorated", "line40", "decorators",
  "funcdef", "$@1", "$@2", "parameters", "fpdef", "fplist", "lines57",
  "fpdefq", "range_func", "stmt", "simple_stmt", "line57", "small_stmt",
  "expr_stmt", "line61", "line62", "EQ_yield_expr_testlist", "augassign",
  "print_stmt", "line67", "lines74", "lines75", "line68", "del_stmt",
  "flow_stmt", "break_stmt", "continue_stmt", "return_stmt", "lines84",
  "yield_stmt", "raise_stmt", "lines87", "lines88", "lines89",
  "dotted_name", "FS_NAME", "global_stmt", "COM_NAME", "exec_stmt",
  "lines110", "assert_stmt", "prim", "primitives", "prime", "declare_stmt",
  "compound_stmt", "if_stmt", "lines115", "ELIF_test_COL_suite",
  "while_stmt", "for_stmt", "try_stmt", "line105", "lines121",
  "except_clause_COL_suite", "with_stmt", "line108", "COM_with_item",
  "with_item", "lines127", "except_clause", "lines129", "lines130",
  "line112", "suite", "stmt_", "testlist_safe", "lines135", "COM_old_test",
  "old_test", "test", "lines142", "or_test", "OR_and_test", "and_test",
  "AND_not_test", "not_test", "comparision", "comp_op_expr", "comp_op",
  "expr", "BO_xor_expr", "xor_expr", "BX_and_expr", "and_expr",
  "BA_shift_expr", "shift_expr", "LSRS_arith_expr", "line137",
  "arith_expr", "PLUSMINUS_term", "line140", "term", "STARDIVMODFF_factor",
  "line143", "factor", "line145", "power", "atom_expr", "trailer_", "atom",
  "lines172", "lines173", "lines174", "listmaker", "line151",
  "testlist_comp", "line153", "trailer", "lines183", "subscriptlist",
  "line158", "COM_subscript", "subscript", "sliceop", "lines189",
  "lines190", "exprlist", "line163", "COM_expr", "testlist", "line166",
  "COM_test", "dictorsetmaker", "line169", "line170", "COM_test_COL_test",
  "classdef", "$@3", "lines202", "arglist", "line175", "argument_COM",
  "argument", "lines209", "list_iter", "list_for", "list_if", "lines214",
  "comp_iter", "comp_for", "comp_if", "lines219", "testlist1",
  "yield_expr", YY_NULLPTR
  };
  return yy_sname[yysymbol];
}
#endif

#define YYPACT_NINF (-424)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-288)

#define yytable_value_is_error(Yyn) \
  0

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
static const yytype_int16 yypact[] =
{
     631,  -424,  -424,  -424,  -424,   721,  -424,  -424,  -424,    29,
    1088,    67,  1088,    52,   109,   579,  -424,  -424,  1088,  1088,
      71,   579,  1088,  1088,  1088,   579,    46,  1088,  1088,  -424,
    -424,  -424,  1088,    79,  1088,   102,  -424,  -424,   113,  -424,
     120,  -424,     9,  -424,   811,   147,  -424,  -424,  -424,  -424,
    -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,
     140,  -424,  -424,  -424,  -424,  -424,   127,   110,    90,   104,
    -424,   680,   135,   138,   137,   -11,   -26,    58,   579,  -424,
     124,    17,  1090,  -424,  -424,   811,  -424,  -424,  -424,   672,
      92,    69,  -424,    20,   155,   167,  -424,  -424,    30,   171,
    -424,  -424,  -424,    22,   164,  -424,   173,  1088,  -424,  -424,
    -424,   127,   163,  -424,  -424,  -424,  -424,  -424,  -424,   170,
     172,   144,   174,   176,   178,   150,   991,    88,   154,  -424,
     181,   125,   190,  -424,  -424,  -424,  -424,  -424,  -424,  -424,
    -424,  -424,    45,  -424,  1088,  -424,  -424,  -424,   185,  1088,
    -424,  -424,  1088,  -424,  1088,  -424,  -424,  -424,  -424,  -424,
    -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,   579,   579,
    -424,   579,  -424,   579,  -424,  -424,  -424,  -424,   579,  -424,
    -424,  -424,   579,  -424,  -424,  -424,  -424,  -424,   579,  -424,
     105,   579,   321,  1088,   202,  -424,    17,   206,  -424,    67,
    -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,
    -424,  -424,   210,  -424,  -424,    67,   216,  -424,  -424,  1088,
     222,   579,  -424,  -424,   185,  -424,  -424,   579,  -424,  -424,
     185,  -424,  -424,  1088,  -424,   185,  -424,  -424,  -424,    84,
      42,   181,  -424,  -424,   185,   579,  -424,  -424,   185,  1088,
    -424,  -424,   220,  -424,  1088,  -424,  -424,  1088,  -424,  -424,
     991,   991,   485,   224,  -424,    61,   991,  1088,  -424,   209,
     579,  -424,  -424,  1088,  -424,  -424,   223,  -424,   215,  -424,
    1007,   181,  -424,  -424,   183,    90,   104,   680,   135,   138,
     137,   -11,   -26,    58,   226,  -424,  -424,   221,  -424,  -424,
     159,  -424,   225,   231,   228,   229,  -424,    13,   230,  -424,
    -424,  1088,   232,  -424,  -424,  -424,   227,  -424,  -424,  -424,
    -424,    92,  -424,   240,  -424,  -424,   208,  -424,   212,  -424,
      33,  -424,  -424,   239,  -424,   237,    84,   256,    98,  -424,
    -424,  -424,   185,  -424,   248,  -424,   174,   172,   174,  -424,
     100,   217,   260,   257,   259,   901,   261,  1088,  -424,   217,
     262,  -424,   253,   991,  -424,   266,  -424,  -424,  -424,  -424,
    1088,  -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,
      99,  1088,   204,  -424,   300,  -424,  -424,   185,  1088,  1088,
    -424,  -424,  -424,  -424,  -424,   264,   270,  -424,  -424,  -424,
    -424,  1088,  1088,  1088,  -424,  -424,   185,  -424,   105,  -424,
     265,   275,  -424,  -424,  -424,   271,   991,  -424,   579,  -424,
    -424,  -424,  -424,  1088,   272,  -424,  -424,   217,  -424,  1088,
     991,   991,   901,   280,   991,  -424,  -424,    12,   235,   991,
    -424,  -424,  -424,   991,  -424,   283,  -424,  -424,   274,  -424,
    -424,   282,  -424,   270,    62,   281,  -424,    76,   285,  -424,
    -424,  -424,  -424,  -424,  -424,   289,   991,  -424,   451,   217,
     217,  -424,  -424,  -424,  -424,  -424,  -424,  -424,  1088,   290,
    -424,  -424,   251,  -424,  -424,   321,  -424,  1088,  -424,  -424,
    -424,  1088,  -424,  -424,  -424,  -424,  -424,  1088,  -424,  -424,
     185,  1088,  -424,  -424,  -424,  -424,  -424,  1088,   991,   991,
    -424,  -424,   539,  -424,  -424,  -424,   991,  -424,  -424,    62,
     281,  -424,    76,   291,  -424,   267,  -424,   304,  -424,  -424,
    -424,  -424,  1088,  -424,  -424,  -424
};

/* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
   Performed when YYTABLE does not specify something else to do.  Zero
   means the default is an error.  */
static const yytype_int16 yydefact[] =
{
       0,   256,   253,   257,   254,     6,   255,    10,   252,     0,
       5,     5,     5,     0,     5,     0,    95,    96,     5,     5,
       0,     0,     0,     0,     0,     0,     0,     0,     0,   239,
     240,   241,     0,     0,     5,     0,     2,     3,     0,     4,
      27,   135,     0,   133,    12,    46,     5,    53,    54,    55,
      56,    90,    91,    92,    94,    93,    57,    58,    59,    52,
      47,   128,   129,   130,   131,   132,     5,     5,   181,   185,
     189,   191,   206,   210,   214,   218,   224,   230,     0,   238,
     242,   245,    61,   134,   100,    11,    13,    46,    47,    61,
     109,     0,   262,     5,   242,     0,   261,   260,     5,     0,
     259,   258,   264,     5,     0,   263,     0,     0,    84,    80,
      81,     5,     5,    89,    99,    97,    98,   107,   101,     5,
     113,     5,     5,     0,     0,     0,     0,     0,     5,   188,
     336,     0,     5,   338,     1,     9,    28,    24,    26,    25,
      14,    50,     0,     8,    39,    40,   298,   296,     5,     0,
     179,   177,     0,   180,     0,   184,   201,   194,   195,   196,
     198,   197,   200,   199,   202,   203,   204,   190,     0,     0,
     205,     0,   209,     0,   213,   222,   221,   217,     0,   227,
     228,   223,     0,   233,   234,   235,   236,   229,     0,   237,
       0,     0,     5,     5,     0,   244,   247,    17,    15,     0,
      68,    69,    70,    71,    72,    73,    74,    75,    76,    77,
      78,    79,     0,    60,    65,     0,     0,   108,    20,     5,
       0,     0,   267,   265,     5,   266,   249,     0,   271,   269,
       5,   270,   248,     0,   308,     5,   302,   306,   250,     5,
       0,     5,    88,    83,     5,    39,   293,   291,     5,     0,
     105,   106,     0,   112,     0,   118,   116,     0,   103,   119,
       0,     0,     0,     0,   167,     0,     0,     0,   152,     0,
       0,   159,   157,     0,   337,   251,     0,   314,     0,    49,
       0,   299,    39,   297,     0,   183,   187,   193,   208,   212,
     216,   220,   226,   232,     0,   122,   121,   126,   120,   243,
       0,   288,   284,     0,     5,     0,   277,     5,     0,   276,
     316,     0,     5,   275,   246,    18,    66,    63,    62,    16,
      64,   111,    23,     0,    22,    19,     0,   268,     0,   272,
       5,   307,    36,     0,    42,    41,     5,     0,     0,    29,
      86,    82,     5,    87,   295,   292,     5,   115,     5,   102,
       5,     5,     0,     0,     0,     0,     0,     5,   145,     5,
       0,   154,   156,     0,   158,     0,   311,    48,    51,   300,
       0,   182,   186,   192,   207,   211,   215,   219,   225,   231,
       0,     0,     0,   274,     5,   280,   278,     5,     5,     0,
     323,   320,   322,   273,   315,     5,   319,   317,    67,   110,
      21,     0,     0,    39,   305,   301,     5,   303,     0,    37,
      41,     0,    33,   125,   124,     0,     0,    85,     0,   294,
     104,   114,   117,     0,     0,   139,   137,     5,   142,     0,
       0,     0,   170,     0,     0,   164,   160,     5,     5,     0,
     155,   153,   313,     0,   178,     0,   127,   283,   282,   279,
     287,     5,   321,   318,     5,     5,   176,     5,     0,   304,
      35,    38,    34,    31,    30,     0,     0,   136,     0,     5,
       5,   169,   168,   147,   166,   165,   162,   163,     0,     0,
     149,   146,   151,   312,   123,     5,   281,     5,   290,   289,
     285,     0,   329,   328,   324,   325,   326,     0,   173,   171,
       5,     0,   335,   334,   330,   331,   332,     0,     0,     0,
     138,    43,     0,   144,   143,   161,     0,   150,   286,     5,
     175,   172,     5,   310,    32,   141,    44,     0,   148,   327,
     174,   333,     0,   309,   140,    45
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -424,  -424,   153,  -424,  -424,    40,  -424,   131,  -424,  -424,
    -424,  -424,  -424,   292,   288,  -424,  -424,  -424,    -3,  -424,
     -50,    -1,  -424,  -325,     3,  -424,    59,   -18,   123,  -424,
      24,  -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,  -424,
    -424,  -424,   308,  -424,  -424,  -178,  -424,  -424,  -424,    27,
    -424,     4,  -424,  -424,  -424,  -307,   -30,  -424,  -424,   352,
    -424,  -324,  -172,  -424,  -424,  -424,  -424,  -424,  -128,  -424,
    -424,    -5,    94,  -424,  -424,  -424,  -424,  -424,  -202,   -70,
    -424,  -424,  -157,  -423,   -10,  -424,  -142,    81,   233,    78,
     -14,  -424,    80,  -424,    -2,    87,   199,    91,   198,    86,
     211,    95,  -424,   205,    85,  -424,   213,    97,  -424,   -58,
    -424,  -424,    10,   200,  -424,  -424,  -424,  -424,  -424,  -424,
    -424,  -424,  -424,  -424,  -424,  -424,   -51,   207,  -424,  -364,
    -424,     0,  -424,    54,    11,  -424,   -65,  -424,  -424,  -424,
    -123,   359,  -424,  -424,   187,    93,  -424,  -279,  -424,  -424,
     314,  -424,  -108,  -424,   -77,  -424,  -110,  -424,     7
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
       0,    35,   145,    36,    37,    86,    39,   212,    40,   220,
     323,    41,   137,    42,    43,   416,   508,   240,   335,   336,
     397,   337,   353,    44,   264,   142,    46,    47,   316,   213,
     214,   215,    48,   109,   110,   341,   243,    49,    50,    51,
      52,    53,   115,    54,    55,   259,   251,   118,    91,   217,
      56,   253,    57,   256,    58,   297,   298,   415,    59,    88,
      61,   426,   427,    62,    63,    64,   358,   481,   359,    65,
     268,   269,   127,   272,   360,   477,   436,   478,   265,   433,
     454,   499,   500,   455,    66,   151,    67,   153,    68,   155,
      69,    70,   167,   168,    71,   170,    72,   172,    73,   174,
      74,   177,   178,    75,   181,   182,    76,   187,   188,    77,
      78,    79,    94,   195,    81,    99,    95,   104,    96,   223,
     100,   229,   196,   308,   303,   386,   387,   448,   489,   305,
     490,   113,   247,   248,    89,   147,   148,   105,   405,   236,
     406,    83,   443,   278,   309,   310,   311,   312,   391,   493,
     494,   495,   496,   503,   504,   505,   506,   131,    84
};

/* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule whose
   number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      93,    98,   103,    45,   111,   123,   124,   284,    87,   119,
      80,    82,   122,   112,   129,    80,   146,   128,   101,   121,
     189,   231,   130,   112,   451,   125,   237,   428,   224,   116,
     432,   414,   395,   230,    13,   438,   175,   192,   235,   193,
      38,   389,   474,   222,    90,   116,   244,    87,   228,   233,
     144,   338,   144,   234,    80,   179,   180,   279,   350,   351,
     144,   242,   246,   403,   361,   274,   475,   106,   519,   339,
       1,   280,     2,   126,   520,     3,   227,     4,   522,   176,
       6,   218,     8,   221,   140,   227,   120,    10,    87,    11,
      12,   219,   332,   227,   132,    80,   227,   241,   283,   333,
      33,   460,   134,   467,   294,   294,   194,   432,   413,   295,
     295,   294,     1,   296,     2,   266,   295,     3,   267,     4,
     296,   491,     6,   518,     8,   221,   356,   135,   357,    10,
     293,    11,    12,   299,   281,   501,    80,    28,     9,   227,
     286,   183,   184,   185,   186,   513,   514,    -7,    29,    30,
     468,   190,   143,   191,    31,    32,   107,   144,   152,    34,
     423,   441,   424,    92,    97,   102,   287,   108,   420,   149,
     422,   114,   117,   154,   327,   169,   342,   171,   173,    28,
     329,   216,   302,   307,   191,   331,   226,   114,   238,   512,
      29,    30,   232,   245,   343,   239,    31,    32,   345,   141,
     249,   254,   252,   260,   257,   261,   318,   262,   270,   307,
     317,   273,   276,   275,   464,   282,   369,   313,   197,   112,
     150,   326,   318,   330,   319,   112,   317,   328,   469,   470,
     392,   321,   473,   527,   325,   347,   363,   482,   365,   346,
     355,   483,   366,   344,   348,   370,   380,   349,   382,   381,
     383,   393,  -287,   407,   385,   199,   388,   128,   384,   456,
     457,   400,   396,   281,   510,   401,   408,   409,   364,   402,
      80,    80,   250,   354,   255,   258,    80,   412,   418,   424,
     404,   271,   429,   267,   430,   277,   431,   442,   434,   439,
      80,   -39,   417,   447,   453,   461,   462,   472,   463,   466,
     479,   307,   484,     1,   485,     2,   524,   525,     3,   487,
       4,   497,   507,     6,   528,     8,   509,   516,   357,   -39,
      10,   532,    11,    12,     1,   535,     2,   423,   315,     3,
     138,     4,   136,   410,     6,   411,     8,   449,   320,   368,
     398,    10,   133,    11,    12,   301,   306,   437,   399,   456,
     445,   421,    60,   534,   517,   456,   459,   440,    87,   456,
     444,   362,   471,   530,   372,    80,   371,   373,   288,   289,
      28,   446,   322,    80,   302,   374,   376,   378,   450,   452,
     375,    29,    30,   291,   290,   285,   377,    31,    32,   300,
     379,    28,   334,   458,   340,   292,   314,   486,   419,   304,
     533,   139,    29,    30,   394,   465,   324,   225,    31,    32,
     300,   529,   531,     0,     0,     0,   344,     0,     0,   307,
       0,     0,     0,     0,     0,     0,    80,     0,     0,     0,
       0,     0,     0,     0,     0,    87,     0,     0,     0,     0,
      80,    80,    80,     0,    80,     0,     0,     0,     0,    80,
     521,     0,     0,    80,     1,     0,     2,     0,   307,     3,
     390,     4,     0,     0,     6,     0,     8,     0,   515,     0,
       0,    10,   511,    11,    12,   302,    80,   450,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     1,   334,
       2,     0,   352,     3,     0,     4,     0,   523,     6,   258,
       8,   258,   307,   425,   425,    10,     0,    11,    12,     0,
     435,     0,   425,     0,     0,     0,     0,     0,    80,    80,
       0,    28,   458,     0,     0,     0,    80,     0,     0,     0,
       0,     0,    29,    30,     0,     0,     0,   301,    31,    32,
       0,   301,     1,     0,     2,     0,     0,     3,     0,     4,
       0,     0,     6,     0,     8,    28,     0,     0,     0,    10,
     526,    11,    12,     0,     0,     0,    29,    30,     0,     0,
       0,     0,    31,    32,     0,     0,     0,     0,     0,     0,
     425,     0,     1,     0,     2,     0,     0,     3,     0,     4,
     476,   480,     6,     0,     8,     0,     0,     0,     0,    10,
       0,    11,    12,     0,   488,     0,     0,   492,   498,    28,
     502,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      29,    30,   425,   425,     0,     0,    31,    32,     0,     0,
       0,     0,     0,     0,     1,     0,     2,     0,   301,     3,
     301,     4,     0,     5,     6,     7,     8,     0,     0,     9,
       0,    10,     0,    11,    12,     0,    13,     0,     0,     0,
      29,    30,     0,     0,     0,     0,    31,    32,     0,     0,
       0,     0,   492,     0,     0,   502,     0,    14,     0,    15,
      16,    17,    18,    19,     0,     0,    20,    21,     0,    22,
      23,     0,    24,     0,    25,    26,     0,    27,     0,     0,
     199,    28,     0,   200,   201,   202,   203,   204,   205,   206,
     207,     0,    29,    30,   208,   209,   210,   211,    31,    32,
       0,     0,    33,    34,     1,     0,     2,     0,     0,     3,
       0,     4,     0,    85,     6,   -11,     8,   156,     0,     9,
       0,    10,     0,    11,    12,     0,    13,     0,     0,     0,
       0,   157,   158,   159,   160,   161,   162,   163,   164,   165,
     166,     0,     0,     0,     0,     0,     0,    14,     0,    15,
      16,    17,    18,    19,     0,     0,    20,    21,     0,    22,
      23,     0,    24,     0,    25,    26,     0,    27,     0,     0,
       0,    28,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    29,    30,     0,     0,     0,     0,    31,    32,
       0,     0,    33,    34,     1,     0,     2,     0,     0,     3,
       0,     4,     0,    85,     6,     0,     8,     0,     0,     9,
       0,    10,     0,    11,    12,     0,    13,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    14,     0,    15,
      16,    17,    18,    19,     0,     0,    20,    21,     0,    22,
      23,     0,    24,     0,    25,    26,     0,    27,     0,     0,
       0,    28,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    29,    30,     0,     0,     0,     0,    31,    32,
       0,     0,    33,    34,     1,     0,     2,     0,     0,     3,
       0,     4,     0,     0,     6,     0,     8,     0,     0,     9,
       0,    10,     0,    11,    12,     0,    13,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    14,     0,    15,
      16,    17,    18,    19,     0,     0,    20,    21,     0,    22,
      23,     0,    24,     0,    25,    26,     0,    27,     0,     0,
       0,    28,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    29,    30,     0,     0,     0,     0,    31,    32,
       0,     0,    33,    34,     1,     0,     2,     0,     0,     3,
       0,     4,     0,   263,     6,     0,     8,     0,     0,     0,
       1,    10,     2,    11,    12,     3,     0,     4,     0,   367,
       6,     0,     8,     0,     0,     0,     0,    10,     0,    11,
      12,     0,     0,     0,     0,     0,     0,    14,     0,    15,
      16,    17,    18,    19,     0,     0,    20,    21,     0,    22,
       0,     0,     0,    14,     0,    15,    16,    17,    18,    19,
       0,    28,    20,    21,     0,    22,     0,     0,     0,     0,
       0,     0,    29,    30,     0,     0,     0,    28,    31,    32,
       0,     0,     0,    34,     0,     0,     0,     0,    29,    30,
       0,     1,     0,     2,    31,    32,     3,     0,     4,    34,
       0,     6,   197,     8,   198,     0,     0,     0,    10,     0,
      11,    12,     0,     0,     0,     0,     0,     0,   199,     0,
       0,   200,   201,   202,   203,   204,   205,   206,   207,     0,
       0,     0,   208,   209,   210,   211,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    28,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    29,
      30,     0,     0,     0,     0,    31,    32
};

static const yytype_int16 yycheck[] =
{
      10,    11,    12,     0,    14,    23,    24,   149,     5,    19,
       0,     0,    22,    15,    28,     5,    66,    27,    11,    21,
      78,    98,    32,    25,   388,    25,   103,   351,    93,    18,
     355,   338,   311,    98,    25,   359,    47,    20,   103,    22,
       0,    28,    30,    93,    15,    34,   111,    44,    98,    27,
      30,     9,    30,   103,    44,    81,    82,    12,   260,   261,
      30,   111,   112,    30,   266,   130,    54,    15,   491,    27,
       3,    26,     5,    27,   497,     8,    63,    10,   501,    90,
      13,    12,    15,    63,    44,    63,    15,    20,    85,    22,
      23,    22,     8,    63,    15,    85,    63,   107,   148,    15,
      91,   408,     0,   427,     6,     6,    89,   432,    10,    11,
      11,     6,     3,    15,     5,    27,    11,     8,    30,    10,
      15,    59,    13,   487,    15,    63,    65,    14,    67,    20,
     188,    22,    23,   191,   144,    59,   126,    70,    18,    63,
     154,    83,    84,    85,    86,   469,   470,     0,    81,    82,
     429,    27,    12,    29,    87,    88,    47,    30,    68,    92,
      60,   363,    62,    10,    11,    12,   168,    14,   346,    59,
     348,    18,    19,    69,   224,    40,   241,    39,    41,    70,
     230,    89,   192,   193,    29,   235,    19,    34,    24,   468,
      81,    82,    21,    30,   244,    22,    87,    88,   248,    46,
      30,    57,    30,    27,    30,    27,   199,    57,    54,   219,
     199,    30,    22,    88,   416,    30,   281,    15,    12,   221,
      67,   221,   215,   233,    14,   227,   215,   227,   430,   431,
     307,    15,   434,   512,    12,    15,    27,   439,    15,   249,
      16,   443,    27,   245,   254,    62,    20,   257,    89,    28,
      19,    21,    27,   330,   304,    28,    27,   267,    30,   401,
     402,    21,    30,   273,   466,    57,    27,    30,   270,    57,
     260,   261,   119,   262,   121,   122,   266,    21,    30,    62,
     330,   128,    22,    30,    27,   132,    27,    21,    27,    27,
     280,    21,   342,    89,    30,    30,    21,    17,    27,    27,
      65,   311,    19,     3,    30,     5,   508,   509,     8,    27,
      10,    30,    27,    13,   516,    15,    27,    27,    67,    19,
      20,    30,    22,    23,     3,    21,     5,    60,   197,     8,
      42,    10,    40,   336,    13,   336,    15,   387,   215,   280,
     316,    20,    34,    22,    23,   192,   193,   357,   321,   491,
     380,   347,     0,   525,   482,   497,   406,   362,   355,   501,
     370,   267,   432,   520,   286,   355,   285,   287,   169,   171,
      70,   381,   219,   363,   384,   288,   290,   292,   388,   389,
     289,    81,    82,   178,   173,   152,   291,    87,    88,    89,
     293,    70,   239,   403,   241,   182,   196,   448,   344,   192,
     523,    42,    81,    82,   311,   423,   219,    93,    87,    88,
      89,   519,   522,    -1,    -1,    -1,   418,    -1,    -1,   429,
      -1,    -1,    -1,    -1,    -1,    -1,   416,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   432,    -1,    -1,    -1,    -1,
     430,   431,   432,    -1,   434,    -1,    -1,    -1,    -1,   439,
     500,    -1,    -1,   443,     3,    -1,     5,    -1,   468,     8,
     307,    10,    -1,    -1,    13,    -1,    15,    -1,   478,    -1,
      -1,    20,    21,    22,    23,   485,   466,   487,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     3,   336,
       5,    -1,     7,     8,    -1,    10,    -1,   507,    13,   346,
      15,   348,   512,   350,   351,    20,    -1,    22,    23,    -1,
     357,    -1,   359,    -1,    -1,    -1,    -1,    -1,   508,   509,
      -1,    70,   532,    -1,    -1,    -1,   516,    -1,    -1,    -1,
      -1,    -1,    81,    82,    -1,    -1,    -1,   384,    87,    88,
      -1,   388,     3,    -1,     5,    -1,    -1,     8,    -1,    10,
      -1,    -1,    13,    -1,    15,    70,    -1,    -1,    -1,    20,
      21,    22,    23,    -1,    -1,    -1,    81,    82,    -1,    -1,
      -1,    -1,    87,    88,    -1,    -1,    -1,    -1,    -1,    -1,
     427,    -1,     3,    -1,     5,    -1,    -1,     8,    -1,    10,
     437,   438,    13,    -1,    15,    -1,    -1,    -1,    -1,    20,
      -1,    22,    23,    -1,   451,    -1,    -1,   454,   455,    70,
     457,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      81,    82,   469,   470,    -1,    -1,    87,    88,    -1,    -1,
      -1,    -1,    -1,    -1,     3,    -1,     5,    -1,   485,     8,
     487,    10,    -1,    12,    13,    14,    15,    -1,    -1,    18,
      -1,    20,    -1,    22,    23,    -1,    25,    -1,    -1,    -1,
      81,    82,    -1,    -1,    -1,    -1,    87,    88,    -1,    -1,
      -1,    -1,   519,    -1,    -1,   522,    -1,    46,    -1,    48,
      49,    50,    51,    52,    -1,    -1,    55,    56,    -1,    58,
      59,    -1,    61,    -1,    63,    64,    -1,    66,    -1,    -1,
      28,    70,    -1,    31,    32,    33,    34,    35,    36,    37,
      38,    -1,    81,    82,    42,    43,    44,    45,    87,    88,
      -1,    -1,    91,    92,     3,    -1,     5,    -1,    -1,     8,
      -1,    10,    -1,    12,    13,    14,    15,    57,    -1,    18,
      -1,    20,    -1,    22,    23,    -1,    25,    -1,    -1,    -1,
      -1,    71,    72,    73,    74,    75,    76,    77,    78,    79,
      80,    -1,    -1,    -1,    -1,    -1,    -1,    46,    -1,    48,
      49,    50,    51,    52,    -1,    -1,    55,    56,    -1,    58,
      59,    -1,    61,    -1,    63,    64,    -1,    66,    -1,    -1,
      -1,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    81,    82,    -1,    -1,    -1,    -1,    87,    88,
      -1,    -1,    91,    92,     3,    -1,     5,    -1,    -1,     8,
      -1,    10,    -1,    12,    13,    -1,    15,    -1,    -1,    18,
      -1,    20,    -1,    22,    23,    -1,    25,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    46,    -1,    48,
      49,    50,    51,    52,    -1,    -1,    55,    56,    -1,    58,
      59,    -1,    61,    -1,    63,    64,    -1,    66,    -1,    -1,
      -1,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    81,    82,    -1,    -1,    -1,    -1,    87,    88,
      -1,    -1,    91,    92,     3,    -1,     5,    -1,    -1,     8,
      -1,    10,    -1,    -1,    13,    -1,    15,    -1,    -1,    18,
      -1,    20,    -1,    22,    23,    -1,    25,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    46,    -1,    48,
      49,    50,    51,    52,    -1,    -1,    55,    56,    -1,    58,
      59,    -1,    61,    -1,    63,    64,    -1,    66,    -1,    -1,
      -1,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    81,    82,    -1,    -1,    -1,    -1,    87,    88,
      -1,    -1,    91,    92,     3,    -1,     5,    -1,    -1,     8,
      -1,    10,    -1,    12,    13,    -1,    15,    -1,    -1,    -1,
       3,    20,     5,    22,    23,     8,    -1,    10,    -1,    12,
      13,    -1,    15,    -1,    -1,    -1,    -1,    20,    -1,    22,
      23,    -1,    -1,    -1,    -1,    -1,    -1,    46,    -1,    48,
      49,    50,    51,    52,    -1,    -1,    55,    56,    -1,    58,
      -1,    -1,    -1,    46,    -1,    48,    49,    50,    51,    52,
      -1,    70,    55,    56,    -1,    58,    -1,    -1,    -1,    -1,
      -1,    -1,    81,    82,    -1,    -1,    -1,    70,    87,    88,
      -1,    -1,    -1,    92,    -1,    -1,    -1,    -1,    81,    82,
      -1,     3,    -1,     5,    87,    88,     8,    -1,    10,    92,
      -1,    13,    12,    15,    14,    -1,    -1,    -1,    20,    -1,
      22,    23,    -1,    -1,    -1,    -1,    -1,    -1,    28,    -1,
      -1,    31,    32,    33,    34,    35,    36,    37,    38,    -1,
      -1,    -1,    42,    43,    44,    45,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    70,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    81,
      82,    -1,    -1,    -1,    -1,    87,    88
};

/* YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
   state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,     5,     8,    10,    12,    13,    14,    15,    18,
      20,    22,    23,    25,    46,    48,    49,    50,    51,    52,
      55,    56,    58,    59,    61,    63,    64,    66,    70,    81,
      82,    87,    88,    91,    92,    97,    99,   100,   101,   102,
     104,   107,   109,   110,   119,   120,   122,   123,   128,   133,
     134,   135,   136,   137,   139,   140,   146,   148,   150,   154,
     155,   156,   159,   160,   161,   165,   180,   182,   184,   186,
     187,   190,   192,   194,   196,   199,   202,   205,   206,   207,
     208,   210,   230,   237,   254,    12,   101,   120,   155,   230,
      15,   144,    98,   180,   208,   212,   214,    98,   180,   211,
     216,   254,    98,   180,   213,   233,    15,    47,    98,   129,
     130,   180,   190,   227,    98,   138,   230,    98,   143,   180,
      15,   190,   180,   123,   123,   227,    27,   168,   180,   186,
     180,   253,    15,   138,     0,    14,   109,   108,   110,   237,
     101,    98,   121,    12,    30,    98,   116,   231,   232,    59,
      98,   181,    68,   183,    69,   185,    57,    71,    72,    73,
      74,    75,    76,    77,    78,    79,    80,   188,   189,    40,
     191,    39,   193,    41,   195,    47,    90,   197,   198,    81,
      82,   200,   201,    83,    84,    85,    86,   203,   204,   205,
      27,    29,    20,    22,    89,   209,   218,    12,    14,    28,
      31,    32,    33,    34,    35,    36,    37,    38,    42,    43,
      44,    45,   103,   125,   126,   127,    89,   145,    12,    22,
     105,    63,   116,   215,   232,   246,    19,    63,   116,   217,
     232,   250,    21,    27,   116,   232,   235,   250,    24,    22,
     113,   180,   116,   132,   232,    30,   116,   228,   229,    30,
      98,   142,    30,   147,    57,    98,   149,    30,    98,   141,
      27,    27,    57,    12,   120,   174,    27,    30,   166,   167,
      54,    98,   169,    30,   232,    88,    22,    98,   239,    12,
      26,   180,    30,   116,   182,   184,   186,   190,   192,   194,
     196,   199,   202,   205,     6,    11,    15,   151,   152,   205,
      89,    98,   180,   220,   223,   225,    98,   180,   219,   240,
     241,   242,   243,    15,   209,   103,   124,   230,   254,    14,
     124,    15,    98,   106,   240,    12,   227,   116,   227,   116,
     180,   116,     8,    15,    98,   114,   115,   117,     9,    27,
      98,   131,   232,   116,   190,   116,   180,    15,   180,   180,
     174,   174,     7,   118,   230,    16,    65,    67,   162,   164,
     170,   174,   168,    27,   190,    15,    27,    12,   122,   232,
      62,   183,   185,   188,   191,   193,   195,   197,   200,   203,
      20,    28,    89,    19,    30,   116,   221,   222,    27,    28,
      98,   244,   250,    21,   241,   243,    30,   116,   126,   145,
      21,    57,    57,    30,   116,   234,   236,   250,    27,    30,
     114,   117,    21,    10,   151,   153,   111,   116,    30,   229,
     141,   147,   141,    60,    62,    98,   157,   158,   157,    22,
      27,    27,   119,   175,    27,    98,   172,   180,   157,    27,
     167,   174,    21,   238,   180,   152,   180,    89,   223,   116,
     180,   225,   180,    30,   176,   179,   182,   182,   180,   116,
     151,    30,    21,    27,   174,   123,    27,   157,   243,   174,
     174,   175,    17,   174,    30,    54,    98,   171,   173,    65,
      98,   163,   174,   174,    19,    30,   222,    27,    98,   224,
     226,    59,    98,   245,   246,   247,   248,    30,    98,   177,
     178,    59,    98,   249,   250,   251,   252,    27,   112,    27,
     174,    21,   243,   157,   157,   180,    27,   164,   225,   179,
     179,   116,   179,   180,   174,   174,    21,   243,   174,   248,
     178,   252,    30,   236,   158,    21
};

/* YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.  */
static const yytype_uint8 yyr1[] =
{
       0,    96,    97,    97,    97,    98,    99,    99,    99,   100,
     100,   101,   101,   101,   101,   102,   102,   103,   103,   104,
     104,   105,   106,   106,   107,   108,   108,   109,   109,   111,
     110,   112,   110,   113,   113,   114,   114,   115,   115,   116,
     116,   117,   117,   118,   118,   118,   119,   119,   120,   120,
     121,   121,   122,   122,   122,   122,   122,   122,   122,   122,
     123,   123,   124,   124,   125,   125,   126,   126,   127,   127,
     127,   127,   127,   127,   127,   127,   127,   127,   127,   127,
     128,   129,   129,   130,   130,   131,   131,   132,   132,   133,
     134,   134,   134,   134,   134,   135,   136,   137,   138,   138,
     139,   140,   141,   141,   142,   142,   143,   143,   144,   144,
     145,   145,   146,   146,   147,   147,   148,   149,   149,   150,
     151,   151,   152,   152,   153,   153,   154,   154,   155,   155,
     155,   155,   155,   155,   155,   155,   156,   156,   157,   157,
     158,   158,   159,   160,   160,   161,   162,   162,   163,   163,
     164,   164,   165,   166,   166,   167,   167,   168,   169,   169,
     170,   171,   171,   172,   172,   173,   173,   174,   174,   175,
     175,   176,   177,   177,   178,   178,   179,   180,   181,   181,
     182,   182,   183,   183,   184,   184,   185,   185,   186,   186,
     187,   187,   188,   188,   189,   189,   189,   189,   189,   189,
     189,   189,   189,   189,   189,   190,   190,   191,   191,   192,
     192,   193,   193,   194,   194,   195,   195,   196,   196,   197,
     197,   198,   198,   199,   199,   200,   200,   201,   201,   202,
     202,   203,   203,   204,   204,   204,   204,   205,   205,   206,
     206,   206,   207,   207,   208,   208,   209,   209,   210,   210,
     210,   210,   210,   210,   210,   210,   210,   210,   211,   211,
     211,   212,   212,   213,   213,   214,   215,   215,   215,   216,
     217,   217,   217,   218,   218,   218,   219,   219,   220,   221,
     221,   222,   222,   223,   223,   223,   224,   225,   225,   226,
     226,   227,   228,   228,   229,   229,   230,   231,   231,   232,
     232,   233,   233,   234,   234,   234,   235,   235,   235,   236,
     236,   238,   237,   239,   239,   240,   240,   241,   242,   242,
     243,   243,   244,   244,   245,   245,   246,   247,   248,   248,
     249,   249,   250,   251,   252,   252,   253,   253,   254
};

/* YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     1,     1,     0,     1,     1,     2,     2,
       1,     1,     1,     2,     2,     2,     3,     1,     2,     4,
       3,     3,     1,     1,     2,     1,     1,     1,     2,     0,
       6,     0,     8,     3,     4,     3,     1,     2,     3,     1,
       1,     1,     1,     4,     5,     6,     1,     1,     4,     3,
       1,     3,     1,     1,     1,     1,     1,     1,     1,     1,
       2,     1,     1,     1,     2,     1,     2,     3,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       2,     1,     3,     2,     1,     2,     1,     2,     1,     2,
       1,     1,     1,     1,     1,     1,     1,     2,     1,     1,
       1,     2,     2,     1,     3,     1,     2,     1,     2,     1,
       3,     2,     3,     2,     3,     2,     3,     3,     1,     3,
       1,     1,     1,     4,     1,     1,     3,     5,     1,     1,
       1,     1,     1,     1,     1,     1,     6,     5,     3,     1,
       5,     4,     5,     7,     7,     4,     3,     3,     3,     1,
       4,     3,     3,     3,     2,     3,     2,     2,     2,     1,
       2,     2,     1,     2,     1,     1,     1,     1,     4,     2,
       1,     2,     2,     1,     3,     2,     1,     2,     4,     1,
       2,     1,     3,     2,     2,     1,     3,     2,     2,     1,
       2,     1,     3,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     2,     1,     3,     2,     2,
       1,     3,     2,     2,     1,     3,     2,     2,     1,     3,
       2,     1,     1,     2,     1,     3,     2,     1,     1,     2,
       1,     3,     2,     1,     1,     1,     1,     2,     1,     1,
       1,     1,     1,     3,     2,     1,     2,     1,     3,     3,
       3,     3,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     2,     1,     1,     2,     2,
       1,     1,     2,     3,     3,     2,     1,     1,     2,     2,
       1,     3,     2,     3,     1,     4,     2,     1,     1,     1,
       1,     2,     2,     1,     3,     2,     2,     2,     1,     2,
       3,     4,     2,     1,     2,     1,     1,     2,     1,     5,
       4,     0,     6,     3,     1,     2,     1,     2,     3,     2,
       2,     3,     1,     1,     1,     1,     5,     3,     1,     1,
       1,     1,     5,     3,     1,     1,     1,     2,     2
};


enum { YYENOMEM = -2 };

#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYNOMEM         goto yyexhaustedlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Backward compatibility with an undocumented macro.
   Use YYerror or YYUNDEF. */
#define YYERRCODE YYUNDEF

/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)                                \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;        \
          (Current).first_column = YYRHSLOC (Rhs, 1).first_column;      \
          (Current).last_line    = YYRHSLOC (Rhs, N).last_line;         \
          (Current).last_column  = YYRHSLOC (Rhs, N).last_column;       \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).first_line   = (Current).last_line   =              \
            YYRHSLOC (Rhs, 0).last_line;                                \
          (Current).first_column = (Current).last_column =              \
            YYRHSLOC (Rhs, 0).last_column;                              \
        }                                                               \
    while (0)
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K])


/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)


/* YYLOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

# ifndef YYLOCATION_PRINT

#  if defined YY_LOCATION_PRINT

   /* Temporary convenience wrapper in case some people defined the
      undocumented and private YY_LOCATION_PRINT macros.  */
#   define YYLOCATION_PRINT(File, Loc)  YY_LOCATION_PRINT(File, *(Loc))

#  elif defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL

/* Print *YYLOCP on YYO.  Private, do not rely on its existence. */

YY_ATTRIBUTE_UNUSED
static int
yy_location_print_ (FILE *yyo, YYLTYPE const * const yylocp)
{
  int res = 0;
  int end_col = 0 != yylocp->last_column ? yylocp->last_column - 1 : 0;
  if (0 <= yylocp->first_line)
    {
      res += YYFPRINTF (yyo, "%d", yylocp->first_line);
      if (0 <= yylocp->first_column)
        res += YYFPRINTF (yyo, ".%d", yylocp->first_column);
    }
  if (0 <= yylocp->last_line)
    {
      if (yylocp->first_line < yylocp->last_line)
        {
          res += YYFPRINTF (yyo, "-%d", yylocp->last_line);
          if (0 <= end_col)
            res += YYFPRINTF (yyo, ".%d", end_col);
        }
      else if (0 <= end_col && yylocp->first_column < end_col)
        res += YYFPRINTF (yyo, "-%d", end_col);
    }
  return res;
}

#   define YYLOCATION_PRINT  yy_location_print_

    /* Temporary convenience wrapper in case some people defined the
       undocumented and private YY_LOCATION_PRINT macros.  */
#   define YY_LOCATION_PRINT(File, Loc)  YYLOCATION_PRINT(File, &(Loc))

#  else

#   define YYLOCATION_PRINT(File, Loc) ((void) 0)
    /* Temporary convenience wrapper in case some people defined the
       undocumented and private YY_LOCATION_PRINT macros.  */
#   define YY_LOCATION_PRINT  YYLOCATION_PRINT

#  endif
# endif /* !defined YYLOCATION_PRINT */


# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Kind, Value, Location); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo,
                       yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  FILE *yyoutput = yyo;
  YY_USE (yyoutput);
  YY_USE (yylocationp);
  if (!yyvaluep)
    return;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo,
                 yysymbol_kind_t yykind, YYSTYPE const * const yyvaluep, YYLTYPE const * const yylocationp)
{
  YYFPRINTF (yyo, "%s %s (",
             yykind < YYNTOKENS ? "token" : "nterm", yysymbol_name (yykind));

  YYLOCATION_PRINT (yyo, yylocationp);
  YYFPRINTF (yyo, ": ");
  yy_symbol_value_print (yyo, yykind, yyvaluep, yylocationp);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, YYLTYPE *yylsp,
                 int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       YY_ACCESSING_SYMBOL (+yyssp[yyi + 1 - yynrhs]),
                       &yyvsp[(yyi + 1) - (yynrhs)],
                       &(yylsp[(yyi + 1) - (yynrhs)]));
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, yylsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args) ((void) 0)
# define YY_SYMBOL_PRINT(Title, Kind, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


/* Context of a parse error.  */
typedef struct
{
  yy_state_t *yyssp;
  yysymbol_kind_t yytoken;
  YYLTYPE *yylloc;
} yypcontext_t;

/* Put in YYARG at most YYARGN of the expected tokens given the
   current YYCTX, and return the number of tokens stored in YYARG.  If
   YYARG is null, return the number of expected tokens (guaranteed to
   be less than YYNTOKENS).  Return YYENOMEM on memory exhaustion.
   Return 0 if there are more than YYARGN expected tokens, yet fill
   YYARG up to YYARGN. */
static int
yypcontext_expected_tokens (const yypcontext_t *yyctx,
                            yysymbol_kind_t yyarg[], int yyargn)
{
  /* Actual size of YYARG. */
  int yycount = 0;
  int yyn = yypact[+*yyctx->yyssp];
  if (!yypact_value_is_default (yyn))
    {
      /* Start YYX at -YYN if negative to avoid negative indexes in
         YYCHECK.  In other words, skip the first -YYN actions for
         this state because they are default actions.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;
      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yyx;
      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
        if (yycheck[yyx + yyn] == yyx && yyx != YYSYMBOL_YYerror
            && !yytable_value_is_error (yytable[yyx + yyn]))
          {
            if (!yyarg)
              ++yycount;
            else if (yycount == yyargn)
              return 0;
            else
              yyarg[yycount++] = YY_CAST (yysymbol_kind_t, yyx);
          }
    }
  if (yyarg && yycount == 0 && 0 < yyargn)
    yyarg[0] = YYSYMBOL_YYEMPTY;
  return yycount;
}




/* The kind of the lookahead of this context.  */
static yysymbol_kind_t
yypcontext_token (const yypcontext_t *yyctx) YY_ATTRIBUTE_UNUSED;

static yysymbol_kind_t
yypcontext_token (const yypcontext_t *yyctx)
{
  return yyctx->yytoken;
}

/* The location of the lookahead of this context.  */
static YYLTYPE *
yypcontext_location (const yypcontext_t *yyctx) YY_ATTRIBUTE_UNUSED;

static YYLTYPE *
yypcontext_location (const yypcontext_t *yyctx)
{
  return yyctx->yylloc;
}

/* User defined function to report a syntax error.  */
static int
yyreport_syntax_error (const yypcontext_t *yyctx);

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg,
            yysymbol_kind_t yykind, YYSTYPE *yyvaluep, YYLTYPE *yylocationp)
{
  YY_USE (yyvaluep);
  YY_USE (yylocationp);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yykind, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YY_USE (yykind);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/* Lookahead token kind.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Location data for the lookahead symbol.  */
YYLTYPE yylloc
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
  = { 1, 1, 1, 1 }
# endif
;
/* Number of syntax errors so far.  */
int yynerrs;




/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate = 0;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus = 0;

    /* Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* Their size.  */
    YYPTRDIFF_T yystacksize = YYINITDEPTH;

    /* The state stack: array, bottom, top.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss = yyssa;
    yy_state_t *yyssp = yyss;

    /* The semantic value stack: array, bottom, top.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs = yyvsa;
    YYSTYPE *yyvsp = yyvs;

    /* The location stack: array, bottom, top.  */
    YYLTYPE yylsa[YYINITDEPTH];
    YYLTYPE *yyls = yylsa;
    YYLTYPE *yylsp = yyls;

  int yyn;
  /* The return value of yyparse.  */
  int yyresult;
  /* Lookahead symbol kind.  */
  yysymbol_kind_t yytoken = YYSYMBOL_YYEMPTY;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;
  YYLTYPE yyloc;

  /* The locations where the error started and ended.  */
  YYLTYPE yyerror_range[3];



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N), yylsp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yychar = YYEMPTY; /* Cause a token to be read.  */

  yylsp[0] = yylloc;
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END
  YY_STACK_PRINT (yyss, yyssp);

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    YYNOMEM;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;
        YYLTYPE *yyls1 = yyls;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yyls1, yysize * YYSIZEOF (*yylsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
        yyls = yyls1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        YYNOMEM;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          YYNOMEM;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
        YYSTACK_RELOCATE (yyls_alloc, yyls);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;
      yylsp = yyls + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */


  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either empty, or end-of-input, or a valid lookahead.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token\n"));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = YYEOF;
      yytoken = YYSYMBOL_YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else if (yychar == YYerror)
    {
      /* The scanner already issued an error message, process directly
         to error recovery.  But do not keep the error token as
         lookahead, it is too special and may lead us to an endless
         loop in error recovery. */
      yychar = YYUNDEF;
      yytoken = YYSYMBOL_YYerror;
      yyerror_range[1] = yylloc;
      goto yyerrlab1;
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END
  *++yylsp = yylloc;

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];

  /* Default location. */
  YYLLOC_DEFAULT (yyloc, (yylsp - yylen), yylen);
  yyerror_range[1] = yyloc;
  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2: /* start: single_input  */
#line 402 "m2.y"
                    {  (yyval.attr).node_id = 0 + dfn;  create_node("", "start" , (yyval.attr).node_id );  create_edge( { (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 1; YYACCEPT;}
#line 2416 "m2.tab.c"
    break;

  case 3: /* start: file_input  */
#line 403 "m2.y"
                   {YYACCEPT;}
#line 2422 "m2.tab.c"
    break;

  case 4: /* start: eval_input  */
#line 404 "m2.y"
                  { (yyval.attr).node_id = 0 + dfn;  create_node("", "start" , (yyval.attr).node_id );  create_edge( { (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 1;YYACCEPT;}
#line 2428 "m2.tab.c"
    break;

  case 6: /* single_input: NEWLINE  */
#line 408 "m2.y"
                      { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("","NEWLINE",(yyvsp[0].attr).node_id);  dfn++;}
#line 2434 "m2.tab.c"
    break;

  case 7: /* single_input: simple_stmt  */
#line 409 "m2.y"
                          {  (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2440 "m2.tab.c"
    break;

  case 8: /* single_input: compound_stmt NEWLINE  */
#line 410 "m2.y"
                                               { (yyval.attr).node_id=dfn+1; (yyvsp[0].attr).node_id= dfn;  create_node("","single_input",(yyval.attr).node_id);create_node("","NEWLINE",(yyvsp[0].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 2446 "m2.tab.c"
    break;

  case 9: /* file_input: NEWstmt ENDMARKER  */
#line 412 "m2.y"
                              {  (yyval.attr).node_id = 1 + dfn;  create_node("", "file_input" , (yyval.attr).node_id );  create_node("", "ENDMARKER" , 0 + dfn );  create_edge( { (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 2; }
#line 2452 "m2.tab.c"
    break;

  case 10: /* file_input: ENDMARKER  */
#line 413 "m2.y"
                      { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn;  create_node("","ENDMARKER",(yyvsp[0].attr).node_id);  dfn++;}
#line 2458 "m2.tab.c"
    break;

  case 11: /* NEWstmt: NEWLINE  */
#line 415 "m2.y"
                 {(yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("","NEWLINE",(yyvsp[0].attr).node_id);  dfn++;}
#line 2464 "m2.tab.c"
    break;

  case 12: /* NEWstmt: stmt  */
#line 416 "m2.y"
              { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2470 "m2.tab.c"
    break;

  case 13: /* NEWstmt: NEWLINE NEWstmt  */
#line 417 "m2.y"
                         {  (yyval.attr).node_id = 1 + dfn;  create_node("", "NEWstmt" , (yyval.attr).node_id );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 2476 "m2.tab.c"
    break;

  case 14: /* NEWstmt: stmt NEWstmt  */
#line 418 "m2.y"
                      {  (yyval.attr).node_id = 0 + dfn;  create_node("", "NEWstmt" , (yyval.attr).node_id );  create_edge( { (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 1; }
#line 2482 "m2.tab.c"
    break;

  case 15: /* eval_input: testlist ENDMARKER  */
#line 420 "m2.y"
                               { (yyval.attr).node_id=dfn+1; (yyvsp[0].attr).node_id= dfn;  create_node("","eval_input",(yyval.attr).node_id);create_node("","ENDMARKER",(yyvsp[0].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 2488 "m2.tab.c"
    break;

  case 16: /* eval_input: testlist Nnew ENDMARKER  */
#line 421 "m2.y"
                                    {  (yyval.attr).node_id = 1 + dfn;  create_node("", "eval_input" , (yyval.attr).node_id );  create_node("", "ENDMARKER" , 0 + dfn );  create_edge( { (yyvsp[-2].attr).node_id, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 2; }
#line 2494 "m2.tab.c"
    break;

  case 17: /* Nnew: NEWLINE  */
#line 423 "m2.y"
              {(yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("","NEWLINE",(yyvsp[0].attr).node_id);  dfn++;}
#line 2500 "m2.tab.c"
    break;

  case 18: /* Nnew: NEWLINE Nnew  */
#line 424 "m2.y"
                   { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","Nnew",(yyval.attr).node_id);create_node("","NEWLINE",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 2506 "m2.tab.c"
    break;

  case 19: /* decorator: AT dotted_name line38 NEWLINE  */
#line 426 "m2.y"
                                         {  (yyval.attr).node_id = 2 + dfn;  create_node("", "decorator" , (yyval.attr).node_id );  create_node("@", "AT" , 1 + dfn );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-2].attr).node_id, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 2512 "m2.tab.c"
    break;

  case 20: /* decorator: AT dotted_name NEWLINE  */
#line 427 "m2.y"
                                  {  (yyval.attr).node_id = 2 + dfn;  create_node("", "decorator" , (yyval.attr).node_id );  create_node("@", "AT" , 1 + dfn );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 2518 "m2.tab.c"
    break;

  case 21: /* line38: LP line41 RP  */
#line 429 "m2.y"
                     {  (yyval.attr).node_id = 2 + dfn;  create_node("", "line38" , (yyval.attr).node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 2524 "m2.tab.c"
    break;

  case 22: /* line41: arglist  */
#line 431 "m2.y"
                { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2530 "m2.tab.c"
    break;

  case 23: /* line41: epsilon  */
#line 432 "m2.y"
                { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 2536 "m2.tab.c"
    break;

  case 24: /* decorated: decorators line40  */
#line 434 "m2.y"
                             { (yyval.attr).node_id=dfn;  create_node("","decorated",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 2542 "m2.tab.c"
    break;

  case 25: /* line40: classdef  */
#line 436 "m2.y"
                 { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2548 "m2.tab.c"
    break;

  case 26: /* line40: funcdef  */
#line 437 "m2.y"
                { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2554 "m2.tab.c"
    break;

  case 27: /* decorators: decorator  */
#line 439 "m2.y"
                      { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2560 "m2.tab.c"
    break;

  case 28: /* decorators: decorator decorators  */
#line 440 "m2.y"
                                 { (yyval.attr).node_id=dfn;  create_node("","decorators",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 2566 "m2.tab.c"
    break;

  case 29: /* $@1: %empty  */
#line 442 "m2.y"
                                { 

                curr_table->insert(string((char*)((yyvsp[-2].attr)).lexeme), "Function", "Void", offset, curr_scope, yylineno, -1);
                tables.push(curr_table);
                scope_names.push(curr_scope);
                offsets.push(offset);

                curr_table= new Sym_Table(curr_table);
                list_of_Symbol_Tables.push_back(curr_table);
                string new_scope="Function_"+string((char*)((yyvsp[-2].attr).lexeme));
                curr_scope=new_scope;
                offset=0;
                nelem=0;
                cls=0;
                /* now push all parameters into symbol table*/
                for(int i=0;i<(int)(funcparam.size());i++)
                {
                        string var_type= funcparam[i].second.first;
                        string var_name= funcparam[i].first;
                        // curr_table->insert(funcparam[i].first, "Function", funcparam[i].second.first, offset, curr_scope, yylineno-1, -1);
                        if(var_type=="self")
                        {
                                cls=1;
                                if(string((char*)((yyvsp[-2].attr).lexeme))=="__init__")
                                {
                                        // func_init_list[class_name_present]
                                        // cout<<"self init declared .. "<<class_name_present<<"\n";
                                        for(int j=1;j<(int)(funcparam.size());j++)
                                        {
                                              func_init_list[class_name_present].push_back(funcparam[j].second.first); 
                                        }
                                }
                                // cout<<"declared .. "<<class_name_present<<": "<<string((char*)($2.lexeme))<<"\n";
                                for(int j=1;j<(int)(funcparam.size());j++)
                                {
                                        class_func_list[{class_name_present,string((char*)((yyvsp[-2].attr).lexeme))}].push_back(funcparam[j].second.first); 
                                }
                        }
                        else if(var_type[0]=='l' )
                        {
                                /* list as parameter */
                                curr_table->insert(funcparam[i].first, "PRIMITIVES", funcparam[i].second.first, offset, curr_scope, yylineno-1, 0);

                                if(var_type[5]=='i' || var_type[5]=='f' ) offset+=(4);
                                else if(var_type[5]=='b' ) offset+=(4);
                        }
                        else if(var_type[0]=='s')
                        {
                                /* string as parameter */
                                curr_table->insert(funcparam[i].first,  "PRIMITIVES", funcparam[i].second.first, offset, curr_scope, yylineno-1, 0);
                                offset+=(4);
                        }
                        else 
                        {
                                /* int bool float as parameter */
                                curr_table->insert(funcparam[i].first,  "PRIMITIVES", funcparam[i].second.first, offset, curr_scope, yylineno-1, -1);
                                if(var_type[0]=='i' || var_type[0]=='f' ) offset+=(4);
                                else if(var_type[0]=='b' ) offset+=(4);
                        }
                
                }

                func_decl_list[string((char*)((yyvsp[-2].attr)).lexeme)].push_back("1");
                func_decl_list[string((char*)((yyvsp[-2].attr)).lexeme)].pop_back();

                if(cls==0) 
                {
                        // func_decl_list[string((char*)($2).lexeme)]=funcparam;
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                func_decl_list[string((char*)((yyvsp[-2].attr)).lexeme)].push_back(var_type);
                        }
                }
                else
                {
                        // cout<<"here came actually";
                        // cout<<string((char*)($2).lexeme)<<"--> ";
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                curr_table->class_func_args[string((char*)((yyvsp[-2].attr)).lexeme)].push_back(var_type);
                                // cout<<"{"<<i<<" , "<<var_type<<"} ";
                        }
                        // cout<<"\n";
                        // cout<<curr_table_<<" "<<string((char*)($2).lexeme)<<" "<<curr_table->class_func_args["__init__"].size()<<"\n";
                        // cout<<"\n";
                        // if(curr_table->class_func_args.find("__init__") != curr_table->class_func_args.end()) cout<<"here ";
                        // else cout<<"not here";
                }
                
                funcparam.clear();
}
#line 2664 "m2.tab.c"
    break;

  case 30: /* funcdef: DEF NAME parameters COL $@1 suite  */
#line 534 "m2.y"
        { 

                /* get back to previous scope*/ 
                curr_table->sz=offset;
                curr_table->table_name=scope_names.top();
                curr_table=tables.top();
                tables.pop();
                curr_scope=scope_names.top();
                scope_names.pop();
                offset=offsets.top();
                offsets.pop();

}
#line 2682 "m2.tab.c"
    break;

  case 31: /* $@2: %empty  */
#line 547 "m2.y"
                                             { 
        // cout<<"hebdbuqally";
                curr_table->insert(string((char*)((yyvsp[-4].attr)).lexeme), "Function", string((char*)((yyvsp[-1].attr)).type), offset, curr_scope, yylineno, -1);
                tables.push(curr_table);
                scope_names.push(curr_scope);
                offsets.push(offset);

                curr_table= new Sym_Table(curr_table);
                list_of_Symbol_Tables.push_back(curr_table);
                string new_scope="Function_"+string((char*)((yyvsp[-4].attr).lexeme));
                curr_scope=new_scope;
                offset=0;
                nelem=0;
                /* now push all parameters into symbol table*/
                cls=0;
                for(int i=0;i<(int)(funcparam.size());i++)
                {
                        string var_type= funcparam[i].second.first;
                        string var_name= funcparam[i].first;
                        // curr_table->insert(funcparam[i].fiassdefrst, "Function", funcparam[i].second.first, offset, curr_scope, yylineno-1, -1);
                        if(var_type=="self")
                        {
                                cls=1;
                                if(string((char*)((yyvsp[-4].attr).lexeme))=="__init__")
                                {
                                        // func_init_list[class_name_present]
                                        // cout<<"self init declared .. "<<class_name_present<<"\n";
                                        for(int j=1;j<(int)(funcparam.size());j++)
                                        {
                                              func_init_list[class_name_present].push_back(funcparam[j].second.first); 
                                        }
                                }
                                for(int j=0;j<(int)(funcparam.size());j++)
                                {
                                        class_func_list[{class_name_present,string((char*)((yyvsp[-4].attr).lexeme))}].push_back(funcparam[j].second.first); 
                                }
                        }
                        else if(var_type[0]=='l' )
                        {
                                /* list as parameter */
                                curr_table->insert(funcparam[i].first, "PRIMITIVES", funcparam[i].second.first, offset, curr_scope, yylineno-1, 0);

                                if(var_type[5]=='i' || var_type[5]=='f' ) offset+=(4);
                                else if(var_type[5]=='b' ) offset+=(4);
                        }
                        else if(var_type[0]=='s')
                        {
                                /* string as parameter */
                                // int string_count=$5.cnt;
                                curr_table->insert(funcparam[i].first,  "PRIMITIVES", funcparam[i].second.first, offset, curr_scope, yylineno-1, 0);
                                offset+=(4);
                        }
                        else 
                        {
                                /* int bool float as parameter */
                                curr_table->insert(funcparam[i].first,  "PRIMITIVES", funcparam[i].second.first, offset, curr_scope, yylineno-1, -1);
                                if(var_type[0]=='i' || var_type[0]=='f' ) offset+=(4);
                                else if(var_type[0]=='b' ) offset+=(4);
                        }
                
                }
                func_decl_list[string((char*)((yyvsp[-4].attr)).lexeme)].push_back("1");
                func_decl_list[string((char*)((yyvsp[-4].attr)).lexeme)].pop_back();
                for(int i=0;i<(int)(funcparam.size());i++)
                {
                        string var_type= funcparam[i].second.first;
                        func_decl_list[string((char*)((yyvsp[-4].attr)).lexeme)].push_back(var_type);
                }


                if(cls==0) 
                {
                        // func_decl_list[string((char*)($2).lexeme)]=funcparam;
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                func_decl_list[string((char*)((yyvsp[-4].attr)).lexeme)].push_back(var_type);
                        }
                }
                else
                {
                        // cout<<string((char*)($2).lexeme)<<"--> ";
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                curr_table->class_func_args[string((char*)((yyvsp[-4].attr)).lexeme)].push_back(var_type);
                                // cout<<"{"<<i<<" , "<<var_type<<"} ";
                        }
                }
                funcparam.clear();
                
        }
#line 2779 "m2.tab.c"
    break;

  case 32: /* funcdef: DEF NAME parameters ARROW prime COL $@2 suite  */
#line 640 "m2.y"
        {
                /* get back to previous scope*/ 
                curr_table->sz=offset;
                curr_table->table_name=scope_names.top();
                curr_table=tables.top();
                tables.pop();
                curr_scope=scope_names.top();
                scope_names.pop();
                offset=offsets.top();
                offsets.pop();
        }
#line 2795 "m2.tab.c"
    break;

  case 33: /* parameters: LP fpdefq RP  */
#line 653 "m2.y"
                         {  (yyval.attr).node_id = 2 + dfn;  create_node("", "parameters" , (yyval.attr).node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 2801 "m2.tab.c"
    break;

  case 34: /* parameters: LP fplist fpdefq RP  */
#line 654 "m2.y"
                                {  (yyval.attr).node_id = 2 + dfn;  create_node("", "parameters" , (yyval.attr).node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-2].attr).node_id, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 2807 "m2.tab.c"
    break;

  case 35: /* fpdef: NAME COL prim  */
#line 656 "m2.y"
                     { 
        funcparam.push_back({string((char*)((yyvsp[-2].attr)).lexeme),{string((char*)((yyvsp[0].attr)).type),-1}}) ; 
        nelem++;
        }
#line 2816 "m2.tab.c"
    break;

  case 36: /* fpdef: SELF  */
#line 660 "m2.y"
            { 

        funcparam.push_back({string((char*)((yyvsp[0].attr)).lexeme),{"self",-1}}) ; 
        nelem++;
}
#line 2826 "m2.tab.c"
    break;

  case 37: /* fplist: fpdef COM  */
#line 666 "m2.y"
                  { (yyval.attr).node_id=dfn+1; (yyvsp[0].attr).node_id= dfn;  create_node("","fplist",(yyval.attr).node_id);create_node(",","COM",(yyvsp[0].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 2832 "m2.tab.c"
    break;

  case 38: /* fplist: fplist fpdef COM  */
#line 667 "m2.y"
                         { (yyval.attr).node_id=dfn+1; (yyvsp[0].attr).node_id= dfn ; create_node("","fplist",(yyval.attr).node_id);create_node(",","COM",(yyvsp[0].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 2838 "m2.tab.c"
    break;

  case 39: /* lines57: COM  */
#line 669 "m2.y"
              { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node(",","COM",(yyvsp[0].attr).node_id);  dfn++;}
#line 2844 "m2.tab.c"
    break;

  case 40: /* lines57: epsilon  */
#line 670 "m2.y"
                 { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 2850 "m2.tab.c"
    break;

  case 41: /* fpdefq: fpdef  */
#line 672 "m2.y"
              { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2856 "m2.tab.c"
    break;

  case 42: /* fpdefq: epsilon  */
#line 673 "m2.y"
                 { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 2862 "m2.tab.c"
    break;

  case 43: /* range_func: RANGE LP argument RP  */
#line 675 "m2.y"
                                 {  (yyval.attr).node_id = 3 + dfn;  create_node("", "range_func" , (yyval.attr).node_id );  create_node("range", "RANGE" , 2 + dfn );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 4; }
#line 2868 "m2.tab.c"
    break;

  case 44: /* range_func: RANGE LP argument argument RP  */
#line 676 "m2.y"
                                          {  (yyval.attr).node_id = 3 + dfn;  create_node("", "range_func" , (yyval.attr).node_id );  create_node("range", "RANGE" , 2 + dfn );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, (yyvsp[-2].attr).node_id, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 4; }
#line 2874 "m2.tab.c"
    break;

  case 45: /* range_func: RANGE LP argument argument argument RP  */
#line 677 "m2.y"
                                                   {  (yyval.attr).node_id = 3 + dfn;  create_node("", "range_func" , (yyval.attr).node_id );  create_node("range", "RANGE" , 2 + dfn );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, (yyvsp[-3].attr).node_id, (yyvsp[-2].attr).node_id, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 4; }
#line 2880 "m2.tab.c"
    break;

  case 46: /* stmt: simple_stmt  */
#line 679 "m2.y"
                  { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2886 "m2.tab.c"
    break;

  case 47: /* stmt: compound_stmt  */
#line 680 "m2.y"
                              { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2892 "m2.tab.c"
    break;

  case 48: /* simple_stmt: small_stmt line57 SCOL NEWLINE  */
#line 682 "m2.y"
                                            {  (yyval.attr).node_id = 2 + dfn;  create_node("", "simple_stmt" , (yyval.attr).node_id );  create_node(";", "SCOL" , 1 + dfn );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { (yyvsp[-3].attr).node_id, (yyvsp[-2].attr).node_id, 1 + dfn, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 2898 "m2.tab.c"
    break;

  case 49: /* simple_stmt: small_stmt line57 NEWLINE  */
#line 683 "m2.y"
                                       {  (yyval.attr).node_id = 1 + dfn;  create_node("", "simple_stmt" , (yyval.attr).node_id );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { (yyvsp[-2].attr).node_id, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 2; }
#line 2904 "m2.tab.c"
    break;

  case 50: /* line57: epsilon  */
#line 685 "m2.y"
                          { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id);   dfn++;}
#line 2910 "m2.tab.c"
    break;

  case 51: /* line57: line57 SCOL small_stmt  */
#line 686 "m2.y"
                                          {  (yyval.attr).node_id = 1 + dfn;  create_node("", "line57" , (yyval.attr).node_id );  create_node(";", "SCOL" , 0 + dfn );  create_edge( { (yyvsp[-2].attr).node_id, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 2916 "m2.tab.c"
    break;

  case 52: /* small_stmt: declare_stmt  */
#line 688 "m2.y"
                         { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2922 "m2.tab.c"
    break;

  case 53: /* small_stmt: expr_stmt  */
#line 689 "m2.y"
                      { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2928 "m2.tab.c"
    break;

  case 54: /* small_stmt: print_stmt  */
#line 690 "m2.y"
                       { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2934 "m2.tab.c"
    break;

  case 55: /* small_stmt: del_stmt  */
#line 691 "m2.y"
                     { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2940 "m2.tab.c"
    break;

  case 56: /* small_stmt: flow_stmt  */
#line 692 "m2.y"
                      { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2946 "m2.tab.c"
    break;

  case 57: /* small_stmt: global_stmt  */
#line 693 "m2.y"
                        { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2952 "m2.tab.c"
    break;

  case 58: /* small_stmt: exec_stmt  */
#line 694 "m2.y"
                      { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2958 "m2.tab.c"
    break;

  case 59: /* small_stmt: assert_stmt  */
#line 695 "m2.y"
                        { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2964 "m2.tab.c"
    break;

  case 60: /* expr_stmt: testlist line62  */
#line 697 "m2.y"
                                      { (yyval.attr).node_id=dfn;  create_node("","expr_stmt",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 2970 "m2.tab.c"
    break;

  case 61: /* expr_stmt: testlist  */
#line 698 "m2.y"
                              { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2976 "m2.tab.c"
    break;

  case 62: /* line61: yield_expr  */
#line 700 "m2.y"
                   { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2982 "m2.tab.c"
    break;

  case 63: /* line61: testlist  */
#line 701 "m2.y"
                 { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 2988 "m2.tab.c"
    break;

  case 64: /* line62: augassign line61  */
#line 703 "m2.y"
                         { (yyval.attr).node_id=dfn;  create_node("","line62",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 2994 "m2.tab.c"
    break;

  case 65: /* line62: EQ_yield_expr_testlist  */
#line 704 "m2.y"
                               { (yyval.attr).node_id = (yyvsp[0].attr).node_id;}
#line 3000 "m2.tab.c"
    break;

  case 66: /* EQ_yield_expr_testlist: EQ line61  */
#line 706 "m2.y"
                                  { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","EQ_yield_expr_testlist",(yyval.attr).node_id);create_node("=","EQ",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3006 "m2.tab.c"
    break;

  case 67: /* EQ_yield_expr_testlist: EQ line61 EQ_yield_expr_testlist  */
#line 707 "m2.y"
                                                         { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn ; create_node("","EQ_yield_expr_testlist",(yyval.attr).node_id);create_node("=","EQ",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3012 "m2.tab.c"
    break;

  case 68: /* augassign: PE  */
#line 709 "m2.y"
              { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("+=","PE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3018 "m2.tab.c"
    break;

  case 69: /* augassign: ME  */
#line 710 "m2.y"
              { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("-=","ME",(yyvsp[0].attr).node_id);  dfn++;}
#line 3024 "m2.tab.c"
    break;

  case 70: /* augassign: SE  */
#line 711 "m2.y"
              { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("*=","SE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3030 "m2.tab.c"
    break;

  case 71: /* augassign: DE  */
#line 712 "m2.y"
              { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("/=","DE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3036 "m2.tab.c"
    break;

  case 72: /* augassign: MODE  */
#line 713 "m2.y"
                { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("%=","MODE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3042 "m2.tab.c"
    break;

  case 73: /* augassign: ANDE  */
#line 714 "m2.y"
                { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("&=","ANDE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3048 "m2.tab.c"
    break;

  case 74: /* augassign: BOE  */
#line 715 "m2.y"
               { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("|=","BOE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3054 "m2.tab.c"
    break;

  case 75: /* augassign: BXE  */
#line 716 "m2.y"
               { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("^=","BXE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3060 "m2.tab.c"
    break;

  case 76: /* augassign: LSE  */
#line 717 "m2.y"
               { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("<<=","LSE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3066 "m2.tab.c"
    break;

  case 77: /* augassign: RSE  */
#line 718 "m2.y"
               { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node(">>=","RSE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3072 "m2.tab.c"
    break;

  case 78: /* augassign: SSE  */
#line 719 "m2.y"
               { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("**=","SSE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3078 "m2.tab.c"
    break;

  case 79: /* augassign: FFE  */
#line 720 "m2.y"
               { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("//=","FFE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3084 "m2.tab.c"
    break;

  case 80: /* print_stmt: PRINT line67  */
#line 722 "m2.y"
                         {  (yyval.attr).node_id = 1 + dfn;  create_node("", "print_stmt" , (yyval.attr).node_id );  create_node("print", "PRINT" , 0 + dfn );  create_edge( { 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 3090 "m2.tab.c"
    break;

  case 81: /* line67: lines74  */
#line 724 "m2.y"
                { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3096 "m2.tab.c"
    break;

  case 82: /* line67: RS test lines75  */
#line 725 "m2.y"
                        { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn ; create_node("","line67",(yyval.attr).node_id);create_node(">>","RS",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3102 "m2.tab.c"
    break;

  case 83: /* lines74: test line68  */
#line 727 "m2.y"
                     { (yyval.attr).node_id=dfn;  create_node("","lines74",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3108 "m2.tab.c"
    break;

  case 84: /* lines74: epsilon  */
#line 728 "m2.y"
                 { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3114 "m2.tab.c"
    break;

  case 85: /* lines75: COM_test lines57  */
#line 730 "m2.y"
                          { (yyval.attr).node_id=dfn;  create_node("","lines75",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3120 "m2.tab.c"
    break;

  case 86: /* lines75: epsilon  */
#line 731 "m2.y"
                 { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3126 "m2.tab.c"
    break;

  case 87: /* line68: COM_test lines57  */
#line 733 "m2.y"
                         { (yyval.attr).node_id=dfn;  create_node("","lines68",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3132 "m2.tab.c"
    break;

  case 88: /* line68: lines57  */
#line 734 "m2.y"
                { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3138 "m2.tab.c"
    break;

  case 89: /* del_stmt: DEL exprlist  */
#line 736 "m2.y"
                       { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","del_stmt",(yyval.attr).node_id);create_node("del","DEL",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3144 "m2.tab.c"
    break;

  case 90: /* flow_stmt: break_stmt  */
#line 738 "m2.y"
                      { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3150 "m2.tab.c"
    break;

  case 91: /* flow_stmt: continue_stmt  */
#line 739 "m2.y"
                         { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3156 "m2.tab.c"
    break;

  case 92: /* flow_stmt: return_stmt  */
#line 740 "m2.y"
                       { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3162 "m2.tab.c"
    break;

  case 93: /* flow_stmt: raise_stmt  */
#line 741 "m2.y"
                      { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3168 "m2.tab.c"
    break;

  case 94: /* flow_stmt: yield_stmt  */
#line 742 "m2.y"
                      { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3174 "m2.tab.c"
    break;

  case 95: /* break_stmt: BREAK  */
#line 744 "m2.y"
                  { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("break","BREAK",(yyvsp[0].attr).node_id);  dfn++;}
#line 3180 "m2.tab.c"
    break;

  case 96: /* continue_stmt: CONTINUE  */
#line 746 "m2.y"
                        { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("continue","CONTINUE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3186 "m2.tab.c"
    break;

  case 97: /* return_stmt: RETURN lines84  */
#line 748 "m2.y"
                            { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","return_stmt",(yyval.attr).node_id);create_node("return","RETURN",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3192 "m2.tab.c"
    break;

  case 98: /* lines84: testlist  */
#line 750 "m2.y"
                  { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3198 "m2.tab.c"
    break;

  case 99: /* lines84: epsilon  */
#line 751 "m2.y"
                 { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3204 "m2.tab.c"
    break;

  case 100: /* yield_stmt: yield_expr  */
#line 753 "m2.y"
                       { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3210 "m2.tab.c"
    break;

  case 101: /* raise_stmt: RAISE lines89  */
#line 755 "m2.y"
                          { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","raise_stmt",(yyval.attr).node_id);create_node("raise","RAISE",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3216 "m2.tab.c"
    break;

  case 102: /* lines87: COM test  */
#line 757 "m2.y"
                  { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","lines87",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3222 "m2.tab.c"
    break;

  case 103: /* lines87: epsilon  */
#line 758 "m2.y"
                 { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3228 "m2.tab.c"
    break;

  case 104: /* lines88: COM test lines87  */
#line 760 "m2.y"
                          { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn;  create_node("","lines88",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3234 "m2.tab.c"
    break;

  case 105: /* lines88: epsilon  */
#line 761 "m2.y"
                 { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3240 "m2.tab.c"
    break;

  case 106: /* lines89: test lines88  */
#line 763 "m2.y"
                      { (yyval.attr).node_id=dfn;  create_node("","lines89",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3246 "m2.tab.c"
    break;

  case 107: /* lines89: epsilon  */
#line 764 "m2.y"
                 { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3252 "m2.tab.c"
    break;

  case 108: /* dotted_name: NAME FS_NAME  */
#line 766 "m2.y"
                          { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","dotted_name",(yyval.attr).node_id);create_node((yyvsp[-1].attr).lexeme,"NAME",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3258 "m2.tab.c"
    break;

  case 109: /* dotted_name: NAME  */
#line 767 "m2.y"
                   { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node((yyvsp[0].attr).lexeme,"NAME",(yyvsp[0].attr).node_id);  dfn++;}
#line 3264 "m2.tab.c"
    break;

  case 110: /* FS_NAME: FS NAME FS_NAME  */
#line 769 "m2.y"
                          {  (yyval.attr).node_id = 2 + dfn;  create_node("", "FS_NAME" , (yyval.attr).node_id );  create_node(".", "FS" , 1 + dfn );  create_node((yyvsp[-1].attr).lexeme, "NAME" , 0 + dfn );  create_edge( { (yyvsp[-2].attr).node_id, 1 + dfn, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 3270 "m2.tab.c"
    break;

  case 111: /* FS_NAME: FS NAME  */
#line 770 "m2.y"
                  { (yyval.attr).node_id=dfn+2; (yyvsp[-1].attr).node_id= dfn+1; (yyvsp[0].attr).node_id=dfn;  create_node("","FS_NAME",(yyval.attr).node_id);create_node(".","FS",(yyvsp[-1].attr).node_id);create_node((yyvsp[0].attr).lexeme,"NAME",(yyvsp[0].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=3;}
#line 3276 "m2.tab.c"
    break;

  case 112: /* global_stmt: GLOBAL NAME COM_NAME  */
#line 772 "m2.y"
                                  { (yyval.attr).node_id=dfn+2; (yyvsp[-2].attr).node_id= dfn+1; (yyvsp[-1].attr).node_id=dfn;  create_node("","global_stmt",(yyval.attr).node_id);create_node("global","GLOBAL",(yyvsp[-2].attr).node_id);create_node((yyvsp[-1].attr).lexeme,"NAME",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=3;}
#line 3282 "m2.tab.c"
    break;

  case 113: /* global_stmt: GLOBAL NAME  */
#line 773 "m2.y"
                         { (yyval.attr).node_id=dfn+2; (yyvsp[-1].attr).node_id= dfn+1; (yyvsp[0].attr).node_id=dfn;  create_node("","global_stmt",(yyval.attr).node_id);create_node("global","GLOBAL",(yyvsp[-1].attr).node_id);create_node((yyvsp[0].attr).lexeme,"NAME",(yyvsp[0].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=3;}
#line 3288 "m2.tab.c"
    break;

  case 114: /* COM_NAME: COM NAME COM_NAME  */
#line 775 "m2.y"
                            {  (yyval.attr).node_id = 2 + dfn;  create_node("", "COM_NAME" , (yyval.attr).node_id );  create_node(",", "COM" , 1 + dfn );  create_node((yyvsp[-1].attr).lexeme, "NAME" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3294 "m2.tab.c"
    break;

  case 115: /* COM_NAME: COM NAME  */
#line 776 "m2.y"
                   { (yyval.attr).node_id=dfn+2; (yyvsp[-1].attr).node_id= dfn+1; (yyvsp[0].attr).node_id=dfn;  create_node("","COM_NAME",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-1].attr).node_id);create_node((yyvsp[0].attr).lexeme,"NAME",(yyvsp[0].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=3;}
#line 3300 "m2.tab.c"
    break;

  case 116: /* exec_stmt: EXEC expr lines110  */
#line 778 "m2.y"
                              { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn; create_node("","exec_stmt",(yyval.attr).node_id);create_node("exec","EXEC",(yyvsp[-2].attr).node_id);create_node("","NAME",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3306 "m2.tab.c"
    break;

  case 117: /* lines110: IN test lines87  */
#line 780 "m2.y"
                          { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn ; create_node("","lines110",(yyval.attr).node_id);create_node("in","IN",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3312 "m2.tab.c"
    break;

  case 118: /* lines110: epsilon  */
#line 781 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3318 "m2.tab.c"
    break;

  case 119: /* assert_stmt: ASSERT test lines87  */
#line 783 "m2.y"
                                 { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn ; create_node("","assert_stmt",(yyval.attr).node_id);create_node("assert","ASSERT",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3324 "m2.tab.c"
    break;

  case 120: /* prim: primitives  */
#line 785 "m2.y"
                 { strcpy((yyval.attr).type, (yyvsp[0].attr).type);(yyval.attr).Isobj=0;}
#line 3330 "m2.tab.c"
    break;

  case 121: /* prim: NAME  */
#line 786 "m2.y"
           { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); (yyval.attr).Isobj=1;}
#line 3336 "m2.tab.c"
    break;

  case 122: /* primitives: PRIMITIVES  */
#line 788 "m2.y"
                       { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); }
#line 3342 "m2.tab.c"
    break;

  case 123: /* primitives: LIST LB primitives RB  */
#line 789 "m2.y"
                                  {
                strcpy((yyval.attr).type,("list["+string((char*)((yyvsp[-1].attr)).type)+"]").c_str());
                //  strcpy($$.type, $1.lexeme);
                  }
#line 3351 "m2.tab.c"
    break;

  case 124: /* prime: prim  */
#line 794 "m2.y"
            { strcpy((yyval.attr).type, (yyvsp[0].attr).type);}
#line 3357 "m2.tab.c"
    break;

  case 125: /* prime: NONE  */
#line 795 "m2.y"
            { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme);}
#line 3363 "m2.tab.c"
    break;

  case 126: /* declare_stmt: atom_expr COL prim  */
#line 797 "m2.y"
                                 {
                /* ( list str  , int float bool ) */
                // if()
                string var_type= string((char*)((yyvsp[0].attr)).type);
                string var_name= string((char*)((yyvsp[-2].attr)).type);
                // cout<<var_type<<"mouryaaaaa "<<var_name<<"\n";
                // if(var_type)
                if((yyvsp[0].attr).Isobj==1)
                {
                        /* object is being declared  */
                        curr_table->insert(string((char*)((yyvsp[-2].attr)).type), "Object", string((char*)((yyvsp[0].attr)).type), offset, curr_scope, yylineno-1, -1 );
                        // class_name_map
                        if(class_name_map.find(var_type)==class_name_map.end()) 
                        {
                                cout<<"Error: Use of Undeclared class "<<var_type<<endl;
                                exit(0);
                        }
                        Sym_Table* temp_class_table=class_name_map[var_type];
                        offset+=(say_size_of_table(temp_class_table));
                }
                else
                {
                        if(var_name.size()>=4 && var_name[4]=='.')
                        {
                                // cout<<"ocahava";
                                /* this is slef created a variable so add it in parent class */
                                Sym_Table* temp_parent_table=tables.top();
                                int temp_parent_offset=offsets.top();
                                offsets.pop();/* only parents offset is needed to change in stack */
                                string temp_parent_scope=scope_names.top();
                                if(var_type[0]=='l')
                                {
                                        // list[int bool str float]
                                        int list_count=0;
                                        temp_parent_table->insert(substring_after_dot(((char*)((yyvsp[-2].attr)).type)), "PRIMITIVES", string((char*)((yyvsp[0].attr)).type), temp_parent_offset, temp_parent_scope, yylineno-1, list_count );

                                        if(var_type[5]=='i' || var_type[5]=='f' ) temp_parent_offset+=list_count*(4);
                                        else if(var_type[5]=='b' ) temp_parent_offset+=list_count*(1);
                                }
                                else if(var_type[0]=='s')
                                {
                                        // str
                                        int string_count=0;
                                        temp_parent_table->insert(substring_after_dot(string((char*)((yyvsp[-2].attr)).type)), "PRIMITIVES", string((char*)((yyvsp[0].attr)).type), temp_parent_offset, temp_parent_scope, yylineno-1, string_count);
                                        temp_parent_offset+=string_count*(1);
                                }
                                else
                                {
                                        // int , bool, float
                                        temp_parent_table->insert(substring_after_dot(string((char*)((yyvsp[-2].attr)).type)), "PRIMITIVES", string((char*)((yyvsp[0].attr)).type), temp_parent_offset, temp_parent_scope, yylineno-1, -1);
                                        if(var_type[0]=='i' || var_type[0]=='f' ) temp_parent_offset+=(4);
                                        else if(var_type[0]=='b' ) temp_parent_offset+=(1);
                                }
                                offsets.push(temp_parent_offset);/* only parents offset is needed to change in stack */
                        }
                        else if(var_type[0]=='l')
                        {
                                // list[int bool str float]
                                curr_table->insert(string((char*)((yyvsp[-2].attr)).type), "PRIMITIVES", string((char*)((yyvsp[0].attr)).type), offset, curr_scope, yylineno-1, -1 );

                                if(var_type[5]=='i' || var_type[5]=='f' ) offset+=(4);
                                else if(var_type[5]=='b' ) offset+=(1);
                        }
                        else if(var_type[0]=='s')
                        {
                                // str
                                curr_table->insert(string((char*)((yyvsp[-2].attr)).type), "PRIMITIVES", string((char*)((yyvsp[0].attr)).type), offset, curr_scope, yylineno-1, -1 );
                                offset+=(1);
                        }
                        else
                        {
                                // int , bool, float
                                curr_table->insert(string((char*)((yyvsp[-2].attr)).type), "PRIMITIVES", string((char*)((yyvsp[0].attr)).type), offset, curr_scope, yylineno-1, -1 );
                                if(var_type[0]=='i' || var_type[0]=='f' ) offset+=(4);
                                else if(var_type[0]=='b' ) offset+=(1);
                        }
                }
                // curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, -1);
                // offset+=getsize(string((char*)($3).type));
                // cout << endl<<$5.cnt << "ewgfdjew"<<endl;
            }
#line 3449 "m2.tab.c"
    break;

  case 127: /* declare_stmt: atom_expr COL prim EQ test  */
#line 878 "m2.y"
                                         {
                /* ( list str  , int float bool ) */
                // if()
                /*  type checking */
                string test_str= string((char*)((yyvsp[0].attr)).type);
                string var_type= string((char*)((yyvsp[-2].attr)).type);
                string var_name= string((char*)((yyvsp[-4].attr)).type);
                // cout<<"\nhere came annamata"<<var_name<<" ";
                // cout<<var_type<<"mouryaaaaa "<<var_name<<"\n";
                if((yyvsp[-2].attr).Isobj==1)
                {

                        /* object is being declared  */
                        curr_table->insert(string((char*)((yyvsp[-4].attr)).type), "Object", string((char*)((yyvsp[-2].attr)).type), offset, curr_scope, yylineno-1, -1 );
                        if(class_name_map.find(var_type)==class_name_map.end()) 
                        {
                                cout<<"Error: Use of Undeclared class "<<var_type<<endl;
                                exit(0);
                        }
                        Sym_Table* temp_class_table=class_name_map[var_type];
                        offset+=(say_size_of_table(temp_class_table));
                }
                else
                {
                        // cout<<"here 666....";
                        if(var_name.size()>=4 && var_name[4]=='.')
                        {
                                // cout<<"ocahava";
                                /* this is slef created a variable so add it in parent class */
                                Sym_Table* temp_parent_table=tables.top();
                                int temp_parent_offset=offsets.top();
                                offsets.pop();/* only parents offset is needed to change in stack */
                                string temp_parent_scope=scope_names.top();
                                if(var_type[0]=='l')
                                {
                                        // list[int bool str float]
                                        type_check_func(In_BTW_BOXES(string((char*)((yyvsp[-2].attr)).type)),string((char*)((yyvsp[0].attr)).data_type));
                                        int list_count=(yyvsp[0].attr).cnt;
                                        temp_parent_table->insert(substring_after_dot(((char*)((yyvsp[-4].attr)).type)), "PRIMITIVES", string((char*)((yyvsp[-2].attr)).type), temp_parent_offset, temp_parent_scope, yylineno-1, list_count );

                                        if(var_type[5]=='i' || var_type[5]=='f' ) temp_parent_offset+=list_count*(4);
                                        else if(var_type[5]=='b' ) temp_parent_offset+=list_count*(1);
                                }
                                else if(var_type[0]=='s')
                                {
                                        // str
                                        type_check_func(string((char*)((yyvsp[-2].attr)).type),string((char*)((yyvsp[0].attr)).data_type));
                                        int string_count=(yyvsp[0].attr).cnt;
                                        temp_parent_table->insert(substring_after_dot(string((char*)((yyvsp[-4].attr)).type)), "PRIMITIVES", string((char*)((yyvsp[-2].attr)).type), temp_parent_offset, temp_parent_scope, yylineno-1, string_count);
                                        temp_parent_offset+=string_count*(1);
                                }
                                else
                                {
                                        // int , bool, float
                                        type_check_func(string((char*)((yyvsp[-2].attr)).type),string((char*)((yyvsp[0].attr)).data_type));
                                        temp_parent_table->insert(substring_after_dot(string((char*)((yyvsp[-4].attr)).type)), "PRIMITIVES", string((char*)((yyvsp[-2].attr)).type), temp_parent_offset, temp_parent_scope, yylineno-1, -1);
                                        if(var_type[0]=='i' || var_type[0]=='f' ) temp_parent_offset+=(4);
                                        else if(var_type[0]=='b' ) temp_parent_offset+=(1);
                                }
                                offsets.push(temp_parent_offset);/* only parents offset is needed to change in stack */
                        }
                        else if(var_type[0]=='l')
                        {
                                // list[int bool str float]
                                type_check_func(In_BTW_BOXES(string((char*)((yyvsp[-2].attr)).type)),string((char*)((yyvsp[0].attr)).data_type));

                                int list_count=(yyvsp[0].attr).cnt;
                                curr_table->insert(string((char*)((yyvsp[-4].attr)).type), "PRIMITIVES", string((char*)((yyvsp[-2].attr)).type), offset, curr_scope, yylineno-1, list_count );

                                if(var_type[5]=='i' || var_type[5]=='f' ) offset+=list_count*(4);
                                else if(var_type[5]=='b' ) offset+=list_count*(1);
                        }
                        else if(var_type[0]=='s')
                        {
                                // str
                                type_check_func(string((char*)((yyvsp[-2].attr)).type),string((char*)((yyvsp[0].attr)).data_type));
                                int string_count=(yyvsp[0].attr).cnt;
                                curr_table->insert(string((char*)((yyvsp[-4].attr)).type), "PRIMITIVES", string((char*)((yyvsp[-2].attr)).type), offset, curr_scope, yylineno-1, string_count );
                                offset+=string_count*(1);
                        }
                        else
                        {
                                // int , bool, float
                                type_check_func(string((char*)((yyvsp[-2].attr)).type),string((char*)((yyvsp[0].attr)).data_type));
                                curr_table->insert(string((char*)((yyvsp[-4].attr)).type), "PRIMITIVES", string((char*)((yyvsp[-2].attr)).type), offset, curr_scope, yylineno-1, -1 );
                                if(var_type[0]=='i' || var_type[0]=='f' ) offset+=(4);
                                else if(var_type[0]=='b' ) offset+=(1);
                        }

                }
            }
#line 3545 "m2.tab.c"
    break;

  case 128: /* compound_stmt: if_stmt  */
#line 970 "m2.y"
                       { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3551 "m2.tab.c"
    break;

  case 129: /* compound_stmt: while_stmt  */
#line 971 "m2.y"
                          { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3557 "m2.tab.c"
    break;

  case 130: /* compound_stmt: for_stmt  */
#line 972 "m2.y"
                        { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3563 "m2.tab.c"
    break;

  case 131: /* compound_stmt: try_stmt  */
#line 973 "m2.y"
                        { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3569 "m2.tab.c"
    break;

  case 132: /* compound_stmt: with_stmt  */
#line 974 "m2.y"
                         { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3575 "m2.tab.c"
    break;

  case 133: /* compound_stmt: funcdef  */
#line 975 "m2.y"
                       { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3581 "m2.tab.c"
    break;

  case 134: /* compound_stmt: classdef  */
#line 976 "m2.y"
                        { }
#line 3587 "m2.tab.c"
    break;

  case 135: /* compound_stmt: decorated  */
#line 977 "m2.y"
                         { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3593 "m2.tab.c"
    break;

  case 136: /* if_stmt: IF expr_stmt COL suite ELIF_test_COL_suite lines115  */
#line 979 "m2.y"
                                                             {  (yyval.attr).node_id = 2 + dfn;  create_node("", "if_stmt" , (yyval.attr).node_id );  create_node("if", "IF" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-4].attr).node_id, 0 + dfn, (yyvsp[-2].attr).node_id, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3599 "m2.tab.c"
    break;

  case 137: /* if_stmt: IF expr_stmt COL suite lines115  */
#line 980 "m2.y"
                                         {  (yyval.attr).node_id = 2 + dfn;  create_node("", "if_stmt" , (yyval.attr).node_id );  create_node("if", "IF" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3605 "m2.tab.c"
    break;

  case 138: /* lines115: ELSE COL suite  */
#line 982 "m2.y"
                         { (yyval.attr).node_id=dfn+2; (yyvsp[-2].attr).node_id= dfn+1; (yyvsp[-1].attr).node_id=dfn;  create_node("","lines115",(yyval.attr).node_id);create_node("else","ELSE",(yyvsp[-2].attr).node_id);create_node(":","COL",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=3;}
#line 3611 "m2.tab.c"
    break;

  case 139: /* lines115: epsilon  */
#line 983 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3617 "m2.tab.c"
    break;

  case 140: /* ELIF_test_COL_suite: ELIF expr_stmt COL suite ELIF_test_COL_suite  */
#line 985 "m2.y"
                                                                  {  (yyval.attr).node_id = 2 + dfn;  create_node("", "ELIF_test_COL_suite" , (yyval.attr).node_id );  create_node("elif", "ELIF" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3623 "m2.tab.c"
    break;

  case 141: /* ELIF_test_COL_suite: ELIF expr_stmt COL suite  */
#line 986 "m2.y"
                                              {  (yyval.attr).node_id = 2 + dfn;  create_node("", "ELIF_test_COL_suite" , (yyval.attr).node_id );  create_node("elif", "ELIF" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-2].attr).node_id, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3629 "m2.tab.c"
    break;

  case 142: /* while_stmt: WHILE expr_stmt COL suite lines115  */
#line 988 "m2.y"
                                               {  (yyval.attr).node_id = 2 + dfn;  create_node("", "while_stmt" , (yyval.attr).node_id );  create_node("while", "WHILE" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3635 "m2.tab.c"
    break;

  case 143: /* for_stmt: FOR exprlist IN testlist COL suite lines115  */
#line 990 "m2.y"
                                                      {  (yyval.attr).node_id = 3 + dfn;  create_node("", "for_stmt" , (yyval.attr).node_id );  create_node("for", "FOR" , 2 + dfn );  create_node("in", "IN" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 2 + dfn, (yyvsp[-5].attr).node_id, 1 + dfn, (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 4; }
#line 3641 "m2.tab.c"
    break;

  case 144: /* for_stmt: FOR exprlist IN range_func COL suite lines115  */
#line 991 "m2.y"
                                                        {  (yyval.attr).node_id = 3 + dfn;  create_node("", "for_stmt" , (yyval.attr).node_id );  create_node("for", "FOR" , 2 + dfn );  create_node("in", "IN" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 2 + dfn, (yyvsp[-5].attr).node_id, 1 + dfn, (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 4; }
#line 3647 "m2.tab.c"
    break;

  case 145: /* try_stmt: TRY COL suite line105  */
#line 993 "m2.y"
                                {  (yyval.attr).node_id = 2 + dfn;  create_node("", "try_stmt" , (yyval.attr).node_id );  create_node("try", "TRY" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3653 "m2.tab.c"
    break;

  case 146: /* line105: except_clause_COL_suite lines115 lines121  */
#line 995 "m2.y"
                                                   {  (yyval.attr).node_id = 0 + dfn;  create_node("", "line105" , (yyval.attr).node_id );  create_edge( { (yyvsp[-2].attr).node_id, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 1; }
#line 3659 "m2.tab.c"
    break;

  case 147: /* line105: FINALLY COL suite  */
#line 996 "m2.y"
                           {  (yyval.attr).node_id = 2 + dfn;  create_node("", "line105" , (yyval.attr).node_id );  create_node("finally", "FINALLY" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3665 "m2.tab.c"
    break;

  case 148: /* lines121: FINALLY COL suite  */
#line 998 "m2.y"
                            {  (yyval.attr).node_id = 2 + dfn;  create_node("", "lines121" , (yyval.attr).node_id );  create_node("finally", "FINALLY" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3671 "m2.tab.c"
    break;

  case 149: /* lines121: epsilon  */
#line 999 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3677 "m2.tab.c"
    break;

  case 150: /* except_clause_COL_suite: except_clause COL suite except_clause_COL_suite  */
#line 1001 "m2.y"
                                                                         {  (yyval.attr).node_id = 1 + dfn;  create_node("", "except_clause_COL_suite" , (yyval.attr).node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 3683 "m2.tab.c"
    break;

  case 151: /* except_clause_COL_suite: except_clause COL suite  */
#line 1002 "m2.y"
                                                 {  (yyval.attr).node_id = 1 + dfn;  create_node("", "except_clause_COL_suite" , (yyval.attr).node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { (yyvsp[-2].attr).node_id, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 3689 "m2.tab.c"
    break;

  case 152: /* with_stmt: WITH with_item line108  */
#line 1004 "m2.y"
                                  { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn ; create_node("","with_stmt",(yyval.attr).node_id);create_node("with","WITH",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3695 "m2.tab.c"
    break;

  case 153: /* line108: COM_with_item COL suite  */
#line 1006 "m2.y"
                                 {  (yyval.attr).node_id = 1 + dfn;  create_node("", "line108" , (yyval.attr).node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { (yyvsp[-2].attr).node_id, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 3701 "m2.tab.c"
    break;

  case 154: /* line108: COL suite  */
#line 1007 "m2.y"
                   { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","line108",(yyval.attr).node_id);create_node(":","COL",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3707 "m2.tab.c"
    break;

  case 155: /* COM_with_item: COM with_item COM_with_item  */
#line 1009 "m2.y"
                                           { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn ; create_node("","COM_with_item",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3713 "m2.tab.c"
    break;

  case 156: /* COM_with_item: COM with_item  */
#line 1010 "m2.y"
                             { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","COM_with_item",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3719 "m2.tab.c"
    break;

  case 157: /* with_item: test lines127  */
#line 1012 "m2.y"
                         { (yyval.attr).node_id=dfn;  create_node("","with_item",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3725 "m2.tab.c"
    break;

  case 158: /* lines127: AS expr  */
#line 1014 "m2.y"
                  { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","lines127",(yyval.attr).node_id);create_node("as","AS",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3731 "m2.tab.c"
    break;

  case 159: /* lines127: epsilon  */
#line 1015 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3737 "m2.tab.c"
    break;

  case 160: /* except_clause: EXCEPT lines130  */
#line 1017 "m2.y"
                               { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","except_clause",(yyval.attr).node_id);create_node("except","EXCEPT",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3743 "m2.tab.c"
    break;

  case 161: /* lines129: line112 test  */
#line 1019 "m2.y"
                       { (yyval.attr).node_id=dfn;  create_node("","lines129",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3749 "m2.tab.c"
    break;

  case 162: /* lines129: epsilon  */
#line 1020 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3755 "m2.tab.c"
    break;

  case 163: /* lines130: test lines129  */
#line 1022 "m2.y"
                        { (yyval.attr).node_id=dfn;  create_node("","lines130",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3761 "m2.tab.c"
    break;

  case 164: /* lines130: epsilon  */
#line 1023 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3767 "m2.tab.c"
    break;

  case 165: /* line112: AS  */
#line 1025 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("as","AS",(yyvsp[0].attr).node_id);  dfn++;}
#line 3773 "m2.tab.c"
    break;

  case 166: /* line112: COM  */
#line 1026 "m2.y"
             { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node(",","COM",(yyvsp[0].attr).node_id);  dfn++;}
#line 3779 "m2.tab.c"
    break;

  case 167: /* suite: simple_stmt  */
#line 1028 "m2.y"
                   { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3785 "m2.tab.c"
    break;

  case 168: /* suite: NEWLINE INDENT stmt_ DEDENT  */
#line 1029 "m2.y"
                                   {  (yyval.attr).node_id = 3 + dfn;  create_node("", "suite" , (yyval.attr).node_id );  create_node("", "NEWLINE" , 2 + dfn );  create_node("", "INDENT" , 1 + dfn );  create_node("", "DEDENT" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 4; }
#line 3791 "m2.tab.c"
    break;

  case 169: /* stmt_: stmt stmt_  */
#line 1031 "m2.y"
                             { (yyval.attr).node_id=dfn;  create_node("","stmt_",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3797 "m2.tab.c"
    break;

  case 170: /* stmt_: stmt  */
#line 1032 "m2.y"
                      { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 3803 "m2.tab.c"
    break;

  case 171: /* testlist_safe: old_test lines135  */
#line 1034 "m2.y"
                                 { (yyval.attr).node_id=dfn;  create_node("","testlist_safe",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3809 "m2.tab.c"
    break;

  case 172: /* lines135: COM_old_test lines57  */
#line 1036 "m2.y"
                               { (yyval.attr).node_id=dfn;  create_node("","line135",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 3815 "m2.tab.c"
    break;

  case 173: /* lines135: epsilon  */
#line 1037 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3821 "m2.tab.c"
    break;

  case 174: /* COM_old_test: COM old_test COM_old_test  */
#line 1039 "m2.y"
                                                   { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn ; create_node("","COM_old_test",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3827 "m2.tab.c"
    break;

  case 175: /* COM_old_test: COM old_test  */
#line 1040 "m2.y"
                                     { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","COM_old_test",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 3833 "m2.tab.c"
    break;

  case 176: /* old_test: or_test  */
#line 1042 "m2.y"
                  { strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3839 "m2.tab.c"
    break;

  case 177: /* test: or_test lines142  */
#line 1044 "m2.y"
                       { (yyval.attr).cnt = (yyvsp[-1].attr).cnt; strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type);  }
#line 3845 "m2.tab.c"
    break;

  case 178: /* lines142: IF or_test ELSE test  */
#line 1046 "m2.y"
                               {  (yyval.attr).node_id = 2 + dfn;  create_node("", "lines142" , (yyval.attr).node_id );  create_node("if", "IF" , 1 + dfn );  create_node("else", "ELSE" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-2].attr).node_id, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 3851 "m2.tab.c"
    break;

  case 179: /* lines142: epsilon  */
#line 1047 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 3857 "m2.tab.c"
    break;

  case 180: /* or_test: and_test OR_and_test  */
#line 1049 "m2.y"
                              {  type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3863 "m2.tab.c"
    break;

  case 181: /* or_test: and_test  */
#line 1050 "m2.y"
                  {(yyval.attr).cnt = (yyvsp[0].attr).cnt;  strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3869 "m2.tab.c"
    break;

  case 182: /* OR_and_test: OR and_test OR_and_test  */
#line 1052 "m2.y"
                                     {  type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type); }
#line 3875 "m2.tab.c"
    break;

  case 183: /* OR_and_test: OR and_test  */
#line 1053 "m2.y"
                         {   strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3881 "m2.tab.c"
    break;

  case 184: /* and_test: not_test AND_not_test  */
#line 1055 "m2.y"
                                {type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3887 "m2.tab.c"
    break;

  case 185: /* and_test: not_test  */
#line 1056 "m2.y"
                   { (yyval.attr).cnt = (yyvsp[0].attr).cnt;  strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);}
#line 3893 "m2.tab.c"
    break;

  case 186: /* AND_not_test: AND not_test AND_not_test  */
#line 1058 "m2.y"
                                        { type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type); }
#line 3899 "m2.tab.c"
    break;

  case 187: /* AND_not_test: AND not_test  */
#line 1059 "m2.y"
                           {  strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3905 "m2.tab.c"
    break;

  case 188: /* not_test: NOT not_test  */
#line 1061 "m2.y"
                                  {  strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3911 "m2.tab.c"
    break;

  case 189: /* not_test: comparision  */
#line 1062 "m2.y"
                      { (yyval.attr).cnt = (yyvsp[0].attr).cnt;  strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3917 "m2.tab.c"
    break;

  case 190: /* comparision: expr comp_op_expr  */
#line 1064 "m2.y"
                               {type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3923 "m2.tab.c"
    break;

  case 191: /* comparision: expr  */
#line 1065 "m2.y"
                 { (yyval.attr).cnt = (yyvsp[0].attr).cnt;  strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3929 "m2.tab.c"
    break;

  case 192: /* comp_op_expr: comp_op expr comp_op_expr  */
#line 1067 "m2.y"
                                        { type_check_func(string((char*)((yyvsp[-2].attr)).data_type),string((char*)((yyvsp[-1].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type); }
#line 3935 "m2.tab.c"
    break;

  case 193: /* comp_op_expr: comp_op expr  */
#line 1068 "m2.y"
                           {  (yyval.attr).cnt = (yyvsp[-1].attr).cnt;  strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 3941 "m2.tab.c"
    break;

  case 194: /* comp_op: LT  */
#line 1070 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("<","LT",(yyvsp[0].attr).node_id);  dfn++;}
#line 3947 "m2.tab.c"
    break;

  case 195: /* comp_op: GT  */
#line 1071 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node(">","GT",(yyvsp[0].attr).node_id);  dfn++;}
#line 3953 "m2.tab.c"
    break;

  case 196: /* comp_op: EE  */
#line 1072 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("==","EE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3959 "m2.tab.c"
    break;

  case 197: /* comp_op: GE  */
#line 1073 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node(">=","GE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3965 "m2.tab.c"
    break;

  case 198: /* comp_op: LE  */
#line 1074 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("<=","LE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3971 "m2.tab.c"
    break;

  case 199: /* comp_op: LG  */
#line 1075 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("<>","LG",(yyvsp[0].attr).node_id);  dfn++;}
#line 3977 "m2.tab.c"
    break;

  case 200: /* comp_op: NE  */
#line 1076 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("!=","NE",(yyvsp[0].attr).node_id);  dfn++;}
#line 3983 "m2.tab.c"
    break;

  case 201: /* comp_op: IN  */
#line 1077 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("in","IN",(yyvsp[0].attr).node_id);  dfn++;}
#line 3989 "m2.tab.c"
    break;

  case 202: /* comp_op: NI  */
#line 1078 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("not in","NI",(yyvsp[0].attr).node_id);  dfn++;}
#line 3995 "m2.tab.c"
    break;

  case 203: /* comp_op: IS  */
#line 1079 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("is","IS",(yyvsp[0].attr).node_id);  dfn++;}
#line 4001 "m2.tab.c"
    break;

  case 204: /* comp_op: INOT  */
#line 1080 "m2.y"
              { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("is not","INOT",(yyvsp[0].attr).node_id);  dfn++;}
#line 4007 "m2.tab.c"
    break;

  case 205: /* expr: xor_expr BO_xor_expr  */
#line 1082 "m2.y"
                           { type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);  }
#line 4013 "m2.tab.c"
    break;

  case 206: /* expr: xor_expr  */
#line 1083 "m2.y"
               { (yyval.attr).cnt = (yyvsp[0].attr).cnt;  strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);  }
#line 4019 "m2.tab.c"
    break;

  case 207: /* BO_xor_expr: BO xor_expr BO_xor_expr  */
#line 1085 "m2.y"
                                     {  type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type);  }
#line 4025 "m2.tab.c"
    break;

  case 208: /* BO_xor_expr: BO xor_expr  */
#line 1086 "m2.y"
                         { strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);  }
#line 4031 "m2.tab.c"
    break;

  case 209: /* xor_expr: and_expr BX_and_expr  */
#line 1088 "m2.y"
                               {  type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 4037 "m2.tab.c"
    break;

  case 210: /* xor_expr: and_expr  */
#line 1089 "m2.y"
                   { (yyval.attr).cnt = (yyvsp[0].attr).cnt; strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 4043 "m2.tab.c"
    break;

  case 211: /* BX_and_expr: BX and_expr BX_and_expr  */
#line 1091 "m2.y"
                                     {   type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type); }
#line 4049 "m2.tab.c"
    break;

  case 212: /* BX_and_expr: BX and_expr  */
#line 1092 "m2.y"
                         { strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);  }
#line 4055 "m2.tab.c"
    break;

  case 213: /* and_expr: shift_expr BA_shift_expr  */
#line 1094 "m2.y"
                                   { type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);  }
#line 4061 "m2.tab.c"
    break;

  case 214: /* and_expr: shift_expr  */
#line 1095 "m2.y"
                     { (yyval.attr).cnt = (yyvsp[0].attr).cnt;strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);}
#line 4067 "m2.tab.c"
    break;

  case 215: /* BA_shift_expr: BA shift_expr BA_shift_expr  */
#line 1097 "m2.y"
                                           { type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type); }
#line 4073 "m2.tab.c"
    break;

  case 216: /* BA_shift_expr: BA shift_expr  */
#line 1098 "m2.y"
                             { strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 4079 "m2.tab.c"
    break;

  case 217: /* shift_expr: arith_expr LSRS_arith_expr  */
#line 1100 "m2.y"
                                       {  type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);   }
#line 4085 "m2.tab.c"
    break;

  case 218: /* shift_expr: arith_expr  */
#line 1101 "m2.y"
                       { (yyval.attr).cnt = (yyvsp[0].attr).cnt; strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 4091 "m2.tab.c"
    break;

  case 219: /* LSRS_arith_expr: line137 arith_expr LSRS_arith_expr  */
#line 1103 "m2.y"
                                                    {  type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type); }
#line 4097 "m2.tab.c"
    break;

  case 220: /* LSRS_arith_expr: line137 arith_expr  */
#line 1104 "m2.y"
                                    { strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);  }
#line 4103 "m2.tab.c"
    break;

  case 221: /* line137: LS  */
#line 1106 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node("<<","LS",(yyvsp[0].attr).node_id);  dfn++; }
#line 4109 "m2.tab.c"
    break;

  case 222: /* line137: RS  */
#line 1107 "m2.y"
            { (yyval.attr).node_id=dfn; (yyvsp[0].attr).node_id=dfn; create_node(">>","RS",(yyvsp[0].attr).node_id);  dfn++; }
#line 4115 "m2.tab.c"
    break;

  case 223: /* arith_expr: term PLUSMINUS_term  */
#line 1109 "m2.y"
                                           { type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);   }
#line 4121 "m2.tab.c"
    break;

  case 224: /* arith_expr: term  */
#line 1110 "m2.y"
                           { (yyval.attr).cnt = (yyvsp[0].attr).cnt; strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 4127 "m2.tab.c"
    break;

  case 225: /* PLUSMINUS_term: line140 term PLUSMINUS_term  */
#line 1112 "m2.y"
                                            { type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type); }
#line 4133 "m2.tab.c"
    break;

  case 226: /* PLUSMINUS_term: line140 term  */
#line 1113 "m2.y"
                                       { strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);   }
#line 4139 "m2.tab.c"
    break;

  case 227: /* line140: PLUS  */
#line 1115 "m2.y"
                         {  strcpy((yyval.attr).type,(yyvsp[0].attr).lexeme);  }
#line 4145 "m2.tab.c"
    break;

  case 228: /* line140: MINUS  */
#line 1116 "m2.y"
               {  strcpy((yyval.attr).type,(yyvsp[0].attr).lexeme);  }
#line 4151 "m2.tab.c"
    break;

  case 229: /* term: factor STARDIVMODFF_factor  */
#line 1118 "m2.y"
                                 { type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); }
#line 4157 "m2.tab.c"
    break;

  case 230: /* term: factor  */
#line 1119 "m2.y"
             { strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);}
#line 4163 "m2.tab.c"
    break;

  case 231: /* STARDIVMODFF_factor: line143 factor STARDIVMODFF_factor  */
#line 1121 "m2.y"
                                                        { type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type); }
#line 4169 "m2.tab.c"
    break;

  case 232: /* STARDIVMODFF_factor: line143 factor  */
#line 1122 "m2.y"
                                    { strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);  }
#line 4175 "m2.tab.c"
    break;

  case 233: /* line143: STAR  */
#line 1124 "m2.y"
               {  strcpy((yyval.attr).type,(yyvsp[0].attr).lexeme);  }
#line 4181 "m2.tab.c"
    break;

  case 234: /* line143: DIV  */
#line 1125 "m2.y"
             {   strcpy((yyval.attr).type,(yyvsp[0].attr).lexeme);  }
#line 4187 "m2.tab.c"
    break;

  case 235: /* line143: MOD  */
#line 1126 "m2.y"
             {  strcpy((yyval.attr).type,(yyvsp[0].attr).lexeme); }
#line 4193 "m2.tab.c"
    break;

  case 236: /* line143: FF  */
#line 1127 "m2.y"
            {  strcpy((yyval.attr).type,(yyvsp[0].attr).lexeme); }
#line 4199 "m2.tab.c"
    break;

  case 237: /* factor: line145 factor  */
#line 1129 "m2.y"
                       {  strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);   }
#line 4205 "m2.tab.c"
    break;

  case 238: /* factor: power  */
#line 1130 "m2.y"
               { (yyval.attr).cnt = (yyvsp[0].attr).cnt; strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);  }
#line 4211 "m2.tab.c"
    break;

  case 239: /* line145: PLUS  */
#line 1132 "m2.y"
               { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); }
#line 4217 "m2.tab.c"
    break;

  case 240: /* line145: MINUS  */
#line 1133 "m2.y"
               { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); }
#line 4223 "m2.tab.c"
    break;

  case 241: /* line145: NEG  */
#line 1134 "m2.y"
             { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); }
#line 4229 "m2.tab.c"
    break;

  case 242: /* power: atom_expr  */
#line 1136 "m2.y"
                 {  (yyval.attr).cnt = (yyvsp[0].attr).cnt; strcpy((yyval.attr).data_type, (yyvsp[0].attr).data_type);}
#line 4235 "m2.tab.c"
    break;

  case 243: /* power: atom_expr SS factor  */
#line 1137 "m2.y"
                           { 
         strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); 
                /* type conversion */
                type_check_func(string((char*)((yyvsp[-2].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type));
         }
#line 4245 "m2.tab.c"
    break;

  case 244: /* atom_expr: atom trailer_  */
#line 1143 "m2.y"
                         { 
                strcpy((yyval.attr).data_type, (yyvsp[-1].attr).data_type);
                string temppp2=(string((char*)((yyvsp[0].attr)).type));
                string temppp1=(string((char*)((yyvsp[-1].attr)).type))+temppp2;
                strcpy((yyval.attr).type,temppp1.c_str());

                // cout<<"meekosadsa "<<(string((char*)($1).type))<<" , "<<temppp2.size()<<"\n";

                if(temppp2.size()>=1 && temppp2[temppp2.size()-1]=='(' )
                {
                // here check for functions arguments are matching wht declaration or not 
                        if(true)
                        {
                                vector<string> temp;
                                vector<string> data_type_params;
                                if(temppp2.size()>=1 && temppp2[0]=='(')
                                {
                                        // cout<<"hh";
                                        string name_of_function=string((char*)((yyvsp[-1].attr)).type); 
                                        if(class_name_map.find(name_of_function)!=class_name_map.end())
                                        {
                                                /* constructor  */
                                                for(int i=0;i<(*((yyvsp[0].attr).abc)).size();i++)
                                                {
                                                        temp.push_back( (*((yyvsp[0].attr).abc))[i] ); 
                                                        data_type_params.push_back(say(temp[i]));
                                                        if(data_type_params[i].size()==0)
                                                        {
                                                                cout<<"Error : Undeclared variable "<<temp[i] <<" at line no:" << yylineno-1<<"\n";
                                                                exit(0);
                                                        } 
                                                }

                                                vector<string> vec=func_init_list[name_of_function];
                                                if(vec.size() > data_type_params.size()) 
                                                {
                                                        cout<<"Error: less arguments passed : at line number "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }
                                                if(vec.size() < data_type_params.size()) 
                                                {
                                                        cout<<"Error: More arguments passed : at line number "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }

                                                for(int i=0;i<vec.size();i++)
                                                {
                                                        type_check_func(vec[i],data_type_params[i]);
                                                }
                                                
                                        }
                                        else
                                        {
                                                // cout<<"here came :";
                                                for(int i=0;i<(*((yyvsp[0].attr).abc)).size();i++)
                                                {
                                                        temp.push_back( (*((yyvsp[0].attr).abc))[i] ); 
                                                        data_type_params.push_back(say(temp[i]));
                                                        // cout<<"herwe "<<temp[i-1]<<" "<<data_type_params[i-1]<<"\n";
                                                        if(data_type_params[i].size()==0)
                                                        {
                                                                if(temp[i]=="len(")
                                                                {
                                                                        data_type_params[i]="list[int]";
                                                                        continue;
                                                                }
                                                                cout<<"Error : Undeclared variable "<<temp[i] <<" at line no:" << yylineno-1<<"\n";
                                                                exit(0);
                                                        } 
                                                        
                                                }
                                                // normal functionn call
                                                // cout<<"kkkk";
                                                string func_name=(string((char*)((yyvsp[-1].attr)).type));
                                                if(func_name!="main" && func_name!="range") 
                                                {
                                                        cout<<func_name<<" \n";
                                                        if(func_decl_list.find(func_name)==func_decl_list.end())
                                                        {
                                                                cout<<"Error: Undeclared function "<<func_name<<" at line no :"<<yylineno-1<<"\n";
                                                                exit(0);
                                                        }
                                                        vector<string> vec=func_decl_list[func_name];

                                                        if(vec.size() > data_type_params.size()) 
                                                        {
                                                                cout<<"Error: less arguments passed : at line number "<<vec.size()<<" "<<data_type_params.size()<<" "<<yylineno-1<<"\n";
                                                                exit(0);
                                                        }
                                                        if(vec.size() < data_type_params.size()) 
                                                        {
                                                                cout<<"Error: More arguments passed : at line number "<<vec.size()<<" "<<data_type_params.size()<<yylineno-1<<"\n";
                                                                exit(0);
                                                        }

                                                        for(int i=0;i<vec.size();i++)
                                                        {
                                                                type_check_func(vec[i],data_type_params[i]);
                                                        }
                                                }
                                        }

                                }
                                else if(temppp2.size()>=1 && temppp2[0]=='.')
                                {
                                        string class_name=string((char*)((yyvsp[-1].attr)).type);
                                        string func_name=solve1((char*)((yyvsp[0].attr)).type);
                                        //  cout<<"saewefw";
                                        if(class_func_list.find({class_name,func_name})!=class_func_list.end())
                                        {
                                                if((*((yyvsp[0].attr).abc))[0]!="self")
                                                {
                                                        cout<<"Error: self is not passed at line no: "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }
                                                for(int i=1;i<(int)(*((yyvsp[0].attr).abc)).size();i++)
                                                {
                                                        temp.push_back( (*((yyvsp[0].attr).abc))[i] ); 
                                                        data_type_params.push_back(say(temp[i-1]));
                                                        if(data_type_params[i-1].size()==0 )
                                                        {
                                                                cout<<"Error : Undeclared variable "<<temp[i-1] <<" at line no:" << yylineno-1<<"\n";
                                                                exit(0);
                                                        } 
                                                }
                                                vector<string> vec=class_func_list[{class_name,func_name}];

                                                if(vec.size() > data_type_params.size()) 
                                                {
                                                        cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: less arguments passed : at line number "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }
                                                if(vec.size() < data_type_params.size()) 
                                                {
                                                        cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: More arguments passed : at line number "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }

                                                for(int i=0;i<vec.size();i++)
                                                {
                                                        type_check_func(vec[i],data_type_params[i]);
                                                }
                                        }
                                        else 
                                        {
                                                //  cout<<"wjkqd";
                                                string object_name=string((char*)((yyvsp[-1].attr)).type);
                                                string func_name=solve1((char*)((yyvsp[0].attr)).type);
                                                string class_name=say(object_name);
                                                /* normal object calling its own method from other scopes  */
                                                for(int i=0;i<(int)(*((yyvsp[0].attr).abc)).size();i++)
                                                {
                                                        temp.push_back( (*((yyvsp[0].attr).abc))[i] ); 
                                                        data_type_params.push_back(say(temp[i]));
                                                        if(data_type_params[i].size()==0 )
                                                        {
                                                                cout<<"Error : Undeclared variable "<<temp[i] <<" at line no:" << yylineno<<"\n";
                                                                exit(0);
                                                        } 
                                                }

                                                vector<string> vec=class_func_list[{class_name,func_name}];

                                                if(vec.size() > data_type_params.size()) 
                                                {
                                                        cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: less arguments passed : at line number "<<yylineno<<"\n";
                                                        exit(0);
                                                }
                                                if(vec.size() < data_type_params.size()) 
                                                {
                                                        cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: More arguments passed : at line number "<<yylineno<<"\n";
                                                        exit(0);
                                                }

                                                for(int i=0;i<vec.size();i++)
                                                {
                                                      type_check_func(vec[i],data_type_params[i]);
                                                }
                                        }

                                       
                                }
                        }
                        
                }
 }
#line 4440 "m2.tab.c"
    break;

  case 245: /* atom_expr: atom  */
#line 1333 "m2.y"
                           { strcpy((yyval.attr).type, (yyvsp[0].attr).type);(yyval.attr).cnt = (yyvsp[0].attr).cnt;}
#line 4446 "m2.tab.c"
    break;

  case 246: /* trailer_: trailer trailer_  */
#line 1335 "m2.y"
                           {
                 string temppp2=(string((char*)((yyvsp[0].attr)).type));
                string temppp1=(string((char*)((yyvsp[-1].attr)).type))+temppp2;
                strcpy((yyval.attr).type,temppp1.c_str()); 
                 (yyval.attr).abc=(yyvsp[0].attr).abc;
                }
#line 4457 "m2.tab.c"
    break;

  case 247: /* trailer_: trailer  */
#line 1341 "m2.y"
                            { (yyval.attr).abc=(yyvsp[0].attr).abc; strcpy((yyval.attr).type,(yyvsp[0].attr).type);  }
#line 4463 "m2.tab.c"
    break;

  case 248: /* atom: LP lines172 RP  */
#line 1343 "m2.y"
                     {  (yyval.attr).node_id = 2 + dfn;  create_node("", "atom" , (yyval.attr).node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 4469 "m2.tab.c"
    break;

  case 249: /* atom: LB lines173 RB  */
#line 1344 "m2.y"
                     {(yyval.attr).cnt = (yyvsp[-1].attr).cnt; strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type); }
#line 4475 "m2.tab.c"
    break;

  case 250: /* atom: LF lines174 RF  */
#line 1345 "m2.y"
                     {  (yyval.attr).node_id = 2 + dfn;  create_node("", "atom" , (yyval.attr).node_id );  create_node("{", "LF" , 1 + dfn );  create_node("}", "RF" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 4481 "m2.tab.c"
    break;

  case 251: /* atom: BT testlist1 BT  */
#line 1346 "m2.y"
                      {  (yyval.attr).node_id = 2 + dfn;  create_node("", "atom" , (yyval.attr).node_id );  create_node("`", "BT" , 1 + dfn );  create_node("`", "BT" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 4487 "m2.tab.c"
    break;

  case 252: /* atom: NAME  */
#line 1347 "m2.y"
           { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); strcpy((yyval.attr).data_type, say(string((char*)((yyvsp[0].attr)).lexeme)).c_str() ); }
#line 4493 "m2.tab.c"
    break;

  case 253: /* atom: NUMBER  */
#line 1348 "m2.y"
              { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme);}
#line 4499 "m2.tab.c"
    break;

  case 254: /* atom: NONE  */
#line 1349 "m2.y"
            { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); }
#line 4505 "m2.tab.c"
    break;

  case 255: /* atom: STRING  */
#line 1350 "m2.y"
              { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); }
#line 4511 "m2.tab.c"
    break;

  case 256: /* atom: BOOL  */
#line 1351 "m2.y"
           { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); }
#line 4517 "m2.tab.c"
    break;

  case 257: /* atom: SELF  */
#line 1352 "m2.y"
                      { strcpy((yyval.attr).type, (yyvsp[0].attr).lexeme); }
#line 4523 "m2.tab.c"
    break;

  case 258: /* lines172: yield_expr  */
#line 1354 "m2.y"
                     { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4529 "m2.tab.c"
    break;

  case 259: /* lines172: testlist_comp  */
#line 1355 "m2.y"
                        { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4535 "m2.tab.c"
    break;

  case 260: /* lines172: epsilon  */
#line 1356 "m2.y"
                   { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 4541 "m2.tab.c"
    break;

  case 261: /* lines173: listmaker  */
#line 1358 "m2.y"
                    {(yyval.attr).cnt = (yyvsp[0].attr).cnt; strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 4547 "m2.tab.c"
    break;

  case 262: /* lines173: epsilon  */
#line 1359 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 4553 "m2.tab.c"
    break;

  case 263: /* lines174: dictorsetmaker  */
#line 1361 "m2.y"
                         { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4559 "m2.tab.c"
    break;

  case 264: /* lines174: epsilon  */
#line 1362 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 4565 "m2.tab.c"
    break;

  case 265: /* listmaker: test line151  */
#line 1364 "m2.y"
                        { (yyval.attr).cnt= (yyvsp[0].attr).cnt+1; type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type);  }
#line 4571 "m2.tab.c"
    break;

  case 266: /* line151: list_for  */
#line 1366 "m2.y"
                  { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4577 "m2.tab.c"
    break;

  case 267: /* line151: lines57  */
#line 1367 "m2.y"
                 { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4583 "m2.tab.c"
    break;

  case 268: /* line151: COM_test lines57  */
#line 1368 "m2.y"
                          { (yyval.attr).cnt = (yyvsp[-1].attr).cnt; strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 4589 "m2.tab.c"
    break;

  case 269: /* testlist_comp: test line153  */
#line 1370 "m2.y"
                            { (yyval.attr).node_id=dfn;  create_node("","testlist_comp",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4595 "m2.tab.c"
    break;

  case 270: /* line153: comp_for  */
#line 1372 "m2.y"
                  { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4601 "m2.tab.c"
    break;

  case 271: /* line153: lines57  */
#line 1373 "m2.y"
                 { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4607 "m2.tab.c"
    break;

  case 272: /* line153: COM_test lines57  */
#line 1374 "m2.y"
                          { (yyval.attr).node_id=dfn;  create_node("","line153",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4613 "m2.tab.c"
    break;

  case 273: /* trailer: LP lines183 RP  */
#line 1376 "m2.y"
                                   { 
                (yyval.attr).abc = (yyvsp[-1].attr).abc;
                strcpy((yyval.attr).type,(yyvsp[-2].attr).lexeme);
        }
#line 4622 "m2.tab.c"
    break;

  case 274: /* trailer: LB subscriptlist RB  */
#line 1380 "m2.y"
                             {  (yyval.attr).node_id = 2 + dfn;  create_node("", "trailer" , (yyval.attr).node_id );  create_node("[", "LB" , 1 + dfn );  create_node("]", "RB" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-1].attr).node_id, 0 + dfn } , (yyval.attr).node_id );  dfn += 3; }
#line 4628 "m2.tab.c"
    break;

  case 275: /* trailer: FS NAME  */
#line 1381 "m2.y"
                 {  
        string temppp="."+(string((char*)((yyvsp[0].attr)).lexeme));
        strcpy((yyval.attr).type,temppp.c_str());
       }
#line 4637 "m2.tab.c"
    break;

  case 276: /* lines183: arglist  */
#line 1386 "m2.y"
                  { (yyval.attr).abc= (yyvsp[0].attr).abc;  /* for(int i=0;i<(*($1.abc)).size();i++) cout << (*($1.abc))[i]<< endl; */  }
#line 4643 "m2.tab.c"
    break;

  case 277: /* lines183: epsilon  */
#line 1387 "m2.y"
                  { (yyval.attr).abc =new vector<string>();}
#line 4649 "m2.tab.c"
    break;

  case 278: /* subscriptlist: subscript line158  */
#line 1389 "m2.y"
                                 {}
#line 4655 "m2.tab.c"
    break;

  case 279: /* line158: COM_subscript lines57  */
#line 1391 "m2.y"
                               { (yyval.attr).node_id=dfn;  create_node("","line158",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4661 "m2.tab.c"
    break;

  case 280: /* line158: lines57  */
#line 1392 "m2.y"
                 { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4667 "m2.tab.c"
    break;

  case 281: /* COM_subscript: COM subscript COM_subscript  */
#line 1394 "m2.y"
                                                      { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn ; create_node("","COM_subscript",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 4673 "m2.tab.c"
    break;

  case 282: /* COM_subscript: COM subscript  */
#line 1395 "m2.y"
                                       { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","COM_subscript",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 4679 "m2.tab.c"
    break;

  case 283: /* subscript: FS FS FS  */
#line 1397 "m2.y"
                    {  (yyval.attr).node_id = 3 + dfn;  create_node("", "subscript" , (yyval.attr).node_id );  create_node(".", "FS" , 2 + dfn );  create_node(".", "FS" , 1 + dfn );  create_node(".", "FS" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, 0 + dfn } , (yyval.attr).node_id );  dfn += 4; }
#line 4685 "m2.tab.c"
    break;

  case 284: /* subscript: test  */
#line 1398 "m2.y"
                {list_size++;}
#line 4691 "m2.tab.c"
    break;

  case 285: /* subscript: lines189 COL lines189 lines190  */
#line 1399 "m2.y"
                                          {  (yyval.attr).node_id = 1 + dfn;  create_node("", "subscript" , (yyval.attr).node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 4697 "m2.tab.c"
    break;

  case 286: /* sliceop: COL lines189  */
#line 1401 "m2.y"
                      { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","sliceop",(yyval.attr).node_id);create_node(":","COL",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 4703 "m2.tab.c"
    break;

  case 287: /* lines189: test  */
#line 1403 "m2.y"
               { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4709 "m2.tab.c"
    break;

  case 288: /* lines189: epsilon  */
#line 1404 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 4715 "m2.tab.c"
    break;

  case 289: /* lines190: sliceop  */
#line 1406 "m2.y"
                  { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4721 "m2.tab.c"
    break;

  case 290: /* lines190: epsilon  */
#line 1407 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 4727 "m2.tab.c"
    break;

  case 291: /* exprlist: expr line163  */
#line 1409 "m2.y"
                       { (yyval.attr).node_id=dfn;  create_node("","exprlist",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4733 "m2.tab.c"
    break;

  case 292: /* line163: COM_expr lines57  */
#line 1411 "m2.y"
                           { (yyval.attr).node_id=dfn;  create_node("","line163",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4739 "m2.tab.c"
    break;

  case 293: /* line163: lines57  */
#line 1412 "m2.y"
                  { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4745 "m2.tab.c"
    break;

  case 294: /* COM_expr: COM expr COM_expr  */
#line 1414 "m2.y"
                                       { (yyval.attr).node_id=dfn+1; (yyvsp[-2].attr).node_id= dfn ; create_node("","COM_expr",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-2].attr).node_id); vector<int> child; child.push_back((yyvsp[-2].attr).node_id);child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 4751 "m2.tab.c"
    break;

  case 295: /* COM_expr: COM expr  */
#line 1415 "m2.y"
                             { (yyval.attr).node_id=dfn+1; (yyvsp[-1].attr).node_id= dfn;  create_node("","COM_expr",(yyval.attr).node_id);create_node(",","COM",(yyvsp[-1].attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn+=2;}
#line 4757 "m2.tab.c"
    break;

  case 296: /* testlist: test line166  */
#line 1417 "m2.y"
                       { (yyval.attr).node_id=dfn;  create_node("","testlist",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4763 "m2.tab.c"
    break;

  case 297: /* line166: COM_test lines57  */
#line 1419 "m2.y"
                          { (yyval.attr).node_id=dfn;  create_node("","line166",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4769 "m2.tab.c"
    break;

  case 298: /* line166: lines57  */
#line 1420 "m2.y"
                 { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4775 "m2.tab.c"
    break;

  case 299: /* COM_test: COM test  */
#line 1422 "m2.y"
                             { (yyval.attr).cnt = 1; strcpy((yyval.attr).data_type,(yyvsp[0].attr).data_type); }
#line 4781 "m2.tab.c"
    break;

  case 300: /* COM_test: COM test COM_test  */
#line 1423 "m2.y"
                                       {(yyval.attr).cnt = (yyvsp[0].attr).cnt+1; type_check_func(string((char*)((yyvsp[-1].attr)).data_type),string((char*)((yyvsp[0].attr)).data_type)); strcpy((yyval.attr).data_type,(yyvsp[-1].attr).data_type);}
#line 4787 "m2.tab.c"
    break;

  case 301: /* dictorsetmaker: test COL test line169  */
#line 1425 "m2.y"
                                       {  (yyval.attr).node_id = 1 + dfn;  create_node("", "dictorsetmaker" , (yyval.attr).node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 4793 "m2.tab.c"
    break;

  case 302: /* dictorsetmaker: test line170  */
#line 1426 "m2.y"
                              { (yyval.attr).node_id=dfn;  create_node("","dictorsetmaker",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4799 "m2.tab.c"
    break;

  case 303: /* line169: comp_for  */
#line 1428 "m2.y"
                  { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4805 "m2.tab.c"
    break;

  case 304: /* line169: COM_test_COL_test lines57  */
#line 1429 "m2.y"
                                    { (yyval.attr).node_id=dfn;  create_node("","line169",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4811 "m2.tab.c"
    break;

  case 305: /* line169: lines57  */
#line 1430 "m2.y"
                 { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4817 "m2.tab.c"
    break;

  case 306: /* line170: comp_for  */
#line 1432 "m2.y"
                  { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4823 "m2.tab.c"
    break;

  case 307: /* line170: COM_test lines57  */
#line 1433 "m2.y"
                          { (yyval.attr).node_id=dfn;  create_node("","line170",(yyval.attr).node_id); vector<int> child; child.push_back((yyvsp[-1].attr).node_id);child.push_back((yyvsp[0].attr).node_id); create_edge(child,(yyval.attr).node_id);  dfn++;}
#line 4829 "m2.tab.c"
    break;

  case 308: /* line170: lines57  */
#line 1434 "m2.y"
                 { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4835 "m2.tab.c"
    break;

  case 309: /* COM_test_COL_test: COM test COL test COM_test_COL_test  */
#line 1436 "m2.y"
                                                                  {  (yyval.attr).node_id = 2 + dfn;  create_node("", "COM_test_COL_test" , (yyval.attr).node_id );  create_node(",", "COM" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 4841 "m2.tab.c"
    break;

  case 310: /* COM_test_COL_test: COM test COL test  */
#line 1437 "m2.y"
                                               {  (yyval.attr).node_id = 2 + dfn;  create_node("", "COM_test_COL_test" , (yyval.attr).node_id );  create_node(",", "COM" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-2].attr).node_id, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 4847 "m2.tab.c"
    break;

  case 311: /* $@3: %empty  */
#line 1439 "m2.y"
                                   { 
                /*  normal class */
                // first add into present scope and 
                string class_name=string((char*)((yyvsp[-2].attr)).lexeme);
                curr_table->insert(string((char*)((yyvsp[-2].attr)).lexeme), "Class", string((char*)((yyvsp[-2].attr)).lexeme) , offset, curr_scope, yylineno, -1);
                tables.push(curr_table);
                scope_names.push(curr_scope);
                offsets.push(offset);
                class_name_present= string((char*)((yyvsp[-2].attr)).lexeme);

                curr_table= new Sym_Table(curr_table);
                list_of_Symbol_Tables.push_back(curr_table);
                string new_scope="Class_"+string((char*)((yyvsp[-2].attr).lexeme));
                curr_scope=new_scope;
                offset=0;
                // map<string,Sym_Table*> class_name_map;
                class_name_map[class_name]=curr_table;
 }
#line 4870 "m2.tab.c"
    break;

  case 312: /* classdef: CLASS NAME lines202 COL $@3 suite  */
#line 1458 "m2.y"
        {
                // cout<<"1386 --> ";
                // printKeys(curr_table->class_func_args);
                string inherited=string((char*)((yyvsp[-3].attr)).type);
                if(inherited.size()!=0)
                {
                        /* copy from inherited class  */
                        Sym_Table* temp_sym_table=class_name_map[inherited];
                        // curr_table->parent=class_name_map[inherited];
                        if(class_name_map.find(inherited) != class_name_map.end())
                        {
                                Sym_Table* temp_sym_table=class_name_map[inherited];
                                for(auto it: temp_sym_table->table)
                                {
                                        if(curr_table->table.find(it.first) == curr_table->table.end()){
                                                // curr_table->table[it.first]=it.second;
                                                curr_table->insert(it.first, "Class", it.second.type , offset, curr_scope, yylineno-1, -1);
                                        }
                                }
                        }
                        else
                        {
                                cout<<"NameError: parent class "<<inherited<<" is not defined";
                                exit(0);
                        }
                }
                /* get back to previous scope*/ 
                curr_table->sz=offset;
                curr_table->table_name=scope_names.top();
                curr_table=tables.top();
                tables.pop();
                curr_scope=scope_names.top();
                scope_names.pop();
                offset=offsets.top();
                offsets.pop();
        }
#line 4911 "m2.tab.c"
    break;

  case 313: /* lines202: LP NAME RP  */
#line 1495 "m2.y"
                     { strcpy((yyval.attr).type, (yyvsp[-1].attr).lexeme); }
#line 4917 "m2.tab.c"
    break;

  case 314: /* lines202: epsilon  */
#line 1496 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 4923 "m2.tab.c"
    break;

  case 315: /* arglist: argument_COM line175  */
#line 1498 "m2.y"
                              {(yyvsp[-1].attr).abc->push_back(string((char*)((yyvsp[0].attr)).type));(yyval.attr).abc = (yyvsp[-1].attr).abc; }
#line 4929 "m2.tab.c"
    break;

  case 316: /* arglist: line175  */
#line 1499 "m2.y"
                  {(yyval.attr).abc =new vector<string>(); string temp=string((char*)((yyvsp[0].attr)).type); (yyval.attr).abc->push_back(temp); }
#line 4935 "m2.tab.c"
    break;

  case 317: /* line175: argument lines57  */
#line 1501 "m2.y"
                          { strcpy((yyval.attr).type, (yyvsp[-1].attr).type);}
#line 4941 "m2.tab.c"
    break;

  case 318: /* argument_COM: argument_COM argument COM  */
#line 1503 "m2.y"
                                         { (yyvsp[-2].attr).abc->push_back(string((char*)((yyvsp[-1].attr)).type));
                                (yyval.attr).abc = (yyvsp[-2].attr).abc;

                         }
#line 4950 "m2.tab.c"
    break;

  case 319: /* argument_COM: argument COM  */
#line 1507 "m2.y"
                                     {
                (yyval.attr).abc =new vector<string>(); (yyval.attr).abc->push_back(string((char*)((yyvsp[-1].attr)).type));
            }
#line 4958 "m2.tab.c"
    break;

  case 320: /* argument: test lines209  */
#line 1511 "m2.y"
                        { strcpy((yyval.attr).type, (yyvsp[-1].attr).type);}
#line 4964 "m2.tab.c"
    break;

  case 321: /* argument: test EQ test  */
#line 1512 "m2.y"
                       {  (yyval.attr).node_id = 1 + dfn;  create_node("", "argument" , (yyval.attr).node_id );  create_node("=", "EQ" , 0 + dfn );  create_edge( { (yyvsp[-2].attr).node_id, 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 4970 "m2.tab.c"
    break;

  case 322: /* lines209: comp_for  */
#line 1514 "m2.y"
                   { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4976 "m2.tab.c"
    break;

  case 323: /* lines209: epsilon  */
#line 1515 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 4982 "m2.tab.c"
    break;

  case 324: /* list_iter: list_for  */
#line 1517 "m2.y"
                    { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4988 "m2.tab.c"
    break;

  case 325: /* list_iter: list_if  */
#line 1518 "m2.y"
                   { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 4994 "m2.tab.c"
    break;

  case 326: /* list_for: FOR exprlist IN testlist_safe lines214  */
#line 1520 "m2.y"
                                                 {  (yyval.attr).node_id = 2 + dfn;  create_node("", "list_for" , (yyval.attr).node_id );  create_node("for", "FOR" , 1 + dfn );  create_node("in", "IN" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 5000 "m2.tab.c"
    break;

  case 327: /* list_if: IF old_test lines214  */
#line 1522 "m2.y"
                              {  (yyval.attr).node_id = 1 + dfn;  create_node("", "list_if" , (yyval.attr).node_id );  create_node("if", "IF" , 0 + dfn );  create_edge( { 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 5006 "m2.tab.c"
    break;

  case 328: /* lines214: list_iter  */
#line 1524 "m2.y"
                    { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 5012 "m2.tab.c"
    break;

  case 329: /* lines214: epsilon  */
#line 1525 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 5018 "m2.tab.c"
    break;

  case 330: /* comp_iter: comp_for  */
#line 1527 "m2.y"
                    { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 5024 "m2.tab.c"
    break;

  case 331: /* comp_iter: comp_if  */
#line 1528 "m2.y"
                   { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 5030 "m2.tab.c"
    break;

  case 332: /* comp_for: FOR exprlist IN or_test lines219  */
#line 1529 "m2.y"
                                           {  (yyval.attr).node_id = 2 + dfn;  create_node("", "comp_for" , (yyval.attr).node_id );  create_node("for", "FOR" , 1 + dfn );  create_node("in", "IN" , 0 + dfn );  create_edge( { 1 + dfn, (yyvsp[-3].attr).node_id, 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 3; }
#line 5036 "m2.tab.c"
    break;

  case 333: /* comp_if: IF old_test lines219  */
#line 1531 "m2.y"
                              {  (yyval.attr).node_id = 1 + dfn;  create_node("", "comp_if" , (yyval.attr).node_id );  create_node("if", "IF" , 0 + dfn );  create_edge( { 0 + dfn, (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 5042 "m2.tab.c"
    break;

  case 334: /* lines219: comp_iter  */
#line 1533 "m2.y"
                    { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 5048 "m2.tab.c"
    break;

  case 335: /* lines219: epsilon  */
#line 1534 "m2.y"
                  { (yyval.attr).node_id=dfn;  create_node("","ε",(yyval.attr).node_id); dfn++;}
#line 5054 "m2.tab.c"
    break;

  case 336: /* testlist1: test  */
#line 1536 "m2.y"
                { (yyval.attr).node_id= (yyvsp[0].attr).node_id;}
#line 5060 "m2.tab.c"
    break;

  case 337: /* testlist1: test COM_test  */
#line 1537 "m2.y"
                         {  (yyval.attr).node_id = 0 + dfn;  create_node("", "testlist1" , (yyval.attr).node_id );  create_edge( { (yyvsp[-1].attr).node_id, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 1; }
#line 5066 "m2.tab.c"
    break;

  case 338: /* yield_expr: YIELD lines84  */
#line 1539 "m2.y"
                          {  (yyval.attr).node_id = 1 + dfn;  create_node("", "yield_expr" , (yyval.attr).node_id );  create_node("yield", "YIELD" , 0 + dfn );  create_edge( { 0 + dfn, (yyvsp[0].attr).node_id } , (yyval.attr).node_id );  dfn += 2; }
#line 5072 "m2.tab.c"
    break;


#line 5076 "m2.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", YY_CAST (yysymbol_kind_t, yyr1[yyn]), &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;

  *++yyvsp = yyval;
  *++yylsp = yyloc;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYSYMBOL_YYEMPTY : YYTRANSLATE (yychar);
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
      {
        yypcontext_t yyctx
          = {yyssp, yytoken, &yylloc};
        if (yyreport_syntax_error (&yyctx) == 2)
          YYNOMEM;
      }
    }

  yyerror_range[1] = yylloc;
  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval, &yylloc);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;
  ++yynerrs;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  /* Pop stack until we find a state that shifts the error token.  */
  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYSYMBOL_YYerror;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYSYMBOL_YYerror)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;

      yyerror_range[1] = *yylsp;
      yydestruct ("Error: popping",
                  YY_ACCESSING_SYMBOL (yystate), yyvsp, yylsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  yyerror_range[2] = yylloc;
  ++yylsp;
  YYLLOC_DEFAULT (*yylsp, yyerror_range, 2);

  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", YY_ACCESSING_SYMBOL (yyn), yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturnlab;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturnlab;


/*-----------------------------------------------------------.
| yyexhaustedlab -- YYNOMEM (memory exhaustion) comes here.  |
`-----------------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  goto yyreturnlab;


/*----------------------------------------------------------.
| yyreturnlab -- parsing is finished, clean up and return.  |
`----------------------------------------------------------*/
yyreturnlab:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval, &yylloc);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  YY_ACCESSING_SYMBOL (+*yyssp), yyvsp, yylsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif

  return yyresult;
}

#line 1541 "m2.y"


// static int yyreport_syntax_error(const yypcontext_t *ctx) {
//     printf("Error at line number %d due to \n", yylineno);
//     return 0; // Return 0 on success
// }
static int yyreport_syntax_error (const yypcontext_t *ctx)
{
        int res = 0;
        // YYLOCATION_PRINT(stderr, yypcontext_location (ctx));
        fprintf (stderr, "line %d: syntax error", yylineno);
        // Report the tokens expected at this point.
        {
        enum { TOKENMAX = 5 };
        yysymbol_kind_t expected[TOKENMAX];
        int n = yypcontext_expected_tokens (ctx, expected, TOKENMAX);
        if (n < 0)
        // Forward errors to yyparse.
        res = n;
        else
                for (int i = 0; i < n; ++i)
                        fprintf (stderr, "%s %s",i == 0 ? ": expected" : " or", yysymbol_name (expected[i]));
        }
        // Report the unexpected token.
        {
                yysymbol_kind_t lookahead = yypcontext_token (ctx);
                if (lookahead != YYSYMBOL_YYEMPTY)
                        fprintf (stderr, " before %s", yysymbol_name (lookahead));
        }
        fprintf (stderr, "\n");
        return res;
}


int main(int argc, char **argv) {
//   cout<<"digraph ast {\n  node [shape=box, style=filled, fillcolor=lightblue]\n";
  yydebug = 0;
  indent.push_back(0);
  dfn=0;
  ++argv; --argc;
  if(argc>0) yyin = fopen( argv[0] , "r" );
  else yyin = stdin;
  before_parsing();
  int temp=yyparse();
//    cout<<"behappy mourya";
//   cout<<"}\n";
  // print all the symbol tables
  sym_counts=1;
  for(auto it:list_of_Symbol_Tables){
        cout<<"\n\n*************************************************start of symbol table ***********************************************\n\n\n\n";
        it->print_csv_table();
        it->print_table();
        cout<<endl;
        cout<<"\n\n*************************************************end of symbol table *************************************************\n\n";
        sym_counts++;

  }
  if(temp==0){
    cout<<"success\n";
  }
  else if(temp==1){
    cout<<"failure\n";
  }
  else if(temp==2){
    cout<<"memory exhaustion\n";
  }
  else{
    cout<<"unknown error\n";
  }
  fclose(yyin);
  return 0;
}


/*
 different function calls 

1) now ;lets solve for object declaration time function call 

*/
