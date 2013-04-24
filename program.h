

#ifndef PROGRAM_H_
#define PROGRAM_H_

#include "hash.h"
struct {
	char progNome[50];
	list *HashVar;
	list *HashFunc;
	list cmdList;
} typedef s_programa;

s_programa *allocateProgram();
void setPrograma(s_programa *p,char *progName,list hashVar[MAX_HASH_SIZE],list hashFunc[MAX_HASH_SIZE],list cmdList);
void executaPrograma(s_programa *p);
void imprimePrograma(s_programa *p);


#endif /* PROGRAM_H_ */
