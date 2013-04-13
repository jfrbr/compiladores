//#include "tree.h"
#ifndef ATRIB_H_
#define ATRIB_H_

struct {
	char op[3];
	char varname[50];
	//char *escopo;
	NODETREEPTR toatrib;
	char *stringToAtrib;
} typedef s_atrib;

s_atrib *allocateAtrib();
void executeAtrib(s_atrib *toExecute,list *hashVar);
void setAtrib(s_atrib *t, char *op, char *varname, /*char *escopo,*/ NODETREEPTR toatrib, char *stringToAtrib);

#endif /* ATRIB_H_ */
