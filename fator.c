#include "fator.h"
#include "hash.h"


s_fator* allocateFator() {
	s_fator *aux;
	aux = (s_fator*)malloc(sizeof(s_fator));
	aux->parametros = initList();
	if (aux) return aux;
	else return NULL;
}
s_fator *executaFator(s_fator* toExecute) {
    
	switch(toExecute->tipo) {
		case T_INT:
		case T_CHAR:
		case T_FLOAT:
		    
			return toExecute;
			break;
        case T_VAR:
        {
            
            s_variavel* v = hashSearchVar(HashVar,(char*)toExecute->valor,"main");
            s_fator* fteste = allocateFator();
            printf("tipo = %d\n",v->tipo);

            if(toExecute->parametros && toExecute->parametros->head) {
            	//printf("'E nois Aqui: %d\n",*(int*)(toExecute->parametros->head->element));
            	int *_t = getNode(toExecute->parametros,0);
            	printf("'E nois Aqui: %d\n",*(int*)_t);
            	if(*(int*)_t == P_MAISMAISANT) {
					if(v->tipo == T_INT) {
						int _tmp = *(int*)v->valor + 1;
						*(int*)v->valor = _tmp;
					}
					else if(v->tipo == T_CHAR) {
						char _tmp = *(char*)v->valor + 1;
						*(char*)v->valor = _tmp;
					}
					else if(v->tipo == T_FLOAT) {
						float _tmp = *(float*)v->valor + 1;
						*(float*)v->valor = _tmp;
					}
            	} else if(*(int*)_t == P_MENOSMENOSANT) {
					if(v->tipo == T_INT) {
						int _tmp = *(int*)v->valor - 1;
						*(int*)v->valor = _tmp;
					}
					else if(v->tipo == T_CHAR) {
						char _tmp = *(char*)v->valor - 1;
						*(char*)v->valor = _tmp;
					}
					else if(v->tipo == T_FLOAT) {
						float _tmp = *(float*)v->valor - 1;
						*(float*)v->valor = _tmp;
					}
            	}
            	//if(*_t) printf("T ok\n");

            }
            setFator(fteste,v->tipo,v->valor,toExecute->parametros);
          
            return fteste;
            break; // LOL BREAK :) - lolwut?
        }
		default:
			return NULL;
			break;
	}
	return NULL;
}

void setFator(s_fator *f, int tipo,void *valor,list parList) {
	f->tipo = tipo;
	f->valor = valor;
	f->parametros = parList;
}
