#ifndef SWITCH_H_
#define SWITCH_H_

struct switch_block{

    void* condition;
    list commands;
} typedef ssb;

struct {

	list commandList;
	char* check_value;
    char* check_value_s;

} typedef s_switch;

s_switch *allocateSwitch();
void setSwitch(s_switch* sw,char* check_value, char* check_value_s);
void addSsb(s_switch* sw, ssb* _ssb);
void executeSwitch(s_switch* sw);
void imprimeSwitch(s_switch* sw);
void imprimeSwitchBlock(ssb* s);

#endif /* SWITCH_H_ */
