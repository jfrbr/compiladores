
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
			printf("To executando um fator %d\n",f->tipo);
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
		    printf("TERMINEI DE EXECUTAR O LOOP\n");
		    break;
		case F_RETURN:
			{
				printf("Tem um return com expressao\n");
				//NODETREEPTR _tnode->element

			break;}
		case F_SWITCH:
		    printf("Achei um switch\n");
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
	printf("Executando Lista de arvores com %d elementos\n",l->nElem);
	for(int i=0;i<l->nElem && hasReturn==0; i++) {
		printf("Has Return: %d\n",hasReturn);

		NODETREEPTR _tmp = aux->element;
		printf("HASBREAK: %d\n",_tmp->tipoNodeTree);

		if (aux){

		    if(_tmp->tipoNodeTree == F_BREAK) {
		    	hasBreak = 1;
		    	break;
		    }
		    if(_tmp->tipoNodeTree == F_CONTINUE) {
				break;
			}
		    if(_tmp->tipoNodeTree == F_RETURN) {
		    	printf("\n\n\nPassei por aqui!\n\n\n");


		    	if(!_tmp->element) {
		    		break;
		    	}
		    	else {
		    		printf("Aqui tambem");
		    		//sleep(1);
		    		retValue = allocateFator();
		    		r = allocateFator();

		    		NODETREEPTR _testeTree = ((NODETREEPTR)(aux->element))->element;
		    		if(_testeTree) printf("Tambem sou uma arvore do tipo %d\n",_testeTree->tipoNodeTree);
		    		r = executeNodeTree(_testeTree);
		    		retValue = r;

		    		//if(retValue) printf("Executou com return: %d\n",*(int*)retValue->valor);
		    		break;
		    	}
		    	hasReturn = 1;

			}

		    executeNodeTree(aux->element);
		    aux = aux->next;
		}else{
            //printf("TREE LIST # AUX NULO\n");
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
