#include "hash.h"

s_loop *allocateLoop() {

	s_loop *aux;
		aux = (s_loop*)malloc(sizeof(s_loop));
		aux->commandList = initList();
		aux->atribList = initList();
		aux->incrementList = initList();
		
        aux->tipo = -1;
        
		if (aux) return aux;
		else return NULL;
}

void setLoop(s_loop* l,NODETREEPTR condition,list commandList,list atribList, list incrementList, int tipo) {
	l->condition = condition;
	l->commandList = commandList;
	l->atribList = atribList;
	l->incrementList = incrementList;
	l->tipo = tipo;
}

int checkConditionLoop(s_loop *l) {

    s_fator *f;
    
    if (l->condition){
    	f = executeNodeTree(l->condition);
    }else{
        return 1;
    }
    
	return *(int*)f->valor;
}

void executeLoop(s_loop* l) {

	printf("\n\nExecutando Loop\n");
	if (l){
	    if (l-> tipo == WHILE){
	                printf("Executando o loop while\n");
	        while(checkConditionLoop(l) != 0 && l->commandList->head && !hasBreak) {
	        	printf("\n\nIteracao HASBREAK: %d\n\n",hasBreak);
		        executeTreeList(l->commandList);
	        }
	    }else if (l->tipo == FOR){

            printf("Executando o loop for\n");

            executeTreeList(l->atribList);

            while(checkConditionLoop(l) != 0 && l->commandList->head) {
		        executeTreeList(l->commandList);
		        executeTreeList(l->incrementList);
	        }
	        
	    }else if (l->tipo == DO_WHILE){
	                printf("Executando o loop do while\n");
            do{
                executeTreeList(l->commandList);
            }while (checkConditionLoop(l) != 0 && l->commandList->head);

	    }else{
            printf("LOOP # TIPO NAO RECONHECIDO PELO LOOP\n");
	    }
	}else{
        printf("LOOP # S_LOOP NULO\n");
	}
	hasBreak = 0;
	printf("TO SAINDO DO EXECUTE LOOP\n");
}
