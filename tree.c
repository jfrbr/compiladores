#include <stdlib.h>
#include "hash.h"

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

s_fator *executeNodeTree(NODETREEPTR node) {
	//debug();
	switch(node->tipoNodeTree) {
		case F_FATOR:
			return executaFator((s_fator*)node->element);
			break;
		case F_TERMO:
			return executeTermo((s_termo*)node->element,(list)(node->children->head->element));
			break;
		case F_EXP:
			return executeExp((s_exp*)node->element,(list)(node->children->head->element));
			break;
		case F_U_EXP:
			return executeU_Exp((s_u_exp*)node->element,(list)(node->children->head->element));
			break;
		case F_U_EXP_LIST:
			return executeU_Exp_List((s_u_exp_list*)node->element,(list)(node->children->head->element));
			break;

		default:
			break;

	}
	return NULL;
}

void setTreeNode(NODETREEPTR node,void* toSet, int tipo) {
	node->tipoNodeTree = tipo;
	node->element = toSet;
}

void appendToTreeNode(NODETREEPTR node,void* toAppend) {
	_toList(node->children,toAppend);
}
