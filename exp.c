#include "hash.h"

s_exp *allocateExp() {
	s_exp *aux;
		aux = (s_exp*)malloc(sizeof(s_exp));
		//aux->parametros = initList();
		if (aux) return aux;
		else return NULL;
}

void *executeExp(s_exp *toExecute, list operands) {
	printf("Operands Exp size: %d\n",operands->nElem);
	if(operands->nElem == 1) {
		//if((NODETREEPTR)(getNode((list)(operands),0))) printf("passei %d\n", ((NODETREEPTR)(getNode((list)(operands),0)))->tipoNodeTree);
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
		printf("Executou A\n");
        

		b_v = executeNodeTree(b);
		printf("Executou B\n");


		switch(toExecute->op) {

			case '+':
				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) + *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*resf = (*(float*)(a_v->valor) + *(int*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*resf = (*(int*)(a_v->valor) + *(float*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*resf = (*(float*)(a_v->valor) + *(float*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) + *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) + *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*resf = (*(float*)(a_v->valor) + *(char*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*resf = (*(char*)(a_v->valor) + *(float*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) + *(char*)(b_v->valor));
					r->tipo = T_CHAR;
					r->valor = res;
				}
				break;

			case '-':
				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) - *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*resf = (*(float*)(a_v->valor) - *(int*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*resf = (*(int*)(a_v->valor) - *(float*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*resf = (*(float*)(a_v->valor) - *(float*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) - *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) - *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*resf = (*(float*)(a_v->valor) - *(char*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*resf = (*(char*)(a_v->valor) - *(float*)(b_v->valor));
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) - *(char*)(b_v->valor));
					r->tipo = T_CHAR;
					r->valor = res;
				}
				break;


			default:
				break;
		}
		return r;
	}

}

void setExp(s_exp *t, char op) {
	t->op = op;

}



