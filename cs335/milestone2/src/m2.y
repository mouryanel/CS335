%{
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


%}

%locations

/* %define parse.error detailed */
%define parse.trace false

%define parse.error custom


%union {
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

}

%token <attr> BOOL UNKNOWN NUMBER LIST RANGE SELF ARROW NONE PRIMITIVES NEWLINE STRING ENDMARKER NAME INDENT DEDENT AT RB LB RP LP LF RF DEF SCOL COL EQ SS COM PE ME SE DE MODE ANDE BOE BXE BX BO BA LSE RSE SSE FFE PRINT RS DEL BREAK CONTINUE RETURN RAISE FROM AS GLOBAL EXEC IN ASSERT IF ELIF WHILE ELSE FOR TRY FINALLY WITH EXCEPT OR AND NOT LT GT EE LE GE NE LG NI IS INOT PLUS MINUS STAR DIV MOD FF NEG BT FS LS CLASS YIELD


%start start ;
%precedence lower
%precedence low
%precedence high   
%precedence UNKNOWN LIST RANGE SELF ARROW NONE PRIMITIVES NUMBER NEWLINE STRING ENDMARKER NAME INDENT DEDENT AT RB LB RP LP LF RF DEF SCOL COL EQ SS COM PE ME SE DE MODE ANDE BOE BXE BX BO BA LSE RSE SSE FFE PRINT RS DEL BREAK CONTINUE RETURN RAISE FROM AS GLOBAL EXEC IN ASSERT IF ELIF WHILE ELSE FOR TRY FINALLY WITH EXCEPT OR AND NOT LT GT EE LE GE NE LG NI IS INOT PLUS MINUS STAR DIV MOD FF NEG BT FS LS CLASS YIELD
%type <attr> start primitives single_input file_input NEWstmt eval_input Nnew decorator line38 line41 decorated line40 decorators funcdef parameters fpdef fplist lines57 fpdefq range_func stmt simple_stmt line57 small_stmt expr_stmt line61 line62 EQ_yield_expr_testlist augassign print_stmt line67 lines75 lines74 line68 del_stmt flow_stmt break_stmt continue_stmt return_stmt lines84 yield_stmt raise_stmt lines87 lines88 lines89 dotted_name FS_NAME global_stmt COM_NAME exec_stmt lines110 assert_stmt prim prime declare_stmt compound_stmt if_stmt lines115 ELIF_test_COL_suite while_stmt for_stmt try_stmt line105 lines121 except_clause_COL_suite with_stmt line108 COM_with_item with_item lines127 except_clause lines129 lines130 line112 suite stmt_ testlist_safe lines135 COM_old_test old_test test lines142 or_test OR_and_test and_test AND_not_test not_test comparision comp_op_expr comp_op expr BO_xor_expr xor_expr BX_and_expr and_expr BA_shift_expr shift_expr LSRS_arith_expr line137 arith_expr PLUSMINUS_term line140 term STARDIVMODFF_factor line143 factor line145 power atom_expr trailer_ atom lines172 lines173 lines174 listmaker line151 testlist_comp line153 trailer lines183 subscriptlist line158 COM_subscript subscript sliceop lines189 lines190 exprlist line163 COM_expr testlist line166 COM_test dictorsetmaker line169 line170 COM_test_COL_test classdef lines202 arglist line175 argument_COM argument lines209 list_iter list_for list_if lines214 comp_iter comp_for comp_if lines219 testlist1 yield_expr 
%%

start: single_input {  $$.node_id = 0 + dfn;  create_node("", "start" , $$.node_id );  create_edge( { $1.node_id } , $$.node_id );  dfn += 1; YYACCEPT;} 
     | file_input  {YYACCEPT;}
     | eval_input { $$.node_id = 0 + dfn;  create_node("", "start" , $$.node_id );  create_edge( { $1.node_id } , $$.node_id );  dfn += 1;YYACCEPT;}
     ;
epsilon: 
       ;
single_input: NEWLINE { $$.node_id=dfn; $1.node_id=dfn; create_node("","NEWLINE",$1.node_id);  dfn++;}
            | simple_stmt {  $$.node_id = $1.node_id;}
            | compound_stmt NEWLINE %prec high { $$.node_id=dfn+1; $2.node_id= dfn;  create_node("","single_input",$$.node_id);create_node("","NEWLINE",$2.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
            ; 
file_input: NEWstmt ENDMARKER {  $$.node_id = 1 + dfn;  create_node("", "file_input" , $$.node_id );  create_node("", "ENDMARKER" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn } , $$.node_id );  dfn += 2; }
          | ENDMARKER { $$.node_id=dfn; $1.node_id=dfn;  create_node("","ENDMARKER",$1.node_id);  dfn++;}
          ;
NEWstmt: NEWLINE {$$.node_id=dfn; $1.node_id=dfn; create_node("","NEWLINE",$1.node_id);  dfn++;}
       | stmt { $$.node_id = $1.node_id;}
       | NEWLINE NEWstmt {  $$.node_id = 1 + dfn;  create_node("", "NEWstmt" , $$.node_id );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { 0 + dfn, $2.node_id } , $$.node_id );  dfn += 2; }
       | stmt NEWstmt {  $$.node_id = 0 + dfn;  create_node("", "NEWstmt" , $$.node_id );  create_edge( { $1.node_id, $2.node_id } , $$.node_id );  dfn += 1; }
       ;
