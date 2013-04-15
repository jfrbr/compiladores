/*
 * list.c
 *
 *  Created on: Mar 24, 2011
 *      Author: andre
 */

#include <stdio.h>
#include <stdlib.h>
#include "list.h"

void debug() {
	printf("entrou\n");
}

NODELISTPTR allocateNode() {
	NODELISTPTR aux;
	aux = (NODELISTPTR)malloc(sizeof(struct nodeList));
	if (aux) return aux;
	else return NULL;
}

list initList() {
	list aux = (list)malloc(sizeof(struct list));
	aux->head=NULL;
	aux->tail=NULL;
	aux->nElem = 0;
	return aux;
}

void* getNode(list l,int index) {
	if(!l || !l->head || index > nList(l)) {
		printf("FAIL\n");
		return NULL;
	}
	NODELISTPTR aux = l->head;
	for(int i=0; i<index; i++) aux = aux->next;
	return aux->element;
}

void addNode(list l,NODELISTPTR node) {
	if(!l||!l->head) {
		l->head = node;
		l->tail = node;
		l->nElem++;
		return;
	};
	if(l->head == l->tail) {
		l->head->next = node;
		l->tail = node;
		l->nElem++;
		return;
	}
	l->tail->next = node;
	l->tail = node;
	l->nElem++;
}

int nList(list l) {
	if(!l||!l->head) return 0;
	NODELISTPTR aux = l->head;
	int i=0;
	while(aux) {i++; aux = aux->next;}
	return i;
}

NODELISTPTR copyNode(NODELISTPTR p) {
	NODELISTPTR aux;
	aux = (NODELISTPTR)malloc(sizeof(struct nodeList));
	aux->element = p->element;
	return aux;
}

void removeFromList(list l,int index) {
	NODELISTPTR aux = l->head,aux2;
	
	if(index > l->nElem-1) {
	    printf("Indice %d nao existe na lista\n",index);
	    return;
	}
	  
	//delete 5
//	0 - 1 - 2 - 3 - 4 - 5 - 6
	for(int i=0; i< index-1; i++) aux = aux->next;
	
	//if(aux->next) {
	  if(aux->next->next) {
	    // l->tail nao muda
	    aux2 = aux->next->next;
	  }
	  else {
	    l->tail = aux;
	    aux2 = NULL;	  
	  }  
	
	
	if(index != 0) {
	  free(aux->next);
	  aux->next = aux2;
	}
	else {
	  l->head = aux->next;
	  free(aux);	  
	}
	
	l->nElem--;
	  

}

void removeWithoutFreeFromList(list l,int index) {
	NODELISTPTR aux = l->head,aux2;

	if(index > l->nElem-1) {
	    printf("Indice %d nao existe na lista\n",index);
	    return;
	}

	if(l->nElem == 1) {
		l = initList();
		return;
	}
	  
	//delete 5
//	0 - 1 - 2 - 3 - 4 - 5 - 6
	for(int i=0; i< index-1; i++) aux = aux->next;

	//if(aux->next) {
	  if(aux->next->next) {
	    // l->tail nao muda
	    aux2 = aux->next->next;
	  }
	  else {
	    l->tail = aux;
	    aux2 = NULL;
	  }
	
	
	if(index != 0) {
	  //free(aux->next);
	  aux->next = aux2;
	}
	else {
	  l->head = aux->next;
	  //free(aux);
	}
	
	l->nElem--;

	
}

void destroyList(list l) {
	NODELISTPTR aux,aux2=l->head;
	for(int i=0; i<l->nElem; i++) {
		aux = aux2;
		aux2 = aux2->next;
		free(aux->element);
		free(aux);
		aux->element = NULL;
		aux = NULL;
	}
	free(l);
	l = NULL;
}

void _toList(list l, void *var) {	
		NODELISTPTR op = allocateNode();
		op->element = var;		
		addNode(l,op);
}
