#include "hash.h"

s_switch *allocateSwitch() {
	s_switch *aux;
		aux = (s_switch*)malloc(sizeof(s_switch));
		aux->commandList = initList();
		aux->check_value = malloc(50*sizeof(char));
		aux->check_value_s = malloc(50*sizeof(char));
		if (aux) return aux;
		else return NULL;
}

void setSwitch(s_switch* sw,char* check_value, char* check_value_s) {
	strcpy(sw->check_value, check_value);
	strcpy(sw->check_value_s, check_value_s);
}

void addSsb(s_switch* sw, ssb* _ssb){
    _toList(sw->commandList, _ssb);
}
void executeSwitch(s_switch* sw) {
	NODELISTPTR _tracker = sw->commandList->head;
	int i;
	void* condition;
	int type = -1;
	if (sw){
	    s_variavel* v = hashSearchVar(HashVar,sw->check_value,sw->check_value_s);
	    if (v){
            condition = v->valor;
            for (i=0; i < sw->commandList->nElem && !hasBreak && !hasReturn;i++){
                ssb* s = (ssb*) _tracker->element;
                if (s->condition == NULL){
                    executeTreeList(s->commands);
                    break;
                }else{
                    if (v->tipo == T_INT){

                        if (*(int*) condition  == *(int*) s->condition){
                            executeTreeList(s->commands);
                        }    
                    }else if (v->tipo == T_CHAR){
                        if (*(char*) condition == *(char*) s->condition){
                            executeTreeList(s->commands);
                        }
                    }
                }
                _tracker = _tracker->next;
            }
        }else{
            printf("SWITCH # NAO ACHEI VARIAVEL NA HASH\n");
        }
	}else{
        printf("SWITCH # S_SWITCH NULO\n");
	}
	hasBreak = 0;
}

void imprimeSwitch(s_switch* sw){

    NODELISTPTR _tracker = sw->commandList->head;

    printf("Switch: ");
	if (sw){
	    printf("Verificacao: %c |",*(sw->check_value));
        int i;
        for (i=0; i < sw->commandList->nElem;i++){
            ssb* s = (ssb*) _tracker->element;
            printf("Bloco %d: ",i);
            imprimeSwitchBlock(s);
        }
	}else{
        printf("SWITCH # S_SWITCH NULO\n");
	}

}

void imprimeSwitchBlock(ssb* s){

    if(!s){
        printf("Switch block vazio. Abortando...\n");
        exit(1);
    }

    printTreeList(s->commands,0);
    printf("| ");

}
