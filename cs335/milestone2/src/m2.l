%{
    #include <bits/stdc++.h>
    using namespace std;
    #include "m2.tab.h"
    extern int yylineno;  
    vector<int> indent;

%}

%option noyywrap
%option yylineno

%x NEWSTATE

%%

\\\n {}
^[ \t]*\r?\n {}
^[ \t]*#.*\r?\n {}
#.*\n
#.*$ {}

^[^ \t\n]+ {
    if (indent.back()!= 0){
        int temp=strlen(yytext);
        for(int i=0;i<temp;i++){
            unput(yytext[temp-1-i]);
        }
        BEGIN(NEWSTATE);
    }
    else{
        REJECT;
    }
    
}
^[ \t\n]+  {
    if (indent.back() < yyleng) {
        indent.push_back(yyleng);
        // cout<<"INDENT"<<endl;
        return INDENT;
    } 
    else if (indent.back() > yyleng) {
        int temp=strlen(yytext);    
    for(int i=0;i<temp;i++){
        unput(yytext[temp-1-i]);
    }
        BEGIN(NEWSTATE);
    }
}

\r?\n      {
    // cout<<"newline found\n";
 return NEWLINE;
}

<NEWSTATE>[ \t\n]+ {
    if (!indent.empty()) 
    {
        if(indent.back()>yyleng){
            indent.pop_back();
            // cout<<"DEDENT"<<endl;
            int temp=strlen(yytext);    
            for(int i=0;i<temp;i++){
                unput(yytext[temp-1-i]);
            }
            return DEDENT;
        }
        else if(indent.back()==yyleng){
            BEGIN(INITIAL);
        }
        else{
            fprintf(stderr, "Error: Incorrect indentation on line %d\n", yylineno);
            exit(1);
        }
        
    }
}

<NEWSTATE>[^ \t\n]+ {
int temp=strlen(yytext);    
    for(int i=0;i<temp;i++){
        unput(yytext[temp-1-i]);
    }
    if (indent.back() != 0) {
        indent.pop_back();
       // cout<<"DEDENT"<<endl;
        return DEDENT;
    }
    else{  
    BEGIN(INITIAL);
    }
    
}  

<<EOF>> {
        if (indent.back()!= 0){
            unput(yytext[0]);
            BEGIN(NEWSTATE);
        }
        else
        {  
            // // cout<<"ENDMARKER"<<endl;
            return ENDMARKER;
        }
}

"True"|"False" {
    strcpy(yylval.attr.lexeme , yytext);
    char strr[1000]="bool";
    strcpy(yylval.attr.data_type , strr);
    return BOOL;
}

"int"|"float"|"bool"|"str"|"complex" { 
    if(yytext == "int") 
    {
        yylval.attr.size = 4;
        char strr[1000]="int";
        strcpy(yylval.attr.data_type , strr);
    }
    else if(yytext == "float") 
    {
        yylval.attr.size = 4;
        char strr[1000]="float";
        strcpy(yylval.attr.data_type , strr);
    }
    else if(yytext == "bool")
    {
        yylval.attr.size = 1;
        char strr[1000]="bool";
        strcpy(yylval.attr.data_type , strr);
    }
    strcpy(yylval.attr.lexeme , yytext);
    return PRIMITIVES;
}

"self" {
    strcpy(yylval.attr.lexeme , yytext);
    return SELF;
}

"list" { 
    strcpy(yylval.attr.lexeme , yytext);
    return LIST ;}

"class" {
    strcpy(yylval.attr.lexeme , yytext);
    return CLASS;
}

"is not" {
    strcpy(yylval.attr.lexeme , yytext);
    return INOT;
}
is {
    strcpy(yylval.attr.lexeme , yytext);
    return IS;
}
"not in" {
    strcpy(yylval.attr.lexeme , yytext);
    return NI;
}

"<>" {
    strcpy(yylval.attr.lexeme , yytext);
    return LG;
}

">=" {
    strcpy(yylval.attr.lexeme , yytext);
    return GE;
}

"!=" {
    strcpy(yylval.attr.lexeme , yytext);
    return NE;
}

"<=" {
    strcpy(yylval.attr.lexeme , yytext);
    return LE;
}

"==" {
    strcpy(yylval.attr.lexeme , yytext);
    
    return EE;
}

"not" {
    strcpy(yylval.attr.lexeme , yytext);
    return NOT;
}

"and" {
    strcpy(yylval.attr.lexeme , yytext);
    return AND;
}

None {
    strcpy(yylval.attr.lexeme , yytext);
    return NONE;
}

or {
    strcpy(yylval.attr.lexeme , yytext);
    return OR;
}

