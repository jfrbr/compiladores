all:	
	flex -i trab1.l
	bison -v analisador_sintatico.y
	gcc -o trab2 analisador_sintatico.tab.c -lfl