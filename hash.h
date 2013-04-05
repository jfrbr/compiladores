#include <stdlib.h>
#include <stdio.h>
#include "list.h"
#include "function.h"
#include "fator.h"
#include "variable.h"
#include "tree.h"
#include "termo.h"
#include "exp.h"


#define T_INT 1
#define T_FLOAT 2
#define T_BOOLEAN 3
#define T_CHAR 4
#define T_STRING 5
#define T_VOID 6
#define T_VAR 10

// Constantes de Execucao
#define F_FATOR 7
#define F_TERMO 8
#define F_EXP 9



#define NOT_USING 0
#define USING 1

#define FLAG_FUNC 999

#define MAX_HASH_SIZE 997

list HashVar[MAX_HASH_SIZE];

void initHash(list *hash,int hashSize);
void destroyHash(list *hash,int hashSize);

void hashInsertVar(list *hash,s_variavel *var);
void hashInsertFunction(list *hash,s_funcao *function);

void hashVarUpdateValue(list *hash,char *nome,char *escopo, void* valor);
void hashVarUpdateUse(list *hash,char *nome,char *escopo, int uso);

s_variavel *hashSearchVar(list *hash,char *nome,char *escopo);
s_funcao *hashSearchFunction(list *hash,char *nome);
int sum_ascii(char *string);

int varExists(list *hash,char *nome,char *escopo);
int functionExists(list *hash,char *nome);

int checkVariables(list* hash);
