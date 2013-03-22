#include <stdio.h>
#include <stdlib.h>
#include "list.h"
#include "parser.h"


int converType(char* type){

	if (!type) return -1;

	switch(type[0]) {
		case 'i':
			return 1;
		case 'f':
			return 2;
		case 'b':
			return 3;
		case 'c':
			return 4;
		case 's':
			return 5;
		case 'v':
			return 6;
		default:
			return -2;
	}
	return 0;
}


// Essa funao e' utilizada pra limpar uma lista de sublistas, como a lista de expressoes de um comando
void cleanExprList(list l) {
  printf("Passou1");
	if(!l || !(l->head)) {
	  printf("Lista nao iniciada\n");
	}
	
	int i,len = l->nElem; 
	
	for(i=0;i<len;i++) {
	    destroyList(getNode(l,i));
	}
	printf("Passou2");
	NODELISTPTR aux = l->head;
	for(i=0;i<len;i++) {
	    free(aux);
	    aux = aux->next;
	}
	
	free(l);
	l=initList();
	
	
}

int returnAtualVarType(){

	if ( strcmp(num_inteiro,"\0") ) return 1;
	if ( strcmp(num_float,"\0") ) return 2;
	if ( strcmp(num_boolean,"\0") ) return 3;
	if ( strcmp(num_char,"\0") ) return 4;
	if ( strcmp(num_string,"\0") ) return 5;

}

