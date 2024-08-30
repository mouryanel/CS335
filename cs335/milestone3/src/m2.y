%{
#include <bits/stdc++.h>
#include<fstream>
using namespace std;

// global variables declaration, used in grammar in
int nelem=0; // used for number of elements in function arguments list
 
#define YYERROR_VERBOSE 1

int cls=0;
map<int, string> node_names;

int sym_counts=0;
int temporaries_counter=1;

map<string, int> listcnt;

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




// 3 ac global variables 
vector<string> output; /* 3ac code each line is stored as strings in vector */
vector<string> list_elements;
map<string,string> func_ret_type;
vector<string> func_ac3_list;
vector<pair<string,string>> func_decl_nametoac3;
stack<int> counter_elif;
stack<int> counter_break;
stack<int> counter_continue;
int repeat_line=-1;
int Is_class=0;
int Is_inherited=0;
int Is_because_of_print=0;
vector<string> print_ac3_list;
vector<string> print_type_list;
string current_class;
string current_parent;
int Is_array = 0;

int Is_Id(string s)
{
    if (s[0] == '@')
        return true;
    for (int i = 0; i < s.size(); i++)
    {
        if (!isalnum(s[i]) && s[i] != '_')
            return false;
    }
    if ((s[0] >= '0' && s[0] <= '9'))
        return false;
    return true;
}



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
        if((a=="int" && b=="float") || (b=="int" && a=="float") || (a=="int" && b=="list[int]") || (b=="int" && a=="list[int]") || (a=="float" && b=="list[int]") || (b=="float" && a=="list[int]") || (a=="float" && b=="list[float]") || (b=="float" && a=="list[float]")) return;
        if(a!=b && isSubstringPresent(a,b)==false && isSubstringPresent(b,a)==false)
        {
                cout<<"1Error : type conversion of "<< a <<" to " << b <<" at line number : "<<yylineno<<endl;
                exit(0);
        }

        if(a=="" || b=="" || (a==b)) return ;
        cout<<"2Error : type conversion of "<< a <<" to " << b <<" at line number : "<<yylineno<<endl;
        exit(0);  
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
                // cout<<" Error: Use of undeclared variable "<<lexi<<"\n";
                // exit(0);
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
        } 

        // cout<<"Error: Use of undeclared variable end"<<"\n";
        //         exit(0);
        
        return "";
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

void place(int line__no,int l){
        for(int i=output.size()-1;i>=0;i--)
        {
                if(l<=0) return ;
                if((output[i].size() >= 3 && output[i].substr(output[i].size() - 3) == "XXX"))
                {
                        output[i].pop_back();output[i].pop_back();output[i].pop_back();
                        output[i]+=to_string(line__no);
                        l--;
                        repeat_line=i;
                }
        }
        return ;
}
void place_break(int line__no,int l){
        for(int i=output.size()-1;i>=0;i--)
        {
                if(l<=0) return ;
                if((output[i].size() >= 3 && output[i].substr(output[i].size() - 3) == "XXB"))
                {
                        output[i].pop_back();output[i].pop_back();output[i].pop_back();
                        output[i]+=to_string(line__no);
                        l--;
                }
        }
        return ;
}
void place_continue(int line__no,int l){
        for(int i=output.size()-1;i>=0;i--)
        {
                if(l<=0) return ;
                if((output[i].size() >= 3 && output[i].substr(output[i].size() - 3) == "XXC"))
                {
                        output[i].pop_back();output[i].pop_back();output[i].pop_back();
                        output[i]+=to_string(line__no);
                        l--;
                }
        }
        return ;
}

void List_AC3(int l,string array){
        string var1;
        vector<string> needed;
        // output.push_back(var1+" = "+array);
        string temp;
        for(int i=0;i<l;i++)
        {
                // cout<<array<<"["<<i<<"]="<<list_elements.back()<<"\n";
                // string temp=var1+" = "+var1+" + 4";
                // output.push_back(temp);
                var1=("@t"+to_string(temporaries_counter++));
                temp=var1+"  = "+list_elements.back();
                needed.push_back(var1);
                output.push_back(temp);
                list_elements.pop_back();
        }
        var1=("@t"+to_string(temporaries_counter++));
        temp=var1+"  = "+to_string((l+1)*8);
        output.push_back(temp);
        output.push_back("param "+var1);
        output.push_back("stackpointer +8");
        output.push_back("call get_list ,1");
        output.push_back("stackpointer -8");

        var1=("@t"+to_string(temporaries_counter++));
        temp=var1+"  = popparameter";
        output.push_back(temp);


        string var2=("@t"+to_string(temporaries_counter++));
        temp=var2+"  = "+var1;
        output.push_back(temp);
        

        output.push_back("*("+var2+") = " +to_string(l));
        output.push_back(var2+" = "+var2+" + 8 ");
        for(int i=0;i<needed.size();i++)
        {
                output.push_back("*("+var2+") = " +needed[i]);
                output.push_back(var2+" = "+var2+" + 8 ");
        }

        output.push_back(array+" = "+var1);

}

string helper_func(string inp,string rem,string place){
        for(int i=0;i<inp.size();i++)
        {
                for(int j=i;j<inp.size();j++)
                {
                        string substring = inp.substr(i, j-i+1);
                        if( (i==0 || !((inp[i-1]>='a' && inp[i-1]<='z') || (inp[i-1]>='A' && inp[i-1]<='Z') ) )
                         && (substring==rem)
                         && (j==inp.size()-1 || !((inp[j+1]>='a' && inp[j+1]<='z') || (inp[j+1]>='A' && inp[j+1]<='Z') ) )
                         )
                        {
                                inp.replace(i, j-i+1, place);
                        }
                }
        }
        return inp;
}

void replace_name_3ac(){
        // func_decl_nametoac3
        int func_ind=-1;
        for(int i=0;i<func_decl_nametoac3.size();i++)
        {
                if(func_decl_nametoac3[i].first=="self") continue;
                for(int j=output.size()-1;j>=0;j--)
                {
                        if(output[j]=="funcbegin") 
                        {
                                func_ind=j;
                                break;
                        }
                        output[j]=helper_func(output[j],func_decl_nametoac3[i].first,func_decl_nametoac3[i].second);
                }
        }



        for(int i=0;i<func_decl_nametoac3.size();i++)
        {
                for(int j=func_ind+1;j<output.size();j++)
                {
                        string temp=output[j];
                        output[j]=helper_func(output[j],func_decl_nametoac3[i].second,func_decl_nametoac3[i].first);

                        if(temp!=output[j]) {
                                
                                if(func_decl_nametoac3[i].first!="self") output.insert(output.begin()+j+1,'`'+func_decl_nametoac3[i].second+" = "+func_decl_nametoac3[i].first);
                                break;
                        }
                }
        }

        func_decl_nametoac3.clear();
}

string remove_last_brace(string s){
        string ans;
        for(int i=0;i<s.size()-1;i++) ans.push_back(s[i]);
        return ans;
}



%}

%locations

/* %define parse.error detailed */
%define parse.trace true

%define parse.error custom


%union {
  struct{
        int node_id;
        int jps; // count varibale for number of (if -- else if) 's
        int Isobj;
        char ac3[1000];
        char lexeme[1000]; // storing lexemes for non terminals
        int cnt; /* size of list */
        int size; /* data size  */
        int ndim;
        char a1[1000],a2[1000],a3[1000];
        int nelem; /* storing number of parameters in function */
        // char* argstring;
        // char* arrtype;
        vector<string>* abc;
        char type[1000]; // storing lexemes for non terminals
        char data_type[1000]; // storing data types
        // char* tempvar;
  }attr;

}

%token <attr> BOOL UNKNOWN LEN NUMBER LIST RANGE SELF ARROW NONE PRIMITIVES NEWLINE STRING ENDMARKER NAME INDENT DEDENT AT RB LB RP LP LF RF DEF SCOL COL EQ SS COM PE ME SE DE MODE ANDE BOE BXE BX BO BA LSE RSE SSE FFE PRINT RS DEL BREAK CONTINUE RETURN RAISE FROM AS GLOBAL EXEC IN ASSERT IF ELIF WHILE ELSE FOR TRY FINALLY WITH EXCEPT OR AND NOT LT GT EE LE GE NE LG NI IS INOT PLUS MINUS STAR DIV MOD FF NEG BT FS LS CLASS YIELD