except {
    strcpy(yylval.attr.lexeme , yytext);
    return EXCEPT;
}

with {
    strcpy(yylval.attr.lexeme , yytext);
    return WITH;
}

finally {
    strcpy(yylval.attr.lexeme , yytext);
    return FINALLY;
}

try {
    strcpy(yylval.attr.lexeme , yytext);
    return TRY;
}

for {
    strcpy(yylval.attr.lexeme , yytext);
    return FOR;
}

elif {
    strcpy(yylval.attr.lexeme , yytext);
    return ELIF;
}

assert {
    strcpy(yylval.attr.lexeme , yytext);
    return ASSERT;
}

in {
    strcpy(yylval.attr.lexeme , yytext);
    return IN;
}
global {
    strcpy(yylval.attr.lexeme , yytext);
    return GLOBAL;
}
as {
    strcpy(yylval.attr.lexeme , yytext);
    return AS;
}
from {
    strcpy(yylval.attr.lexeme , yytext);
    return FROM;
}

raise {
    strcpy(yylval.attr.lexeme , yytext);
    return RAISE;
}

else {
    strcpy(yylval.attr.lexeme , yytext);
    return ELSE;
}

while {
    strcpy(yylval.attr.lexeme , yytext);
    return WHILE;
}

if {
    strcpy(yylval.attr.lexeme , yytext);
    return IF;
}

exec {
    strcpy(yylval.attr.lexeme , yytext);
    return EXEC;
}

del {
    strcpy(yylval.attr.lexeme , yytext);
    return DEL;
}

break {
    strcpy(yylval.attr.lexeme , yytext);
    return BREAK;
}

continue {
    strcpy(yylval.attr.lexeme , yytext);
    return CONTINUE;
}

return {
    strcpy(yylval.attr.lexeme , yytext);
    return RETURN;
}

">>" {
    strcpy(yylval.attr.lexeme , yytext);
    return RS;
}
print {
    strcpy(yylval.attr.lexeme , yytext);
    return PRINT;
}

"//=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return FFE;
}

"**=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return SSE;
}

">>=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return RSE;
}

"<<=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return LSE;
}

"&" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return BA;
}

"|" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return BO;
}

"^" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return BX;
}

"^=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return BXE;
}

"|=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return BOE;
}
"&=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return ANDE;
}
"%=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return MODE;
}

"/=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return DE;
}

"*=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return SE;
}

"-=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return ME;
}
"," {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return COM;
}

"+=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return PE;
}
"**" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return SS;
}
"=" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);

    // cout<<"eq found\n";
    return EQ;
}

":" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    // cout<<"col found\n";
    return COL;
}
";" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return SCOL;
}
"<<" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return LS;
}

"." {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return FS;
}
"`" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return BT;
}

"~" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return NEG;
}

"//" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return FF;
}

"%" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return MOD;
}

"/" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return DIV;
}

"*" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return STAR;
}
"->" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return ARROW;
}

"-" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return MINUS;
}

"+" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return PLUS;
}

">" {
    // strcpy(yylval.attr.lexeme , yytext);
    // cout<<"gt found\n";
    strcpy(yylval.attr.lexeme , yytext);
    return GT;
}

"<" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return LT;
}
def {
    // strcpy(yylval.attr.lexeme , yytext);lexeme.clear();
    strcpy(yylval.attr.lexeme , yytext);
    return DEF;
}

at {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return AT;
}

"(" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return LP;
}

")" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return RP;
}

"[" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return LB;
}

"]" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return RB;
}

"}" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return RF;
}

"{" {
    // strcpy(yylval.attr.lexeme , yytext);
    strcpy(yylval.attr.lexeme , yytext);
    return LF;
}



[0-9]+|[0-9]+[eE][0-9]+ {
    strcpy(yylval.attr.lexeme , yytext);
    char strr[1000]="int";
    strcpy(yylval.attr.data_type , strr);
    return NUMBER;
}

[0-9]*\.[0-9]*|[0-9]*\.[0-9]*[eE][0-9]+ {
    strcpy(yylval.attr.lexeme , yytext);
    char strr[1000]="float";
    strcpy(yylval.attr.data_type , strr);
    return NUMBER;
}


  

[a-zA-Z_][a-zA-Z0-9_]* {
    strcpy(yylval.attr.lexeme , yytext);
    return NAME;
}

\"([^\"]*)\"|\'([^\']*)\' {
    strcpy(yylval.attr.lexeme , yytext);
    yylval.attr.cnt = strlen(yytext)-2;
    char strr[1000]="str";
    strcpy(yylval.attr.data_type , strr);
    return STRING;}


[ \t] {}


. {
    strcpy(yylval.attr.lexeme , yytext);
    return UNKNOWN;
}

%%

