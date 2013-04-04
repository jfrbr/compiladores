#include "hash.h"

s_termo *allocateTermo() {
	s_termo *aux;
		aux = (s_termo*)malloc(sizeof(s_termo));
		//aux->parametros = initList();
		if (aux) return aux;
		else return NULL;
}

void *executeTermo(s_termo *toExecute, list operands) {
	printf("Operands size: %d\n",operands->nElem);
	if(operands->nElem == 1) {
		return executeNodeTree((NODETREEPTR)(getNode((list)(operands),0)));
	}
	else {
		NODETREEPTR a,b;
		a = ((NODETREEPTR)(getNode((list)(operands),0)));
		b = ((NODETREEPTR)(getNode((list)(operands),1)));
		s_fator *a_v,*b_v,*r;
		int *res;
		res = malloc(sizeof(int));

		switch(toExecute->op) {
			case '*':
				a_v = executeNodeTree(a);
				b_v = executeNodeTree(b);

				/*if(a->tipoNodeTree == F_FATOR) {
					int tfatora = ((s_fator*)(a->element))->tipo;
				}
				if(b->tipoNodeTree == F_FATOR) {

				}*/
				//printf("Valor: %d",*(int*)a_v * *(int*)b_v);
				printf("Valor: %d",*(int*)b_v->valor);
				printf("Passou1\n");
				debug();

				*res = (*(int*)(a_v->valor) * *(int*)(b_v->valor));
				r = malloc(sizeof(int));
				//r = (int*)r;
				r->valor = res;
				r->tipo = T_INT;

				printf("Res: %d\nR: %d\n",*res,*(int*)r);
				return r;
				break;

			default:
				break;
		}
	}

}

void setTermo(s_termo *t, char op) {
	t->op = op;

}
