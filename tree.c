
#include <stdlib.h>
#include "hash.h"

tree initTree() {
	tree aux = (tree)malloc(sizeof(struct tree));
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
	s_fator *f,*r;
	s_variavel *v;
	switch(node->tipoNodeTree) {
		case F_FATOR:
			// Daqui pra baixo nao garanto nada
			f = (s_fator*)node->element;
			r = executaFator(f);

			if(f->tipo == T_VAR) {
				v = hashSearchVar(HashVar,(char*)f->valor,currentFunction);
				if(!v) {
					v = hashSearchVar(HashVar,(char*)f->valor,(char*)getNode(functionStack,functionStack->nElem-2));
				}

				if(f->parametros && f->parametros->head) {
					int *_t = getNode(f->parametros,0);
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
				}
			}
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
		case F_RETURN:
			{
			break;} // LOL {} break :)
		case F_SWITCH:
		    executeSwitch((s_switch*)node->element);
		    break;
		default:
			break;

	}
	return NULL;
}

s_fator* executeTreeList(list l) {
	if(!l) return NULL;
	NODELISTPTR aux = l->head;
	s_fator *r = NULL;
	for(int i=0;i<l->nElem && hasReturn==0; i++) {
		NODETREEPTR _tmp = aux->element;
		if (aux){

		    if(_tmp->tipoNodeTree == F_BREAK) {
		    	hasBreak = 1;
		    	break;
		    }
		    if(_tmp->tipoNodeTree == F_CONTINUE) {
				break;
			}
		    if(_tmp->tipoNodeTree == F_RETURN) {
				if(!_tmp->element) {
		    		break;
		    	}
		    	else {
		    		retValue = allocateFator();
		    		r = allocateFator();

		    		NODETREEPTR _testeTree = ((NODETREEPTR)(aux->element))->element;
		    		r = executeNodeTree(_testeTree);
		    		retValue = r;
		    		break;
		    	}
		    	hasReturn = 1;

			}

		    executeNodeTree(aux->element);
		    aux = aux->next;
		}else{
            printf("TREE LIST # AUX NULO\n");
		}
	}
	return r;
}

void setTreeNode(NODETREEPTR node,void* toSet, int tipo) {
	node->tipoNodeTree = tipo;
	node->element = toSet;
}

void appendToTreeNode(NODETREEPTR node,void* toAppend) {
	_toList(node->children,toAppend);
}

void printNodeTree(NODETREEPTR node){

    if (!node){
        printf("Node vazio. Abortando...\n");
        exit(1);
    }
    
	switch(node->tipoNodeTree) {
		case F_FATOR:
			imprimeFator((s_fator*)node->element);
			break;
		case F_TERMO:
			imprimeTermo((s_termo*)node->element,(list)(node->children->head->element));
			break;
		case F_EXP:
		    imprimeExp((s_exp*)node->element,(list)(node->children->head->element));
			break;
		case F_U_EXP:
            imprimeU_Exp((s_u_exp*)node->element,(list)(node->children->head->element));
			break;
		case F_U_EXP_LIST:

			imprimeU_Exp_List((s_u_exp_list*)node->element,(list)(node->children->head->element));
			break;
		case F_ATRIB:
			imprimeAtrib((s_atrib*)node->element);
			break;
		case F_CONDITIONAL:
			imprimeConditional((s_conditional*)node->element);
			break;
		case F_LOOP:
		    imprimeLoop((s_loop*)node->element);
		    break;
		case F_RETURN:
			{
			break;} // LOL {} break :)
		case F_SWITCH:
		    imprimeSwitch((s_switch*)node->element);
		    break;
		default:
			break;
	}
}

void printTreeList(list l,int flag) {

	if(!l) return;
	NODELISTPTR aux = l->head;
	
	for(int i=0;i<l->nElem; i++) {
		NODETREEPTR _tmp = aux->element;
		printNodeTree(aux->element);
		aux = aux->next;
        if (flag) printf("\n");
        else printf(" ");
    }
}
