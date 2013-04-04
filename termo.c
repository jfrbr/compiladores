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
		s_fator *a_v,*b_v,*r = malloc(sizeof(s_fator));

		int *res,*aint,*bint;
		float *resf,*afloat,*bfloat;
		res = malloc(sizeof(int));
		resf = malloc(sizeof(float));

		a_v = executeNodeTree(a);
		b_v = executeNodeTree(b);

		switch(toExecute->op) {
			// TODO Terminar os operadores - Quando terminar, passar pra exp
			case '*':

				// TODO Terminar essas combinacoes
				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) * *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*resf = (*(float*)(a_v->valor) * *(int*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*resf = (*(int*)(a_v->valor) * *(float*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*resf = (*(float*)(a_v->valor) * *(float*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}

				break;

			default:
				break;
		}
		return r;
	}

}

void setTermo(s_termo *t, char op) {
	t->op = op;

}
