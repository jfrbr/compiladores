#include "variable.h"

s_variavel* allocateVar() {
	s_variavel *aux;
	aux = (s_variavel*)malloc(sizeof(s_variavel));
	if (aux) return aux;
	else return NULL;
}

void setVar(s_variavel *var,char *nome,void *valor,int tipo,char *escopo) {
	if(!var) {
		printf("Ponteiro pra Var nulo\n");
		exit(1);
	}
	strcpy(var->nome,nome);
	var->valor = valor;
	var->tipo = tipo;
	strcpy(var->escopo,escopo);
}

int checkVarType(s_variavel *var,int tipo) {
	return (var) && var->tipo == tipo;
}
