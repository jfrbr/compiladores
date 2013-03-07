

#include "function.h"

s_funcao* allocateFunction() {
	s_funcao *aux;
	aux = (s_funcao*)malloc(sizeof(s_funcao));
	if (aux) return aux;
	else return NULL;
}

void setFunction(s_funcao *function,char *nome,int aridade,int tipo_retorno,list parametros) {
	if(!function) {
		printf("Ponteiro pra Var nulo\n");
		exit(1);
	}
	strcpy(function->nome,nome);
	function->aridade = aridade;
	function->tipo_retorno = tipo_retorno;
	function->parametros = parametros;
}

int checkArity(s_funcao *function,int arity) {
	return (function) && function->aridade == arity;
}

int checkReturnType(s_funcao *function,int returnType) {
	return (function) && function->tipo_retorno == returnType;
}
//int
