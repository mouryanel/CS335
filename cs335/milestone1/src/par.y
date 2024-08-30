%{
#include <bits/stdc++.h>
using namespace std;
#define YYDEBUG 1 


extern int yylex();
extern int yyparse();
extern vector<int> indent;
extern FILE *yyin;
extern int yylineno;

int dfn;
vector<int> curr_dfn;
vector<string> curr_labels;

void yyerror (char const *s)
{
        cout<<s<<" at line no "<<yylineno<<"\n";
}
void timeout_handler(int signum) {
    printf("Timeout: Parser execution took too long.\n");
    exit(EXIT_FAILURE);
}
void create_node(string lexeme,string label,int dfn){
        cout<<"  ";
        cout<< dfn<<" [label=\""<<label;
        if(label == "NAME" )
        {
                cout<<" ( "  ;

                for(int i=0;i<lexeme.size();i++)
                {
                        if( (lexeme[i]>='a' && lexeme[i]<='z') 
                        || (lexeme[i]>='A' && lexeme[i]<='Z') 
                        || (lexeme[i]=='_')
                        || (lexeme[i]>='0' && lexeme[i]<='9')
                        ) cout<<lexeme[i];
                        else break;
                }
                cout<<" ) ";
        }
        else if(lexeme.length()){
              cout<<" ( "  ;

              for(int i=0;i<lexeme.length();i++){
                if(lexeme[i]=='\"')cout<<'\\';
                cout<<lexeme[i];
              }
              cout<<" ) ";
        }
        cout<<"\"]\n";
}
void create_edge(vector<int> children,int parent){
  cout<<"  ";
  cout<<parent<<"->{";

  for(int i=0;i<children.size();i++){
   cout<<children[i]<<(i<children.size()-1?",":"");
  }
  cout<<"}\n";
  if(children.size()>1)
  {
  cout<<"  ";  
    cout<<"{rank=same; ";
    for(int i=0;i<children.size();i++){
      cout<<children[i]<<(i<children.size()-1?"->":" [style=invis];}\n");
    }
  }
}


%}

%locations

/* %define parse.error detailed */
%define parse.trace false

%define parse.error custom


%union {
  struct{
    int node_id;
    char* lexeme; 
  }attr;

}

%token <attr> UNKNOWN NUMBER LIST RANGE SELF ARROW NONE PRIMITIVES NEWLINE STRING ENDMARKER NAME INDENT DEDENT AT RB LB RP LP LF RF DEF SCOL COL EQ SS COM PE ME SE DE MODE ANDE BOE BXE BX BO BA LSE RSE SSE FFE PRINT RS DEL BREAK CONTINUE RETURN RAISE FROM AS GLOBAL EXEC IN ASSERT IF ELIF WHILE ELSE FOR TRY FINALLY WITH EXCEPT OR AND NOT LT GT EE LE GE NE LG NI IS INOT PLUS MINUS STAR DIV MOD FF NEG BT FS LS CLASS YIELD


%start start ;
%precedence lower
%precedence low
%precedence high   
%precedence UNKNOWN LIST RANGE SELF ARROW NONE PRIMITIVES NUMBER NEWLINE STRING ENDMARKER NAME INDENT DEDENT AT RB LB RP LP LF RF DEF SCOL COL EQ SS COM PE ME SE DE MODE ANDE BOE BXE BX BO BA LSE RSE SSE FFE PRINT RS DEL BREAK CONTINUE RETURN RAISE FROM AS GLOBAL EXEC IN ASSERT IF ELIF WHILE ELSE FOR TRY FINALLY WITH EXCEPT OR AND NOT LT GT EE LE GE NE LG NI IS INOT PLUS MINUS STAR DIV MOD FF NEG BT FS LS CLASS YIELD
%type <attr> start primitives single_input file_input NEWstmt eval_input Nnew decorator line38 line41 decorated line40 decorators funcdef parameters fpdef fplist lines57 fpdefq range_func stmt simple_stmt line57 small_stmt expr_stmt line61 line62 EQ_yield_expr_testlist augassign print_stmt line67 lines75 lines74 line68 del_stmt flow_stmt break_stmt continue_stmt return_stmt lines84 yield_stmt raise_stmt lines87 lines88 lines89 dotted_name FS_NAME global_stmt COM_NAME exec_stmt lines110 assert_stmt prim prime declare_stmt compound_stmt if_stmt lines115 ELIF_test_COL_suite while_stmt for_stmt try_stmt line105 lines121 except_clause_COL_suite with_stmt line108 COM_with_item with_item lines127 except_clause lines129 lines130 line112 suite stmt_ testlist_safe lines135 COM_old_test old_test test lines142 or_test OR_and_test and_test AND_not_test not_test comparision comp_op_expr comp_op expr BO_xor_expr xor_expr BX_and_expr and_expr BA_shift_expr shift_expr LSRS_arith_expr line137 arith_expr PLUSMINUS_term line140 term STARDIVMODFF_factor line143 factor line145 power atom_expr trailer_ atom lines172 lines173 lines174 listmaker line151 testlist_comp line153 trailer lines183 subscriptlist line158 COM_subscript subscript sliceop lines189 lines190 exprlist line163 COM_expr testlist line166 COM_test dictorsetmaker line169 line170 COM_test_COL_test classdef lines202 arglist line175 argument_COM argument lines209 list_iter list_for list_if lines214 comp_iter comp_for comp_if lines219 testlist1 yield_expr 
%%

