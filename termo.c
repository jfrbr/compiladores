#include "hash.h"

s_termo *allocateTermo() {
	s_termo *aux;
		aux = (s_termo*)malloc(sizeof(s_termo));
		if (aux) return aux;
		else return NULL;
}

void *executeTermo(s_termo *toExecute, list operands) {
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
		int* v_parameter = malloc(sizeof(int));
		int a_mult=1,b_mult=1;
		res = malloc(sizeof(int));
		resf = malloc(sizeof(float));
		a_v = executeNodeTree(a);
		b_v = executeNodeTree(b);

		// There's a long journey ahead, be careful
		switch(toExecute->op) {

			case '*':
				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) * *(int*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_INT;
					r->valor = res;
					printf("a->valor = %d\n",*(int*)a_v->valor);
					printf("b->valor = %d\n",*(int*)b_v->valor);
					printf("r->valor = %d\n",*(int*)r->valor);
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*resf = (*(float*)(a_v->valor) * *(int*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*resf = (*(int*)(a_v->valor) * *(float*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*resf = (*(float*)(a_v->valor) * *(float*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) * *(char*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) * *(int*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*resf = (*(float*)(a_v->valor) * *(char*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*resf = (*(char*)(a_v->valor) * *(float*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) * *(char*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_CHAR;
					r->valor = res;
				}
				break;

			case '/':
				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) / *(int*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*resf = (*(float*)(a_v->valor) / *(int*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*resf = (*(int*)(a_v->valor) / *(float*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*resf = (*(float*)(a_v->valor) / *(float*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) / *(char*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) / *(int*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*resf = (*(float*)(a_v->valor) / *(char*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*resf = (*(char*)(a_v->valor) / *(float*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_FLOAT;
					r->valor = resf;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) / *(char*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_CHAR;
					r->valor = res;
				}
				break;

			case '%':
				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) % *(int*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) % *(int*)(b_v->valor))*a_mult*b_mult;
					r->tipo = T_INT;
					r->valor = res;
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
