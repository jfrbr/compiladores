%{
#include <stdio.h>
#include <string.h>
#include "hash.h"
#include "parser.h"

extern char ident[256];
int Nlinha=1;
extern char atrib[200];
extern char num_inteiro[50];
extern char num_float[50];
extern char num_char[50];
extern char num_string[300];
extern char num_boolean[10];
extern lines;
char currentFunction[50];

list HashVar[MAX_HASH_SIZE];
list HashFunc[MAX_HASH_SIZE];

list exprList;
list testList;

%}

%token token_numero
%token token_mais
%token token_vezes
%token token_menos
%token token_div
%token token_mod
%token token_igual
%token token_menor
%token token_maior
%token token_maiori
%token token_menori
%token token_menormaior
%token token_atribuicao
%token token_ponto
%token token_ptevirgula
%token token_doispt
%token token_abrep
%token token_fechap
%token token_abrec
%token token_fechac
%token token_enquanto
%token token_faca
%token token_se
%token token_entao
%token token_senao
%token token_inicio
%token token_fim
%token token_programa
%token token_var
%token token_ident
%token token_asterisco
%token token_void
%token token_int
%token token_char
%token token_float
%token token_main
%token token_virgula
%token token_return
%token token_double
%token token_auto
%token token_break
%token token_case
%token token_const
%token token_continue
%token token_default
%token token_do
%token token_else
%token token_enum
%token token_extern
%token token_for
%token token_goto
%token token_if
%token token_include
%token token_long
%token token_register
%token token_short
%token token_signed
%token token_sizeof
%token token_static
%token token_struct
%token token_switch
%token token_typedef
%token token_union
%token token_unsigned
%token token_volatile
%token token_while
%token token_num_inteiro
%token token_num_float
%token token_divisao
%token token_maismais
%token token_menosmenos
%token token_shiftdireita
%token token_shiftesquerda
%token token_maiorigual
%token token_menorigual
%token token_igualigual
%token token_diferente
%token token_maisigual
%token token_menosigual
%token token_vezesigual
%token token_divisaoigual
%token token_ecomigual
%token token_xnorigual
%token token_ouigual
%token token_shiftesquerdaigual
%token token_shiftdireitaigual
%token token_doispontos
%token token_tralha
%token token_aspa_simples
%token token_aspas
%token token_contra_barra
%token token_ecomecom
%token token_ecom
%token token_ou
%token token_ou_bitbit
%token token_chapeuzinho
%token token_exclamacao
%token token_int_main
%token token_abrecol
%token token_fechacol
%token token_letra
%token token_string
%token token_bool
%token token_true
%token token_false

%start PROG

%%


BLOCO_GLOBAL: DECFUNC BLOCO_GLOBAL2
	      | DEC_VAR_GLOBAL BLOCO_GLOBAL2
	      //| DEC_STRUCT BLOCO_GLOBAL2
;	  

BLOCO_GLOBAL2: /**/
	      | DECFUNC BLOCO_GLOBAL2
	      | DEC_VAR_GLOBAL BLOCO_GLOBAL2
		
;


PROG:	BLOCO_GLOBAL token_int_main token_abrep token_fechap token_abrec {printf("Wololo\n\n\n"); strcpy(atrib,"\0"); strcpy(currentFunction,"main");} BLOCO token_fechac
      | token_int_main token_abrep token_fechap token_abrec {strcpy(atrib,"\0"); strcpy(currentFunction,"main");} BLOCO token_fechac
;

