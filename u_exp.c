#include "hash.h"

s_u_exp *allocateU_Exp() {
	s_u_exp *aux;
		aux = (s_u_exp*)malloc(sizeof(s_u_exp));
		if (aux) return aux;
		else return NULL;
}

void *executeU_Exp(s_u_exp *toExecute, list operands) {
	if(operands->nElem == 1) {
		return executeNodeTree((NODETREEPTR)(getNode((list)(operands),0)));
	}
	else {
		NODETREEPTR a,b;
		a = ((NODETREEPTR)(getNode((list)(operands),0)));
		b = ((NODETREEPTR)(getNode((list)(operands),1)));
		s_fator *a_v,*b_v,*r = malloc(sizeof(s_fator));
		int *res,*aint,*bint;
		float *afloat,*bfloat;
		res = malloc(sizeof(int));
		a_v = executeNodeTree(a);
		b_v = executeNodeTree(b);

		// < > <= >= == !=
			if(!strcmp(toExecute->op,"<")) {

				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {

					*res = (*(int*)(a_v->valor) < *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*res = (*(float*)(a_v->valor) < *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*res = (*(int*)(a_v->valor) < *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*res = (*(float*)(a_v->valor) < *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) < *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) < *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*res = (*(float*)(a_v->valor) < *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*res = (*(char*)(a_v->valor) < *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) < *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
			}
			else if(!strcmp(toExecute->op,">")) {

				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) > *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*res = (*(float*)(a_v->valor) > *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*res = (*(int*)(a_v->valor) > *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*res = (*(float*)(a_v->valor) > *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) > *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) > *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*res = (*(float*)(a_v->valor) > *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*res = (*(char*)(a_v->valor) > *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) > *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
			}else if(!strcmp(toExecute->op,"<=")) {

				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) <= *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {

					*res = (*(float*)(a_v->valor) <= *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
					
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*res = (*(int*)(a_v->valor) <= *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*res = (*(float*)(a_v->valor) <= *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) <= *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) <= *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*res = (*(float*)(a_v->valor) <= *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*res = (*(char*)(a_v->valor) <= *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) <= *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
			}else if(!strcmp(toExecute->op,">=")) {

				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) >= *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*res = (*(float*)(a_v->valor) >= *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*res = (*(int*)(a_v->valor) >= *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*res = (*(float*)(a_v->valor) >= *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) >= *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) >= *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*res = (*(float*)(a_v->valor) >= *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*res = (*(char*)(a_v->valor) >= *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) >= *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
			}else if(!strcmp(toExecute->op,"==")) {

				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) == *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*res = (*(float*)(a_v->valor) == *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*res = (*(int*)(a_v->valor) == *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*res = (*(float*)(a_v->valor) == *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) == *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) == *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*res = (*(float*)(a_v->valor) == *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*res = (*(char*)(a_v->valor) == *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) == *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
			}else if(!strcmp(toExecute->op,"!=")) {

				if(a_v->tipo == T_INT && b_v->tipo == T_INT) {
					*res = (*(int*)(a_v->valor) != *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;

				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_INT) {
					*res = (*(float*)(a_v->valor) != *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_FLOAT) {
					*res = (*(int*)(a_v->valor) != *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {
					*res = (*(float*)(a_v->valor) != *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_INT && b_v->tipo == T_CHAR) {
					*res = (*(int*)(a_v->valor) != *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_INT) {
					*res = (*(char*)(a_v->valor) != *(int*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_FLOAT && b_v->tipo == T_CHAR) {
					*res = (*(float*)(a_v->valor) != *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_FLOAT) {
					*res = (*(char*)(a_v->valor) != *(float*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}
				else if(a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {
					*res = (*(char*)(a_v->valor) != *(char*)(b_v->valor));
					r->tipo = T_INT;
					r->valor = res;
				}

			}
		return r;
	}
}

void setU_Exp(s_u_exp *t, char *op) {
	strcpy(t->op,op);
}