%start start ;
%precedence lower
%precedence low
%precedence high   
%precedence UNKNOWN LIST RANGE LEN SELF ARROW NONE PRIMITIVES NUMBER NEWLINE STRING ENDMARKER NAME INDENT DEDENT AT RB LB RP LP LF RF DEF SCOL COL EQ SS COM PE ME SE DE MODE ANDE BOE BXE BX BO BA LSE RSE SSE FFE PRINT RS DEL BREAK CONTINUE RETURN RAISE FROM AS GLOBAL EXEC IN ASSERT IF ELIF WHILE ELSE FOR TRY FINALLY WITH EXCEPT OR AND NOT LT GT EE LE GE NE LG NI IS INOT PLUS MINUS STAR DIV MOD FF NEG BT FS LS CLASS YIELD
%type <attr> print_terminal start primitives single_input file_input NEWstmt eval_input Nnew decorator line38 line41 decorated line40 decorators funcdef parameters fpdef fplist lines57 fpdefq range_func stmt simple_stmt line57 small_stmt expr_stmt line61 line62 EQ_yield_expr_testlist augassign print_stmt line67  lines74 line68 del_stmt flow_stmt break_stmt continue_stmt return_stmt lines84 yield_stmt raise_stmt lines87 lines88 lines89 dotted_name FS_NAME global_stmt COM_NAME exec_stmt lines110 assert_stmt prim prime declare_stmt compound_stmt if_stmt lines115 ELIF_test_COL_suite while_stmt for_stmt try_stmt line105 lines121 except_clause_COL_suite with_stmt line108 COM_with_item with_item lines127 except_clause lines129 lines130 line112 suite stmt_ testlist_safe lines135 COM_old_test old_test test lines142 or_test  and_test  not_test comparision  comp_op expr  xor_expr  and_expr  shift_expr  line137 arith_expr PLUSMINUS_term line140 term STARDIVMODFF_factor line143 factor line145 power atom_expr trailer_ atom lines172 lines173 lines174 listmaker line151 testlist_comp line153 trailer lines183 subscriptlist line158 COM_subscript subscript sliceop lines189 lines190 exprlist line163 COM_expr testlist  COM_test dictorsetmaker line169 line170 COM_test_COL_test classdef lines202 arglist line175 argument_COM argument lines209 list_iter list_for list_if lines214 comp_iter comp_for comp_if lines219 testlist1 yield_expr 
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
decorator: AT dotted_name line38 NEWLINE {  $$.node_id = 2 + dfn;  create_node("", "decorator" , $$.node_id );  create_node("@t", "AT" , 1 + dfn );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, $3.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
         | AT dotted_name NEWLINE {  $$.node_id = 2 + dfn;  create_node("", "decorator" , $$.node_id );  create_node("@t", "AT" , 1 + dfn );  create_node("", "NEWLINE" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
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

                func_ret_type[string((char*)($2).lexeme)]="Void";

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
                        output.push_back(string((char*)($2).lexeme)+" :");
                        output.push_back("funcbegin");
                        // func_decl_list[string((char*)($2).lexeme)]=funcparam;
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                string var_name= funcparam[i].first;
                                func_decl_list[string((char*)($2).lexeme)].push_back(var_type);
                                string var1=("@t"+to_string(temporaries_counter++));
                                output.push_back(var1+" = "+"popparamater");
                                func_decl_nametoac3.push_back({var_name,var1});
                                // cout<<"{"<<i<<" , "<<var1<<" , "<<var_name<<" } ";
                        }

                        // for(int i=0;i<func_decl_nametoac3.size();i++) output.push_back(func_decl_nametoac3[i].second+"="+func_decl_nametoac3[i].first);
                }
                else
                {
                        // cout<<"function: "<<$2.lexeme<<"\n";
                        // func_decl_list[string((char*)($2).lexeme)]=funcparam;
                        if( (string((char*)($2).lexeme) == "__init__") && Is_inherited==1)
                        {
                                output.push_back(current_class+"."+string((char*)($2).lexeme)+" : "+current_parent);
                                output.push_back("funcbegin");
                        }
                        else
                        {
                                output.push_back(current_class+"."+string((char*)($2).lexeme)+" :");
                                output.push_back("funcbegin");
                        }
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                string var_name= funcparam[i].first;
                                func_decl_list[string((char*)($2).lexeme)].push_back(var_type);
                                string var1=("@t"+to_string(temporaries_counter++));
                                output.push_back(var1+" = "+"popparamater");
                                func_decl_nametoac3.push_back({var_name,var1});
                                // cout<<"{"<<i<<" , "<<var1<<" , "<<var_name<<" } ";
                        }

                        // for(int i=1;i<func_decl_nametoac3.size();i++) output.push_back(func_decl_nametoac3[i].second+"="+func_decl_nametoac3[i].first);

                        // cout<<"\n";
                        // cout<<curr_table_<<" "<<string((char*)($2).lexeme)<<" "<<curr_table->class_func_args["__init__"].size()<<"\n";
                        // cout<<"\n";
                        // if(curr_table->class_func_args.find("__init__") != curr_table->class_func_args.end()) cout<<"here ";
                        // else cout<<"not here";
                }
                
                funcparam.clear();
} suite { 

                /* get back to previous scope*/ 
                output.push_back("funcend");
                // cout<<"size of repl: "<<func_decl_nametoac3.size()<<"\n";
                replace_name_3ac();
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
        func_ret_type[string((char*)($2).lexeme)]=string((char*)($5).type);
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
                // cout<<"\nstart func params : "<<$2.lexeme<<'\n';
                // for(int i=0;i<(int)(funcparam.size());i++)
                // {
                //         string var_type= funcparam[i].second.first;
                //         func_decl_list[string((char*)($2).lexeme)].push_back(var_type);

                //         // cout<<i<<" --> "<<var_type<<"\n";
                // }


                if(cls==0) 
                {
                        output.push_back(string((char*)($2).lexeme)+" :");
                        output.push_back("funcbegin");
                        // func_decl_list[string((char*)($2).lexeme)]=funcparam;
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                string var_name= funcparam[i].first;
                                func_decl_list[string((char*)($2).lexeme)].push_back(var_type);
                                string var1=("@t"+to_string(temporaries_counter++));
                                output.push_back(var1+" = "+"popparamater");
                                func_decl_nametoac3.push_back({var_name,var1});
                                // cout<<"{"<<i<<" , "<<var1<<" , "<<var_name<<" } ";
                        }
                        // for(int i=0;i<func_decl_nametoac3.size();i++) output.push_back(func_decl_nametoac3[i].second+"="+func_decl_nametoac3[i].first);

                }
                else
                {
                        // cout<<string((char*)($2).lexeme)<<"--> ";
                        if( (string((char*)($2).lexeme) == "__init__") && Is_inherited==1)
                        {
                                output.push_back(current_class+"."+string((char*)($2).lexeme)+" : "+current_parent);
                                output.push_back("funcbegin");
                        }
                        else
                        {
                                output.push_back(current_class+"."+string((char*)($2).lexeme)+" :");
                                output.push_back("funcbegin");
                        }
                        // func_decl_list[string((char*)($2).lexeme)]=funcparam;
                        for(int i=0;i<(int)(funcparam.size());i++)
                        {
                                string var_type= funcparam[i].second.first;
                                string var_name= funcparam[i].first;
                                func_decl_list[string((char*)($2).lexeme)].push_back(var_type);
                                string var1=("@t"+to_string(temporaries_counter++));
                                output.push_back(var1+" = "+"popparamater");
                                func_decl_nametoac3.push_back({var_name,var1});
                                // cout<<"{"<<i<<" , "<<var_type<<" , "<<var_name<<" } ";
                        }
                        // for(int i=1;i<func_decl_nametoac3.size();i++) output.push_back(func_decl_nametoac3[i].second+"="+func_decl_nametoac3[i].first);

                }
                funcparam.clear();
                
        }
        suite
        {
                output.push_back("funcend");
                // cout<<"size of repl: "<<func_decl_nametoac3.size()<<"\n";
                replace_name_3ac();
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
range_func: RANGE LP test RP { 
         $$.ndim = 1;
         strcpy($$.a1,$3.ac3);
        // $$.cnt=$3.type ; for(int i=0;i<$$.cnt;i++) $$.v.push_back(i); 
        }
          | RANGE LP test COM test RP { 
                $$.ndim = 2;
                strcpy($$.a1,$3.ac3);
                strcpy($$.a2,$5.ac3);
                // int a= $3.cnt;int b= $5.cnt;for(int i=a;i<b;i++) $$.v.push_back(i); 
                }
          | RANGE LP test COM test COM test RP { 
                $$.ndim = 3;
                strcpy($$.a1,$3.ac3);
                strcpy($$.a2,$5.ac3);
                strcpy($$.a3,$7.ac3);
                // int a= $3.cnt;int b= $5.cnt;for(int i=a;i<b;i+=$7.cnt) $$.v.push_back(i); 
                }
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
expr_stmt: testlist line62 %prec high {
                
                // func_ret_type[string((char*)($2).lexeme)]=string((char*)($5).type);
                // cout << $1.ac3 <<" =he " << $2.type;
                if(func_ret_type.find($2.ac3)!=func_ret_type.end())
                {
                        // func call 
                        // has some return type 
                        type_check_func(say(string((char*)($1).type)),func_ret_type[$2.ac3]);
                        string var1=("@t"+to_string(temporaries_counter++));
                        output.push_back(var1+" = popparam");
                        string temp=string((char*)($1).ac3)+" = "+var1;
                        output.push_back(temp);
                }
                else
                {
                        $1.cnt = $2.cnt; 
                        listcnt[string((char*)($1).ac3)] = $2.cnt;
                        // cout << $1.ac3 <<" = ok  " << $2.type<<" ok "<<($2).ac3<<" .. ";
                        string temp=string((char*)($1).ac3)+" = "+string((char*)($2).ac3);
                        output.push_back(temp);
                }
           }
         | testlist %prec low { $$.node_id = $1.node_id;}
         ;
line61: yield_expr { $$.node_id = $1.node_id;}
      | testlist {
                strcpy($$.ac3, $1.ac3);
                strcpy($$.type, $1.type); 
                $$.node_id = $1.node_id;
}
      ;
line62: augassign line61 { $$.node_id=dfn;  create_node("","line62",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
      | EQ_yield_expr_testlist { 

                $$.cnt = $1.cnt;
                strcpy($$.ac3, $1.ac3); 
                strcpy($$.type, $1.type); 
                $$.node_id = $1.node_id;
        }
      ;
EQ_yield_expr_testlist: EQ line61 { 
                // cout<<"check1"<<" "<<$2.ac3<<"\n";
                                $$.cnt = $2.cnt; 
                                strcpy($$.ac3, $2.ac3); 
                                strcpy($$.type, $2.type); 
}
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
print_stmt: print_terminal line67 {
       for(int i=0;i<$2.cnt;i++) 
        {
                if(!(Is_Id(print_ac3_list[print_ac3_list.size()-1-i])))
                {
                       string var1=("@t"+to_string(temporaries_counter++));
                       output.push_back(var1+" = "+print_ac3_list[print_ac3_list.size()-1-i]);  
                       print_ac3_list[print_ac3_list.size()-1-i]=var1;
                }
        }
        for(int i=0;i<$2.cnt;i++) 
        {
               // cout<<print_ac3_list[print_ac3_list.size()-1-i]<<" , ";
                string temp="param "+print_ac3_list[print_ac3_list.size()-1-i];
                output.push_back(temp);
                output.push_back("stackpointer +8");
                // cout<<print_type_list[print_type_list.size()-1-i]<<"\n";
                if(print_type_list[print_type_list.size()-1-i] =="int" || print_type_list[print_type_list.size()-1-i] =="list[int]") temp="call print_int , 1";
                if(print_type_list[print_type_list.size()-1-i] =="bool")  temp="call print_bool , 1";
                if(print_type_list[print_type_list.size()-1-i] =="str")  temp="call print_str , 1";
                output.push_back(temp);
                output.push_back("stackpointer -8");
        }
        Is_because_of_print=0;
        }
        ;
print_terminal: PRINT {Is_because_of_print=1;}

line67: lines74 { $$.cnt = $1.cnt; $$.node_id= $1.node_id;}
      ;
lines74: test line68 { $$.cnt = $1.cnt;}
       | epsilon { $$.cnt = 0;$$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
       ;
// lines75: COM_test lines57 { $$.node_id=dfn;  create_node("","lines75",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
//        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
//        ;
line68: COM_test lines57 { $$.cnt = $1.cnt;$$.node_id=dfn;  create_node("","lines68",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
      | lines57 { $$.cnt =0;$$.node_id= $1.node_id;}
      ;
del_stmt: DEL exprlist { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","del_stmt",$$.node_id);create_node("del","DEL",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        ;
flow_stmt: break_stmt { $$.node_id= $1.node_id;}
         | continue_stmt { $$.node_id= $1.node_id;}
         | return_stmt { $$.node_id= $1.node_id;}
         | raise_stmt { $$.node_id= $1.node_id;}
         | yield_stmt { $$.node_id= $1.node_id;}
         ;
break_stmt: BREAK { 
        // cout<<"came\n";
        counter_break.top()++;
        string temp="jump line XXB";
        output.push_back(temp);
}
          ;
continue_stmt: CONTINUE { 
        counter_continue.top()++;
        string temp="jump line XXC";
        output.push_back(temp);
}
             ;
return_stmt: RETURN lines84 { 
}
        ;
lines84: testlist { output.push_back("return "+string((char*)($1).ac3)); }
       | epsilon { output.push_back("return ");}
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
                // cout<<"\nmourya\n";
                listcnt[string((char*)($1).ac3)]= $5.cnt;
                string test_str= string((char*)($5).type);
                string var_type= string((char*)($3).type);
                string var_name= string((char*)($1).type);
                if(func_ret_type.find($5.ac3)!=func_ret_type.end())
                {
                        // func call 
                        // has some return type 
                        // cout<<"came: "<<say(string((char*)($3).type))<<"\n";
                        type_check_func(string((char*)($3).type),func_ret_type[$5.ac3]);
                        string var1=("@t"+to_string(temporaries_counter++));
                        output.push_back(var1+" = popparam");
                        string temp=string((char*)($1).ac3)+" = "+var1;
                        output.push_back(temp);
                }
                else{
                        
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
                                        /* this is self created a variable so add it in parent class */
                                        Sym_Table* temp_parent_table=tables.top();
                                        int temp_parent_offset=offsets.top();
                                        offsets.pop();/* only parents offset is needed to change in stack */
                                        string temp_parent_scope=scope_names.top();
                                        if(var_type[0]=='l')
                                        {
                                                // list[int bool str float]
                                                type_check_func(In_BTW_BOXES(string((char*)($3).type)),string((char*)($5).ac3));
                                                int list_count=$5.cnt;
                                                List_AC3(list_count,string((char*)($1).type));
                                                temp_parent_table->insert(substring_after_dot(((char*)($1).type)), "PRIMITIVES", string((char*)($3).type), temp_parent_offset, temp_parent_scope, yylineno-1, list_count );

                                                if(var_type[5]=='i' || var_type[5]=='f' ) temp_parent_offset+=list_count*(4);
                                                else if(var_type[5]=='b' ) temp_parent_offset+=list_count*(1);
                                        }
                                        else if(var_type[0]=='s')
                                        {
                                                // str
                                                string temp=(string((char*)($1).type))+" = "+(string((char*)($5).ac3));
                                                output.push_back(temp);
                                                type_check_func(string((char*)($3).type),string((char*)($5).data_type));
                                                int string_count=$5.cnt;
                                                temp_parent_table->insert(substring_after_dot(string((char*)($1).type)), "PRIMITIVES", string((char*)($3).type), temp_parent_offset, temp_parent_scope, yylineno-1, string_count);
                                                temp_parent_offset+=string_count*(1);
                                        }
                                        else
                                        {
                                                // cout<<"1168 line\n";
                                                // int , bool, float
                                                string temp=(string((char*)($1).type))+" = "+(string((char*)($5).ac3));
                                                output.push_back(temp);
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
                                        List_AC3(list_count,string((char*)($1).type));
                                        curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, list_count );

                                        if(var_type[5]=='i' || var_type[5]=='f' ) offset+=list_count*(4);
                                        else if(var_type[5]=='b' ) offset+=list_count*(1);
                                }
                                else if(var_type[0]=='s')
                                {
                                        // str
                                        string temp=(string((char*)($1).type))+" = "+(string((char*)($5).ac3));
                                        output.push_back(temp);
                                        type_check_func(string((char*)($3).type),string((char*)($5).data_type));
                                        int string_count=$5.cnt;
                                        curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, string_count );
                                        offset+=string_count*(1);
                                }
                                else
                                {
                                        // int , bool, float
                                        // cout<<"1205 line\n";
                                        string temp=(string((char*)($1).type))+" = "+(string((char*)($5).ac3));
                                        output.push_back(temp);
                                        type_check_func(string((char*)($3).type),string((char*)($5).data_type));
                                        curr_table->insert(string((char*)($1).type), "PRIMITIVES", string((char*)($3).type), offset, curr_scope, yylineno-1, -1 );
                                        if(var_type[0]=='i' || var_type[0]=='f' ) offset+=(4);
                                        else if(var_type[0]=='b' ) offset+=(1);
                                }

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

// modified grammar 
// if_stmt: IF expr_stmt COL { 
//         /*
//         l1: if var jump line l3 
//         l2: jump line xxx
//         */ 
//         counter_elif=0;
//         string temp="if "+string((char*)($2).ac3)+" jump line "+to_string(output.size()+3);
//         output.push_back(temp);
//         temp="jump line XXX"; /* need to update after finding false block */
//         output.push_back(temp); 
//         }
//         suite {
//         /*
//         l1: jump line (get out of this scope) 
//         l2: else if block starts here
//         */ 
//         place(output.size()+2,1);
//         string temp="jump line XXX"; /* need to update after finding right line number to get out */ 
//         output.push_back(temp);
//         }
//         ELIF_test_COL_suite lines115  { 
//         // cout<<"here 1048 "<<" "<<$1.jps<<" "<<$2.jps<<" "<<$3.jps<<" "<<$5.jps<<" "<<$7.jps<<"\n";
//         place(output.size()+1,counter_elif+1); 
//         // cout<<"here -->number of elif blocks"<<counter_elif<<"\n";

//         }
//        | IF expr_stmt COL { 
//         /*
//         l1: if var jump line l3 
//         l2: jump line xxx
//         */ 
//         counter_elif=0;
//         string temp="if "+string((char*)($2).ac3)+" jump line "+to_string(output.size()+3);
//         output.push_back(temp);
//         temp="jump line XXX"; /* need to update after finding false block */
//         output.push_back(temp); 
// }
//         suite {

//         place(output.size()+2,1);
//         string temp="jump line XXX"; /* need to update after finding right line number to get out */ 
//         output.push_back(temp);

// }
//         lines115 {
//         cout<<"here===";
//         place(output.size()+1,1); 

// }     
//        ;

if_stmt: IF expr_stmt COL { 
        /*
        l1: if var jump line l3 
        l2: jump line xxx
        */ 
        // cout<<"ochake error: "<<'\n';
        // if()
        counter_elif.push(0);
        string temp="if "+string((char*)($2).ac3)+" jump line "+to_string(output.size()+3);
        output.push_back(temp);
        temp="jump line XXX"; /* need to update after finding false block */ 
        output.push_back(temp);
}
        suite {
                /*
                l1: jump line (get out of this scope) 
                l2: else if block starts here
                */ 
                place(output.size()+2,1);
                string temp="jump line XXX"; /* need to update after finding right line number to get out */ 
                output.push_back(temp);
        }
        new_nonterminal;



new_nonterminal : ELIF_test_COL_suite lines115 %prec high  {  place(output.size()+1,counter_elif.top()+1);  counter_elif.pop(); }
        | lines115 %prec low { place(output.size()+1,counter_elif.top()+1); counter_elif.pop(); }
       ;  
lines115: ELSE COL suite {  } %prec high
        | epsilon {  } %prec low
        ;
ELIF_test_COL_suite: ELIF_test_COL_suite ELIF expr_stmt COL {

        $<attr>$.jps=$1.jps+1;
        // counter_elif++;
        counter_elif.top()++;
        string temp="if "+string((char*)($2).ac3)+" jump line "+to_string(output.size()+3);
        output.push_back(temp);
        temp="jump line XXX"; /* need to update after finding false block */ 
        output.push_back(temp);
} 

        suite {
      
        place(output.size()+2,1);
        string temp="jump line XXX"; /* need to update after finding right line number to get out */ 
        output.push_back(temp);

}       %prec high

        | ELIF expr_stmt COL { 
        
        $<attr>$.jps=1; 
        counter_elif.top()++;
        string temp="if "+string((char*)($2).ac3)+" jump line "+to_string(output.size()+3);
        output.push_back(temp);
        temp="jump line XXX"; /* need to update after finding false block */ 
        output.push_back(temp);     
}
        suite {

        place(output.size()+2,1);
        string temp="jump line XXX"; /* need to update after finding right line number to get out */ 
        output.push_back(temp);

}       %prec low
        ;

// if_stmt: IF expr_stmt COL suite ELIF_test_COL_suite lines115 
//        | IF expr_stmt COL suite lines115
//        ;
// lines115: ELSE COL suite 
//         | epsilon 
//         ;
// ELIF_test_COL_suite: ELIF_test_COL_suite   ELIF expr_stmt COL suite 
//                    | ELIF expr_stmt COL suite
//                    ;

while_stmt: WHILE expr_stmt COL { 
        /*
        l1: if var jump line l3 
        l2: jump line xxx
        */ 
        counter_break.push(0);counter_continue.push(0);
        string temp="if "+string((char*)($2).ac3)+" jump line "+to_string(output.size()+3);
        output.push_back(temp);
        temp="jump line XXX"; /* need to update after finding false block */ 
        output.push_back(temp);
}       suite{

        place_break(output.size()+2,counter_break.top());
        counter_break.pop(); 
        place(output.size()+2,1);  /* get out of loop */
        assert(repeat_line!=-1);
        string temp="jump line "+to_string(repeat_line-1); /* need to update after finding right line number to get out */ 
        output.push_back(temp);
        place_continue(output.size(),counter_continue.top());
        counter_continue.pop();
}
 lines115 
          ;
for_stmt: FOR exprlist IN testlist COL  {
                counter_break.push(0);counter_continue.push(0);
                string var1=("@t"+to_string(temporaries_counter++));
                string tt= var1+" = 0"; 
                output.push_back(tt);
                string var2=("@t"+to_string(temporaries_counter++));
                tt= var2+" = "+var1+" < "+to_string(listcnt[string((char*)($4).ac3)]); 
                output.push_back(tt);

                // strcpy($$.ac3, ("t"+to_string(temporaries_counter++)).c_str());
                string temp="if "+var2+" jump line "+to_string(output.size()+3);
                output.push_back(temp);
                temp="jump line XXX"; /* need to update after finding false block */ 
                output.push_back(temp);
                string var4 = ("@t"+to_string(temporaries_counter++));
                temp = var4 + " = "+ string((char*)($4).ac3) +"["+  var1+ "]";
                output.push_back(temp);
                temp = string((char*)($2).ac3) + " = " + var4 ;
                output.push_back(temp);
                string var3=("@t"+to_string(temporaries_counter++));
                temp=var3+" = "+var1+ " + 1 ";
                output.push_back(temp);
                temp=var1+" = "+var3;
                output.push_back(temp);
        }
        suite{
                place_break(output.size()+2,counter_break.top());
                counter_break.pop(); 
                place(output.size()+2,1);  /* get out of loop */
                assert(repeat_line!=-1);
                string temp="jump line "+to_string(repeat_line-1); /* need to update after finding right line number to get out */ 
                output.push_back(temp);
                place_continue(output.size(),counter_continue.top());
                counter_continue.pop();
}
          lines115 
        | FOR exprlist IN range_func COL {
                counter_break.push(0);counter_continue.push(0);
                string var1=("@t"+to_string(temporaries_counter++));
                string tt;
                if($4.ndim == 1) tt= var1+" = 0"; 
                else tt= var1+" = "+string((char*)($4).a1);
                output.push_back(tt);
                string var2=("@t"+to_string(temporaries_counter++));
                if($4.ndim == 1) tt= var2+" = "+var1+" < "+string((char*)($4).a1); 
                else tt= var2+" = "+var1+" < "+string((char*)($4).a2);
                output.push_back(tt);

                // strcpy($$.ac3, ("t"+to_string(temporaries_counter++)).c_str());
                string temp="if "+var2+" jump line "+to_string(output.size()+3);
                output.push_back(temp);
                temp="jump line XXX"; /* need to update after finding false block */ 
                output.push_back(temp);
                temp = string((char*)($2).ac3) + " = " + var1 ;
                output.push_back(temp);
                string var3=("@t"+to_string(temporaries_counter++));
                if($4.ndim == 3) temp=var3+" = "+var1+ " + "+string((char*)($4).a3);
                else temp=var3+" = "+var1+ " + 1 ";
                output.push_back(temp);
                temp=var1+" = "+var3;
                output.push_back(temp);
        }
        suite{
                place_break(output.size()+2,counter_break.top());
                counter_break.pop(); 
                place(output.size()+2,1);  /* get out of loop */
                assert(repeat_line!=-1);
                string temp="jump line "+to_string(repeat_line-1); /* need to update after finding right line number to get out */ 
                output.push_back(temp);
                place_continue(output.size(),counter_continue.top());
                counter_continue.pop();
}
          lines115 
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
old_test: or_test { $$.cnt = $1.cnt;strcpy($$.data_type,$1.data_type);strcpy($$.ac3, $1.ac3); strcpy($$.type, $1.type); }
        ;
test: or_test lines142 { 
        $$.cnt = $1.cnt; 
        // cout <<endl<< $$.cnt << endl;
        // cout <<endl << "length: "<<$$.cnt <<endl;
        strcpy($$.ac3, $1.ac3); 
        strcpy($$.data_type,$1.data_type);  
        strcpy($$.type, $1.type);

}
    ;
lines142: IF or_test ELSE test {  $$.node_id = 2 + dfn;  create_node("", "lines142" , $$.node_id );  create_node("if", "IF" , 1 + dfn );  create_node("else", "ELSE" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id } , $$.node_id );  dfn += 3; }
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
or_test: or_test OR and_test {  
        // type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type); 
        type_check_func(string((char*)($1).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$1.data_type);
        strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
        string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).lexeme)+" "+string((char*)($3).ac3);
        output.push_back(temp);
        // cout << $$.ac3 << " = " << $1.ac3 << " " << $2.lexeme << " " << $3.ac3 <<"\n";
}
       | and_test {
        $$.cnt = $1.cnt;
        strcpy($$.ac3, $1.ac3); 
         strcpy($$.data_type,$1.data_type); 
        strcpy($$.type, $1.type);

}
       ;
// OR_and_test: OR and_test OR_and_test {  type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
//            | OR and_test {   strcpy($$.data_type,$2.data_type); }
//            ;
and_test: and_test AND not_test {
        // type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type); 
        
        type_check_func(string((char*)($1).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$1.data_type);
        strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
        string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).lexeme)+" "+string((char*)($3).ac3);
        output.push_back(temp);
                // cout << $$.ac3 << " = " << $1.ac3 << " " << $2.lexeme << " " << $3.ac3 <<"\n";

}
        | not_test { 
        $$.cnt = $1.cnt;
        strcpy($$.ac3, $1.ac3);
        strcpy($$.data_type,$1.data_type);
        strcpy($$.type, $1.type);
}
        ;
// AND_not_test: AND not_test AND_not_test { type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
//             | AND not_test {  strcpy($$.data_type,$2.data_type); }
//             ;
not_test: NOT not_test %prec high {  strcpy($$.data_type,$2.data_type); 
        // type_check_func(string((char*)($1).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$1.data_type);
        strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
        string temp=string((char*)($$).ac3)+" = "+string((char*)($1).lexeme)+" "+string((char*)($2).ac3);
        output.push_back(temp);
                // cout << $$.ac3 << " = " << $1.lexeme <<" "<< $2.ac3 <<"\n";
        }
        | comparision { 
        $$.cnt = $1.cnt;
        strcpy($$.ac3, $1.ac3);
        strcpy($$.data_type,$1.data_type); 
        strcpy($$.type, $1.type);
}
        ;
comparision: comparision comp_op expr {
        // cout<<"\nochesa1519.."<<$1.type<<" "<<$$3.type<<"\n";
        string main_dunder=$3.type;
        // cout<<"Whats that : "<<main_dunder<<"\n";
        if( main_dunder == "\"__main__\"") 
        {
                // cout<<"dunder case:"<<"\n";
                strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
                string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).type)+" "+string((char*)($3).ac3);
                output.push_back(temp);
        }
        else
        {
                type_check_func(string((char*)($1).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$1.data_type);
                strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
                string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).type)+" "+string((char*)($3).ac3);
                output.push_back(temp);
                // cout << $$.ac3 << " = " << $1.ac3 << " " << $2.type << " " << $3.ac3 <<"\n";
        }

        
        }
        | expr { 
                $$.cnt = $1.cnt;
        strcpy($$.ac3, $1.ac3);
        strcpy($$.data_type,$1.data_type); 
        strcpy($$.type, $1.type);
}
          ;
