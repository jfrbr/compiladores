all:	
	flex -i trab1.l
	gcc -c list.c variable.c function.c hash.c -std=c99
	bison -v analisador_sintatico.y
	gcc -o trab3 analisador_sintatico.tab.c -lfl list.o variable.o function.o hash.o 

