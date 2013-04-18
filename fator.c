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
    //printf("Executando um fator aqui %d %d\n",F_FUNCAO,toExecute->tipo);
	switch(toExecute->tipo) {
		case T_INT:
		case T_CHAR:
		case T_FLOAT:
		    printf("Numero %d\n",*(int*)toExecute->valor);

			return toExecute;
			break;
        case T_VAR:
        {
        	s_variavel* v;

        	printf("CurrentFunction: %s, var: %s\n",currentFunction,(char*)toExecute->valor);
        	v = hashSearchVar(HashVar,(char*)toExecute->valor,currentFunction);

        	if (!v){
        		// Procurar um nivel acima, se existir
        		//printf("Entrei\n");
        		if(functionStack->nElem > 1) {
        			printf("Entrei\n");
        			v = hashSearchVar(HashVar,(char*)toExecute->valor,(char*)getNode(functionStack,functionStack->nElem-2));
        		}
        		else {
					v = hashSearchVar(HashVar,(char*)toExecute->valor,"global");

					if (!v){
						printf("Variavel nao encontrada na hash. Abortando...\n");
						exit(-1);
					}
        		}
        	}


            s_fator* fteste = allocateFator();
            if((s_fator*)v->valor) printf("FATOR AQUI\n");

            printf("Atipo = %d %d\n",v->tipo,*(int*)v->valor);
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
        case F_FUNCAO:
        {


        	printf("Avaliando uma funcao pahnois %s\n",(char*)toExecute->valor);
        	s_funcao* func = hashSearchFunction(HashFunc,(char*)toExecute->valor);

        	if(func) {
        		if(!func->parametros) {
					s_fator *r = executeTreeList(func->cmdList);
					printf("Passou\n");
					if(retValue) {
						printf("Executou com return: %d\n",*(int*)retValue->valor);
						r = retValue;
						hasReturn = 0;
						retValue = NULL;
						return r;
					}
        		}
        		else {
        			char *_fname = malloc(50*sizeof(char));

        			strcpy(currentFunction,(char*)toExecute->valor);
        			strcpy(_fname,(char*)toExecute->valor);
        			_toList(functionStack,_fname);
        			printf("A funcao tem %d parametros\n",func->parametros->nElem);
        			printf("Foram passados %d parametros\n",toExecute->parametros->nElem);
        			// Agora precisa realizar as atribuicoes dos parametros nas variaveis
        			NODELISTPTR _tracker = func->parNames->head, _typeTracker = func->parametros->head;
        			NODELISTPTR _parTracker = toExecute->parametros->head;
        			for(int i=0; i<func->parametros->nElem; i++) {
        				printf("funcparname[%d]: %s\n",i,(char*)_tracker->element);
        				printf("Conversao a ser feita: %d\n",*(int*)_typeTracker->element);

        				s_fator *_r = allocateFator();
        				_r = executeNodeTree(_parTracker->element);
        				printf("Valor de _r: %d\n",*(int*)_r->valor);
        				hashVarUpdateValue(HashVar,(char*)_tracker->element,(char*)toExecute->valor,_r->valor);
        				_parTracker = _parTracker->next;
        				_tracker = _tracker->next;
        				_typeTracker = _typeTracker->next;

        			}
        			_tracker = func->parNames->head;
        			printf("Valores atualizados:\n");
        			for(int i=0; i<func->parametros->nElem; i++) {
        				printf("funcparname[%d]: %s\n",i,(char*)_tracker->element);
        				s_variavel *_tmpv = hashSearchVar(HashVar,(char*)_tracker->element,(char*)toExecute->valor);
        				//printf("Valor da variavel: %d\n",*(int*)_tmpv->valor);
        				//if((s_fator*)_tmpv->valor) {

        					//printf("E uma fator carai %d!\n",*(int*)((s_fator*)(_tmpv->valor))->valor);
        				//}
        				_tracker = _tracker->next;
					}
        			s_fator *r = executeTreeList(func->cmdList);
					printf("Passou2\n");
					if(retValue) {
						printf("Executou com return: %d\n",*(int*)retValue->valor);
						r = retValue;
						hasReturn = 0;
						retValue = NULL;
						return r;
					}
					printf("gNode: %s\n\n",(char*)getNode(functionStack,functionStack->nElem-1));
					if(functionStack->nElem > 1) {
						strcpy(currentFunction,(char*)getNode(functionStack,functionStack->nElem-2));
					}
					else {
						strcpy(currentFunction,"main");
					}
        			//exit(2);
        		}

        	}
        	//s_fator *r = executeTreeList()



        	break;
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
