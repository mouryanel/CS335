#!/bin/bash
flex m2.l
bison -d m2.y
g++ -o parser m2.tab.c lex.yy.c -lfl
./parser input.py