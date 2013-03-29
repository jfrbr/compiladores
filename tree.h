#ifndef TREE_H_
#define TREE_H_
#include "hash.h"

struct nodeTree {
	void* element;
	struct nodeTree* next;
	list children;
};
typedef struct nodeTree* NODETREEPTR;

struct tree {
	NODETREEPTR head;
};
typedef struct tree* tree;

tree initTree();
NODETREEPTR allocateTreeNode();



#endif /* TREE_H_ */
