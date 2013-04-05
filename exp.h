#ifndef EXP_H_
#define EXP_H_

#include "hash.h"

struct {
	char op;
	//void *valor;
	//list parametros;
} typedef s_exp;

s_exp *allocateExp();
void *executeExp(s_exp *toExecute,list operands);
void setExp(s_exp *t, char op);

#endif /* EXP_H_ */
