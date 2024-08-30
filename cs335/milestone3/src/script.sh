#!/bin/bash
flex m2.l
bison -d m2.y
g++ -o parser m2.tab.c lex.yy.c -lfl
./parser input.py 2> error.txt > output.txt
g++ -o a X86.cpp
./a output.txt >  asm.s
gcc asm.s -o asm.o -no-pie
./asm.o