DECFUNC : TIPO token_ident token_abrep PARAMETROS_TIPO token_fechap {

		//	printf("ATRIB = %s\n",atrib);
			char *tipo, *funcname,*varlist,*var;
			tipo = strtok(atrib," ");
		//	printf("TIPO = %s\n",tipo);
			int returnType = converType(tipo);
			
			funcname = strtok(NULL,"(");	
		//	printf("%s\n",funcname);
			strcpy(currentFunction,funcname);

			varlist = strtok(NULL,")");
		//	printf("VAR LIST = %s\n",varlist);

			list parameters = initList();

			int* tipo_var = (int*) malloc (sizeof(int));			

			var = strtok(varlist,",");
			
			while (var){

				int *b = malloc(sizeof(int));
				*b = converType(var);
				//tipo_var = (int*)b;
				NODELISTPTR node = allocateNode();
				node->element = b;						
				addNode(parameters,node);

				var = strtok(NULL,",");
			}

			s_funcao *function = allocateFunction();
			setFunction(function,funcname,parameters->nElem,returnType,parameters);
		
			if(!funcExists(HashFunc,function->nome)) {
				hashInsertFunction(HashFunc,function);
			}
			else {
				printf("Erro: Funcao %s sendo redeclarada\n",function->nome);
			}
			
			strcpy(atrib,"\0");
			strcpy(ident,"\0");


			} token_abrec BLOCO token_fechac 
	| TIPO token_ident token_abrep token_fechap {
	
		char *tipo,*funcname,*var;
		tipo = strtok(atrib," ");
		int type = converType(tipo);
		
		funcname = strtok(NULL,"(");
	
		strcpy(currentFunction,funcname);

		s_funcao *function = allocateFunction();
		setFunction(function,funcname,0,type,NULL);
		
		if(!funcExists(HashFunc,function->nome)) {
			hashInsertFunction(HashFunc,function);
		}
		else {
			printf("Erro: Funcao %s sendo redeclarada\n",function->nome);
		}
			
		strcpy(atrib,"\0");
	} token_abrec BLOCO token_fechac 
;

DEC_VAR_GLOBAL: TIPO VAR DEC_VAR_GLOBAL2 token_ptevirgula
;

DEC_VAR_GLOBAL2: | token_virgula VAR DEC_VAR_GLOBAL2
;

PARAMETROS_TIPO: TIPO VAR PARAMETROS_TIPO2
;

PARAMETROS_TIPO2: | token_virgula TIPO VAR PARAMETROS_TIPO2
;
	  
