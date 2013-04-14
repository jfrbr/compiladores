#ifndef LOOP_H_
#define LOOP_H_

struct {
	NODETREEPTR condition;
	list commandList;
	list atribList;
	list incrementList;
	int tipo;
} typedef s_loop;

s_loop *allocateLoop();
void setLoop(s_loop* l,NODETREEPTR condition,list commandList,list atribList, list incrementList, int tipo);
int checkConditionLoop(s_loop *l);
void executeLoop(s_loop* l);

#endif /* LOOP_H_ */
