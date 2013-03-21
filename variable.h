#ifndef VARIABLE_H_
#define VARIABLE_H_
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "list.h"

struct  {
  char nome[30];
  void *valor;
  int tipo;
  char escopo[30];
  int lineDeclared;
  // TODO adicionar atributo para tratar vetores e matrizes
} typedef s_variavel;


s_variavel* allocateVar();
void setVar(s_variavel *var,char *nome,void *valor,int tipo,char *escopo,int lineDeclared);
int checkVarType(s_variavel *var,int tipo);


#endif /* VARIABLE_H_ */
