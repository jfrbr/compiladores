#include <stdio.h>
#include <stdlib.h>
#include "list.h"
#include "parser.h"


int converType(char* type){

	if (!type) return -1;

	switch(type[0]) {
		case 'i':
			return 1;
		case 'f':
			return 2;
		case 'b':
			return 3;
		case 'c':
			return 4;
		case 's':
			return 5;
		case 'v':
			return 6;
		default:
			return -2;
	}
	return 0;
}


// Essa funao e' utilizada pra limpar uma lista de sublistas, como a lista de expressoes de um comando
void cleanExprList(list l) {
  //printf("Passou1");
	if(!l || !(l->head)) {
	  //printf("Lista nao iniciada\n");
	  return;
	}
	
	int i,len = l->nElem; 
	
	for(i=0;i<len;i++) {
	    destroyList(getNode(l,i));
	}
	//printf("Passou2");
	NODELISTPTR aux = l->head;
	for(i=0;i<len;i++) {
	    free(aux);
	    aux = aux->next;
	}
	
	free(l);
	l=initList();
	
	
}
/*
#define T_INT 1
#define T_FLOAT 2
#define T_BOOLEAN 3
#define T_CHAR 4
#define T_STRING 5
#define T_VOID 6
*/
int changeType(int t1, int t2, char* c){
	
	if (!c) return -2;

	if ( !strcmp(c,">") )
		if (t1 != 3 && t1 != 3 && t1 != 5 && t2 != 5) return 3;
		else return -1;

	if ( !strcmp(c,"<") )
		if( t1 != 3 && t1 != 3 && t1 != 5 && t2 != 5) return 3;
		else return -1;

	if ( !strcmp(c,">=") )
		if ( t1 != 3 && t1 != 3 && t1 != 5 && t2 != 5) return 3;
		else return -1;

	if ( !strcmp(c,"<="))
		if(t1 != 3 && t1 != 3 && t1 != 5 && t2 != 5) return 3;
		else return -1;

	if ( !strcmp(c,"==") )
		if (t1 != 5 && t2 != 5) return 3;
		else return -1;

	if ( !strcmp(c,"!=")) 
		if (t1 != 5 && t2 != 5) return 3;
		else return -1;

	
	if (t1 == 1){
		
		if ( t2 == 1 ) return 1;
		if ( t2 == 2) return 2;
		if ( t2 == 3) return -1;
		if ( t2 == 4 ) return 1;
		if ( t2 == 5) return -1;
		if ( t2 == 6) return -1;
		
		return -1;
	}

	if (t1 == 2){

		if ( t2 == 1 ) return 2;
		if ( t2 == 2) return 2;
		if ( t2 == 3) return -1;
		if ( t2 == 4 ) return 2;
		if ( t2 == 5) return -1;
		if ( t2 == 6) return -1;

		return -1;
	}

	if (t1 == 4){

		if ( t2 == 1 ) return 4;
		if ( t2 == 2) return -1;
		if ( t2 == 3) return -1;
		if ( t2 == 4 ) return 4;
		if ( t2 == 5) return -1;
		if ( t2 == 6) return -1;

		return -1;
	}
	
	if (t1==5 || t1 ==6 || t1 == -1 || t2 == -1) return -1;

}

int returnTypeExprList(list l){

	if(!l || !(l->head)) {
	  printf("Lista nao iniciada\n");
	  return -1;
	}

	int i, len = l->nElem, type;
	char* op = NULL;

	NODELISTPTR aux = l->head;

	type = *((int*)aux->element);
	
	aux = aux->next;
	
	for (i=1;i<len;i++){
		
		if (i%2 != 0){
			
			op = (char*) aux->element;
			
		}else{		
			type = changeType(type, *(int*)aux->element,op);
			
		}
				
		aux = aux->next;
	}
	
	return type;
}

int returnAtualVarType(){

	if ( strcmp(num_inteiro,"\0") ) return 1;
	if ( strcmp(num_float,"\0") ) return 2;
	if ( strcmp(num_boolean,"\0") ) return 3;
	if ( strcmp(num_char,"\0") ) return 4;
	if ( strcmp(num_string,"\0") ) return 5;

}

// This function will check for characters such as \n in strings and get them to occupy a single byte
void checkSpecialChars(char *str,int len) {
	for(int i=0; i<len; i++) {
		if(str[i] == '\\') {
			switch(str[i+1]) {
				case 'n':
					str[i] = '\n';
					break;
			}
			for(int j = i+1; j<len; j++)
				str[j] = str[j+1];
		}
		if(str[i] == '"') {
			for(int j = i; j<len; j++)
							str[j] = str[j+1];
		}
	}
}
