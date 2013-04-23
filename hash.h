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
#include "stdbool.h"
#include "atrib.h"
#include "conditional.h"
#include "loop.h"
#include "switch.h"

extern char currentFunction[50];
extern int find_ok;
int hasBreak;
int hasReturn;
s_fator *retValue;
extern list functionStack;

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
#define F_BREAK 17
#define F_CONTINUE 18
#define F_RETURN 19
#define F_FUNCAO 20

// Variacoes de variavel
#define NEGATIVE_VALUE 1
#define P_MAISMAISANT 2
#define P_MENOSMENOSANT 3
#define P_MAISMAISAFT 4
#define P_MENOSMENOSAFT 5

#define RETURN_VAR_NAME 6

// Comandos Especiais
#define F_ATRIB 13
#define F_CONDITIONAL 14
#define F_DEC 16
#define F_LOOP 15
#define F_SWITCH 32

// Variacoes LOOP
#define WHILE 0
#define DO_WHILE 1
#define FOR 2

#define NOT_USING 0
#define USING 1

#define FLAG_FUNC 999

#define MAX_HASH_SIZE 997

list HashVar[MAX_HASH_SIZE];
list HashFunc[MAX_HASH_SIZE];

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