start: single_input {  $$.node_id = 0 + dfn;  create_node("", "start" , $$.node_id );  create_edge( { $1.node_id } , $$.node_id );  dfn += 1; YYACCEPT;} 
     | file_input  {  $$.node_id = 0 + dfn;  create_node("", "start" , $$.node_id );  create_edge( { $1.node_id } , $$.node_id );  dfn += 1; YYACCEPT;}
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
funcdef: DEF NAME parameters COL suite {  $$.node_id = 3 + dfn;  create_node("", "funcdef" , $$.node_id );  create_node("def", "DEF" , 2 + dfn );  create_node($2.lexeme, "NAME" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, $3.node_id, 0 + dfn, $5.node_id } , $$.node_id );  dfn += 4; }
       | DEF NAME parameters ARROW prime COL suite {  $$.node_id = 4 + dfn;  create_node("", "funcdef" , $$.node_id );  create_node("def", "DEF" , 3 + dfn );  create_node($2.lexeme, "NAME" , 2 + dfn );  create_node("->", "ARROW" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 3 + dfn, 2 + dfn, $3.node_id, 1 + dfn, $5.node_id, 0 + dfn, $7.node_id } , $$.node_id );  dfn += 5; }
       ;
parameters: LP fpdefq RP {  $$.node_id = 2 + dfn;  create_node("", "parameters" , $$.node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
          | LP fplist fpdefq RP {  $$.node_id = 2 + dfn;  create_node("", "parameters" , $$.node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, $3.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
          ;
fpdef: NAME COL prim {  $$.node_id = 2 + dfn;  create_node("", "fpdef" , $$.node_id );  create_node($1.lexeme, "NAME" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 3; }
     | SELF { $$.node_id=dfn; $1.node_id=dfn; create_node("self","SELF",$1.node_id);  dfn++;}
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
prim: primitives { $$.node_id= $1.node_id;}
    | NAME { $$.node_id=dfn; $1.node_id=dfn; create_node($1.lexeme,"NAME",$1.node_id);  dfn++;}
    ;
primitives: PRIMITIVES { $$.node_id=dfn; $1.node_id=dfn; create_node($1.lexeme,"PRIMITIVES",$1.node_id);  dfn++;}
          | LIST LB primitives RB {  $$.node_id = 3 + dfn;  create_node("", "primitives" , $$.node_id );  create_node("list", "LIST" , 2 + dfn );  create_node("[", "LB" , 1 + dfn );  create_node("]", "RB" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, $3.node_id, 0 + dfn } , $$.node_id );  dfn += 4; }
          ;
prime: prim { $$.node_id= $1.node_id;}
     | NONE { $$.node_id=dfn; $1.node_id=dfn; create_node("None","NONE",$1.node_id);  dfn++;}
     ;
declare_stmt: atom_expr COL prim {  $$.node_id = 1 + dfn;  create_node("", "declare_stmt" , $$.node_id );  create_node(":", "COL" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 2; }
            | atom_expr COL prim EQ test {  $$.node_id = 2 + dfn;  create_node("", "declare_stmt" , $$.node_id );  create_node(":", "COL" , 1 + dfn );  create_node("=", "EQ" , 0 + dfn );  create_edge( { $1.node_id, 1 + dfn, $3.node_id, 0 + dfn, $5.node_id } , $$.node_id );  dfn += 3; }
            ;
compound_stmt: if_stmt { $$.node_id= $1.node_id;}
             | while_stmt { $$.node_id= $1.node_id;}
             | for_stmt { $$.node_id= $1.node_id;}
             | try_stmt { $$.node_id= $1.node_id;}
             | with_stmt { $$.node_id= $1.node_id;}
             | funcdef { $$.node_id= $1.node_id;}
             | classdef { $$.node_id= $1.node_id;}
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
old_test: or_test { $$.node_id= $1.node_id;}
        ;
test: or_test lines142 { $$.node_id=dfn;  create_node("","test",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
    ;
lines142: IF or_test ELSE test {  $$.node_id = 2 + dfn;  create_node("", "lines142" , $$.node_id );  create_node("if", "IF" , 1 + dfn );  create_node("else", "ELSE" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn, $4.node_id } , $$.node_id );  dfn += 3; }
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
or_test: and_test OR_and_test { $$.node_id=dfn;  create_node("","or_test",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | and_test { $$.node_id= $1.node_id;}
       ;
OR_and_test: OR and_test OR_and_test { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","OR_and_test",$$.node_id);create_node("or","OR",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
           | OR and_test { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","OR_and_test",$$.node_id);create_node("or","OR",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
           ;
and_test: not_test AND_not_test { $$.node_id=dfn;  create_node("","and_test",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        | not_test { $$.node_id= $1.node_id;}
        ;
AND_not_test: AND not_test AND_not_test { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","AND_not_test",$$.node_id);create_node("and","AND",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
            | AND not_test { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","AND_not_test",$$.node_id);create_node("and","AND",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
            ;
not_test: NOT not_test %prec high { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","not_test",$$.node_id);create_node("not","NOT",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        | comparision { $$.node_id= $1.node_id;}
        ;
comparision: expr comp_op_expr { $$.node_id=dfn;  create_node("","comparision",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
          | expr { $$.node_id= $1.node_id;}
          ;
comp_op_expr: comp_op expr comp_op_expr {  $$.node_id = 0 + dfn;  create_node("", "comp_op_expr" , $$.node_id );  create_edge( { $1.node_id, $2.node_id, $3.node_id } , $$.node_id );  dfn += 1; }
            | comp_op expr { $$.node_id=dfn;  create_node("","comp_op_expr",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
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
expr: xor_expr BO_xor_expr { $$.node_id=dfn;  create_node("","expr",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
    | xor_expr { $$.node_id= $1.node_id;}
    ;
BO_xor_expr: BO xor_expr BO_xor_expr { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","BO_xor_expr",$$.node_id);create_node("|","BO",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
           | BO xor_expr { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","BO_xor_expr",$$.node_id);create_node("|","BO",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
           ;
xor_expr: and_expr BX_and_expr { $$.node_id=dfn;  create_node("","xor_expr",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        | and_expr { $$.node_id= $1.node_id;}
        ;
BX_and_expr: BX and_expr BX_and_expr { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","BX_and_expr",$$.node_id);create_node("^","BX",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
           | BX and_expr { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","BX_and_expr",$$.node_id);create_node("^","BX",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
           ;
and_expr: shift_expr BA_shift_expr { $$.node_id=dfn;  create_node("","and_expr",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        | shift_expr { $$.node_id= $1.node_id;}
        ;
BA_shift_expr: BA shift_expr BA_shift_expr { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","BA_shift_expr",$$.node_id);create_node("&","BA",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             | BA shift_expr { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","BA_shift_expr",$$.node_id);create_node("&","BA",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             ;
shift_expr: arith_expr LSRS_arith_expr { $$.node_id=dfn;  create_node("","shift_expr",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
          | arith_expr { $$.node_id= $1.node_id;}
          ;
LSRS_arith_expr: line137 arith_expr LSRS_arith_expr { $$.node_id=dfn;  create_node("","LSRS_arith_expr",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn++;}
               | line137 arith_expr { $$.node_id=dfn;  create_node("","LSRS_arith_expr",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
               ;
line137: LS { $$.node_id=dfn; $1.node_id=dfn; create_node("<<","LS",$1.node_id);  dfn++;}
       | RS { $$.node_id=dfn; $1.node_id=dfn; create_node(">>","RS",$1.node_id);  dfn++;}
       ;
arith_expr: term PLUSMINUS_term %prec high { $$.node_id=dfn;  create_node("","arith_expr",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
          | term %prec low { $$.node_id= $1.node_id;}
          ;
PLUSMINUS_term: line140 term PLUSMINUS_term { $$.node_id=dfn;  create_node("","PLUSMINUS_term",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn++;}
              | line140 term %prec low { $$.node_id=dfn;  create_node("","PLUSMINUS_term",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
              ;
line140: PLUS %prec high { $$.node_id=dfn; $1.node_id=dfn; create_node("+","PLUS",$1.node_id);  dfn++;}
       | MINUS { $$.node_id=dfn; $1.node_id=dfn; create_node("-","MINUS",$1.node_id);  dfn++;}
       ;
term: factor STARDIVMODFF_factor { $$.node_id=dfn;  create_node("","term",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
    | factor { $$.node_id= $1.node_id;}
    ;
STARDIVMODFF_factor: line143 factor STARDIVMODFF_factor { $$.node_id=dfn;  create_node("","STARDIVMODFF_factor",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn++;}
                   | line143 factor { $$.node_id=dfn;  create_node("","STARDIVMODFF_factor",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
                   ;
line143: STAR { $$.node_id=dfn; $1.node_id=dfn; create_node("*","STAR",$1.node_id);  dfn++;}
       | DIV { $$.node_id=dfn; $1.node_id=dfn; create_node("/","DIV",$1.node_id);  dfn++;}
       | MOD { $$.node_id=dfn; $1.node_id=dfn; create_node("%","MOD",$1.node_id);  dfn++;}
       | FF { $$.node_id=dfn; $1.node_id=dfn; create_node("//","FF",$1.node_id);  dfn++;}
       ;
factor: line145 factor { $$.node_id=dfn;  create_node("","factor",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
      | power  { $$.node_id= $1.node_id;}
      ;
line145: PLUS  { $$.node_id=dfn; $1.node_id=dfn; create_node("+","PLUS",$1.node_id);  dfn++;}
       | MINUS { $$.node_id=dfn; $1.node_id=dfn; create_node("-","MINUS",$1.node_id);  dfn++;}
       | NEG { $$.node_id=dfn; $1.node_id=dfn; create_node("~","NEG",$1.node_id);  dfn++;}
       ;
power: atom_expr { $$.node_id= $1.node_id;}
     | atom_expr SS factor {  $$.node_id = 1 + dfn;  create_node("", "power" , $$.node_id );  create_node("**", "SS" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn, $3.node_id } , $$.node_id );  dfn += 2; }
     ;
atom_expr: atom trailer_ { $$.node_id=dfn;  create_node("","atom_expr",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
         | atom %prec low { $$.node_id= $1.node_id;}
         ;
trailer_: trailer trailer_ { $$.node_id=dfn;  create_node("","trailer_",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
        | trailer %prec low { $$.node_id= $1.node_id;}
        ;
atom: LP lines172 RP {  $$.node_id = 2 + dfn;  create_node("", "atom" , $$.node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
    | LB lines173 RB {  $$.node_id = 2 + dfn;  create_node("", "atom" , $$.node_id );  create_node("[", "LB" , 1 + dfn );  create_node("]", "RB" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
    | LF lines174 RF {  $$.node_id = 2 + dfn;  create_node("", "atom" , $$.node_id );  create_node("{", "LF" , 1 + dfn );  create_node("}", "RF" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
    | BT testlist1 BT {  $$.node_id = 2 + dfn;  create_node("", "atom" , $$.node_id );  create_node("`", "BT" , 1 + dfn );  create_node("`", "BT" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
    | NAME { $$.node_id=dfn; $1.node_id=dfn; create_node($1.lexeme,"NAME",$1.node_id);  dfn++;}
    | NUMBER  { $$.node_id=dfn; $1.node_id=dfn; create_node($1.lexeme,"NUMBER",$1.node_id);  dfn++;}
    | NONE  { $$.node_id=dfn; $1.node_id=dfn; create_node("None","NONE",$1.node_id);  dfn++;}
    | STRING  { $$.node_id=dfn; $1.node_id=dfn; create_node($1.lexeme,"STRING",$1.node_id);  dfn++;}
    | SELF %prec low  { $$.node_id=dfn; $1.node_id=dfn; create_node("self","SELF",$1.node_id);  dfn++;}
    ;
lines172: yield_expr { $$.node_id= $1.node_id;}
        | testlist_comp { $$.node_id= $1.node_id;}
        | epsilon  { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
lines173: listmaker { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
lines174: dictorsetmaker { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
listmaker: test line151 { $$.node_id=dfn;  create_node("","listmaker",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
         ;
line151: list_for { $$.node_id= $1.node_id;}
       | lines57 { $$.node_id= $1.node_id;}
       | COM_test lines57 { $$.node_id=dfn;  create_node("","line151",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       ;
testlist_comp: test line153 { $$.node_id=dfn;  create_node("","testlist_comp",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
             ;
line153: comp_for { $$.node_id= $1.node_id;}
       | lines57 { $$.node_id= $1.node_id;}
       | COM_test lines57 { $$.node_id=dfn;  create_node("","line153",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       ;
trailer: LP lines183 RP %prec high {  $$.node_id = 2 + dfn;  create_node("", "trailer" , $$.node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
       | LB subscriptlist RB {  $$.node_id = 2 + dfn;  create_node("", "trailer" , $$.node_id );  create_node("[", "LB" , 1 + dfn );  create_node("]", "RB" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
       | FS NAME {  $$.node_id = 2 + dfn;  create_node("", "trailer" , $$.node_id );  create_node(".", "FS" , 1 + dfn );  create_node($2.lexeme, "NAME" , 0 + dfn );  create_edge( { 1 + dfn, 0 + dfn } , $$.node_id );  dfn += 3; }
       ;
lines183: arglist { $$.node_id= $1.node_id;}
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
subscriptlist: subscript line158 { $$.node_id=dfn;  create_node("","subscriptlist",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
             ;
line158: COM_subscript lines57 { $$.node_id=dfn;  create_node("","line158",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | lines57 { $$.node_id= $1.node_id;}
       ;
COM_subscript: COM subscript COM_subscript %prec high { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","COM_subscript",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             | COM subscript %prec low { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","COM_subscript",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
             ;
subscript: FS FS FS {  $$.node_id = 3 + dfn;  create_node("", "subscript" , $$.node_id );  create_node(".", "FS" , 2 + dfn );  create_node(".", "FS" , 1 + dfn );  create_node(".", "FS" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, 0 + dfn } , $$.node_id );  dfn += 4; }
         | test { $$.node_id= $1.node_id;}
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
COM_test: COM test %prec low { $$.node_id=dfn+1; $1.node_id= dfn;  create_node("","COM_test",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn+=2;}
        | COM test COM_test %prec high { $$.node_id=dfn+1; $1.node_id= dfn ; create_node("","COM_test",$$.node_id);create_node(",","COM",$1.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id);child.push_back($3.node_id); create_edge(child,$$.node_id);  dfn+=2;}
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
classdef: CLASS NAME lines202 COL suite {  $$.node_id = 3 + dfn;  create_node("", "classdef" , $$.node_id );  create_node("class", "CLASS" , 2 + dfn );  create_node($2.lexeme, "NAME" , 1 + dfn );  create_node(":", "COL" , 0 + dfn );  create_edge( { 2 + dfn, 1 + dfn, $3.node_id, 0 + dfn, $5.node_id } , $$.node_id );  dfn += 4; }
        ;
lines202: LP lines84 RP {  $$.node_id = 2 + dfn;  create_node("", "lines202" , $$.node_id );  create_node("(", "LP" , 1 + dfn );  create_node(")", "RP" , 0 + dfn );  create_edge( { 1 + dfn, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 3; }
        | epsilon { $$.node_id=dfn;  create_node("","ε",$$.node_id); dfn++;}
        ;
arglist: argument_COM line175 { $$.node_id=dfn;  create_node("","arglist",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       | line175  { $$.node_id= $1.node_id;}
       ;
line175: argument lines57 { $$.node_id=dfn;  create_node("","line175",$$.node_id); vector<int> child; child.push_back($1.node_id);child.push_back($2.node_id); create_edge(child,$$.node_id);  dfn++;}
       ;
argument_COM: argument_COM argument COM  {  $$.node_id = 1 + dfn;  create_node("", "argument_COM" , $$.node_id );  create_node(",", "COM" , 0 + dfn );  create_edge( { $1.node_id, $2.node_id, 0 + dfn } , $$.node_id );  dfn += 2; }
            | argument COM %prec low {  $$.node_id = 1 + dfn;  create_node("", "argument_COM" , $$.node_id );  create_node(",", "COM" , 0 + dfn );  create_edge( { $1.node_id, 0 + dfn } , $$.node_id );  dfn += 2; }
            ;
argument: test lines209 {  $$.node_id = 0 + dfn;  create_node("", "argument" , $$.node_id );  create_edge( { $1.node_id, $2.node_id } , $$.node_id );  dfn += 1; }
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
  cout<<"digraph ast {\n  node [shape=box, style=filled, fillcolor=lightblue]\n";
  indent.push_back(0);
  dfn=0;
  ++argv; --argc;
  if(argc>0) yyin = fopen( argv[0] , "r" );
  else yyin = stdin;
  int temp=yyparse();
  cout<<"}\n";
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
