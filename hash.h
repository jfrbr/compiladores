#include <stdlib.h>
#include <stdio.h>
#include "list.h"
#include "function.h"
#include "variable.h"

#define T_INT 1
#define T_FLOAT 2
#define T_BOOLEAN 3
#define T_CHAR 4
#define T_STRING 5
#define T_VOID 6

#define MAX_HASH_SIZE 997


void initHash(list *hash,int hashSize);
void destroyHash(list *hash,int hashSize);

void hashInsertVar(list *hash,s_variavel *var);
void hashInsertFunction(list *hash,s_funcao *function);

s_variavel *hashSearchVar(list *hash,char *nome,char *escopo);
s_funcao *hashSearchFunction(list *hash,char *nome);
int sum_ascii(char *string);

int varExists(list *hash,char *nome,char *escopo);
int functionExists(list *hash);

int checkVariables(list* hash);