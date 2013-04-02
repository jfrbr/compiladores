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

		return executaFator((s_fator*)(((NODETREEPTR)(getNode((list)(operands),0)))->element));
	}
	else {
		NODETREEPTR a,b;
		a = ((NODETREEPTR)(getNode((list)(operands),0)));
		b = ((NODETREEPTR)(getNode((list)(operands),1)));
		void *a_v,*b_v,*r;
		int *res;
		res = malloc(sizeof(int));

		switch(toExecute->op) {
			case '*':
				if(a)
				/*switch(a->tipoNodeTree) {
					case T_INT:
						///int a_v;
						//a_v = (int*)malloc(sizeof(int));
						break;
					case T_FLOAT:
						//a_v = (float*)malloc(sizeof(float));
						break;
				}
				switch(b->tipoNodeTree) {
					case T_INT:
						///int a_v;
						//b_v = (int*)malloc(sizeof(int));
						break;
					case T_FLOAT:
						//b_v = (float*)malloc(sizeof(float));
						break;
				}*/
				printf("Valor1: %d",a->tipoNodeTree);
				a_v = executeNodeTree(a);
				b_v = executeNodeTree(b);


				//printf("Valor: %d",*(int*)a_v * *(int*)b_v);
				printf("Valor: %d",*(int*)b_v);
				printf("Passou1\n");
				debug();

				*res = (*(int*)a_v * *(int*)b_v);
				r = malloc(sizeof(int));
				//r = (int*)r;
				r = res;

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
