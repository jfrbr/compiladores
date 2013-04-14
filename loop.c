#include "hash.h"

s_loop *allocateLoop() {

	s_loop *aux;
		aux = (s_loop*)malloc(sizeof(s_loop));
		aux->commandList = initList();
		aux->atribList = initList();
		aux->incrementList = initList();
		
        aux->tipo = -1;
        
		if (aux) return aux;
		else return NULL;
}

void setLoop(s_loop* l,NODETREEPTR condition,list commandList,list atribList, list incrementList, int tipo) {
	l->condition = condition;
	l->commandList = commandList;
	l->atribList = atribList;
	l->incrementList = incrementList;
	l->tipo = tipo;
}

int checkConditionLoop(s_loop *l) {
	s_fator *f = executeNodeTree(l->condition);
	
	return *(int*)f->valor;
}

void executeLoop(s_loop* l) {
	printf("\n\nExecutando Loop\n");
	while(checkConditionLoop(l) != 0 && l->commandList->head) {
		executeTreeList(l->commandList);
	}
}
