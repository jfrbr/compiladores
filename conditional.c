#include "hash.h"

s_conditional *allocateConditional() {
	s_conditional *aux;
		aux = (s_conditional*)malloc(sizeof(s_conditional));
		aux->commandList = initList();
		aux->elseCommandList = initList();
		//aux->condition = initTree();
		//aux->parametros = initList();
		if (aux) return aux;
		else return NULL;
}

void setConditional(s_conditional *cond,NODETREEPTR condition,list commandList,list elseCommandList ) {
	cond->condition = condition;
	cond->commandList = commandList;
	cond->elseCommandList = elseCommandList;
}

int checkCondition(s_conditional *cond) {
	s_fator *f = executeNodeTree(cond->condition);
	return *(int*)f->valor;
}

void executeConditional(s_conditional* cond) {
	printf("Executando Condicional\n");
	if(checkCondition(cond) != 0 && cond->commandList->head) {
		executeTreeList(cond->commandList);
	}
	else
		if(cond->elseCommandList->head)
			executeTreeList(cond->elseCommandList);

}
