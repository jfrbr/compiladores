#ifndef TREE_H_
#define TREE_H_

struct nodeTree {
	void* element;
	struct nodeTree* next;
	list children;
	// Para auxiliar na execuçao
	int tipoNodeTree;
};
typedef struct nodeTree* NODETREEPTR;

struct tree {
	NODETREEPTR head;
};
typedef struct tree* tree;

tree initTree();
NODETREEPTR allocateTreeNode();

void setTreeNode(NODETREEPTR node,void* toSet,int tipo);
void appendToTreeNode(NODETREEPTR node,void* toAppend);
s_fator *executeNodeTree(NODETREEPTR node);



#endif /* TREE_H_ */
