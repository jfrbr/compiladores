#include <stdlib.h>
#include <stdio.h>
#include "list.h"
#include "function.h"
#include "fator.h"
#include "variable.h"
#include "tree.h"
#include "termo.h"
#include "exp.h"
#include "u_exp.h"
#include "u_exp_list.h"
<<<<<<< HEAD
#include "stdbool.h"
=======
#include "atrib.h"

extern char currentFunction[50];
>>>>>>> c2a54c418b21ed796164f29cee45c90f040fb902

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
#define F_U_EXP 11
#define F_U_EXP_LIST 12


// Variacoes de variavel
#define NEGATIVE_VALUE 1

#define F_ATRIB 13

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
