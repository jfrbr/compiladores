#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "function.h"
#include "hash.h"



/*void hashInsertVar(s_variavel **hash,s_variavel *var) {
  int i = sum_ascii(var->nome)%MAX_HASH_SIZE;
  hash[i] = var;
}*/

void initHash(list *hash,int hashSize) {
	for(int i=0; i<hashSize; i++) {
		hash[i] = initList();
	}
}

void destroyHash(list *hash,int hashSize) {
	for(int i=0; i<hashSize; i++) {
			destroyList(hash[i]);
		}
}

void hashInsertVar(list *hash,s_variavel *var) {
  int i = sum_ascii(var->nome)%MAX_HASH_SIZE;

  NODELISTPTR node = allocateNode();
  node->element = var;
  addNode(hash[i],node);
}

s_variavel *hashSearchVar(list *hash,char *nome,char *escopo) {
	int index = sum_ascii(nome)%MAX_HASH_SIZE;
	if(!hash[index]) return NULL;
	s_variavel *aux;
	for(int j=0; j < hash[index]->nElem; j++) {
		aux = ((s_variavel*)(getNode(hash[index],j)));
		if((strcmp(aux->nome,nome) == 0) && (strcmp(aux->escopo,escopo) == 0)) return aux;
	}
	return NULL;
}

void hashVarUpdateValue(list *hash,char *nome,char *escopo, void* valor) {

	int index = sum_ascii(nome)%MAX_HASH_SIZE;
	if(!hash[index]) return;
	s_variavel *aux;
	for(int j=0; j < hash[index]->nElem; j++) {
		aux = ((s_variavel*)(getNode(hash[index],j)));
		if((strcmp(aux->nome,nome) == 0) && (strcmp(aux->escopo,escopo) == 0)){
			aux->valor = valor;
			return;
		}
	}
	return;
}
void hashVarUpdateUse(list *hash,char *nome,char *escopo, int uso) {

	int index = sum_ascii(nome)%MAX_HASH_SIZE;
	if(!hash[index]) return;
	s_variavel *aux;
	for(int j=0; j < hash[index]->nElem; j++) {
		aux = ((s_variavel*)(getNode(hash[index],j)));
		if((strcmp(aux->nome,nome) == 0) && (strcmp(aux->escopo,escopo) == 0)){
			aux->used = uso;
			return;
		}
	}
	return;
}

void hashInsertFunction(list *hash,s_funcao *function) {
  int i = sum_ascii(function->nome)%MAX_HASH_SIZE;

  NODELISTPTR node = allocateNode();
  node->element = function;
  addNode(hash[i],node);
}


s_funcao *hashSearchFunction(list *hash,char *nome) {
	int index = sum_ascii(nome)%MAX_HASH_SIZE;
	if(!hash[index]) return NULL;
	s_funcao *aux;
	for(int j=0; j < hash[index]->nElem; j++) {
		aux = ((s_funcao*)(getNode(hash[index],j)));
		if(strcmp(aux->nome,nome) == 0) return aux;
	}
	return NULL;
}

int sum_ascii(char *string) {
  int i = 0;
  int ascii = 0;
  for(i=0;string[i]!='\0';i++) {
    ascii += string[i];
  }
  return ascii;
}

int varExists(list *hash,char *nome,char *escopo) {
	s_variavel *aux = hashSearchVar(hash,nome,escopo);

	if(aux) return 1;
	else return 0;
}

int funcExists(list *hash,char *nome) {
	s_funcao *aux = hashSearchFunction(hash,nome);

	if(aux) return 1;
	else return 0;
}
int checkVariables(list* hash){

	if (!hash) return -1;

	for (int i=0; i < MAX_HASH_SIZE; i++){
		if (hash[i]->nElem > 0){
			for (int j=0; j < hash[i]->nElem; j++){
				list l = hash[i];
				s_variavel* v = getNode(l,j);
				if (v->used == NOT_USING){
					 printf("A variavel %s/%s nao foi utilizada\n",v->nome,v->escopo);
				}
			}
		}
	}

}

/*int main() {
  s_variavel *teste = allocateVar(),*teste2=allocateVar();
  list genericHashVar[MAX_HASH_SIZE],hashFunction[MAX_HASH_SIZE];

  for(int i=0; i<MAX_HASH_SIZE; i++) {
	  genericHashVar[i] = initList();
	  hashFunction[i] = initList();
  }

  setVar(teste,"Teste",NULL,T_FLOAT,"main");
  setVar(teste2,"Tdsue",NULL,T_FLOAT,"main");

  hashInsertVar(genericHashVar,teste);
  hashInsertVar(genericHashVar,teste2);

  s_funcao *bolada = allocateFunction();
  setFunction(bolada,"Bingo",2,T_FLOAT,NULL);

  hashInsertFunction(hashFunction,bolada);

  //printf("Teste: %d, isFloat: %s\n",sum_ascii(((s_variavel*)(getNode(genericHashVar[517],1)->element))->nome),((s_variavel*)(getNode(genericHashVar[517],1)->element))->nome);
  printf("Search teste: %s\n",hashSearchFunction(hashFunction,"Bingo")->nome);

}
*/
