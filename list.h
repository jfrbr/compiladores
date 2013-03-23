/*
 * list.h
 *
 *  Created on: Mar 24, 2011
 *      Author: andre
 */

#ifndef LIST_H_
#define LIST_H_

struct nodeList {
	void* element;
	struct nodeList* next;
};
typedef struct nodeList* NODELISTPTR;

struct list {
	NODELISTPTR head;
	NODELISTPTR tail;
	int nElem;
};
typedef struct list* list;

void debug();
list initList();
void addNode(list l, NODELISTPTR node);
void* getNode(list l,int index);
NODELISTPTR allocateNode();
NODELISTPTR copyNode(NODELISTPTR p);
int nList(list l);
void removeFromList(list l,int index);
void destroyList(list l);
void _toList(list l,void *var);


#endif /* LIST_H_ */
