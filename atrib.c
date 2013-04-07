#include "hash.h"

s_atrib *allocateAtrib() {
	s_atrib *aux;
		aux = (s_atrib*)malloc(sizeof(s_atrib));
		//aux->parametros = initList();
		if (aux) return aux;
		else return NULL;
}

void executeAtrib(s_atrib *toExecute,list *hashVar) {
	s_fator *executeResult = executeNodeTree(toExecute->toatrib);
	hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,executeResult->valor);
}

void setAtrib(s_atrib *t, char *op, char *varname, NODETREEPTR toatrib, char *stringToAtrib) {

	strcpy(t->op,op);
	debug();
	strcpy(t->varname,varname);
	t->toatrib = toatrib;
	//strcpy(t->stringToAtrib,stringToAtrib);
}
