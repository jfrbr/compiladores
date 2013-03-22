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