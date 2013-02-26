all:	
	flex -i trab1.l
	bison analizador_sintatico.y
	gcc -otrab3 analizador_sintatico.tab.c -lfl
