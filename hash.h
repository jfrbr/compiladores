#include <stdlib.h>
#include <stdio.h>
#include "list.h"

#define T_INT 1
#define T_FLOAT 2
#define T_BOOLEAN 3
#define T_CHAR 4
#define T_STRING 5

#define MAX_HASH_SIZE 997

struct  {
  char nome[30];
  void *valor;
  int tipo;
  char escopo[30];
} typedef s_variavel;
s_variavel* allocateVar();

void setVar(s_variavel *var,char *nome,void *valor,int tipo,char *escopo);
int checkVarType(s_variavel *var,int tipo);

void hashInsertVar(list *hash,s_variavel *var);
s_variavel *hashSearchVar(list *hash,char *nome);
s_funcao *hashSearchFunction(list *hash,char *nome);
int sum_ascii(char *string);
