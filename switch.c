#include "hash.h"

s_switch *allocateSwitch() {

	s_switch *aux;
		aux = (s_switch*)malloc(sizeof(s_switch));
		aux->commandList = initList();
		aux->atribList = initList();
		aux->incrementList = initList();
		
        aux->tipo = -1;
        
		if (aux) return aux;
		else return NULL;
}

void setSwitch(s_switch* sw,NODETREEPTR condition,list commandList,list atribList, list incrementList, int tipo) {
	sw->condition = condition;
	sw->commandList = commandList;
	sw->atribList = atribList;
	sw->incrementList = incrementList;
	sw->tipo = tipo;
}

void executeSwitch(s_switch* sw) {

	printf("\n\nExecutando Switch\n");
	if (sw){
	
	}else{
        printf("LOOP # S_LOOP NULO\n");
	}
	hasBreak = 0;
}
