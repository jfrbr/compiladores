#ifndef U_EXP_H_
#define U_EXP_H_

#include "hash.h"

struct {
	char op[2];
	//void *valor;
	//list parametros;
} typedef s_u_exp;

s_u_exp *allocateU_Exp();
void *executeU_Exp(s_u_exp *toExecute,list operands);
void setU_Exp(s_u_exp *t, char *op);

#endif /* U_EXP_H_ */
