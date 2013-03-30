#include "hash.h"

s_termo *allocateTermo() {
	s_termo *aux;
		aux = (s_termo*)malloc(sizeof(s_termo));
		//aux->parametros = initList();
		if (aux) return aux;
		else return NULL;
}
void *executeTermo(s_termo *toExecute) {

}

void setTermo(s_termo *t, char op);
