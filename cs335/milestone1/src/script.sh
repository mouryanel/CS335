#!/bin/bash
flex lexer.l
bison -d par.y
g++ -o parser par.tab.c lex.yy.c -lfl
./parser input.py >graph.dot
