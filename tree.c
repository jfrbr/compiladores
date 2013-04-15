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
	s_fator *f,*r;
	s_variavel *v;
	switch(node->tipoNodeTree) {
		case F_FATOR:
			f = (s_fator*)node->element;
			r = executaFator(f);
			if(f->tipo == T_VAR) {
				printf("Executando Variavel aaeHOOOOOOOOOOOOOOOOOO\n");
				v = hashSearchVar(HashVar,(char*)f->valor,"main");
				//s_fator* fteste = allocateFator();
				printf("tipo = %d\n",v->tipo);

				if(f->parametros && f->parametros->head) {
					//printf("'E nois Aqui: %d\n",*(int*)(toExecute->parametros->head->element));
					int *_t = getNode(f->parametros,0);
					printf("'E nois Aqui: %d\n",*(int*)_t);
					if(*(int*)_t == P_MAISMAISAFT) {
						if(r->tipo == T_INT) {
							int _tmp = *(int*)r->valor + 1;
							*(int*)r->valor = _tmp;
						}
						else if(r->tipo == T_CHAR) {
							char _tmp = *(char*)r->valor + 1;
							*(char*)r->valor = _tmp;
						}
						else if(r->tipo == T_FLOAT) {
							float _tmp = *(float*)r->valor + 1;
							*(float*)r->valor = _tmp;
						}
					} else if(*(int*)_t == P_MENOSMENOSAFT) {
						if(r->tipo == T_INT) {
							int _tmp = *(int*)r->valor - 1;
							*(int*)r->valor = _tmp;
						}
						else if(v->tipo == T_CHAR) {
							char _tmp = *(char*)r->valor - 1;
							*(char*)r->valor = _tmp;
						}
						else if(r->tipo == T_FLOAT) {
							float _tmp = *(float*)r->valor - 1;
							*(float*)r->valor = _tmp;
						}
					}
					//if(*_t) printf("T ok\n");

				}

			}
			//return executaFator((s_fator*)node->element);
			return r;
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
		case F_ATRIB:
			executeAtrib((s_atrib*)node->element,HashVar);
			return NULL;
			break;
		case F_CONDITIONAL:
			executeConditional((s_conditional*)node->element);
			return NULL;
			break;
		case F_LOOP:
		    executeLoop((s_loop*)node->element);
		    break;
		default:
			break;

	}
	return NULL;
}

void executeTreeList(list l) {
	if(!l) return;
	NODELISTPTR aux = l->head;
	printf("Executando Lista de arvores com %d elementos",l->nElem);
	for(int i=0;i<l->nElem; i++) {
		executeNodeTree(aux->element);
		aux = aux->next;
	}
}

void setTreeNode(NODETREEPTR node,void* toSet, int tipo) {
	node->tipoNodeTree = tipo;
	node->element = toSet;
}

void appendToTreeNode(NODETREEPTR node,void* toAppend) {
	_toList(node->children,toAppend);
}
