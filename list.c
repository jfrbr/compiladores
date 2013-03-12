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
	if(!l || !l->head || index > nList(l)-1) return NULL;
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
