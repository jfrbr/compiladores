all:	
	flex -i trab1.l
	bison -v analisador_sintatico.y
	gcc -otrab3 analisador_sintatico.tab.c -lfl