eval_input: testlist ENDMARKER { $$.node_id=dfn+1; $2.node_id= dfn;  create_node("","eval_input",$$.node_id);create_node("","ENDMARKER",$2.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
          | testlist Nnew ENDMARKER {  $$.node_id = 1 + dfn;  create_node("", "eval_input" , $$.node_id );  create_node("", "ENDMARKER" , 0 + dfn );  create_edge( { $1.node_id, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 2; }
          ;
Nnew: NEWLINE {$$.node_id=dfn; $1.node_id=dfn; create_node("","NEWLINE",$1.node_id);  dfn++;}
    | NEWLINE Nnew { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","Nnew",$$.node_id);create_node("","NEWLINE",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
    ; 
decorator: AT dotted_name line38 NEWLINE {  $$.node_id = 2 + dfn;  create_node("", "decorator" , $$.node_id );  create_node("@", "AT" , 1 + dfn );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, $3.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
         | AT dotted_name NEWLINE {  $$.node_id = 2 + dfn;  create_node("", "decorator" , $$.node_id );  create_node("@", "AT" , 1 + dfn );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
         ;
line38: LP line41 RP {  $$.node_id = 2 + dfn;  create_node("", "line38" , $$.node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
      ;
line41: arglist { $$.node_id = $1.node_id;}
      | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
      ;
decorated: decorators line40 { $$.node_id=dfn;  create_node("","decorated",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
         ;
line40: classdef { $$.node_id = $1.node_id;}
      | funcdef { $$.node_id = $1.node_id;}
      ;
decorators: decorator { $$.node_id = $1.node_id;}
          | decorator decorators { $$.node_id=dfn;  create_node("","decorators",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
          ;
funcdef: DEF NAME parameters COL{ 

                curr_table->insert(string((char*)($2).lexeme), "Function", "Void", offset, curr_scope, yylineno, -1);
                tables.push(curr_table);
                scope_names.push(curr_scope);
                offsets.push(offset);

                curr_table= new Sym_Table(curr_table);
                list_of_Symbol_Tables.push_back(curr_table);
                string new_scope="Function_"+string((char*)($2.lexeme));
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
                                if(string((char*)($2.lexeme))=="__init__")
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
                                        class_func_list[{class_name_present,string((char*)($2.lexeme))}].push_back(funcparam[j].second.first); 
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

                func_decl_list[string((char*)($2).lexeme)].push_back("1");
                func_decl_list[string((char*)($2).lexeme)].pop_back();

                if(cls==0) 
                {
                        // func_decl_list[string((char*)($2).lexeme)]=funcparam;
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                func_decl_list[string((char*)($2).lexeme)].push_back(var_type);
                        }
                }
                else
                {
                        // cout<<"here came actually";
                        // cout<<string((char*)($2).lexeme)<<"--> ";
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                curr_table->class_func_args[string((char*)($2).lexeme)].push_back(var_type);
                                // cout<<"{"<<i<<" , "<<var_type<<"} ";
                        }
                        // cout<<"\n";
                        // cout<<curr_table_<<" "<<string((char*)($2).lexeme)<<" "<<curr_table->class_func_args["__init__"].size()<<"\n";
                        // cout<<"\n";
                        // if(curr_table->class_func_args.find("__init__") != curr_table->class_func_args.end()) cout<<"here ";
                        // else cout<<"not here";
                }
                
                funcparam.clear();
} suite { 

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
       | DEF NAME parameters ARROW prime COL { 
        // cout<<"hebdbuqally";
                curr_table->insert(string((char*)($2).lexeme), "Function", string((char*)($5).type), offset, curr_scope, yylineno, -1);
                tables.push(curr_table);
                scope_names.push(curr_scope);
                offsets.push(offset);

                curr_table= new Sym_Table(curr_table);
                list_of_Symbol_Tables.push_back(curr_table);
                string new_scope="Function_"+string((char*)($2.lexeme));
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
                                if(string((char*)($2.lexeme))=="__init__")
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
                                        class_func_list[{class_name_present,string((char*)($2.lexeme))}].push_back(funcparam[j].second.first); 
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
                func_decl_list[string((char*)($2).lexeme)].push_back("1");
                func_decl_list[string((char*)($2).lexeme)].pop_back();
                for(int i=0;i<(int)(funcparam.size());i++)
                {
                        string var_type= funcparam[i].second.first;
                        func_decl_list[string((char*)($2).lexeme)].push_back(var_type);
                }


                if(cls==0) 
                {
                        // func_decl_list[string((char*)($2).lexeme)]=funcparam;
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                func_decl_list[string((char*)($2).lexeme)].push_back(var_type);
                        }
                }
                else
                {
                        // cout<<string((char*)($2).lexeme)<<"--> ";
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                curr_table->class_func_args[string((char*)($2).lexeme)].push_back(var_type);
                                // cout<<"{"<<i<<" , "<<var_type<<"} ";
                        }
                }
                funcparam.clear();
                
        }
        suite
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
        
       ;
parameters: LP fpdefq RP {  $$.node_id = 2 + dfn;  create_node("", "parameters" , $$.node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
          | LP fplist fpdefq RP {  $$.node_id = 2 + dfn;  create_node("", "parameters" , $$.node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, $3.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
          ;
fpdef: NAME COL prim { 
        funcparam.push_back({string((char*)($1).lexeme),{string((char*)($3).type),-1}}) ; 
        nelem++;
        }
     | SELF { 

        funcparam.push_back({string((char*)($1).lexeme),{"self",-1}}) ; 
        nelem++;
}
     ;
fplist: fpdef COM { $$.node_id=dfn+1; $2.node_id= dfn;  create_node("","fplist",$$.node_id);create_node(",","COM",$2.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
      | fplist fpdef COM { $$.node_id=dfn+1; $3.node_id= dfn ; create_node("","fplist",$$.node_id);create_node(",","COM",$3.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
      ;
lines57:  COM { $$.node_id=dfn; $1.node_id=dfn; create_node(",","COM",$1.node_id);  dfn++;}
       | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
       ; 
fpdefq: fpdef { $$.node_id = $1.node_id;}
      | epsilon  { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
      ;
range_func: RANGE LP argument RP {  $$.node_id = 3 + dfn;  create_node("", "range_func" , $$.node_id );  create_node("range", "RANGE" , 2 + dfn );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, $3.node_id, 0 + dfn } , $$.node_id );  dfn += 4; }
          | RANGE LP argument argument RP {  $$.node_id = 3 + dfn;  create_node("", "range_func" , $$.node_id );  create_node("range", "RANGE" , 2 + dfn );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, $3.node_id, $4.node_id, 0 + dfn } , $$.node_id );  dfn += 4; }
          | RANGE LP argument argument argument RP {  $$.node_id = 3 + dfn;  create_node("", "range_func" , $$.node_id );  create_node("range", "RANGE" , 2 + dfn );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, $3.node_id, $4.node_id, $5.node_id, 0 + dfn } , $$.node_id );  dfn += 4; }
          ; 
stmt: simple_stmt { $$.node_id = $1.node_id;}
    | compound_stmt %prec low { $$.node_id = $1.node_id;}
    ;
simple_stmt: small_stmt line57 SCOL NEWLINE {  $$.node_id = 2 + dfn;  create_node("", "simple_stmt" , $$.node_id );  create_node(";", "SCOL" , 1 + dfn );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { $1.node_id, $2.node_id, 1 + dfn, 0 + dfn } , $$.node_id );  dfn += 3; }
           | small_stmt line57 NEWLINE {  $$.node_id = 1 + dfn;  create_node("", "simple_stmt" , $$.node_id );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { $1.node_id, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 2; }
           ;
line57: epsilon %prec low { $$.node_id=dfn;  create_node("","ε",$$.node_id);   dfn++;}
      | line57 SCOL small_stmt %prec high {  $$.node_id = 1 + dfn;  create_node("", "line57" , $$.node_id );  create_node(";", "SCOL" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 2; }
      ;
small_stmt: declare_stmt { $$.node_id = $1.node_id;}
          | expr_stmt { $$.node_id = $1.node_id;}
          | print_stmt { $$.node_id = $1.node_id;}
          | del_stmt { $$.node_id = $1.node_id;}
          | flow_stmt { $$.node_id = $1.node_id;}
          | global_stmt { $$.node_id = $1.node_id;}
          | exec_stmt { $$.node_id = $1.node_id;}
          | assert_stmt { $$.node_id = $1.node_id;}
          ;
expr_stmt: testlist line62 %prec high { $$.node_id=dfn;  create_node("","expr_stmt",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
         | testlist %prec low { $$.node_id = $1.node_id;}
         ;
line61: yield_expr { $$.node_id = $1.node_id;}
      | testlist { $$.node_id = $1.node_id;}
      ;
line62: augassign line61 { $$.node_id=dfn;  create_node("","line62",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
      | EQ_yield_expr_testlist { $$.node_id = $1.node_id;}
      ;
EQ_yield_expr_testlist: EQ line61 { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","EQ_yield_expr_testlist",$$.node_id);create_node("=","EQ",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
                      | EQ line61 EQ_yield_expr_testlist { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","EQ_yield_expr_testlist",$$.node_id);create_node("=","EQ",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
                      ;
augassign: PE { $$.node_id=dfn; $1.node_id=dfn; create_node("+=","PE",$1.node_id);  dfn++;}
         | ME { $$.node_id=dfn; $1.node_id=dfn; create_node("-=","ME",$1.node_id);  dfn++;}
         | SE { $$.node_id=dfn; $1.node_id=dfn; create_node("*=","SE",$1.node_id);  dfn++;}
         | DE { $$.node_id=dfn; $1.node_id=dfn; create_node("/=","DE",$1.node_id);  dfn++;}
         | MODE { $$.node_id=dfn; $1.node_id=dfn; create_node("%=","MODE",$1.node_id);  dfn++;}
         | ANDE { $$.node_id=dfn; $1.node_id=dfn; create_node("&=","ANDE",$1.node_id);  dfn++;}
         | BOE { $$.node_id=dfn; $1.node_id=dfn; create_node("|=","BOE",$1.node_id);  dfn++;}
         | BXE { $$.node_id=dfn; $1.node_id=dfn; create_node("^=","BXE",$1.node_id);  dfn++;}
         | LSE { $$.node_id=dfn; $1.node_id=dfn; create_node("<<=","LSE",$1.node_id);  dfn++;}
         | RSE { $$.node_id=dfn; $1.node_id=dfn; create_node(">>=","RSE",$1.node_id);  dfn++;}
         | SSE { $$.node_id=dfn; $1.node_id=dfn; create_node("**=","SSE",$1.node_id);  dfn++;}
         | FFE { $$.node_id=dfn; $1.node_id=dfn; create_node("//=","FFE",$1.node_id);  dfn++;}
         ;
print_stmt: PRINT line67 {  $$.node_id = 1 + dfn;  create_node("", "print_stmt" , $$.node_id );  create_node("print", "PRINT" , 0 + dfn );  create_edge( { 0 + dfn, $2.node_id } , $$.node_id );  dfn += 2; }
          ;
line67: lines74 { $$.node_id= $1.node_id;}
      | RS test lines75 { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","line67",$$.node_id);create_node(">>","RS",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
      ;
lines74: test line68 { $$.node_id=dfn;  create_node("","lines74",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
       ;
lines75: COM_test lines57 { $$.node_id=dfn;  create_node("","lines75",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
       ;
line68: COM_test lines57 { $$.node_id=dfn;  create_node("","lines68",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
      | lines57 { $$.node_id= $1.node_id;}
      ;
del_stmt: DEL exprlist { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","del_stmt",$$.node_id);create_node("del","DEL",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        ;
flow_stmt: break_stmt { $$.node_id= $1.node_id;}
         | continue_stmt { $$.node_id= $1.node_id;}
         | return_stmt { $$.node_id= $1.node_id;}
         | raise_stmt { $$.node_id= $1.node_id;}
         | yield_stmt { $$.node_id= $1.node_id;}
         ;
break_stmt: BREAK { $$.node_id=dfn; $1.node_id=dfn; create_node("break","BREAK",$1.node_id);  dfn++;}
          ;
continue_stmt: CONTINUE { $$.node_id=dfn; $1.node_id=dfn; create_node("continue","CONTINUE",$1.node_id);  dfn++;}
             ;
return_stmt: RETURN lines84 { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","return_stmt",$$.node_id);create_node("return","RETURN",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
           ;
lines84: testlist { $$.node_id= $1.node_id;}
       | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
       ;
yield_stmt: yield_expr { $$.node_id= $1.node_id;}
          ;
raise_stmt: RAISE lines89 { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","raise_stmt",$$.node_id);create_node("raise","RAISE",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
          ;
lines87: COM test { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","lines87",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
       | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
       ;
lines88: COM test lines87 { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","lines88",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
       | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
       ;
lines89: test lines88 { $$.node_id=dfn;  create_node("","lines89",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
       ;
dotted_name: NAME FS_NAME { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","dotted_name",$$.node_id);create_node($1.lexeme,"NAME",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
           | NAME  { $$.node_id=dfn; $1.node_id=dfn; create_node($1.lexeme,"NAME",$1.node_id);  dfn++;}
           ;
FS_NAME : FS NAME FS_NAME {  $$.node_id = 2 + dfn;  create_node("", "FS_NAME" , $$.node_id );  create_node(".", "FS" , 1 + dfn );  create_node($2.lexeme, "NAME" , 0 + dfn );  create_edge( { $1.node_id, 1 + dfn, 0 + dfn } , $$.node_id );  dfn += 3; }
        | FS NAME { $$.node_id=dfn+2; $1.node_id= dfn+1; $2.node_id=dfn;  create_node("","FS_NAME",$$.node_id);create_node(".","FS",$1.node_id);create_node($2.lexeme,"NAME",$2.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=3;}
        ;
global_stmt: GLOBAL NAME COM_NAME { $$.node_id=dfn+2; $1.node_id= dfn+1; $2.node_id=dfn;  create_node("","global_stmt",$$.node_id);create_node("global","GLOBAL",$1.node_id);create_node($2.lexeme,"NAME",$2.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=3;}
           | GLOBAL NAME { $$.node_id=dfn+2; $1.node_id= dfn+1; $2.node_id=dfn;  create_node("","global_stmt",$$.node_id);create_node("global","GLOBAL",$1.node_id);create_node($2.lexeme,"NAME",$2.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=3;}
           ;
COM_NAME: COM NAME COM_NAME {  $$.node_id = 2 + dfn;  create_node("", "COM_NAME" , $$.node_id );  create_node(",", "COM" , 1 + dfn );  create_node($2.lexeme, "NAME" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 3; }
        | COM NAME { $$.node_id=dfn+2; $1.node_id= dfn+1; $2.node_id=dfn;  create_node("","COM_NAME",$$.node_id);create_node(",","COM",$1.node_id);create_node($2.lexeme,"NAME",$2.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=3;}
        ;
exec_stmt: EXEC expr lines110 { $$.node_id=dfn+1; $1.node_id= dfn; create_node("","exec_stmt",$$.node_id);create_node("exec","EXEC",$1.node_id);create_node("","NAME",$2.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
         ;
lines110: IN test lines87 { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","lines110",$$.node_id);create_node("in","IN",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
assert_stmt: ASSERT test lines87 { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","assert_stmt",$$.node_id);create_node("assert","ASSERT",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
           ;
prim: primitives { strcpy($$.type, $1.type);$$.Isobj=0;}
    | NAME { strcpy($$.type, $1.lexeme); $$.Isobj=1;}
    ;
primitives: PRIMITIVES { strcpy($$.type, $1.lexeme); }
          | LIST LB primitives RB {
                strcpy($$.type,("list["+string((char*)($3).type)+"]").c_str());
                //  strcpy($$.type, $1.lexeme);
                  }
          ;
prime: prim { strcpy($$.type, $1.type);}
     | NONE { strcpy($$.type, $1.lexeme);}
     ;
declare_stmt: atom_expr COL prim {
                /* ( list str  , int float bool ) */
                // if()
                string var_type= string((char*)($3).type);
                string var_name= string((char*)($1).type);
                // cout<<var_type<<"mouryaaaaa "<<var_name<<"\n";
                // if(var_type)
                if($3.Isobj==1)
                {
                        /* object is being declared  */
                        curr_table->insert(string((char*)($1).type), "Object", string((char*)($3).type), offset, curr_scope, yylineno-1, -1 );
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
                                        temp_parent_table->insert(substring_after_dot(((char*)($1).type)), "PRIMITIVES", string((char*)($3).type), temp_parent_offset, temp_parent_scope, yylineno-1, list_count );

                                        if(var_type[5]=='i' || var_type[5]=='f' ) temp_parent_offset+=list_count*(4);
                                        else if(var_type[5]=='b' ) temp_parent_offset+=list_count*(1);
                                }
                                else if(var_type[0]=='s')
                                {
                                        // str
                                        int string_count=0;
                                        temp_parent_table->insert(substring_after_dot(string((char*)($1).type)), "PRIMITIVES", string((char*)($3).type), temp_parent_offset, temp_parent_scope, yylineno-1, string_count);
                                        temp_parent_offset+=string_count*(1);
                                }
                                else
                                {
                                        // int , bool, float
                                        temp_parent_table->insert(substring_after_dot(string((char*)($1).type)), "PRIMITIVES", string((char*)($3).type), temp_parent_offset, temp_parent_scope, yylineno-1, -1);
                                        if(var_type[0]=='i' || var_type[0]=='f' ) temp_parent_offset+=(4);
                                        else if(var_type[0]=='b' ) temp_parent_offset+=(1);
                                }
                                offsets.push(temp_parent_offset);/* only parents offset is needed to change in stack */
                        }
                        else if(var_type[0]=='l')
                        {
                                // list[int bool str float]
                                curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, -1 );

                                if(var_type[5]=='i' || var_type[5]=='f' ) offset+=(4);
                                else if(var_type[5]=='b' ) offset+=(1);
                        }
                        else if(var_type[0]=='s')
                        {
                                // str
                                curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, -1 );
                                offset+=(1);
                        }
                        else
                        {
                                // int , bool, float
                                curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, -1 );
                                if(var_type[0]=='i' || var_type[0]=='f' ) offset+=(4);
                                else if(var_type[0]=='b' ) offset+=(1);
                        }
                }
                // curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, -1);
                // offset+=getsize(string((char*)($3).type));
                // cout << endl<<$5.cnt << "ewgfdjew"<<endl;
            }
            | atom_expr COL prim EQ test {
                /* ( list str  , int float bool ) */
                // if()
                /*  type checking */
                string test_str= string((char*)($5).type);
                string var_type= string((char*)($3).type);
                string var_name= string((char*)($1).type);
                // cout<<"\nhere came annamata"<<var_name<<" ";
                // cout<<var_type<<"mouryaaaaa "<<var_name<<"\n";
                if($3.Isobj==1)
                {

                        /* object is being declared  */
                        curr_table->insert(string((char*)($1).type), "Object", string((char*)($3).type), offset, curr_scope, yylineno-1, -1 );
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
                                        type_check_func(In_BTW_BOXES(string((char*)($3).type)),string((char*)($5).data_type));
                                        int list_count=$5.cnt;
                                        temp_parent_table->insert(substring_after_dot(((char*)($1).type)), "PRIMITIVES", string((char*)($3).type), temp_parent_offset, temp_parent_scope, yylineno-1, list_count );

                                        if(var_type[5]=='i' || var_type[5]=='f' ) temp_parent_offset+=list_count*(4);
                                        else if(var_type[5]=='b' ) temp_parent_offset+=list_count*(1);
                                }
                                else if(var_type[0]=='s')
                                {
                                        // str
                                        type_check_func(string((char*)($3).type),string((char*)($5).data_type));
                                        int string_count=$5.cnt;
                                        temp_parent_table->insert(substring_after_dot(string((char*)($1).type)), "PRIMITIVES", string((char*)($3).type), temp_parent_offset, temp_parent_scope, yylineno-1, string_count);
                                        temp_parent_offset+=string_count*(1);
                                }
                                else
                                {
                                        // int , bool, float
                                        type_check_func(string((char*)($3).type),string((char*)($5).data_type));
                                        temp_parent_table->insert(substring_after_dot(string((char*)($1).type)), "PRIMITIVES", string((char*)($3).type), temp_parent_offset, temp_parent_scope, yylineno-1, -1);
                                        if(var_type[0]=='i' || var_type[0]=='f' ) temp_parent_offset+=(4);
                                        else if(var_type[0]=='b' ) temp_parent_offset+=(1);
                                }
                                offsets.push(temp_parent_offset);/* only parents offset is needed to change in stack */
                        }
                        else if(var_type[0]=='l')
                        {
                                // list[int bool str float]
                                type_check_func(In_BTW_BOXES(string((char*)($3).type)),string((char*)($5).data_type));

                                int list_count=$5.cnt;
                                curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, list_count );

                                if(var_type[5]=='i' || var_type[5]=='f' ) offset+=list_count*(4);
                                else if(var_type[5]=='b' ) offset+=list_count*(1);
                        }
                        else if(var_type[0]=='s')
                        {
                                // str
                                type_check_func(string((char*)($3).type),string((char*)($5).data_type));
                                int string_count=$5.cnt;
                                curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, string_count );
                                offset+=string_count*(1);
                        }
                        else
                        {
                                // int , bool, float
                                type_check_func(string((char*)($3).type),string((char*)($5).data_type));
                                curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, -1 );
                                if(var_type[0]=='i' || var_type[0]=='f' ) offset+=(4);
                                else if(var_type[0]=='b' ) offset+=(1);
                        }

                }
            }
            ;
compound_stmt: if_stmt { $$.node_id= $1.node_id;}
             | while_stmt { $$.node_id= $1.node_id;}
             | for_stmt { $$.node_id= $1.node_id;}
             | try_stmt { $$.node_id= $1.node_id;}
             | with_stmt { $$.node_id= $1.node_id;}
             | funcdef { $$.node_id= $1.node_id;}
             | classdef { }
             | decorated { $$.node_id= $1.node_id;}
             ;
if_stmt: IF expr_stmt COL suite ELIF_test_COL_suite lines115 {  $$.node_id = 2 + dfn;  create_node("", "if_stmt" , $$.node_id );  create_node("if", "IF" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id, $5.node_id, $6.node_id } , $$.node_id );  dfn += 3; }
       | IF expr_stmt COL suite lines115 {  $$.node_id = 2 + dfn;  create_node("", "if_stmt" , $$.node_id );  create_node("if", "IF" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id, $5.node_id } , $$.node_id );  dfn += 3; }
       ;
lines115: ELSE COL suite { $$.node_id=dfn+2; $1.node_id= dfn+1; $2.node_id=dfn;  create_node("","lines115",$$.node_id);create_node("else","ELSE",$1.node_id);create_node(":","COL",$2.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=3;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
ELIF_test_COL_suite: ELIF expr_stmt COL suite ELIF_test_COL_suite {  $$.node_id = 2 + dfn;  create_node("", "ELIF_test_COL_suite" , $$.node_id );  create_node("elif", "ELIF" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id, $5.node_id } , $$.node_id );  dfn += 3; }
                   | ELIF expr_stmt COL suite {  $$.node_id = 2 + dfn;  create_node("", "ELIF_test_COL_suite" , $$.node_id );  create_node("elif", "ELIF" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id } , $$.node_id );  dfn += 3; }
                   ;
while_stmt: WHILE expr_stmt COL suite lines115 {  $$.node_id = 2 + dfn;  create_node("", "while_stmt" , $$.node_id );  create_node("while", "WHILE" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id, $5.node_id } , $$.node_id );  dfn += 3; }
          ;
for_stmt: FOR exprlist IN testlist COL suite lines115 {  $$.node_id = 3 + dfn;  create_node("", "for_stmt" , $$.node_id );  create_node("for", "FOR" , 2 + dfn );  create_node("in", "IN" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 2 + dfn, $2.node_id, 1 + dfn, $4.node_id, 0 + dfn, $6.node_id, $7.node_id } , $$.node_id );  dfn += 4; }
        | FOR exprlist IN range_func COL suite lines115 {  $$.node_id = 3 + dfn;  create_node("", "for_stmt" , $$.node_id );  create_node("for", "FOR" , 2 + dfn );  create_node("in", "IN" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 2 + dfn, $2.node_id, 1 + dfn, $4.node_id, 0 + dfn, $6.node_id, $7.node_id } , $$.node_id );  dfn += 4; }
        ;
try_stmt: TRY COL suite line105 {  $$.node_id = 2 + dfn;  create_node("", "try_stmt" , $$.node_id );  create_node("try", "TRY" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn, $3.node_id, $4.node_id } , $$.node_id );  dfn += 3; }
        ;
line105: except_clause_COL_suite lines115 lines121 {  $$.node_id = 0 + dfn;  create_node("", "line105" , $$.node_id );  create_edge( { $1.node_id, $2.node_id, $3.node_id } , $$.node_id );  dfn += 1; }
       | FINALLY COL suite {  $$.node_id = 2 + dfn;  create_node("", "line105" , $$.node_id );  create_node("finally", "FINALLY" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 3; }
       ;
lines121: FINALLY COL suite {  $$.node_id = 2 + dfn;  create_node("", "lines121" , $$.node_id );  create_node("finally", "FINALLY" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 3; }
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
except_clause_COL_suite: except_clause COL suite except_clause_COL_suite {  $$.node_id = 1 + dfn;  create_node("", "except_clause_COL_suite" , $$.node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn, $3.node_id, $4.node_id } , $$.node_id );  dfn += 2; }
                       | except_clause COL suite {  $$.node_id = 1 + dfn;  create_node("", "except_clause_COL_suite" , $$.node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 2; }
                       ;
with_stmt: WITH with_item line108 { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","with_stmt",$$.node_id);create_node("with","WITH",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
         ;
line108: COM_with_item COL suite {  $$.node_id = 1 + dfn;  create_node("", "line108" , $$.node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 2; }
       | COL suite { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","line108",$$.node_id);create_node(":","COL",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
       ;
COM_with_item: COM with_item COM_with_item { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","COM_with_item",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             | COM with_item { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","COM_with_item",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             ;
with_item: test lines127 { $$.node_id=dfn;  create_node("","with_item",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
         ;
lines127: AS expr { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","lines127",$$.node_id);create_node("as","AS",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
except_clause: EXCEPT lines130 { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","except_clause",$$.node_id);create_node("except","EXCEPT",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             ;
lines129: line112 test { $$.node_id=dfn;  create_node("","lines129",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
lines130: test lines129 { $$.node_id=dfn;  create_node("","lines130",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
line112: AS { $$.node_id=dfn; $1.node_id=dfn; create_node("as","AS",$1.node_id);  dfn++;}
       | COM { $$.node_id=dfn; $1.node_id=dfn; create_node(",","COM",$1.node_id);  dfn++;}
       ;
suite: simple_stmt { $$.node_id= $1.node_id;}
     | NEWLINE INDENT stmt_ DEDENT {  $$.node_id = 3 + dfn;  create_node("", "suite" , $$.node_id );  create_node("", "NEWLINE" , 2 + dfn );  create_node("", "INDENT" , 1 + dfn );  create_node("", "DEDENT" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, $3.node_id, 0 + dfn } , $$.node_id );  dfn += 4; }
     ;
stmt_: stmt stmt_ %prec high { $$.node_id=dfn;  create_node("","stmt_",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
     | stmt %prec low { $$.node_id= $1.node_id;}
     ;
testlist_safe: old_test lines135 { $$.node_id=dfn;  create_node("","testlist_safe",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
             ;
lines135: COM_old_test lines57 { $$.node_id=dfn;  create_node("","line135",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
COM_old_test: COM old_test COM_old_test %prec high { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","COM_old_test",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
            | COM old_test %prec low { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","COM_old_test",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
            ;
old_test: or_test { strcpy($$.data_type,$1.data_type); }
        ;
test: or_test lines142 { $$.cnt = $1.cnt; strcpy($$.data_type,$1.data_type);  }
    ;
lines142: IF or_test ELSE test {  $$.node_id = 2 + dfn;  create_node("", "lines142" , $$.node_id );  create_node("if", "IF" , 1 + dfn );  create_node("else", "ELSE" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id } , $$.node_id );  dfn += 3; }
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
or_test: and_test OR_and_test {  type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type); }
       | and_test {$$.cnt = $1.cnt;  strcpy($$.data_type,$1.data_type); }
       ;
OR_and_test: OR and_test OR_and_test {  type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
           | OR and_test {   strcpy($$.data_type,$2.data_type); }
           ;
and_test: not_test AND_not_test {type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type); }
        | not_test { $$.cnt = $1.cnt;  strcpy($$.data_type,$1.data_type);}
        ;
AND_not_test: AND not_test AND_not_test { type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
            | AND not_test {  strcpy($$.data_type,$2.data_type); }
            ;
not_test: NOT not_test %prec high {  strcpy($$.data_type,$2.data_type); }
        | comparision { $$.cnt = $1.cnt;  strcpy($$.data_type,$1.data_type); }
        ;
comparision: expr comp_op_expr {type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type); }
          | expr { $$.cnt = $1.cnt;  strcpy($$.data_type,$1.data_type); }
          ;
comp_op_expr: comp_op expr comp_op_expr { type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type); }
            | comp_op expr {  $$.cnt = $1.cnt;  strcpy($$.data_type,$2.data_type); }
            ;
comp_op: LT { $$.node_id=dfn; $1.node_id=dfn; create_node("<","LT",$1.node_id);  dfn++;}
       | GT { $$.node_id=dfn; $1.node_id=dfn; create_node(">","GT",$1.node_id);  dfn++;}
       | EE { $$.node_id=dfn; $1.node_id=dfn; create_node("==","EE",$1.node_id);  dfn++;}
       | GE { $$.node_id=dfn; $1.node_id=dfn; create_node(">=","GE",$1.node_id);  dfn++;}
       | LE { $$.node_id=dfn; $1.node_id=dfn; create_node("<=","LE",$1.node_id);  dfn++;}
       | LG { $$.node_id=dfn; $1.node_id=dfn; create_node("<>","LG",$1.node_id);  dfn++;}
       | NE { $$.node_id=dfn; $1.node_id=dfn; create_node("!=","NE",$1.node_id);  dfn++;}
       | IN { $$.node_id=dfn; $1.node_id=dfn; create_node("in","IN",$1.node_id);  dfn++;}
       | NI { $$.node_id=dfn; $1.node_id=dfn; create_node("not in","NI",$1.node_id);  dfn++;}
       | IS { $$.node_id=dfn; $1.node_id=dfn; create_node("is","IS",$1.node_id);  dfn++;}
       | INOT { $$.node_id=dfn; $1.node_id=dfn; create_node("is not","INOT",$1.node_id);  dfn++;}
       ;
expr: xor_expr BO_xor_expr { type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type);  }
    | xor_expr { $$.cnt = $1.cnt;  strcpy($$.data_type,$1.data_type);  }
    ;
BO_xor_expr: BO xor_expr BO_xor_expr {  type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type);  }
           | BO xor_expr { strcpy($$.data_type,$2.data_type);  }
           ;
xor_expr: and_expr BX_and_expr {  type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type); }
        | and_expr { $$.cnt = $1.cnt; strcpy($$.data_type,$1.data_type); }
        ;
BX_and_expr: BX and_expr BX_and_expr {   type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
           | BX and_expr { strcpy($$.data_type,$2.data_type);  }
           ;
and_expr: shift_expr BA_shift_expr { type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type);  }
        | shift_expr { $$.cnt = $1.cnt;strcpy($$.data_type,$1.data_type);}
        ;
BA_shift_expr: BA shift_expr BA_shift_expr { type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
             | BA shift_expr { strcpy($$.data_type,$2.data_type); }
             ;
shift_expr: arith_expr LSRS_arith_expr {  type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type);   }
          | arith_expr { $$.cnt = $1.cnt; strcpy($$.data_type,$1.data_type); }
          ;
LSRS_arith_expr: line137 arith_expr LSRS_arith_expr {  type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
               | line137 arith_expr { strcpy($$.data_type,$2.data_type);  }
               ;
line137: LS { $$.node_id=dfn; $1.node_id=dfn; create_node("<<","LS",$1.node_id);  dfn++; }
       | RS { $$.node_id=dfn; $1.node_id=dfn; create_node(">>","RS",$1.node_id);  dfn++; }
       ;
arith_expr: term PLUSMINUS_term %prec high { type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type);   }
          | term %prec low { $$.cnt = $1.cnt; strcpy($$.data_type,$1.data_type); }
          ;
PLUSMINUS_term: line140 term PLUSMINUS_term { type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
              | line140 term %prec low { strcpy($$.data_type,$2.data_type);   }
              ;
line140: PLUS %prec high {  strcpy($$.type,$1.lexeme);  }
       | MINUS {  strcpy($$.type,$1.lexeme);  }
       ;
term: factor STARDIVMODFF_factor { type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); }
    | factor { strcpy($$.data_type,$1.data_type);}
    ;
STARDIVMODFF_factor: line143 factor STARDIVMODFF_factor { type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
                   | line143 factor { strcpy($$.data_type,$2.data_type);  }
                   ;
line143: STAR  {  strcpy($$.type,$1.lexeme);  }
       | DIV {   strcpy($$.type,$1.lexeme);  }
       | MOD {  strcpy($$.type,$1.lexeme); }
       | FF {  strcpy($$.type,$1.lexeme); }
       ;
factor: line145 factor {  strcpy($$.data_type,$2.data_type);   }
      | power  { $$.cnt = $1.cnt; strcpy($$.data_type,$1.data_type);  }
      ;
line145: PLUS  { strcpy($$.type, $1.lexeme); }
       | MINUS { strcpy($$.type, $1.lexeme); }
       | NEG { strcpy($$.type, $1.lexeme); }
       ;
power: atom_expr {  $$.cnt = $1.cnt; strcpy($$.data_type, $1.data_type);}
     | atom_expr SS factor { 
         strcpy($$.type, $3.lexeme); 
                /* type conversion */
                type_check_func(string((char*)($1).data_type),string((char*)($3).data_type));
         }
     ;
atom_expr: atom trailer_ { 
                strcpy($$.data_type, $1.data_type);
                string temppp2=(string((char*)($2).type));
                string temppp1=(string((char*)($1).type))+temppp2;
                strcpy($$.type,temppp1.c_str());

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
                                        string name_of_function=string((char*)($1).type); 
                                        if(class_name_map.find(name_of_function)!=class_name_map.end())
                                        {
                                                /* constructor  */
                                                for(int i=0;i<(*($2.abc)).size();i++)
                                                {
                                                        temp.push_back( (*($2.abc))[i] ); 
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
                                                for(int i=0;i<(*($2.abc)).size();i++)
                                                {
                                                        temp.push_back( (*($2.abc))[i] ); 
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
                                                string func_name=(string((char*)($1).type));
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
                                        string class_name=string((char*)($1).type);
                                        string func_name=solve1((char*)($2).type);
                                        //  cout<<"saewefw";
                                        if(class_func_list.find({class_name,func_name})!=class_func_list.end())
                                        {
                                                if((*($2.abc))[0]!="self")
                                                {
                                                        cout<<"Error: self is not passed at line no: "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }
                                                for(int i=1;i<(int)(*($2.abc)).size();i++)
                                                {
                                                        temp.push_back( (*($2.abc))[i] ); 
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
                                                string object_name=string((char*)($1).type);
                                                string func_name=solve1((char*)($2).type);
                                                string class_name=say(object_name);
                                                /* normal object calling its own method from other scopes  */
                                                for(int i=0;i<(int)(*($2.abc)).size();i++)
                                                {
                                                        temp.push_back( (*($2.abc))[i] ); 
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
         | atom %prec low  { strcpy($$.type, $1.type);$$.cnt = $1.cnt;}
         ;
trailer_: trailer trailer_ {
                 string temppp2=(string((char*)($2).type));
                string temppp1=(string((char*)($1).type))+temppp2;
                strcpy($$.type,temppp1.c_str()); 
                 $$.abc=$2.abc;
                }
        | trailer %prec low { $$.abc=$1.abc; strcpy($$.type,$1.type);  }
        ;
atom: LP lines172 RP {  $$.node_id = 2 + dfn;  create_node("", "atom" , $$.node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
    | LB lines173 RB {$$.cnt = $2.cnt; strcpy($$.data_type,$2.data_type); }
    | LF lines174 RF {  $$.node_id = 2 + dfn;  create_node("", "atom" , $$.node_id );  create_node("{", "LF" , 1 + dfn );  create_node("}", "RF" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
    | BT testlist1 BT {  $$.node_id = 2 + dfn;  create_node("", "atom" , $$.node_id );  create_node("`", "BT" , 1 + dfn );  create_node("`", "BT" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
    | NAME { strcpy($$.type, $1.lexeme); strcpy($$.data_type, say(string((char*)($1).lexeme)).c_str() ); }
    | NUMBER  { strcpy($$.type, $1.lexeme);}
    | NONE  { strcpy($$.type, $1.lexeme); }
    | STRING  { strcpy($$.type, $1.lexeme); }
    | BOOL { strcpy($$.type, $1.lexeme); }
    | SELF %prec low  { strcpy($$.type, $1.lexeme); }
    ;
lines172: yield_expr { $$.node_id= $1.node_id;}
        | testlist_comp { $$.node_id= $1.node_id;}
        | epsilon  { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
lines173: listmaker {$$.cnt = $1.cnt; strcpy($$.data_type,$1.data_type); }
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
lines174: dictorsetmaker { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
listmaker: test line151 { $$.cnt= $2.cnt+1; type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type);  }
         ;
line151: list_for { $$.node_id= $1.node_id;}
       | lines57 { $$.node_id= $1.node_id;}
       | COM_test lines57 { $$.cnt = $1.cnt; strcpy($$.data_type,$2.data_type); }
       ;
testlist_comp: test line153 { $$.node_id=dfn;  create_node("","testlist_comp",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
             ;
line153: comp_for { $$.node_id= $1.node_id;}
       | lines57 { $$.node_id= $1.node_id;}
       | COM_test lines57 { $$.node_id=dfn;  create_node("","line153",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       ;
trailer: LP lines183 RP %prec high { 
                $$.abc = $2.abc;
                strcpy($$.type,$1.lexeme);
        }
       | LB subscriptlist RB {  $$.node_id = 2 + dfn;  create_node("", "trailer" , $$.node_id );  create_node("[", "LB" , 1 + dfn );  create_node("]", "RB" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
       | FS NAME {  
        string temppp="."+(string((char*)($2).lexeme));
        strcpy($$.type,temppp.c_str());
       }
       ;
lines183: arglist { $$.abc= $1.abc;  /* for(int i=0;i<(*($1.abc)).size();i++) cout << (*($1.abc))[i]<< endl; */  }
        | epsilon { $$.abc =new vector<string>();}
        ;
subscriptlist: subscript line158 {}
             ;
line158: COM_subscript lines57 { $$.node_id=dfn;  create_node("","line158",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | lines57 { $$.node_id= $1.node_id;}
       ;
COM_subscript: COM subscript COM_subscript %prec high { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","COM_subscript",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             | COM subscript %prec low { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","COM_subscript",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             ;
subscript: FS FS FS {  $$.node_id = 3 + dfn;  create_node("", "subscript" , $$.node_id );  create_node(".", "FS" , 2 + dfn );  create_node(".", "FS" , 1 + dfn );  create_node(".", "FS" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, 0 + dfn } , $$.node_id );  dfn += 4; }
         | test {list_size++;}
         | lines189 COL lines189 lines190 {  $$.node_id = 1 + dfn;  create_node("", "subscript" , $$.node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn, $3.node_id, $4.node_id } , $$.node_id );  dfn += 2; }
         ;
sliceop: COL lines189 { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","sliceop",$$.node_id);create_node(":","COL",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
       ;
lines189: test { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
lines190: sliceop { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
exprlist: expr line163 { $$.node_id=dfn;  create_node("","exprlist",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        ;
line163 : COM_expr lines57 { $$.node_id=dfn;  create_node("","line163",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        | lines57 { $$.node_id= $1.node_id;}
        ;
COM_expr: COM expr COM_expr %prec high { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","COM_expr",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        | COM expr %prec low { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","COM_expr",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        ;
testlist: test line166 { $$.node_id=dfn;  create_node("","testlist",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        ;
line166: COM_test lines57 { $$.node_id=dfn;  create_node("","line166",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | lines57 { $$.node_id= $1.node_id;}
       ;
COM_test: COM test %prec low { $$.cnt = 1; strcpy($$.data_type,$2.data_type); }
        | COM test COM_test %prec high {$$.cnt = $3.cnt+1; type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type);}
        ;
dictorsetmaker:  test COL test line169 {  $$.node_id = 1 + dfn;  create_node("", "dictorsetmaker" , $$.node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn, $3.node_id, $4.node_id } , $$.node_id );  dfn += 2; }
              | test line170  { $$.node_id=dfn;  create_node("","dictorsetmaker",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
              ;
line169: comp_for { $$.node_id= $1.node_id;}
       | COM_test_COL_test lines57  { $$.node_id=dfn;  create_node("","line169",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | lines57 { $$.node_id= $1.node_id;}
       ;
line170: comp_for { $$.node_id= $1.node_id;}
       | COM_test lines57 { $$.node_id=dfn;  create_node("","line170",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | lines57 { $$.node_id= $1.node_id;}
       ;
COM_test_COL_test: COM test COL test COM_test_COL_test %prec high {  $$.node_id = 2 + dfn;  create_node("", "COM_test_COL_test" , $$.node_id );  create_node(",", "COM" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id, $5.node_id } , $$.node_id );  dfn += 3; }
                 | COM test COL test %prec low {  $$.node_id = 2 + dfn;  create_node("", "COM_test_COL_test" , $$.node_id );  create_node(",", "COM" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id } , $$.node_id );  dfn += 3; }
                 ;
classdef: CLASS NAME lines202 COL  { 
                /*  normal class */
                // first add into present scope and 
                string class_name=string((char*)($2).lexeme);
                curr_table->insert(string((char*)($2).lexeme), "Class", string((char*)($2).lexeme) , offset, curr_scope, yylineno, -1);
                tables.push(curr_table);
                scope_names.push(curr_scope);
                offsets.push(offset);
                class_name_present= string((char*)($2).lexeme);

                curr_table= new Sym_Table(curr_table);
                list_of_Symbol_Tables.push_back(curr_table);
                string new_scope="Class_"+string((char*)($2.lexeme));
                curr_scope=new_scope;
                offset=0;
                // map<string,Sym_Table*> class_name_map;
                class_name_map[class_name]=curr_table;
 }
         suite
        {
                // cout<<"1386 --> ";
                // printKeys(curr_table->class_func_args);
                string inherited=string((char*)($3).type);
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
        ;
lines202: LP NAME RP { strcpy($$.type, $2.lexeme); }
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
arglist: argument_COM line175 {$1.abc->push_back(string((char*)($2).type));$$.abc = $1.abc; }
       | line175  {$$.abc =new vector<string>(); string temp=string((char*)($1).type); $$.abc->push_back(temp); }
       ;
line175: argument lines57 { strcpy($$.type, $1.type);}
       ;
argument_COM: argument_COM argument COM  { $1.abc->push_back(string((char*)($2).type));
                                $$.abc = $1.abc;

                         }
            | argument COM %prec low {
                $$.abc =new vector<string>(); $$.abc->push_back(string((char*)($1).type));
            }
            ;
argument: test lines209 { strcpy($$.type, $1.type);}
        | test EQ test {  $$.node_id = 1 + dfn;  create_node("", "argument" , $$.node_id );  create_node("=", "EQ" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 2; }
        ;
lines209: comp_for { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
list_iter: list_for { $$.node_id= $1.node_id;}
         | list_if { $$.node_id= $1.node_id;}
         ;
list_for: FOR exprlist IN testlist_safe lines214 {  $$.node_id = 2 + dfn;  create_node("", "list_for" , $$.node_id );  create_node("for", "FOR" , 1 + dfn );  create_node("in", "IN" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id, $5.node_id } , $$.node_id );  dfn += 3; }
        ;
list_if: IF old_test lines214 {  $$.node_id = 1 + dfn;  create_node("", "list_if" , $$.node_id );  create_node("if", "IF" , 0 + dfn );  create_edge( { 0 + dfn, $2.node_id, $3.node_id } , $$.node_id );  dfn += 2; }
       ;
lines214: list_iter { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
comp_iter: comp_for { $$.node_id= $1.node_id;}
         | comp_if { $$.node_id= $1.node_id;}
comp_for: FOR exprlist IN or_test lines219 {  $$.node_id = 2 + dfn;  create_node("", "comp_for" , $$.node_id );  create_node("for", "FOR" , 1 + dfn );  create_node("in", "IN" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id, $5.node_id } , $$.node_id );  dfn += 3; }
        ;
comp_if: IF old_test lines219 {  $$.node_id = 1 + dfn;  create_node("", "comp_if" , $$.node_id );  create_node("if", "IF" , 0 + dfn );  create_edge( { 0 + dfn, $2.node_id, $3.node_id } , $$.node_id );  dfn += 2; }
       ;
lines219: comp_iter { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
testlist1: test { $$.node_id= $1.node_id;}
         | test COM_test {  $$.node_id = 0 + dfn;  create_node("", "testlist1" , $$.node_id );  create_edge( { $1.node_id, $2.node_id } , $$.node_id );  dfn += 1; }
         ;
yield_expr: YIELD lines84 {  $$.node_id = 1 + dfn;  create_node("", "yield_expr" , $$.node_id );  create_node("yield", "YIELD" , 0 + dfn );  create_edge( { 0 + dfn, $2.node_id } , $$.node_id );  dfn += 2; }
          ;
%%

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
