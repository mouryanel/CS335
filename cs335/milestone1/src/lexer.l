%{
    #include <bits/stdc++.h>
    using namespace std;
    #include "par.tab.h"
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

"int"|"float"|"bool"|"str"|"complex" { 
    yylval.attr.lexeme = yytext;
    return PRIMITIVES;}

"self" {
    yylval.attr.lexeme = yytext;
    return SELF;
}

"list" { 
    yylval.attr.lexeme = yytext;
    return LIST ;}

"class" {
    yylval.attr.lexeme = yytext;
    return CLASS;
}

"is not" {
    yylval.attr.lexeme = yytext;
    return INOT;
}
is {
    yylval.attr.lexeme = yytext;
    return IS;
}
"not in" {
    yylval.attr.lexeme = yytext;
    return NI;
}

"<>" {
    yylval.attr.lexeme = yytext;
    return LG;
}

">=" {
    yylval.attr.lexeme = yytext;
    return GE;
}

"!=" {
    yylval.attr.lexeme = yytext;
    return NE;
}

"<=" {
    yylval.attr.lexeme = yytext;
    return LE;
}

"==" {
    yylval.attr.lexeme = yytext;
    
    return EE;
}

"not" {
    yylval.attr.lexeme = yytext;
    return NOT;
}

"and" {
    yylval.attr.lexeme = yytext;
    return AND;
}

None {
    yylval.attr.lexeme = yytext;
    return NONE;
}

or {
    yylval.attr.lexeme = yytext;
    return OR;
}

except {
    yylval.attr.lexeme = yytext;
    return EXCEPT;
}

with {
    yylval.attr.lexeme = yytext;
    return WITH;
}

finally {
    yylval.attr.lexeme = yytext;
    return FINALLY;
}

try {
    yylval.attr.lexeme = yytext;
    return TRY;
}

for {
    yylval.attr.lexeme = yytext;
    return FOR;
}

elif {
    yylval.attr.lexeme = yytext;
    return ELIF;
}

assert {
    yylval.attr.lexeme = yytext;
    return ASSERT;
}

in {
    yylval.attr.lexeme = yytext;
    return IN;
}
global {
    yylval.attr.lexeme = yytext;
    return GLOBAL;
}
as {
    yylval.attr.lexeme = yytext;
    return AS;
}
from {
    yylval.attr.lexeme = yytext;
    return FROM;
}

raise {
    yylval.attr.lexeme = yytext;
    return RAISE;
}

else {
    yylval.attr.lexeme = yytext;
    return ELSE;
}

while {
    yylval.attr.lexeme = yytext;
    return WHILE;
}

if {
    yylval.attr.lexeme = yytext;
    return IF;
}

exec {
    yylval.attr.lexeme = yytext;
    return EXEC;
}

del {
    yylval.attr.lexeme = yytext;
    return DEL;
}

break {
    yylval.attr.lexeme = yytext;
    return BREAK;
}

continue {
    yylval.attr.lexeme = yytext;
    return CONTINUE;
}

return {
    yylval.attr.lexeme = yytext;
    return RETURN;
}

">>" {
    yylval.attr.lexeme = yytext;
    return RS;
}
print {
    yylval.attr.lexeme = yytext;
    return PRINT;
}

"//=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return FFE;
}

"**=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return SSE;
}

">>=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return RSE;
}

"<<=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return LSE;
}

"&" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return BA;
}

"|" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return BO;
}

"^" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return BX;
}

"^=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return BXE;
}

"|=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return BOE;
}
"&=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return ANDE;
}
"%=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return MODE;
}

"/=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return DE;
}

"*=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return SE;
}

"-=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return ME;
}
"," {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return COM;
}

"+=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return PE;
}
"**" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return SS;
}
"=" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    // cout<<"eq found\n";
    return EQ;
}

":" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    // cout<<"col found\n";
    return COL;
}
";" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return SCOL;
}
"<<" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return LS;
}

"." {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return FS;
}
"`" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return BT;
}

"~" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return NEG;
}

"//" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return FF;
}

"%" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return MOD;
}

"/" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return DIV;
}

"*" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return STAR;
}
"->" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return ARROW;
}

"-" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return MINUS;
}

"+" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return PLUS;
}

">" {
    // yylval.attr.lexeme = yytext;
    // cout<<"gt found\n";
    yylval.attr.lexeme = yytext;
    return GT;
}

"<" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return LT;
}
def {
    // yylval.attr.lexeme = yytext;lexeme.clear();
    yylval.attr.lexeme = yytext;
    return DEF;
}

at {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return AT;
}

"(" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return LP;
}

")" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return RP;
}

"[" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return LB;
}

"]" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return RB;
}

"}" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return RF;
}

"{" {
    // yylval.attr.lexeme = yytext;
    yylval.attr.lexeme = yytext;
    return LF;
}



[0-9]+|[0-9]+[eE][0-9]+ {
    yylval.attr.lexeme = yytext;
    return NUMBER;
}

[0-9]*\.[0-9]*|[0-9]*\.[0-9]*[eE][0-9]+ {
    yylval.attr.lexeme = yytext;
    return NUMBER;
}


  

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.attr.lexeme = yytext;
    return NAME;
}

\"([^\"]*)\"|\'([^\']*)\' {
    yylval.attr.lexeme = yytext;
    return STRING;}


[ \t] {}


. {
    yylval.attr.lexeme = yytext;
    return UNKNOWN;
}

%%

