#include "hash.h"

s_atrib *allocateAtrib() {
	s_atrib *aux;
		aux = (s_atrib*)malloc(sizeof(s_atrib));
		//aux->parametros = initList();
		if (aux) return aux;
		else return NULL;
}

void executeAtrib(s_atrib *toExecute,list *hashVar) {

    printf("EXECUTE ATRIB\n");
	char op_value[3];
    
    if (toExecute){
        strcpy(op_value, toExecute->op);
    }else{
        printf("ATRIB # S_ATRIB NULO\n");
    }

    printf("OP = %s\n",op_value);
	s_fator *executeResult = executeNodeTree(toExecute->toatrib);
	
	if (executeResult){

        if ( !strcmp(op_value,"=") ){
	        hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,executeResult->valor);
	    }else if (!strcmp(op_value,"+=")){

            s_variavel *v = hashSearchVar(hashVar,toExecute->varname,currentFunction);

            if (v){

                if (v->tipo == T_INT || v->tipo == T_CHAR){


                    if (v->valor != NULL){
                        int* int_value = malloc(sizeof(int));
                        *int_value = (*(int*)v->valor)+(*(int*)executeResult->valor);
                        hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,int_value);
                    }else{
                        printf("Atribuindo valor a variavel nao inicializada.\n");
                        exit(1);
                    }

                }else if (v->tipo == T_FLOAT){

                    if (v->valor != NULL){
                
                        float* float_value = malloc(sizeof(float));
                        *float_value = (*(float*)v->valor)+ (*(float*)executeResult->valor);
                        hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,float_value);
                    }else{
                        printf("Atribuindo valor a variavel nao inicializada.\n");
                        exit(1);
                    }
                }
            }else{
                printf("ATRIB # Nao achei variavel na hash.\n");
            }
	    }else if (!strcmp(op_value,"-=")){

            s_variavel *v = hashSearchVar(hashVar,toExecute->varname,currentFunction);
            if (v){
                if (v->tipo == T_INT || v->tipo == T_CHAR){
                    if (v->valor != NULL){
                        int* int_value = malloc(sizeof(int));
                        *int_value = (*(int*)v->valor)-(*(int*)executeResult->valor);
                        hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,int_value);
                    }else{
                        printf("Atribuindo valor a variavel nao inicializada.\n");
                        exit(1);
                    }

                }else if (v->tipo == T_FLOAT){

                    if (v->valor != NULL){
                        float* float_value = malloc(sizeof(float));
                        *float_value = (*(float*)v->valor)-(*(float*)executeResult->valor);
                        hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,float_value);
                    }else{
                        printf("Atribuindo valor a variavel nao inicializada.\n");
                        exit(1);
                    }
                }
            }else{
                printf("ATRIB # Nao achei variavel na hash.\n");
            }
	    }else if (!strcmp(op_value,"*=")){

            s_variavel *v = hashSearchVar(hashVar,toExecute->varname,currentFunction);
            if (v){
                if (v->tipo == T_INT || v->tipo == T_CHAR){
                    if (v->valor != NULL){
                        int* int_value = malloc(sizeof(int));
                        *int_value = (*(int*)v->valor) * (*(int*)executeResult->valor);
                        hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,int_value);
                    }else{
                        printf("Atribuindo valor a variavel nao inicializada.\n");
                    }

                }else if (v->tipo == T_FLOAT){

                    if (v->valor != NULL){
                        float* float_value = malloc(sizeof(float));
                        *float_value = (*(float*)v->valor)  * (*(float*)executeResult->valor);
                        hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,float_value);
                    }else{
                        printf("Atribuindo valor a variavel nao inicializada.\n");
                        exit(1);
                    }
                }
            }else{
                printf("ATRIB # Nao achei variavel na hash.\n");
            }
	    }else if (!strcmp(op_value,"/=")){

            s_variavel *v = hashSearchVar(hashVar,toExecute->varname,currentFunction);
            if (v){
                if (v->tipo == T_INT || v->tipo == T_CHAR){

                    if (v->valor != NULL){
                        int* int_value = malloc(sizeof(int));
                        *int_value = (*(int*)v->valor)/(*(int*)executeResult->valor);
                        hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,int_value);
                    }else{
                        printf("Atribuindo valor a variavel nao inicializada.\n");
                        exit(1);
                    }

                }else if (v->tipo == T_FLOAT){

                    if (v->valor != NULL){
                        float* float_value  = malloc(sizeof(float));
                        *float_value = (*(float*)v->valor)/(*(float*)executeResult->valor);
                        hashVarUpdateValue(hashVar,toExecute->varname,currentFunction,float_value);
                    }else{
                        printf("Atribuindo valor a variavel nao inicializada.\n");
                        exit(1);
                    }
                }
            }else{
                printf("ATRIB # Nao achei variavel na hash.\n");
            }
	    }
	}else{
	    printf("ATRIB # S_FATOR NULO!\n");
	}
}

void setAtrib(s_atrib *t, char *op, char *varname, NODETREEPTR toatrib, char *stringToAtrib) {

	strcpy(t->op,op);
	debug();
	strcpy(t->varname,varname);
	t->toatrib = toatrib;
	//strcpy(t->stringToAtrib,stringToAtrib);
}
