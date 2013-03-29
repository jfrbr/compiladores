#include <stdlib.h>
#include "tree.h"

tree initTree() {
	tree aux = (tree)malloc(sizeof(struct tree));
	/*aux->head=NULL;
	aux->tail=NULL;
	aux->nElem = 0;*/
	if(aux) return aux;
	else {
		printf("Nao foi possivel alocar arvore");
		exit(3);
	}

}
NODETREEPTR allocateTreeNode() {

		NODETREEPTR aux;
		aux = (NODETREEPTR)malloc(sizeof(struct nodeTree));
		aux->children = initList();
		if (aux) return aux;
		else return NULL;

}
