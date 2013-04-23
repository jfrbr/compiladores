
#ifndef FATOR_H_
#define FATOR_H_

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
//#include "hash.h"
#include "list.h"
#include "parser.h"

#define T_FUNCTION 7

struct {
	int tipo;
	void *valor;
	list parametros;
} typedef s_fator;

s_fator *allocateFator();
s_fator *executaFator(s_fator *toExecute);
void setFator(s_fator *f, int tipo,void *valor,list parList);

#endif /* FATOR_H_ */