// comp_op_expr: comp_op expr comp_op_expr { type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type); }
//             | comp_op expr {  $$.cnt = $1.cnt;  strcpy($$.data_type,$2.data_type); }
            ;
comp_op: LT { strcpy($$.type, $1.lexeme);   $$.node_id=dfn; $1.node_id=dfn; create_node("<","LT",$1.node_id);  dfn++;}
       | GT { strcpy($$.type, $1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node(">","GT",$1.node_id);  dfn++;}
       | EE { strcpy($$.type, $1.lexeme);  $$.node_id=dfn; $1.node_id=dfn; create_node("==","EE",$1.node_id);  dfn++;}
       | GE { strcpy($$.type, $1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node(">=","GE",$1.node_id);  dfn++;}
       | LE { strcpy($$.type, $1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node("<=","LE",$1.node_id);  dfn++;}
       | LG { strcpy($$.type, $1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node("<>","LG",$1.node_id);  dfn++;}
       | NE { strcpy($$.type, $1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node("!=","NE",$1.node_id);  dfn++;}
       | IN { strcpy($$.type, $1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node("in","IN",$1.node_id);  dfn++;}
       | NI { strcpy($$.type, $1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node("not in","NI",$1.node_id);  dfn++;}
       | IS { strcpy($$.type, $1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node("is","IS",$1.node_id);  dfn++;}
       | INOT { strcpy($$.type, $1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node("is not","INOT",$1.node_id);  dfn++;}
       ;
expr: expr BO xor_expr { 
        $$.cnt = $1.cnt;
        // type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type);  
        type_check_func(string((char*)($1).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$1.data_type);
        strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
        string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).lexeme)+" "+string((char*)($3).ac3);
        output.push_back(temp);
                // cout << $$.ac3 << " = " << $1.ac3 << " " << $2.lexeme << " " << $3.ac3 <<"\n";
        }
    | xor_expr { 
        $$.cnt = $1.cnt;
        strcpy($$.ac3, $1.ac3); 
        strcpy($$.data_type,$1.data_type); 
        strcpy($$.type, $1.type);
}
    ;
// BO_xor_expr: BO xor_expr BO_xor_expr {  type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type);  }
//            | BO xor_expr { strcpy($$.data_type,$2.data_type);  }
//            ;
xor_expr: xor_expr BX and_expr {  
        // type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type);
        type_check_func(string((char*)($1).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$1.data_type);
        strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
        string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).lexeme)+" "+string((char*)($3).ac3);
        output.push_back(temp);
                        // cout << $$.ac3 << " = " << $1.ac3 << " " << $2.lexeme << " " << $3.ac3 <<"\n";
 }
        | and_expr { 
                $$.cnt = $1.cnt;
        strcpy($$.ac3, $1.ac3); 
        strcpy($$.data_type,$1.data_type);
        strcpy($$.type, $1.type);
}
        ;
// BX_and_expr: BX and_expr BX_and_expr {   type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
//            | BX and_expr { strcpy($$.data_type,$2.data_type);  }
//            ;
and_expr: and_expr BA shift_expr { 
        $$.cnt = $1.cnt;
        // type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type);  
        type_check_func(string((char*)($1).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$1.data_type);
        strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
        string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).lexeme)+" "+string((char*)($3).ac3);
        output.push_back(temp);
        // cout << $$.ac3 << " = " << $1.ac3 << " " << $2.lexeme << " " << $3.ac3 <<"\n";
}
        | shift_expr { 
        $$.cnt = $1.cnt;
        strcpy($$.ac3, $1.ac3); 
        strcpy($$.data_type,$1.data_type);
        strcpy($$.type, $1.type);
}
        ;
// BA_shift_expr: shift_expr BA BA_shift_expr { type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
//              | BA shift_expr { strcpy($$.data_type,$2.data_type); }
//              ;
shift_expr: shift_expr line137 arith_expr  { 
        $$.cnt = $3.cnt;
        //  type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type); 
                type_check_func(string((char*)($1).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$1.data_type);
                strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
                string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).type)+" "+string((char*)($3).ac3);
                output.push_back(temp);
                // cout << $$.ac3 << " = " << $1.ac3 << " " << $2.type << " " << $3.ac3 <<"\n";
}
          | arith_expr { 
                $$.cnt = $1.cnt;
                // $$.ac3 = $1.ac3;
                strcpy($$.data_type,$1.data_type);
                strcpy($$.ac3, $1.ac3);
                strcpy($$.type, $1.type); 
}
          ;
// LSRS_arith_expr:  LSRS_arith_expr line137 arith_expr {  type_check_func(string((char*)($2).data_type),string((char*)($3).data_type)); strcpy($$.data_type,$2.data_type); }
//                | arith_expr { strcpy($$.data_type,$2.data_type);  }
               ;
line137: LS { strcpy($$.type,$1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node("<<","LS",$1.node_id);  dfn++; }
       | RS { strcpy($$.type,$1.lexeme); $$.node_id=dfn; $1.node_id=dfn; create_node(">>","RS",$1.node_id);  dfn++; }
       ;
arith_expr:  PLUSMINUS_term %prec high { 
        $$.cnt = $1.cnt;
        // type_check_func(string((char*)($1).data_type),string((char*)($2).data_type));
         strcpy($$.data_type,$1.data_type); strcpy($$.ac3, $1.ac3); strcpy($$.type, $1.type);
}
          ;
PLUSMINUS_term: PLUSMINUS_term line140 term  {
        $$.cnt = $1.cnt;
        type_check_func(string((char*)($1).data_type),say(string((char*)($3).type))); 
        // cout<<"hmmk "<<string((char*)($1).data_type)<<" "<<say(string((char*)($3).type))<<'\n';
        strcpy($$.data_type,$3.data_type);
        strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
        string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).type)+" "+string((char*)($3).ac3);
        output.push_back(temp);
        // cout << $$.ac3 << " = " << $1.ac3 << " " << $2.type << " " << $3.ac3 <<"\n";
}
        | term %prec low {$$.cnt = $1.cnt; strcpy($$.data_type,$1.data_type); strcpy($$.ac3, $1.ac3);strcpy($$.type, $1.type);  }
        ;
line140: PLUS %prec high {  strcpy($$.type,$1.lexeme);  }
       | MINUS {  strcpy($$.type,$1.lexeme);  }
       ;


term: STARDIVMODFF_factor  { 
        $$.cnt = $1.cnt;
        // type_check_func(string((char*)($1).data_type),string((char*)($2).data_type));
                                 
        // strcpy($$.ac3, ("t"+to_string(temporaries_counter++)).c_str());
        // cout <<$$.ac3 << " = " << $1.ac3 << " "<< $2.ac3 <<"\n";
        strcpy($$.data_type,$1.data_type);
        strcpy($$.type, $1.type);
        strcpy($$.ac3, $1.ac3);
}
    ;
STARDIVMODFF_factor: STARDIVMODFF_factor line143 factor  {
        $$.cnt = $1.cnt;

        type_check_func(string((char*)($1).data_type),say(string((char*)($3).type))); strcpy($$.data_type,$3.data_type);
        // create a new temp variable and then temp = $1.ac3 $2.type $3.ac3 
        strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
        string temp=string((char*)($$).ac3)+" = "+string((char*)($1).ac3)+" "+string((char*)($2).lexeme)+" "+string((char*)($3).ac3);
        output.push_back(temp);
        // cout << $$.ac3 << " = " << $1.ac3 << " " << $2.type << " " << $3.ac3 <<"\n";
                                                                
 }
        |  factor { 
                $$.cnt = $1.cnt;
        strcpy($$.data_type,$1.data_type);
        strcpy($$.ac3, $1.ac3);
        strcpy($$.type, $1.type);
        // strcpy($$.data_type,$2.data_type);
        // string temppp2=(string((char*)($2).type));
        // string temppp1=(string((char*)($1).type))+temppp2;
        // strcpy($$.type,temppp1.c_str()); 
}
        ;
line143: STAR  {  strcpy($$.type,$1.lexeme);   }
       | DIV {   strcpy($$.type,$1.lexeme);  }
       | MOD {  strcpy($$.type,$1.lexeme);  }
       | FF {  strcpy($$.type,$1.lexeme);  }
       ;
factor: line145 factor {  $$.cnt = $1.cnt;strcpy($$.data_type,$2.data_type);  

                strcpy($$.ac3, ("@t"+to_string(temporaries_counter++)).c_str());
                string temp=string((char*)($$).ac3)+" = "+string((char*)($1).type)+string((char*)($2).ac3);
                output.push_back(temp);
                strcpy($$.type,(string((char*)($1).type)+string((char*)($2).type)).c_str());
                // cout <<"here::: " << $$.ac3 << " = " << $1.type << $2.ac3 <<"\n";
                // string temppp2=(string((char*)($2).type));
                // string temppp1=(string((char*)($1).type))+temppp2;
                // strcpy($$.type,temppp1.c_str()); 
        }
      | power  { $$.cnt = $1.cnt; strcpy($$.type, $1.type); strcpy($$.data_type,$1.data_type); strcpy($$.ac3, $1.ac3);  }
      ;
line145: PLUS  { strcpy($$.type, $1.lexeme); }
       | MINUS { strcpy($$.type, $1.lexeme); }
       | NEG { strcpy($$.type, $1.lexeme); }
       ;
power: atom_expr {  $$.cnt = $1.cnt; strcpy($$.type, $1.type); strcpy($$.data_type, $1.data_type); strcpy($$.ac3, $1.ac3);  }
     | atom_expr SS factor { 
        $$.cnt = $1.cnt;
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
                // cout<<"ochidamma vayyari\n";
                // cout<<"meekosadsa .."<<(string((char*)($1).type))<<" ,..  "<<temppp1<<" .. "<<temppp2<<"\n";
                if(temppp2.size()>=1 && temppp2[0]=='.' )
                {
                        vector<string> temp;
                                vector<string> data_type_params;
                //        case: self.srname
                                if(temppp2.size()>=1 && temppp2[temppp2.size()-1]=='(' )
                                {
                                        string class_name=string((char*)($1).type);
                                        string func_name=solve1((char*)($2).type);
                                        // cout<<"object function calling case: ";
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
                                                        // cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: less arguments passed : at line number "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }
                                                if(vec.size() < data_type_params.size()) 
                                                {
                                                        // cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: More arguments passed : at line number "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }

                                                for(int i=0;i<vec.size();i++)
                                                {
                                                        type_check_func(vec[i],data_type_params[i]);
                                                }
                                                // output.push_back("param "+);
                                                vector<string> temp1703;
                                                for(int i=0;i<vec.size();i++) 
                                                {
                                                        temp1703.push_back(func_ac3_list.back());
                                                        func_ac3_list.pop_back();
                                                }
                                                for(int i=0;i<vec.size();i++)
                                                {
                                                        // cout<<"hehe "<<func_ac3_list.back()<<"\n";
                                                        output.push_back("param "+temp1703.back());
                                                        temp1703.pop_back();
                                                }
                                                output.push_back("stackpointer +xxx");
                                                output.push_back("call "+remove_last_brace(temppp1)+" , "+to_string(vec.size()));
                                                output.push_back("stackpointer -xxx");
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
                                                        // cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: less arguments passed : at line number "<<yylineno<<"\n";
                                                        exit(0);
                                                }
                                                if(vec.size() < data_type_params.size()) 
                                                {
                                                        // cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: More arguments passed : at line number "<<yylineno<<"\n";
                                                        exit(0);
                                                }

                                                for(int i=0;i<vec.size();i++)
                                                {
                                                      type_check_func(vec[i],data_type_params[i]);
                                                }
                                        }
                                }
                                else
                                {
                                        // cout<<"came here annamata: "<<temppp1<<"\n";
                                        strcpy($$.ac3,temppp1.c_str());
                                }
                }
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
                                                // cout<<"constructor call case :\n";
                                                /* constructor  */
                                                for(int i=0;i<(int)(*($2.abc)).size();i++)
                                                {
                                                        temp.push_back( (*($2.abc))[i] ); 
                                                        data_type_params.push_back(say(temp[i]));
                                                        // cout<<"herwe "<<temp[i]<<" "<<data_type_params[i]<<"\n";
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
                                                vector<string> temp1703;
                                                for(int i=0;i<vec.size();i++) 
                                                {
                                                        temp1703.push_back(func_ac3_list.back());
                                                        func_ac3_list.pop_back();
                                                }
                                                output.push_back("param &"+(string((char*)($1).type)));
                                                for(int i=0;i<vec.size();i++)
                                                {
                                                        // cout<<"hehe "<<func_ac3_list.back()<<"\n";
                                                        output.push_back("param "+temp1703.back());
                                                        temp1703.pop_back();
                                                }
                                                output.push_back("stackpointer +xxx");
                                                output.push_back("call "+string((char*)($1).type)+".__init__, "+to_string(vec.size()+1));
                                                output.push_back("stackpointer -xxx");
                                        }
                                        else
                                        {
                                                // cout<<"normal function --1\n";
                                                // cout<<"here came :size"<<(*($2.abc)).size()<<"\n";
                                                vector<string> func_temp_params;
                                                for(int i=0;i<(*($2.abc)).size();i++)
                                                {
                                                        temp.push_back( (*($2.abc))[i] ); 
                                                        data_type_params.push_back(say(temp[i]));
                                                        // cout<<"herwe "<<temp[i]<<" "<<data_type_params[i]<<"\n";
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
                                                string func_name=(string((char*)($1).type));
                                                // cout<<"kkkk"<<func_name<<"\n";
                                                if(func_name!="main" && func_name!="range") 
                                                {
                                                        // cout<<func_name<<" \n";
                                                        if(func_decl_list.find(func_name)==func_decl_list.end())
                                                        {
                                                                cout<<"Error: Undeclared function "<<func_name<<" at line no :"<<yylineno-1<<"\n";
                                                                exit(0);
                                                        }
                                                        vector<string> vec=func_decl_list[func_name];
                                                        // cout<<"definition size: "<<func_name<<" : "<<func_decl_list[func_name].size()<<"\n";
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

                                                        // error free so now add 3ac for normal function call 
                                                        // cout<<"bef: size: "<<func_ac3_list.size()<<"\n";
                                                        vector<string> temp1703;
                                                        for(int i=0;i<vec.size();i++) 
                                                        {
                                                                temp1703.push_back(func_ac3_list.back());
                                                                func_ac3_list.pop_back();
                                                        }
                                                        for(int i=0;i<vec.size();i++)
                                                        {
                                                                // cout<<"hehe "<<func_ac3_list.back()<<"\n";
                                                                output.push_back("param "+temp1703.back());
                                                                temp1703.pop_back();
                                                        }
                                                        output.push_back("stackpointer +xxx");
                                                        output.push_back("call "+string((char*)($1).type)+" , "+to_string(vec.size()));
                                                        output.push_back("stackpointer -xxx");
                                                }
                                                else
                                                {
                                                        // case: range or main 
                                                        // cout<<"***************\n"; 
                                                        output.push_back("stackpointer +xxx");
                                                        output.push_back("call main , 0 ");
                                                        output.push_back("stackpointer -xxx");
                                                }
                                        }

                                }
                                else if(temppp2.size()>=1 && temppp2[0]=='.')
                                {
                                        string class_name=string((char*)($1).type);
                                        string func_name=solve1((char*)($2).type);
                                        // cout<<"object function calling case: ";
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
                                                        // cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: less arguments passed : at line number "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }
                                                if(vec.size() < data_type_params.size()) 
                                                {
                                                        // cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: More arguments passed : at line number "<<yylineno-1<<"\n";
                                                        exit(0);
                                                }

                                                for(int i=0;i<vec.size();i++)
                                                {
                                                        type_check_func(vec[i],data_type_params[i]);
                                                }
                                                vector<string> temp1703;
                                                for(int i=0;i<vec.size();i++) 
                                                {
                                                        temp1703.push_back(func_ac3_list.back());
                                                        func_ac3_list.pop_back();
                                                }
                                                for(int i=0;i<vec.size();i++)
                                                {
                                                        // cout<<"hehe "<<func_ac3_list.back()<<"\n";
                                                        output.push_back("param "+temp1703.back());
                                                        temp1703.pop_back();
                                                }
                                                output.push_back("stackpointer +xxx");
                                                output.push_back("call "+string((char*)($1).type)+" , "+to_string(vec.size()));
                                                output.push_back("stackpointer -xxx");
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
                                                        // cout<<vec.size()<<" "<<data_type_params.size()<<" ";
                                                        cout<<"Error: less arguments passed : at line number "<<yylineno<<"\n";
                                                        exit(0);
                                                }
                                                if(vec.size() < data_type_params.size()) 
                                                {
                                                        // cout<<vec.size()<<" "<<data_type_params.size()<<" ";
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
                else 
                {
                        if(Is_array)
                        {
                                strcpy($$.ac3,("@t"+to_string(temporaries_counter++)).c_str());
                                string temp=(string((char*)($$).ac3))+" = "+(string((char*)($1).type))+" [] "+(string((char*)($2).ac3));
                                output.push_back(temp); 
                        }
                        else
                        {
                                if(!(string((char*)($2).ac3)).empty())
                                {
                                        strcpy($$.ac3,("@t"+to_string(temporaries_counter++)).c_str());
                                        string temp=(string((char*)($$).ac3))+" = "+(string((char*)($1).type))+" + "+(string((char*)($2).ac3));
                                        output.push_back(temp);
                                }
                        }
                        Is_array=0;
                        
                }
 }
         | atom %prec low  { 
                strcpy($$.type, $1.type); 
                $$.cnt = $1.cnt;
                strcpy($$.ac3, $1.ac3);
}
         ;
trailer_: trailer trailer_ {
                string temppp2=(string((char*)($2).type));
                string temppp1=(string((char*)($1).type))+temppp2;
                strcpy($$.type,temppp1.c_str()); 
                $$.abc=$2.abc;
        }
        | trailer %prec low { $$.abc=$1.abc; strcpy($$.type,$1.type); strcpy($$.ac3,$1.ac3);  }
        ;
atom: LP lines172 RP { $$.cnt = $2.cnt; }
    | LB lines173 RB {$$.cnt = $2.cnt; strcpy($$.data_type,$2.data_type); }
    | LF lines174 RF {  $$.node_id = 2 + dfn;  create_node("", "atom" , $$.node_id );  create_node("{", "LF" , 1 + dfn );  create_node("}", "RF" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
    | BT testlist1 BT {  $$.node_id = 2 + dfn;  create_node("", "atom" , $$.node_id );  create_node("`", "BT" , 1 + dfn );  create_node("`", "BT" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
    | NAME { strcpy($$.ac3, $1.lexeme); $$.cnt  = 1;strcpy($$.type, $1.lexeme); strcpy($$.data_type, say(string((char*)($1).lexeme)).c_str() );}
    | LEN LP testlist RP {
                string te = "@t"+to_string(temporaries_counter++);
                string temp=te+" = "+(string((char*)($3).lexeme));
                output.push_back(temp);
                string tem = "@t"+to_string(temporaries_counter++);
                temp=tem+" = "+"len";
                output.push_back(temp);
                int c= listcnt[string((char*)($3).ac3)];
                // cout << endl<< listcnt.size() << endl;
                strcpy($$.ac3,("@t"+to_string(temporaries_counter++)).c_str());
                temp=(string((char*)($$).ac3))+" = "+to_string(c) ;
                output.push_back(temp);
     } %prec high
    | NUMBER  {$$.cnt  = 1; strcpy($$.type, $1.lexeme);strcpy($$.ac3, $1.lexeme);  }
    | NONE  { strcpy($$.type, $1.lexeme);strcpy($$.ac3, $1.lexeme);  }
    | STRING  { strcpy($$.ac3, $1.lexeme);$$.cnt  = 1;strcpy($$.type, $1.lexeme);}
    | BOOL { strcpy($$.type, $1.lexeme);strcpy($$.ac3, $1.lexeme);  }
    | SELF %prec low  { strcpy($$.type, $1.lexeme);strcpy($$.ac3, $1.lexeme);  }
    ;
lines172: yield_expr { $$.node_id= $1.node_id;}
        | testlist_comp { $$.cnt  = $1.cnt;}
        | epsilon  { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
lines173: listmaker {$$.cnt = $1.cnt; strcpy($$.data_type,$1.data_type); }
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
lines174: dictorsetmaker { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
listmaker: test line151 { $$.cnt= $2.cnt+1; type_check_func(string((char*)($1).data_type),string((char*)($2).data_type)); strcpy($$.data_type,$2.data_type);  list_elements.push_back(string((char*)($1).type)); }
         ;
line151: list_for { $$.node_id= $1.node_id;}
       | lines57 { $$.cnt=0;$$.node_id= $1.node_id;}
       | COM_test lines57 { $$.cnt = $1.cnt; strcpy($$.data_type,$2.data_type);  }
       ;
testlist_comp: test line153 {$$.cnt  = $1.cnt+ $2.cnt;print_ac3_list.push_back(string((char*)($1).ac3));print_type_list.push_back(string((char*)($1).data_type)); }
             ;
line153: comp_for { $$.node_id= $1.node_id;}
       | lines57 { $$.cnt  = 0;$$.node_id= $1.node_id;}
       | COM_test lines57 {$$.cnt  = $1.cnt; $$.node_id=dfn;  create_node("","line153",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       ;
trailer: LP lines183 RP %prec high { 
                $$.abc = $2.abc;
                strcpy($$.type,$1.lexeme);
        }
       | LB subscriptlist RB {  
        Is_array=1;
        // cout<<"ochi p.."<<say(string((char*)($2).type))<<"..\n";
        if(!(say(string((char*)($2).type))=="int" || say(string((char*)($2).type))=="" ))
        {
                cout<<"Error: Array index must be integer at line number: "<<yylineno<<'\n';
                exit(0);
        }
        strcpy($$.ac3,("@t"+to_string(temporaries_counter++)).c_str());
        string temp=(string((char*)($$).ac3))+" = "+(string((char*)($2).ac3));
        output.push_back(temp);
}
       | FS NAME {  
        string temppp="."+(string((char*)($2).lexeme));
        strcpy($$.type,temppp.c_str());
       }
       ;
lines183: arglist { $$.abc= $1.abc;  /* for(int i=0;i<(*($1.abc)).size();i++) cout << (*($1.abc))[i]<< endl; */  }
        | epsilon { $$.abc =new vector<string>();}
        ;
subscriptlist: subscript line158 {
        strcpy($$.ac3,$1.ac3);
        strcpy($$.type,$1.type);
}
             ;
line158: COM_subscript lines57 { $$.node_id=dfn;  create_node("","line158",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | lines57 { $$.node_id= $1.node_id;}
       ;
COM_subscript: COM subscript COM_subscript %prec high { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","COM_subscript",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             | COM subscript %prec low { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","COM_subscript",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             ;
subscript: FS FS FS {  $$.node_id = 3 + dfn;  create_node("", "subscript" , $$.node_id );  create_node(".", "FS" , 2 + dfn );  create_node(".", "FS" , 1 + dfn );  create_node(".", "FS" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, 0 + dfn } , $$.node_id );  dfn += 4; }
         | test {list_size++;strcpy($$.ac3,$1.ac3); strcpy($$.type,$1.type);}
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
exprlist: expr line163 {
                strcpy($$.ac3, $1.ac3); 
                $$.node_id=dfn;  
                create_node("","exprlist",$$.node_id); 
                vector<int> child; 
                child.push_back($1.node_id);
                child.push_back($2.node_id); 
                create_edge(child,$$.node_id);  
                dfn++;
        }
        ;
line163 : COM_expr lines57 { $$.node_id=dfn;  create_node("","line163",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        | lines57 { $$.node_id= $1.node_id;}
        ;
COM_expr: COM expr COM_expr %prec high { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","COM_expr",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        | COM expr %prec low { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","COM_expr",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        ;
testlist: test {
                $$.cnt=$1.cnt;
                // cout<<"ammo"<<$1.ac3<<"\n";
                strcpy($$.ac3, $1.ac3); 
                strcpy($$.type, $1.type); 
                // $$.node_id=dfn;  
                // create_node("","testlist",$$.node_id); 
                // vector<int> child; 
                // child.push_back($1.node_id);
                // child.push_back($2.node_id); 
                // create_edge(child,$$.node_id);  
                // dfn++;
        }
        ;
// line166: COM_test lines57 {$$.cnt = $1.cnt; $$.node_id=dfn;  create_node("","line166",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
//        | lines57 {$$.cnt= 0;  $$.node_id= $1.node_id;}
//        ;
COM_test: COM test %prec low { $$.cnt = 1; strcpy($$.data_type,$2.data_type); list_elements.push_back(string((char*)($2).type)); print_ac3_list.push_back(string((char*)($2).ac3));print_type_list.push_back(string((char*)($2).data_type)); }
        | COM test COM_test %prec high {
                $$.cnt = $3.cnt+1;
                if(Is_because_of_print==0) type_check_func(string((char*)($2).data_type),string((char*)($3).data_type));
                strcpy($$.data_type,$2.data_type);
                list_elements.push_back(string((char*)($2).type));
                print_ac3_list.push_back(string((char*)($2).ac3));
                print_type_list.push_back(string((char*)($2).data_type));
                }
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

// class_terminal: CLASS {Is_class=1;}
//                 ;
classdef: CLASS NAME lines202 COL  { 
                /*  normal class */
                // first add into present scope and 
                string class_name=string((char*)($2).lexeme);
                current_class=class_name;
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
                output.push_back(string((char*)($2.lexeme))+" :");
                string inherited=string((char*)($3).type);
                if(inherited.size()!=0) output.push_back("ParentName: "+string((char*)($2).lexeme));
                output.push_back("classbegin:");
                
 }
         suite
        {
                output.push_back("classend:");
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
                Is_class=0;    
                Is_inherited=0;
        }
        ;
lines202: LP NAME RP { Is_inherited=1; current_parent=$2.lexeme; strcpy($$.type, $2.lexeme); }
        | epsilon { Is_inherited=0;$$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
arglist: argument_COM line175 { $1.abc->push_back(string((char*)($2).type)); $$.abc = $1.abc; func_ac3_list.push_back($2.ac3);}
       | line175  {$$.abc =new vector<string>(); string temp=string((char*)($1).type); $$.abc->push_back(temp); func_ac3_list.push_back($1.ac3);}
       ;
line175: argument lines57 {  strcpy($$.type, $1.type);}
       ;
argument_COM: argument_COM argument COM  { $1.abc->push_back(string((char*)($2).type));
                                $$.abc = $1.abc;
                                func_ac3_list.push_back($2.ac3);
                        }
            | argument COM %prec low {
                $$.abc =new vector<string>(); $$.abc->push_back(string((char*)($1).type)); func_ac3_list.push_back($1.ac3);
            }
            ;
argument: test lines209 { strcpy($$.type, $1.type); strcpy($$.ac3, $1.ac3); }
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

void adding_labels(vector<string> &output){
        vector<int> numbers;
        unordered_map<int,int> mp;

        for(int i=0;i<output.size();i++){
                size_t index = output[i].find("jump line");
                if (index != string::npos) { //"Substring found at index: "
                        string number="";
                        int index=output[i].length()-1;

                        while(output[i][index]>='0' && output[i][index]<='9'){
                                number=output[i][index]+number;
                                index--;
                        }
                        if(mp[stoi(number)]==0){
                                numbers.push_back(stoi(number));
                                mp[stoi(number)]=1;
                        }
                        
                        index=output[i].length()-1;

                        while(output[i][index]!='j'){
                                index--;
                        }
                        output[i].replace(index,10,"jump .Label");
                }   
        }
        sort(numbers.begin(),numbers.end());

        int index=0,past_lines_count=0,index2=0;

        while(index<numbers.size() && index2<output.size()){

                if(output[index2][0]=='`'){
                        output[index2]=output[index2].substr(1);
                }
                else{
                        past_lines_count++;
                }
                index2++;

                if(numbers[index]==past_lines_count+1){
                        output.insert(output.begin()+index2,".Label"+to_string(numbers[index])+" :\n");
                        index++;
                        index2++;
                }
        }
}
int ignore_bhai(int ind){
        if(ind>=6 && ind<=9) return 0;
        return 1;
}
int main(int argc, char **argv) {
//   cout<<"digraph ast {\n  node [shape=box, style=filled, fillcolor=lightblue]\n";
  yydebug = 1;
  indent.push_back(0);
  dfn=0;
  ++argv; --argc;
  if(argc>0) yyin = fopen( argv[0] , "r" );
  else yyin = stdin;
  before_parsing();
  int temp=yyparse();
 int count_main=0;
//   for(int i=0;i<output.size();i++)
//   {
//         if(output[i]=="main:") count_main++;
//   }
//   if(count_main==0) 
//   {
//         cout<<"Error: No main declared\n";
//         exit(0);
//   }
//   if(count_main>=2) 
//   {
//         cout<<"Error: Multiple main functions\n";
//         exit(0);
//   }
//    cout<<"behappy mourya";
//   cout<<"}\n";
  // print all the symbol tables
  sym_counts=1;
//   for(auto it:list_of_Symbol_Tables){
//         cout<<"\n\n*************************************************start of symbol table ***********************************************\n\n\n\n";
//         it->print_csv_table();
//         it->print_table();
//         cout<<endl;
//         cout<<"\n\n*************************************************end of symbol table *************************************************\n\n";
//         sym_counts++;

//   }
//    cout<<"\n\n************************* 3AC starts here *************************\n\n";
        adding_labels(output);
   for(int i=0;i<output.size();i++) 
   {
        
        cout<<output[i]<<"\n";
   }
   cout<<"exit\n";
//    cout<<"\n************************* 3AC ends here *************************\n\n";


//   if(temp==0){
//     cout<<"\n\n*************************success*************************\n";
//   }
//   else if(temp==1){
//     cout<<"\n\n*************************failure*************************\n";
//   }
//   else if(temp==2){
//     cout<<"memory exhaustion\n";
//   }
//   else{
//     cout<<"unknown error\n";
//   }
  fclose(yyin);
  return 0;
}


/*
 different function calls 

1) now ;lets solve for object declaration time function call 

*/
