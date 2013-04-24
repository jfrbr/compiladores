#include "hash.h"

s_programa *allocateProgram() {
	s_programa *aux = malloc(sizeof(s_programa));
	//initHash(aux->HashFunc,MAX_HASH_SIZE);
	//initHash(aux->Hash,MAX_HASH_SIZE);
	aux->cmdList = initList();

	aux->HashVar = calloc(MAX_HASH_SIZE,sizeof(list));
	initHash(aux->HashVar,MAX_HASH_SIZE);

	aux->HashFunc = calloc(MAX_HASH_SIZE,sizeof(list));
	initHash(aux->HashFunc,MAX_HASH_SIZE);

	return aux;
}
void setPrograma(s_programa *p,char *progName,list *hashVar,list *hashFunc,list cmdList) {
	strcpy(p->progNome,progName);
	p->HashVar = hashVar;
	p->HashFunc = hashFunc;
	p->cmdList = cmdList;
}

void executaPrograma(s_programa *p) {
	executeTreeList(p->cmdList);
}
void imprimePrograma(s_programa *p){
    printTreeList(p->cmdList,1);
}
