#ifndef SWITCH_H_
#define SWITCH_H_

struct {
	NODETREEPTR condition;
	list commandList;
	list atribList;
	list incrementList;
	int tipo;
} typedef s_switch;

s_switch *allocateSwitch();
void setSwitch(s_switch* sw,NODETREEPTR condition,list commandList,list atribList, list incrementList, int tipo);
void executeSwitch(s_switch* sw);

#endif /* SWITCH_H_ */
