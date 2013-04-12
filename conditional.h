#ifndef CONDITIONAL_H_
#define CONDITIONAL_H_

struct {
	NODETREEPTR condition;
	list commandList;
	list elseCommandList;
} typedef s_conditional;

s_conditional *allocateConditional();
void setConditional(s_conditional *cond,NODETREEPTR condition,list commandList,list elseCommandList);
int checkCondition(s_conditional *cond);
void executeConditional(s_conditional* cond);

#endif /* CONDITIONAL_H_ */
