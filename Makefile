all:
	flex -o trab1.c trab1.l
	gcc trab1.c -o trab1 -lfl
	latex -output-directory=doc/ doc/doc_trab1.tex 
	
clean:	
	rm trab1 doc/doc_trab1.dvi doc/doc_trab1.aux doc/doc_trab1.log

