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
			return toExecute;
			break;
        case T_VAR:
        {
        	s_variavel* v;
        	v = hashSearchVar(HashVar,(char*)toExecute->valor,currentFunction);

        	if (!v){
        		// Procurar um nivel acima, se existir
        		if(functionStack->nElem > 1) {
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
            if(toExecute->parametros && toExecute->parametros->head) {
            	int *_t = getNode(toExecute->parametros,0);
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
            	} else if (*(int*)_t == NEGATIVE_VALUE){
                        if (v->tipo == T_INT){
                            int _tmp = *(int*)v->valor * -1;
						    *(int*)v->valor = _tmp;
                        }else if (v->tipo == T_FLOAT){
                        	float _tmp = *(float*)v->valor * -1;
						    *(float*)v->valor = _tmp;
                        }else if (v->tipo == T_CHAR){
                            char _tmp = *(char*)v->valor * -1;
						    *(char*)v->valor = _tmp;
                         }
            	}

            }
            setFator(fteste,v->tipo,v->valor,toExecute->parametros);
            return fteste;
            break; // LOL BREAK :)
        }
        case F_FUNCAO:
        {

        	s_funcao* func = hashSearchFunction(HashFunc,(char*)toExecute->valor);
        	if(func) {
        		if(!func->parametros && strcmp(func->nome,"printf")!=0 && strcmp(func->nome,"scanf")!=0 && strcmp(func->nome,"max")!=0 && strcmp(func->nome,"min")!=0) {
					s_fator *r = executeTreeList(func->cmdList);
					if(retValue) {
						r = retValue;
						hasReturn = 0;
						retValue = NULL;
						return r;
					}
        		}
        		else { // FUNÇÃO COM PARAMETROS
        			char *_fname = malloc(50*sizeof(char));

        			strcpy(currentFunction,(char*)toExecute->valor);
        			strcpy(_fname,(char*)toExecute->valor);
        			_toList(functionStack,_fname);

        			// PRINTF
        			if(strcmp(_fname,"printf")==0) {
        				char *_formatString;
        				int len = strlen((char*)toExecute->parametros->head->element);
        				_formatString = calloc(len+1,sizeof(char));
        				strcpy(_formatString,(char*)toExecute->parametros->head->element);

        				checkSpecialChars(_formatString,len);
           				int *_int;
           				float *_float;
           				char *_char;

        				// Agora decidir o valor a imprimir
            			NODELISTPTR _parTracker = toExecute->parametros->head->next;
            			
            			s_fator* _r = allocateFator();
            			_r = executeNodeTree(_parTracker->element);
            			
            			if (_r->tipo == T_INT){
    						printf(_formatString,*(int*)_r->valor);
    					}else if (_r->tipo == T_FLOAT){
    						printf(_formatString,*(float*)_r->valor);
    					}else if (_r->tipo == T_CHAR){
    						printf(_formatString,*(char*)_r->valor);
    					}
						//exit(1);

						if(functionStack->nElem > 1) {
						    strcpy(currentFunction,(char*)getNode(functionStack,functionStack->nElem-2));
						}
						else {
							strcpy(currentFunction,"main");
						}
						removeWithoutFreeFromList(functionStack,functionStack->nElem-1);
        				return NULL;
        			}

        			// SCANF
        			if(strcmp(_fname,"scanf")==0) {
        				char *_formatString;
        				int len = strlen((char*)toExecute->parametros->head->element);
        				_formatString = calloc(len+1,sizeof(char));
        				strcpy(_formatString,(char*)toExecute->parametros->head->element);

        				/* NEM TENTE ENTENDER ISSO AQUI */
        				// Agora decidir o valor a substituir
            			NODELISTPTR _parTracker = toExecute->parametros->head->next;
            			NODETREEPTR _r;
            			_r = _parTracker->element;

            			list operands = _r->children->head->element;
            			_r = operands->head->element;
            			s_fator *_f = _r->element;

						s_variavel *v = hashSearchVar(HashVar,(char*)_f->valor,currentFunction);

						if (!v){
							// Procurar um nivel acima, se existir
							if(functionStack->nElem > 1) {
								v = hashSearchVar(HashVar,(char*)_f->valor,(char*)getNode(functionStack,functionStack->nElem-2));
							}
							else {
								v = hashSearchVar(HashVar,(char*)_f->valor,"global");
								if (!v){
									printf("Variavel nao encontrada na hash. Abortando...\n");
									exit(-1);
								}
							}
						}

						int _tipoDesejado = checkDataScanf(_formatString,len);

						if(v->tipo != _tipoDesejado) {
							printf("Este dado nao pode ser inserido nessa variavel\n");
							exit(1);
						}
						/* A PARTE DAS ATRIBUICOES E AQUI */
						int *_int;
        				float *_float;
        				char *_char;
        				if(_tipoDesejado == T_INT) {
        					int _tmp;

        					// Restore stdin to keyboard
        					FILE *terminal;
        					if(stdin) {
        						terminal = fopen("/dev/tty", "rw");
        					}
        					fscanf(terminal,"%d",&_tmp);
        					fclose(terminal);
        					_int = malloc(sizeof(int));
        					*_int = _tmp;
        					setVar(v,v->nome,_int,v->tipo,v->escopo,v->lineDeclared);

        				}else if(_tipoDesejado == T_FLOAT) {
        					float _tmp;

        					// Restore stdin to keyboard
        					FILE *terminal;
        					if(stdin) {
        						terminal = fopen("/dev/tty", "rw");
        					}

        					fscanf(terminal,"%f",&_tmp);
        					fclose(terminal);

        					_float = malloc(sizeof(float));
        					*_float = _tmp;
        					setVar(v,v->nome,_float,v->tipo,v->escopo,v->lineDeclared);
        				}else if(_tipoDesejado == T_CHAR) {
        					char _tmp;

        					// Restore stdin to keyboard
        					FILE *terminal;
        					if(stdin) {
        						terminal = fopen("/dev/tty", "rw");
        					}
        					fscanf(terminal,"%c",&_tmp);
        					fclose(terminal);
        					_char = malloc(sizeof(char));
        					*_char = _tmp;
        					setVar(v,v->nome,_char,v->tipo,v->escopo,v->lineDeclared);
        				}
        				if(functionStack->nElem > 1) {
        										strcpy(currentFunction,(char*)getNode(functionStack,functionStack->nElem-2));
        									}
        									else {
        										strcpy(currentFunction,"main");
        									}
        				removeWithoutFreeFromList(functionStack,functionStack->nElem-1);
        				return NULL;
        			}
                    if (strcmp(_fname,"min") == 0){
                        if (toExecute->parametros->nElem != 2){
                            printf("Quantidade de parametros errada na funcao de minimo\nAbortando...");
                            exit(1);
                        }
                        NODETREEPTR a,b;
                		a = ((NODETREEPTR)(getNode((list)(toExecute->parametros),0)));
		                b = ((NODETREEPTR)(getNode((list)(toExecute->parametros),1)));
                		s_fator *a_v,*b_v, *r = malloc(sizeof(s_fator));
                		a_v = executeNodeTree(a);
                		b_v = executeNodeTree(b);
                		if ( a_v->tipo == T_INT && b_v->tipo == T_INT){
                		    if (*(int*)a_v->valor < *(int*)b_v->valor){
                		        int *res = malloc(sizeof(int));
                		        *res = *(int*)a_v->valor;
                		        r->valor = res;
                		        r->tipo = T_INT;
                		     }
                		    else{
                		        int *res = malloc(sizeof(int));
                		        *res = *(int*)b_v->valor;
                		        r->valor = res;
                		        r->tipo = T_INT;
                		    }
                		}else if (a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {

                		    if (*(float*)a_v->valor < *(float*)b_v->valor){
                		        float *res = malloc(sizeof(float));
                		        *res = *(float*)a_v->valor;
                		        r->valor = res;
                		        r->tipo = T_FLOAT;
                		     }
                		    else{
                		        float *res = malloc(sizeof(float));
                		        *res = *(float*)b_v->valor;
                		        r->valor = res;
                		        r->tipo = T_FLOAT;
                		    }

                		}else if (a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {

                		    if (*(char*)a_v->valor < *(char*)b_v->valor){
                		        char *res = malloc(sizeof(float));
                		        *res = *(float*)a_v->valor;
                		        r->valor = res;
                		        r->tipo = T_CHAR;
                		     }
                		    else{
                		        char *res = malloc(sizeof(float));
                		        *res = *(char*)b_v->valor;
                		        r->valor = res;
                		        r->tipo = T_CHAR;
                		    }

                		}

                		if(functionStack->nElem > 1) {
        				    strcpy(currentFunction,(char*)getNode(functionStack,functionStack->nElem-2));
        				}
        				else {
        					strcpy(currentFunction,"main");
        				}
        				removeWithoutFreeFromList(functionStack,functionStack->nElem-1);
                        return r;
                    }

                    if (strcmp(_fname,"max") == 0){
                        if (toExecute->parametros->nElem != 2){
                            printf("Quantidade de parametros errada na funcao de minimo\nAbortando...");
                            exit(1);
                        }
                        NODETREEPTR a,b;
                		a = ((NODETREEPTR)(getNode((list)(toExecute->parametros),0)));
		                b = ((NODETREEPTR)(getNode((list)(toExecute->parametros),1)));
                		s_fator *a_v,*b_v, *r = malloc(sizeof(s_fator));
                		a_v = executeNodeTree(a);
                		b_v = executeNodeTree(b);
                		if ( a_v->tipo == T_INT && b_v->tipo == T_INT){
                		    if (*(int*)a_v->valor > *(int*)b_v->valor){
                		        int *res = malloc(sizeof(int));
                		        *res = *(int*)a_v->valor;
                		        r->valor = res;
                		        r->tipo = T_INT;
                		     }
                		    else{
                		        int *res = malloc(sizeof(int));
                		        *res = *(int*)b_v->valor;
                		        r->valor = res;
                		        r->tipo = T_INT;
                		    }
                		}else if (a_v->tipo == T_FLOAT && b_v->tipo == T_FLOAT) {

                		    if (*(float*)a_v->valor > *(float*)b_v->valor){
                		        float *res = malloc(sizeof(float));
                		        *res = *(float*)a_v->valor;
                		        r->valor = res;
                		        r->tipo = T_FLOAT;
                		     }
                		    else{
                		        float *res = malloc(sizeof(float));
                		        *res = *(float*)b_v->valor;
                		        r->valor = res;
                		        r->tipo = T_FLOAT;
                		    }

                		}else if (a_v->tipo == T_CHAR && b_v->tipo == T_CHAR) {

                		    if (*(char*)a_v->valor > *(char*)b_v->valor){
                		        char *res = malloc(sizeof(float));
                		        *res = *(float*)a_v->valor;
                		        r->valor = res;
                		        r->tipo = T_CHAR;
                		     }
                		    else{
                		        char *res = malloc(sizeof(float));
                		        *res = *(char*)b_v->valor;
                		        r->valor = res;
                		        r->tipo = T_CHAR;
                		    }

                		}

                		if(functionStack->nElem > 1) {
        				    strcpy(currentFunction,(char*)getNode(functionStack,functionStack->nElem-2));
        				}
        				else {
        					strcpy(currentFunction,"main");
        				}
        				removeWithoutFreeFromList(functionStack,functionStack->nElem-1);
                        
                        return r;
                    }

        			// Agora precisa realizar as atribuicoes dos parametros nas variaveis

        			NODELISTPTR _tracker = func->parNames->head, _typeTracker = func->parametros->head;
        			NODELISTPTR _parTracker = toExecute->parametros->head;

        			// Welcome to the Jungle!
        			for(int i=0; i<func->parametros->nElem; i++) {
        				s_fator *_r = allocateFator();
        				_r = executeNodeTree(_parTracker->element);
        				hashVarUpdateValue(HashVar,(char*)_tracker->element,(char*)toExecute->valor,_r->valor);
        				_parTracker = _parTracker->next;
        				_tracker = _tracker->next;
        				_typeTracker = _typeTracker->next;

        			}
        			_tracker = func->parNames->head;
        			for(int i=0; i<func->parametros->nElem; i++) {
        				s_variavel *_tmpv = hashSearchVar(HashVar,(char*)_tracker->element,(char*)toExecute->valor);
        				_tracker = _tracker->next;
					}
        			s_fator *r = executeTreeList(func->cmdList);

					if(retValue) {
						r = retValue;
						hasReturn = 0;
						retValue = NULL;
						return r;
					}
					if(functionStack->nElem > 1) {
						strcpy(currentFunction,(char*)getNode(functionStack,functionStack->nElem-2));
					}
					else {
						strcpy(currentFunction,"main");
					}
					removeWithoutFreeFromList(functionStack,functionStack->nElem-1);
        		}

        	}
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
void imprimeFator(s_fator *f){

	if (!f){
		printf("Fator nulo\n");
	}
	switch (f->tipo){
	case T_INT:
		printf("%d",*(int*)f->valor);
		break;
	case T_FLOAT:
		printf("%f",*(float*)f->valor);
		break;
	case T_CHAR:
		printf("%c",*(char*)f->valor);
		break;
	case T_VAR:
		printf("%s",(char*)f->valor);
		break;
	case F_FUNCAO:
		printf("%s",(char*)f->valor);
		break;
	}
}