COMANDAO:   DEC_VAR token_ptevirgula {
	  printf("Comecando um novo comando - declaracao\n");

	  char *tipo,*varlist,*var;
	  printf("ATRIB = %s\n",atrib);
	  tipo = strtok(atrib," ");
	  printf("TIPO = %s\n",tipo);
	  varlist = strtok(NULL," ");	
	  printf("VAR LIST = %s\n",varlist);
	  
	  var = strtok(varlist,",;");
	  int type= converType(tipo);
	  	  
	  while(var){
		
		s_variavel *v = allocateVar();
	
		setVar(v,var,NULL,type,currentFunction,lines);
			
		if(!varExists(HashVar,v->nome,v->escopo)) {
			hashInsertVar(HashVar,v);
		}
		else {
			printf("Erro: Variavel %s sendo redeclarada\n",v->nome);
		}
		var = strtok (NULL, " ,;");
	  }
	  strcpy(tipo,"\0");
	  strcpy(atrib,"\0");
	}
	
	
	| U_EXP_LIST token_ptevirgula 	{
	  printf("Terminando comando -exp\n");
	  strcpy(atrib,"\0");
	  debug();
	  cleanExprList(exprList);
	  debug();
	}
	
	| ATRIBUICAO token_ptevirgula {
			printf("Comecando um novo comando -atrib \n");
			printf("ATRIBUICAO = %s\n",atrib);
			char *varname = strtok(atrib," ");
			printf("%s\n",varname);
			s_variavel *v = hashSearchVar(HashVar,varname,currentFunction);
			if (v == NULL){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				exit(1);
			}
			hashVarUpdateUse(HashVar,varname,currentFunction,USING);
			printf("CURRENT FUNCTION = %s\n",currentFunction);
			int tipo_var = v->tipo;

			printf("TIPO VAR = %d\n",tipo_var);
			char *operador = strtok(NULL," ;");
			printf("OPERADOR = %s\n",operador);

			int testando = returnAtualVarType();
			printf("BAGULHO DOIDO = %d\n",testando);			
	
			if (!strcmp(operador,"=")){
				if ( (tipo_var == T_INT || tipo_var == T_FLOAT || tipo_var == T_CHAR) && strcmp(num_inteiro,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( tipo_var == T_FLOAT && strcmp(num_float,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( tipo_var == T_CHAR && strcmp(num_char,"\0")) {
					printf("Ok! Tipo permitido!\n");
				}else if ( tipo_var == T_BOOLEAN && strcmp(num_boolean,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else{
					printf("ATRIBUICAO NAO PERMITIDA\n");
				}
			}else if (!strcmp(operador,"+=")){
				if ( (tipo_var == T_INT || tipo_var == T_FLOAT || tipo_var == T_CHAR) && strcmp(num_inteiro,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( (tipo_var == T_FLOAT || tipo_var == T_INT || tipo_var == T_CHAR )&& strcmp(num_float,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( (tipo_var == T_CHAR || tipo_var == T_INT || tipo_var == T_FLOAT) && strcmp(num_char,"\0")) {
					printf("Ok! Tipo permitido!\n");
				}else if ( tipo_var == T_BOOLEAN && strcmp(num_boolean,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else{
					printf("ATRIBUICAO NAO PERMITIDA\n");
				}
			}else if (!strcmp(operador,"-=")){
				if ( (tipo_var == T_INT || tipo_var == T_FLOAT || tipo_var == T_CHAR) && strcmp(num_inteiro,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( (tipo_var == T_FLOAT || tipo_var == T_INT || tipo_var == T_CHAR )&& strcmp(num_float,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( (tipo_var == T_CHAR || tipo_var == T_INT) && strcmp(num_char,"\0")) {
					printf("Ok! Tipo permitido!\n");
				}else if ( tipo_var == T_BOOLEAN && strcmp(num_boolean,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else{
					printf("ATRIBUICAO NAO PERMITIDA\n");
				}
			}else if (!strcmp(operador,"*=")){
				if ( (tipo_var == T_INT || tipo_var == T_FLOAT || tipo_var == T_CHAR) && strcmp(num_inteiro,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( (tipo_var == T_FLOAT || tipo_var == T_INT || tipo_var == T_CHAR )&& strcmp(num_float,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( (tipo_var == T_CHAR || tipo_var == T_INT) && strcmp(num_char,"\0")) {
					printf("Ok! Tipo permitido!\n");
				}else if ( tipo_var == T_BOOLEAN && strcmp(num_boolean,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else{
					printf("ATRIBUICAO NAO PERMITIDA\n");
				}
			}else if (!strcmp(operador,"/=")){
				if ( (tipo_var == T_INT || tipo_var == T_FLOAT || tipo_var == T_CHAR) && strcmp(num_inteiro,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( (tipo_var == T_FLOAT || tipo_var == T_INT || tipo_var == T_CHAR )&& strcmp(num_float,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else if ( (tipo_var == T_CHAR || tipo_var == T_INT) && strcmp(num_char,"\0")) {
					printf("Ok! Tipo permitido!\n");
				}else if ( tipo_var == T_BOOLEAN && strcmp(num_boolean,"\0")){
					printf("Ok! Tipo permitido!\n");
				}else{
					printf("ATRIBUICAO NAO PERMITIDA\n");
				}
			}else {
					printf("OPERADOR NÃO TRATADO!\n");
			}					
			strcpy(num_float,"\0");
			strcpy(num_inteiro,"\0");
			strcpy(num_boolean,"\0");
			strcpy(num_char,"\0");
			strcpy(num_string,"\0");
			strcpy(atrib,"\0");
	}		
	| token_string token_ptevirgula
	// TODO verificar se o tipo do return é o mesmo da funçao atual
	| token_return {
	
		printf("Aqui tem o return com exp\n");	
		cleanExprList(exprList);
		
	} U_EXP_LIST token_ptevirgula
	
	| token_return {
	
		printf("Aqui tem o return com exp\n");	
		//cleanExprList(exprList);
		
	} token_ptevirgula
	
	| token_ptevirgula {
		printf("Comecando um novo comando\n");
		strcpy(num_float,"\0");
		strcpy(num_inteiro,"\0");
		
	}
	| token_if token_abrep IF_EXP token_fechap COMANDAO token_else COMANDAO
	| token_if token_abrep IF_EXP token_fechap token_else COMANDAO
	| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else token_abrec BLOCO token_fechac
	| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else COMANDAO
	| token_if token_abrep IF_EXP token_fechap COMANDAO token_else token_abrec BLOCO token_fechac
	| token_if token_abrep IF_EXP token_fechap token_else token_abrec BLOCO token_fechac
	| SWITCH
	| token_break token_ptevirgula
	| token_continue token_ptevirgula
	| LOOP	
;



BLOCO:	/**/ | COMANDAO BLOCO2 	| COMANDO BLOCO2
;

BLOCO2: /**/ | COMANDAO BLOCO2 | COMANDO BLOCO2
;

/* Declaração de Variáveis */

DEC_VAR: TIPO VAR DEC_VAR2
;

DEC_VAR2: /**/ 
	| token_virgula VAR DEC_VAR2
;

PONTEIRO: token_vezes PONTEIRO2
;

PONTEIRO2: | token_vezes PONTEIRO2
;

VAR: PONTEIRO token_ident
	| token_ecom token_ident
	| token_ident
	| token_ecom token_ident COLCHETE
	| token_ident COLCHETE
	| PONTEIRO token_ident COLCHETE
;

COLCHETE : token_abrecol U_EXP_LIST token_fechacol COLCHETE2
;

COLCHETE2: /**/
      | token_abrecol U_EXP_LIST token_fechacol COLCHETE2
      ;



TIPO: token_int | token_char | token_double | token_float | token_void | token_bool
;


/* EXPRESSAO */
U_EXP: EXP token_igualigual {
		char *op = malloc(2*sizeof(char));
		strcpy(op,"==");
		_toList(testList,op);
      } EXP
      | EXP token_maior {
		char *op = malloc(sizeof(char));
		strcpy(op,">");
		_toList(testList,op);
      } EXP
      | EXP token_menor {
		char *op = malloc(sizeof(char));
		strcpy(op,"<");
		_toList(testList,op);
      } EXP
      | EXP token_maiorigual {
		char *op = malloc(2*sizeof(char));
		strcpy(op,">=");
		_toList(testList,op);
      } EXP
      | EXP token_menorigual {
		char *op = malloc(2*sizeof(char));
		strcpy(op,"<=");
		_toList(testList,op);
      } EXP
      | EXP token_diferente {
		char *op = malloc(2*sizeof(char));
		strcpy(op,"!=");
		_toList(testList,op);
      } EXP
      | EXP
  
;

IF_EXP :
      U_EXP_LIST
;

U_EXP_LIST : U_EXP {
	    // Append current expression on expression list and reset testList
	    NODELISTPTR apList = allocateNode();
	    apList->element = testList;
	    addNode(exprList,apList);
	    testList = initList();
	    
	    } U_EXP_LIST2
;

U_EXP_LIST2 : {
		printf("Acabou a lista de expressoes!\n");
	      }
	      | token_ecomecom U_EXP {	      
		  // Append current expression on expression list and reset testList
		  NODELISTPTR apList = allocateNode();
		  apList->element = testList;
		  addNode(exprList,apList);
		  testList = initList();
		  
		  
		  
		  
		  
	      }	      
	      U_EXP_LIST2 
	      | token_ou U_EXP {
		  // Append current expression on expression list and reset testList
		  NODELISTPTR apList = allocateNode();
		  apList->element = testList;
		  addNode(exprList,apList);
		  testList = initList();
	      }
	    U_EXP_LIST2
;


EXP: EXP token_mais {
		printf("Achei um +\n");
		char *op = malloc(sizeof(char));
		*op = '+';
		_toList(testList,op);
      } TERMO
    | EXP token_menos {
		printf("Achei um -\n");
		char *op = malloc(sizeof(char));
		*op = '-';		
		_toList(testList,op);
      } TERMO
    | TERMO
;

TERMO: TERMO token_vezes {
		char *op = malloc(sizeof(char));
		*op = '*';		
		_toList(testList,op);
      } FATOR 
      | TERMO token_divisao {
		char *op = malloc(sizeof(char));
		*op = '/';		
		_toList(testList,op);
      } FATOR
      | TERMO token_mod {		
		char *op = malloc(sizeof(char));
		*op = '%';		
		_toList(testList,op);
      } FATOR
      | FATOR
;

FATOR: token_num_float {
		
		printf("Achei um float\n");		
		int *tipo = malloc(sizeof(int));
		*tipo = T_FLOAT;
		_toList(testList,tipo);
		
	  }
	  
	  | token_num_inteiro {
		printf("Achei um int\n");
		int *tipo = malloc(sizeof(int));
		*tipo = T_INT;
		_toList(testList,tipo);
	  }	  

	  | VAR {
		// Check if var exists
		printf("Achei uma variavel: %s\n",ident);
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction)) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		}
		
		int *tipo = malloc(sizeof(int));
		*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		printf("Tipo da variavel: %d\n",*tipo);
		
		_toList(testList,tipo);
		
		strcpy(atrib,"\0");
	  }
	  
	  | token_abrep U_EXP_LIST token_fechap 
	  | token_letra {
		printf("Achei um char\n");
		
		int *tipo = malloc(sizeof(int));
		*tipo = T_CHAR;
		
		_toList(testList,tipo);
	  }
	  | CHAMADA_FUNCAO {
		// Check if var exists
		printf("Achei uma funcao: %s\n",ident);
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!funcExists(HashFunc,ident)) {
		  printf("Erro na linha %d: Funcao %s nao declarada\n",lines,ident);
		}
		
		int *tipo = malloc(sizeof(int));
		*tipo = ((s_funcao*)(hashSearchFunction(HashFunc,ident)))->tipo_retorno;
		printf("Tipo da variavel: %d\n",*tipo);
		
		_toList(testList,tipo);
	  
	  }
	  
	  
	  
      	  | VAR token_maismais {
		// Check if var exists
		printf("Achei uma variavel: %s\n",ident);
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction)) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		}
		
		
		int *tipo = malloc(sizeof(int));
		*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber ++\n",lines,ident);
		}
		
		printf("Tipo da variavel: %d\n",*tipo);
		_toList(testList,tipo);
		
		strcpy(atrib,"\0");
      	  }
	  | token_maismais VAR {
		// Check if var exists
		printf("Achei uma variavel: %s\n",ident);
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction)) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		}
		
		
		int *tipo = malloc(sizeof(int));
		*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber ++\n",lines,ident);
		}
		printf("Tipo da variavel: %d\n",*tipo);
		
		_toList(testList,tipo);
		
		strcpy(atrib,"\0");	  
	  }
	  
	  | token_menosmenos VAR {
		printf("Achei uma variavel: %s\n",ident);
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction)) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		}
		
		
		int *tipo = malloc(sizeof(int));
		*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber --\n",lines,ident);
		}
		printf("Tipo da variavel: %d\n",*tipo);
		
		_toList(testList,tipo);
		
		strcpy(atrib,"\0");
	  }
	  | VAR token_menosmenos {
		
		printf("Achei uma variavel: %s\n",ident);
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction)) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		}		

		int *tipo = malloc(sizeof(int));
		*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber --\n",lines,ident);
		}
		printf("Tipo da variavel: %d\n",*tipo);

		_toList(testList,tipo);
		strcpy(atrib,"\0");	  
	  }
	  | token_menos token_num_float {
		printf("Achei um float\n");

		int *tipo = malloc(sizeof(int));
		*tipo = T_FLOAT;
		_toList(testList,tipo);	  
	  }
	  | token_menos VAR {
		printf("Achei uma variavel: %s\n",ident);
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction)) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		}		

		int *tipo = malloc(sizeof(int));
		*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber --\n",lines,ident);
		}
		printf("Tipo da variavel: %d\n",*tipo);
		_toList(testList,tipo);
		
		strcpy(atrib,"\0");	  
	  }
	  | token_menos token_num_inteiro {
		printf("Achei um int\n");
		
		int *tipo = malloc(sizeof(int));
		*tipo = T_INT;
		
		_toList(testList,tipo);
	  }
;


/* ATRIBUICAO */
ATRIBUICAO: VAR token_igual TO_ATRIB
	  | VAR token_maisigual TO_ATRIB
	  | VAR token_menosigual TO_ATRIB
	  | VAR token_vezesigual TO_ATRIB
	  | VAR token_divisaoigual TO_ATRIB
	  | VAR token_ecomigual TO_ATRIB
	  | VAR token_xnorigual TO_ATRIB
	  | VAR token_ouigual TO_ATRIB
	  | VAR token_shiftdireitaigual TO_ATRIB
	  | VAR token_shiftesquerdaigual TO_ATRIB
;

TO_ATRIB:  U_EXP_LIST | token_string;

CHAMADA_FUNCAO : token_ident token_abrep PARAMETROS token_fechap {
			printf("Chamou funcao com parametros\n");
			char *funcname,*parlist,*tmpparlist;
			
			int nParam=1;
			funcname = strtok(atrib,"(");
			printf("funcname: %s\n",funcname);
			parlist = strtok(NULL,")");
			printf("parlist: %s\n",parlist);
			//strcpy(tmpparlist,parlist);
			//strcat(tmpparlist,"\0");
			int i=0;
			//printf("tmpparlist: %s\n",tmpparlist);
			for(i=0; parlist[i] != '\0'; i++) {
				//printf("tmpparlist[%d]: %c\n",i,'a');
				if(parlist[i]==',') nParam++;
			}
			printf("Parametros passados: %d\n",nParam);
			
			// Verifica existencia e aridade da funcao
			if(!funcExists(HashFunc,funcname)) {
				printf("Erro na linha %d: Funcao nao definida\n",lines);
			}
			else {
				s_funcao *aux = hashSearchFunction(HashFunc,funcname);
				if(checkArity(aux,nParam) != 1) {
					printf("Erro na linha %d: Funcao sendo chamada com numero incorreto de parametros\n",lines);
				}
				// Verifica se a lista de parametros esta com os tipos corretos
				else {
					list pList = aux->parametros;
					int i=0;
					for(i=0; i<aux->parametros->nElem; i++) {
					
						int piOriginal,piPassado;
						
						piOriginal = *(int*)(getNode(pList,i));
						printf("Parametro %d: %d\n",i,*(int*)(getNode(pList,i)));
						//pList = pList->next;
						
						piPassado = *(int*)getNode(t,0);
						list t = getNode(exprList,i);
						printf("Parametro Passdo (%d): %d\n",i,*(int*)getNode(t,0));
						
						switch(piOriginal) {
							case T_INT:
								if(piPassado != T_CHAR && piPassado != T_INT && piPassado != T_FLOAT) {
									printf("Tipo de parametro incorreto!\n");
								}
								break;
						}
						
					}
				}
			}
			
			//
			
			//debug();
		}
		


		  | token_ident token_abrep token_fechap {
			printf("Chamou uma funcao sem parametro: %s\n",atrib);
			char *funcname;
			funcname = strtok(atrib,"(");
			printf("funcname: %s\n",funcname);
			if(!funcExists(HashFunc,funcname)) {
				printf("Erro na linha %d: Funcao nao definida\n",lines);
			}
			else {
				s_funcao *aux = hashSearchFunction(HashFunc,funcname);
				if(checkArity(aux,0) != 1) {
					printf("Erro na linha %d: Funcao com parametros sendo chamada sem parametros\n",lines);
				}
			}
			strcpy(atrib,"\0");
		  }
;

PARAMETROS: U_EXP_LIST PAR2 | token_string PAR2;

PAR2: | token_virgula U_EXP_LIST PAR2 | token_virgula token_string PAR2;



COMANDO: CMD_NAO_ASSOC | CMD_NAO_ASSOC_CHAVE
;

CMD_NAO_ASSOC_CHAVE : token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac
		      | token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else COMANDO
;

CMD_NAO_ASSOC : token_if token_abrep IF_EXP token_fechap COMANDAO
		| token_if token_abrep IF_EXP token_fechap COMANDO
		| token_if token_abrep IF_EXP token_fechap COMANDAO token_else COMANDO
		| token_if token_abrep IF_EXP token_fechap token_else COMANDO
;

/* SWITCH */

SWITCH: token_switch token_abrep VAR token_fechap token_abrec SWITCH_BLOCK token_fechac;

SWITCH_BLOCK : token_default token_doispontos BLOCO 
		| token_case token_num_inteiro token_doispontos BLOCO SWITCH_BLOCK2 token_default token_doispontos BLOCO
		| token_case token_letra token_doispontos BLOCO SWITCH_BLOCK2 token_default token_doispontos BLOCO
;
SWITCH_BLOCK2 : 
		| token_case token_num_inteiro token_doispontos BLOCO SWITCH_BLOCK2
		| token_case token_letra token_doispontos BLOCO SWITCH_BLOCK2 
;

/* LOOP */

LOOP : FOR_LOOP | DO_WHILE_LOOP | WHILE_LOOP ;

WHILE_LOOP: token_while token_abrep U_EXP_LIST token_fechap COMANDAO
	    | token_while token_abrep U_EXP_LIST token_fechap token_abrec BLOCO token_fechac
;

DO_WHILE_LOOP : token_do COMANDAO token_while token_abrep U_EXP_LIST token_fechap token_ptevirgula
		| token_do token_abrec BLOCO token_fechac token_while token_abrep U_EXP_LIST token_fechap token_ptevirgula
;

FOR_LOOP : token_for token_abrep ATRIBUICAO_LIST token_ptevirgula U_EXP_LIST token_ptevirgula COMMAND_LIST token_fechap COMANDAO
	   | token_for token_abrep ATRIBUICAO_LIST token_ptevirgula U_EXP_LIST token_ptevirgula COMMAND_LIST token_fechap token_abrec BLOCO token_fechac
	   | token_for token_abrep ATRIBUICAO_LIST token_ptevirgula token_ptevirgula COMMAND_LIST token_fechap COMANDAO
	   | token_for token_abrep ATRIBUICAO_LIST token_ptevirgula token_ptevirgula COMMAND_LIST token_fechap token_abrec BLOCO token_fechac
;

ATRIBUICAO_LIST : | ATRIBUICAO ATRIBUICAO_LIST2
;

ATRIBUICAO_LIST2 : | token_virgula ATRIBUICAO ATRIBUICAO_LIST2
;

COMMAND_LIST : | ATRIBUICAO COMMAND_LIST2 | EXP COMMAND_LIST2
;

COMMAND_LIST2 : | token_virgula ATRIBUICAO COMMAND_LIST2 | token_virgula  EXP COMMAND_LIST2
;
%%

#include "lex.yy.c"

main(){

	initHash(HashVar,MAX_HASH_SIZE);
	initHash(HashFunc,MAX_HASH_SIZE);
	
	exprList = initList();
	testList = initList();

	strcpy(atrib,"\0");
	strcpy(num_float,"\0");
	strcpy(num_inteiro,"\0");
	strcpy(num_char,"\0");

	yyparse();
	s_funcao *func = hashSearchFunction(HashFunc,"testando");
	//printf("Aridade da funcao %s: %d\n",func->nome,func->aridade);
	func = hashSearchFunction(HashFunc,"f");
	//if (func) printf("Aridade da funcao %s: %d\n",func->nome,func->aridade);

	/* Checa se variaveis declaradas nao foram utilizadas */

	checkVariables(HashVar);
	
	s_variavel *tmp = hashSearchVar(HashVar,"a","main");
//	printf("%s\n",tmp->valor);

	s_variavel *tmp2 = hashSearchVar(HashVar,"c","testando");
	//printf("%s %d\n",(char*)(tmp2->valor),tmp2->lineDeclared);

	
/*	testList = (list)(getNode(exprList,0));
	
	printf("Expr types: %d\n",testList->nElem);
	int i=0;
	for(i=0; i < testList->nElem; i++) {
		printf("Type %d from expr: %d\n",i,*(int*)(getNode(testList,i)));
	}
*/	


//	if(tmp->nome) printf("Variavel Existe com escopo %s\n",tmp->escopo);
//	printf("sde exists: %d\n",varExists(HashVar,"sde",NULL));
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){
	printf("Erro na Linha: %d\n", lines);
}

