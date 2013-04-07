%{
#include <stdio.h>
#include <string.h>
#include "hash.h"
#include "parser.h"

extern char ident[256];
char lident[256];
int Nlinha=1;
extern char atrib[200];
extern char num_inteiro[50];
extern char num_float[50];
extern char num_char[50];
extern char num_string[300];
extern char num_boolean[10];
extern lines;
char currentFunction[50];
char funcCalled[50];
int eval;
int in_for;
int tipoVar;
extern list HashVar[MAX_HASH_SIZE];
list HashFunc[MAX_HASH_SIZE];

list exprList;
list testList;
list parList;

s_fator *fteste;

NODETREEPTR nodeTree;
NODETREEPTR expTree;
NODETREEPTR u_expTree;
list fatorList;
list termoList;
list auxlist;
tree bigTree;

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
%token token_stringtype

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


PROG:	BLOCO_GLOBAL token_int_main token_abrep token_fechap token_abrec {strcpy(atrib,"\0"); strcpy(currentFunction,"main");} BLOCO token_fechac
      | token_int_main token_abrep token_fechap token_abrec {strcpy(atrib,"\0"); strcpy(currentFunction,"main");} BLOCO token_fechac
;

DECFUNC : TIPO token_ident token_abrep {
	strcpy(currentFunction,ident);
}	PARAMETROS_TIPO token_fechap {


			char *tipo, *funcname,*varlist,*var,*varname;
			tipo = strtok(atrib," ");

			int returnType = converType(tipo);
			
			funcname = strtok(NULL,"(");	

			strcpy(currentFunction,funcname);

			varlist = strtok(NULL,")");
			

			list parameters = initList();

			int* tipo_var = (int*) malloc (sizeof(int));			

			var = strtok(varlist,",");
			
			int i=0;
			
			//for(i=0; i<parList->nElem-1; i++) {
				//printf("Par: %s\n",(char*)getNode(parList,i));
			//}
			
			while (var){
			
				
				int *b = malloc(sizeof(int));
				*b = converType(var);
				
				//printf("var: %s\n",var);
				//varname = strtok(var," ");
				//printf("varname: %s\n",ident);
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
				printf("Erro semantico na linha %d: Funcao %s sendo redeclarada\n",lines,function->nome);
				exit(2);
			}
			
			strcpy(atrib,"\0");
			strcpy(ident,"\0");
			//strcpy(currentFunction,"global");


			} token_abrec BLOCO token_fechac {
			    strcpy(currentFunction,"global");
			}
	| TIPO token_ident token_abrep token_fechap {
		
			char *tipo, *funcname,*varlist,*var;
			tipo = strtok(atrib," ");
		
			int returnType = converType(tipo);
			
			funcname = strtok(NULL,"(");	
		
			strcpy(currentFunction,funcname);

	
		int type = converType(tipo);
		
		s_funcao *function = allocateFunction();
		setFunction(function,funcname,0,type,NULL);
		
		if(!funcExists(HashFunc,function->nome)) {
			hashInsertFunction(HashFunc,function);
		}
		else {
			printf("Erro semantico na linha %d: Funcao %s sendo redeclarada\n",lines,function->nome);
			exit(2);
		}
			
		strcpy(atrib,"\0");
	} token_abrec BLOCO token_fechac 
;

DEC_VAR_GLOBAL: TIPO VAR DEC_VAR_GLOBAL2 token_ptevirgula {

	//printf("Current Function");
	strcpy(currentFunction,"global");

	  char *tipo,*varlist,*var;
	  
	  tipo = strtok(atrib," ");
	  
	  varlist = strtok(NULL," ");	
	  
	  
	  var = strtok(varlist,",;");
	  int type= converType(tipo);
	  	  
	  while(var){
		
		s_variavel *v = allocateVar();
		
		setVar(v,var,NULL,type,currentFunction,lines);
			
		if(!varExists(HashVar,v->nome,v->escopo)) {
			hashInsertVar(HashVar,v);
		}
		else {
			printf("Erro semantico na linha %d: Variavel %s sendo redeclarada\n",lines,v->nome);
			exit(2);
		}
		var = strtok (NULL, " ,;");
	  }
	  strcpy(tipo,"\0");
	  strcpy(atrib,"\0");
	}
;

DEC_VAR_GLOBAL2: | token_virgula VAR DEC_VAR_GLOBAL2
;

PARAMETROS_TIPO: TIPO VAR  {

		/*printf("VarTipo: %d\n",tipoVar);
		printf("currentFunction: %s\n",currentFunction);
		*/
		s_variavel *var = allocateVar();		
		setVar(var,ident,NULL,tipoVar,currentFunction,lines);
		hashInsertVar(HashVar,var);
		
} PARAMETROS_TIPO2
;

PARAMETROS_TIPO2: | token_virgula TIPO VAR  {
		/*printf("VarTipo: %d\n",tipoVar);
		printf("currentFunction: %s\n",currentFunction);
		*/
		s_variavel *var = allocateVar();		
		setVar(var,ident,NULL,tipoVar,currentFunction,lines);
		hashInsertVar(HashVar,var);
} PARAMETROS_TIPO2
;
	  
COMANDAO:   DEC_VAR token_ptevirgula {
	  
	  //printf("tipo: %s\n",atrib);
	  char *tipo,*varlist,*var;
	  
	  tipo = strtok(atrib," ");
	  
	  
	  varlist = strtok(NULL," ");	
	  
	  
	  var = strtok(varlist,",;");
	  int type= converType(tipo);
	  
	  
	  	  
	  while(var){
		
		s_variavel *v = allocateVar();
	
		setVar(v,var,NULL,type,currentFunction,lines);
			
		if(!varExists(HashVar,v->nome,v->escopo)) {
			hashInsertVar(HashVar,v);
		}
		else {
			printf("Erro semantico na linha %d: Variavel %s sendo redeclarada\n",lines,v->nome);
			exit(2);
		}
		var = strtok (NULL, " ,;");
	  }
	  strcpy(tipo,"\0");
	  strcpy(atrib,"\0");
	}
	
	
	| U_EXP_LIST token_ptevirgula 	{
	  
	  strcpy(atrib,"\0");
	  
	  //if(strcpy(funcCalled,
	  int j;
	  
	  list _last = getNode(exprList,exprList->nElem-1);	  
	  
	  if(_last->nElem > 1) {
	  
	  if(*(int*)getNode(_last,1) != 999) {		
		
		if(*(int*)getNode(_last,1) != FLAG_FUNC) {

		list concatList = initList();
		for(j=0;j<exprList->nElem;j++) {
		
		    list _last = getNode(exprList,j);	  
		    int i = 0;
		    for(i = 0; i<_last->nElem; i++) {
	
		      _toList(concatList,getNode(_last,i));
		    }
			      
		}
		
		int i;
		
		eval = returnTypeExprList(concatList);
	
		/*if(eval < 0) {
				printf("Erro na linha %d: Expressao incompativel\n",lines);
				exit(2);
		}
		s_funcao *_fcalled;
		_fcalled = hashSearchFunction(HashFunc,currentFunction);
		
		
		if(returnTypeExprList(concatList) == -1 || returnTypeExprList(concatList) != _fcalled->tipo_retorno) {
		  printf("Erro na linha %d: Return associado a funcao %s nao corresponde ao tipo informado %d\n",lines,_fcalled->nome,_fcalled->tipo_retorno);
		  exit(2);
		}*/
		destroyList(concatList);
	  }
	  }
	  else {
		// remove flagFunc
		int j;
		 
		removeFromList(exprList,exprList->nElem-1);		
		// Check one by one
		
		for(j=0;j<exprList->nElem;j++) {
			if(returnTypeExprList(getNode(exprList,j)) < 0) {				
				printf("Erro na linha %d: Expressao incompativel---\n",lines);
				exit(2);
			}
			
		}
		
	  }
	  }
	  else {
		eval = returnTypeExprList(_last);
	  }
	  
	  cleanExprList(exprList);
	  
	}
	
	| ATRIBUICAO token_ptevirgula {
			
			strcpy(num_float,"\0");
			strcpy(num_inteiro,"\0");
			strcpy(num_boolean,"\0");
			strcpy(num_char,"\0");
			strcpy(num_string,"\0");
			strcpy(atrib,"\0");
	}		
	| token_string token_ptevirgula
	// TODO verificar se o tipo do return é o mesmo da funçao atual
	| token_return U_EXP_LIST {
	
	
		
	list _last = getNode(exprList,exprList->nElem-1);
	if(_last->nElem > 1) {
	
	int j;
	  if(*(int*)getNode(_last,1) != FLAG_FUNC) {

		list concatList = initList();
		for(j=0;j<exprList->nElem;j++) {
		
		    list _last = getNode(exprList,j);	  
		    int i = 0;
		    for(i = 0; i<_last->nElem; i++) {
	
		      _toList(concatList,getNode(_last,i));
		    }
			      
		}
		
	
		int i;
		
		eval = returnTypeExprList(concatList);
	
		if(eval < 0) {
				printf("Erro na linha %d: Expressao incompativel\n",lines);
				exit(2);
		}
		s_funcao *_fcalled;
		_fcalled = hashSearchFunction(HashFunc,currentFunction);
		
		
		if(returnTypeExprList(concatList) == -1 || returnTypeExprList(concatList) != _fcalled->tipo_retorno) {
		  printf("Erro na linha %d: Return associado a funcao %s nao corresponde ao tipo informado %d\n",lines,_fcalled->nome,_fcalled->tipo_retorno);
		  exit(2);
		}
		destroyList(concatList);
	  }
	  else {
		// remove flagFunc
		int j;
		removeFromList(exprList,exprList->nElem-1);		
		// Check one by one
		for(j=0;j<exprList->nElem;j++) {
			if(returnTypeExprList(getNode(exprList,j)) < 0) {
				printf("Erro na linha %d: Expressao incompativel\n",lines);
				exit(2);
			}
			
		}
	  }
	  }
	  else {
		eval = returnTypeExprList(_last);
		
		if(eval < 0) {
				printf("Erro na linha %d: Expressao incompativel\n",lines);
				exit(2);
		}
		s_funcao *_fcalled;
		_fcalled = hashSearchFunction(HashFunc,currentFunction);
		
		
		if(eval == -1 || eval != _fcalled->tipo_retorno) {
		  printf("Erro na linha %d: Return associado a funcao %s nao corresponde ao tipo informado %d\n",lines,_fcalled->nome,_fcalled->tipo_retorno);
		  exit(2);
		}
	  
	  }
	  cleanExprList(exprList);
	  strcpy(atrib,"\0");
		
		//cleanExprList(exprList);
		
	}  token_ptevirgula
	
	| token_return {
	
		
		strcpy(atrib,"\0");
		//cleanExprList(exprList);
		
	} token_ptevirgula
	
	| token_ptevirgula {
		strcpy(atrib,"\0");
		cleanExprList(exprList);
		strcpy(num_float,"\0");
		strcpy(num_inteiro,"\0");
		
	}
	| token_if token_abrep IF_EXP token_fechap COMANDAO token_else COMANDAO {
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_else COMANDAO  {
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else token_abrec BLOCO token_fechac  {
		
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else COMANDAO  {
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap COMANDAO token_else token_abrec BLOCO token_fechac  {
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_else token_abrec BLOCO token_fechac {
		cleanExprList(exprList);
	}
	| SWITCH  {
		strcpy(atrib,"\0");
		cleanExprList(exprList);
	}
	| token_break token_ptevirgula 
	| token_continue token_ptevirgula
	| LOOP	 {
		strcpy(atrib,"\0");
		cleanExprList(exprList);
	}
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



TIPO: token_int {tipoVar = T_INT;} | token_char {tipoVar = T_CHAR;} | token_float {tipoVar = T_FLOAT;}| token_void {tipoVar = T_VOID;}
      | token_bool {tipoVar = T_BOOLEAN;} | token_stringtype {tipoVar = T_STRING;}
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
      } EXP {
      printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
	//printf("Debug Tipo de B: %d\n",((NODETREEPTR)(fatorList->head->next)->element)->tipoNodeTree);
	nodeTree = allocateTreeNode();
	
	s_u_exp *u_exp = allocateU_Exp();
	setU_Exp(u_exp,">");	
	
	setTreeNode(nodeTree,u_exp,F_U_EXP);
	int i=0;
	
	if(fatorList->nElem > 2) {
	  int u=0;
	  NODELISTPTR _tracker = fatorList->head;
	  for(u=0; u < fatorList->nElem-3; u++) {
	    _tracker = _tracker->next;	    
	  }
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 2;
	  
	  _tracker->next = NULL;
	  fatorList->tail = _tracker;
	  fatorList->nElem = fatorList->nElem-2;
	  appendToTreeNode(nodeTree,auxlist);
	}
	else {
	  appendToTreeNode(nodeTree,fatorList);
	  fatorList = initList();	
	}
	printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);

      
      }
      | EXP token_menor {
		char *op = malloc(sizeof(char));
		strcpy(op,"<");
		_toList(testList,op);
      } EXP {
      printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
	//printf("Debug Tipo de B: %d\n",((NODETREEPTR)(fatorList->head->next)->element)->tipoNodeTree);
	nodeTree = allocateTreeNode();
	
	s_u_exp *u_exp = allocateU_Exp();
	setU_Exp(u_exp,"<");	
	
	setTreeNode(nodeTree,u_exp,F_U_EXP);
	int i=0;
	
	if(fatorList->nElem > 2) {
	  int u=0;
	  NODELISTPTR _tracker = fatorList->head;
	  for(u=0; u < fatorList->nElem-3; u++) {
	    _tracker = _tracker->next;	    
	  }
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 2;
	  
	  _tracker->next = NULL;
	  fatorList->tail = _tracker;
	  fatorList->nElem = fatorList->nElem-2;
	  appendToTreeNode(nodeTree,auxlist);
	}
	else {
	  appendToTreeNode(nodeTree,fatorList);
	  fatorList = initList();	
	}
	printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);

      
      }
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
      | EXP {
    
	printf("EXP\n");
	nodeTree = allocateTreeNode();
	
	s_u_exp *u_exp = allocateU_Exp();
	setU_Exp(u_exp,"(");	
	
	setTreeNode(nodeTree,u_exp,F_U_EXP);
	//int i=0;
	/*NODELISTPTR
	for(i=0; i<fatorList->nElem; i++) {
		
	}*/
	
	
	appendToTreeNode(nodeTree,fatorList);
//	fatorList = initList();

	u_expTree = allocateTreeNode();
	
	setTreeNode(u_expTree,u_exp,F_U_EXP);
	appendToTreeNode(u_expTree,fatorList);
	//fatorList = initList();

    }
  
;

IF_EXP :
      U_EXP_LIST {strcpy(atrib,"\0"); cleanExprList(exprList);}
;

U_EXP_LIST : U_EXP {
	    // Append current expression on expression list and reset testList
	    if(testList->head) {
	      NODELISTPTR apList = allocateNode();
	      apList->element = testList;
	      addNode(exprList,apList);
	      testList = initList();
	      
	     
	      }
	    } U_EXP_LIST2
;

U_EXP_LIST2 : | token_ecomecom {
			char *ecomecom = malloc(2*sizeof(char));
			strcpy(ecomecom,"&&");
			_toList(testList,ecomecom);
	      } U_EXP {	      
		  if(testList->head) {
		  // Append current expression on expression list and reset testList
		  NODELISTPTR apList = allocateNode();
		  apList->element = testList;
		  addNode(exprList,apList);
		  testList = initList();
		  }
		  
		  
		  
		  
	      }	      
	      U_EXP_LIST2 
	      | token_ou {
			char *ouou = malloc(2*sizeof(char));
			strcpy(ouou,"||");
			_toList(testList,ouou);
	      }
	      
	      U_EXP {
		  
		  if(testList->head) {
		  // Append current expression on expression list and reset testList
		  NODELISTPTR apList = allocateNode();
		  apList->element = testList;
		  addNode(exprList,apList);
		  testList = initList();
		  
		  }
	      }
	    U_EXP_LIST2
;


EXP: EXP token_mais {
		
		char *op = malloc(sizeof(char));
		*op = '+';
		_toList(testList,op);
		
		printf("Encontrei soma\n");
		
      } TERMO {
      
	printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
	//printf("Debug Tipo de B: %d\n",((NODETREEPTR)(fatorList->head->next)->element)->tipoNodeTree);
	nodeTree = allocateTreeNode();
	
	s_exp *exp = allocateExp();
	setExp(exp,'+');	
	
	setTreeNode(nodeTree,exp,F_EXP);
	int i=0;
	
	if(fatorList->nElem > 2) {
	  int u=0;
	  NODELISTPTR _tracker = fatorList->head;
	  for(u=0; u < fatorList->nElem-3; u++) {
	    _tracker = _tracker->next;	    
	  }
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 2;
	  
	  _tracker->next = NULL;
	  fatorList->tail = _tracker;
	  fatorList->nElem = fatorList->nElem-2;
	  appendToTreeNode(nodeTree,auxlist);
	}
	else {
	  
	  appendToTreeNode(nodeTree,fatorList);
	  fatorList = initList();	
	}
	printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);

      }
    | EXP token_menos {

	    printf("Encontrei menos\n");
		char *op = malloc(sizeof(char));
		*op = '-';		
		_toList(testList,op);

      } TERMO {
	printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
	//printf("Debug Tipo de B: %d\n",((NODETREEPTR)(fatorList->head->next)->element)->tipoNodeTree);
	nodeTree = allocateTreeNode();
	
	s_exp *exp = allocateExp();
	setExp(exp,'-');	
	
	setTreeNode(nodeTree,exp,F_EXP);
	int i=0;
	
	if(fatorList->nElem > 2) {
	  int u=0;
	  NODELISTPTR _tracker = fatorList->head;
	  for(u=0; u < fatorList->nElem-3; u++) {
	    _tracker = _tracker->next;	    
	  }
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 2;
	  
	  _tracker->next = NULL;
	  fatorList->tail = _tracker;
	  fatorList->nElem = fatorList->nElem-2;
	  appendToTreeNode(nodeTree,auxlist);
	}
	else {
	  
	  appendToTreeNode(nodeTree,fatorList);
	  fatorList = initList();	
	}
	printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);
      
      }

    | TERMO {
    
	printf("Termo\n");
	nodeTree = allocateTreeNode();
	
	s_exp *exp = allocateExp();
	setExp(exp,'(');	
	
	setTreeNode(nodeTree,exp,F_EXP);
	int i=0;
	/*NODELISTPTR
	for(i=0; i<fatorList->nElem; i++) {
		
	}*/
	
	
	appendToTreeNode(nodeTree,fatorList);
//	fatorList = initList();

	expTree = allocateTreeNode();
	
	setTreeNode(expTree,exp,F_EXP);
	appendToTreeNode(expTree,fatorList);
	//fatorList = initList();

    }
;

TERMO: TERMO token_vezes {
		char *op = malloc(sizeof(char));
		*op = '*';		
		_toList(testList,op);
      } FATOR {
 	
	nodeTree = allocateTreeNode();
	
	s_termo *termo = allocateTermo();
	setTermo(termo,'*');	
	
	setTreeNode(nodeTree,termo,F_TERMO);
	
	
	if(fatorList->nElem > 2) {
	  int u=0;
	  NODELISTPTR _tracker = fatorList->head;
	  for(u=0; u < fatorList->nElem-3; u++) {
	    _tracker = _tracker->next;	    
	  }
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 2;
	  
	  _tracker->next = NULL;
	  fatorList->tail = _tracker;
	  fatorList->nElem = fatorList->nElem-2;
	  appendToTreeNode(nodeTree,auxlist);
	}
	else {
	  
	  appendToTreeNode(nodeTree,fatorList);
	  fatorList = initList();	
	}
	printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);
      }
      | TERMO token_divisao {
		char *op = malloc(sizeof(char));
		*op = '/';		
		_toList(testList,op);
      } FATOR {
	nodeTree = allocateTreeNode();
	
	s_termo *termo = allocateTermo();
	setTermo(termo,'/');	
	
	setTreeNode(nodeTree,termo,F_TERMO);
	
	
	if(fatorList->nElem > 2) {
	  int u=0;
	  NODELISTPTR _tracker = fatorList->head;
	  for(u=0; u < fatorList->nElem-3; u++) {
	    _tracker = _tracker->next;	    
	  }
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 2;
	  
	  _tracker->next = NULL;
	  fatorList->tail = _tracker;
	  fatorList->nElem = fatorList->nElem-2;
	  appendToTreeNode(nodeTree,auxlist);
	}
	else {
	  
	  appendToTreeNode(nodeTree,fatorList);
	  fatorList = initList();	
	}
	printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);
      }
      | TERMO token_mod {		
		char *op = malloc(sizeof(char));
		*op = '%';		
		_toList(testList,op);
      } FATOR {
	nodeTree = allocateTreeNode();
	
	s_termo *termo = allocateTermo();
	setTermo(termo,'%');	
	
	setTreeNode(nodeTree,termo,F_TERMO);
	
	
	if(fatorList->nElem > 2) {
	  int u=0;
	  NODELISTPTR _tracker = fatorList->head;
	  for(u=0; u < fatorList->nElem-3; u++) {
	    _tracker = _tracker->next;	    
	  }
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 2;
	  
	  _tracker->next = NULL;
	  fatorList->tail = _tracker;
	  fatorList->nElem = fatorList->nElem-2;
	  appendToTreeNode(nodeTree,auxlist);
	}
	else {
	  
	  appendToTreeNode(nodeTree,fatorList);
	  fatorList = initList();	
	}
	printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);
     
      }
      | FATOR {
	printf("Fator\n");
	nodeTree = allocateTreeNode();
	
	s_termo *termo = allocateTermo();
	setTermo(termo,'(');	
	
	setTreeNode(nodeTree,termo,F_TERMO);
	int i=0;
	/*NODELISTPTR
	for(i=0; i<fatorList->nElem; i++) {
		
	}*/
	appendToTreeNode(nodeTree,fatorList);
//	fatorList = initList();
	
	
      }
;

FATOR: token_num_float {
		
		
		int *tipo = malloc(sizeof(int));
		*tipo = T_FLOAT;
		_toList(testList,tipo);
		
		
		//
		printf("Tem um float\n");
		fteste = allocateFator();
		printf("Numero inteiro: %f\n",atof(num_float));
		float *pf = malloc(sizeof(float));
		*pf = atof(num_float);
		
		setFator(fteste,T_FLOAT,pf,NULL);
		
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);
		
		
	  }
	  
	  | token_num_inteiro {
		
		int *tipo = malloc(sizeof(int));
		*tipo = T_INT;
		_toList(testList,tipo);
		
		printf("Tem um int\n");
		fteste = allocateFator();
		printf("Numero inteiro: %d\n",atoi(num_inteiro));
		int *inteiro = malloc(sizeof(int));
		*inteiro = atoi(num_inteiro);
		
		setFator(fteste,T_INT,inteiro,NULL);
		
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);
		
		
	  }	  

	  | VAR {
		// Check if var exists
		
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  exit(2);
		}
		
		int *tipo = malloc(sizeof(int));
		
		if(varExists(HashVar,ident,currentFunction)) {
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo; 
		  hashVarUpdateUse(HashVar,ident,currentFunction,USING);
		}
		else  {
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;
		  hashVarUpdateUse(HashVar,ident,"global",USING);
		  }
		
		
		_toList(testList,tipo);
		
        printf("Tem uma variavel\n");
		fteste = allocateFator();
		printf("Variavel: %s\n",ident);
		char *variavel = malloc(strlen(ident)*sizeof(char));
        strcpy(variavel,ident);
		
		setFator(fteste,T_VAR,variavel,NULL);
		
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);

		//strcpy(atrib,"\0");
	  }
	  
	  | token_abrep {
	    
	    
	    NODELISTPTR apList = allocateNode();
	    apList->element = testList;
	    addNode(exprList,apList);
	    	
	    testList = initList();
	    	    
	  } U_EXP_LIST token_fechap {
		
		//if(testList->head) printf("TestList vazia %d\n",testList->nElem);
		// Evaluate
		list _last = getNode(exprList,exprList->nElem-1);
		
		int i;
		
		int *eval_aux = malloc(sizeof(int));
		
		eval = returnTypeExprList(_last);
		*eval_aux = eval;

		if(eval < 0) {
			printf("Erro na linha %d: Tipos incompativeis numa expressao\n",lines);
			exit(2);
		}

		// Check if it needs appending
		list _previous = getNode(exprList,exprList->nElem-2);
		if(_previous) {
			removeFromList(exprList,exprList->nElem-1);			
			_toList(_previous,eval_aux);			
		}
		
		
		
	  }
	  | token_letra {
		
		int *tipo = malloc(sizeof(int));
		*tipo = T_CHAR;
		
		_toList(testList,tipo);
	  }
	  | CHAMADA_FUNCAO {
		//printf("Achei uma funcao: %s\n",ident);
		
		
		int *tipo = malloc(sizeof(int));
		*tipo = ((s_funcao*)(hashSearchFunction(HashFunc,funcCalled)))->tipo_retorno;
		
		
		int *flagFunc = malloc(sizeof(int));
		*flagFunc = FLAG_FUNC;
		
		_toList(testList,tipo);
		_toList(testList,flagFunc);
		
		
		
		strcpy(funcCalled,"\0");
	  }
	  
	  
	  
      	  | VAR token_maismais {
		// Check if var exists
		
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  exit(2);
		}
		
		
		
		int *tipo = malloc(sizeof(int));
		
		//*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber ++\n",lines,ident);
		  exit(2);
		}
		
		
		_toList(testList,tipo);
		strcpy(atrib,"\0");
      	  }
	  | token_maismais VAR {
		// Check if var exists
		printf("Achei uma variavel: %s\n",ident);
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  exit(2);
		}
		
		
		int *tipo = malloc(sizeof(int));
		
		//*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;
		
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber ++\n",lines,ident);
		  exit(2);
		}
		
		
		_toList(testList,tipo);
		
		strcpy(atrib,"\0");	  
	  }
	  
	  | token_menosmenos VAR {
		
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  exit(2);
		}
		
		
		int *tipo = malloc(sizeof(int));
		//*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber --\n",lines,ident);
		  exit(2);
		}
		
		
		_toList(testList,tipo);
		
		strcpy(atrib,"\0");
	  }
	  | VAR token_menosmenos {
		
		
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  exit(2);
		}		

		int *tipo = malloc(sizeof(int));
		//*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber --\n",lines,ident);
		  exit(2);
		}
		

		_toList(testList,tipo);
		strcpy(atrib,"\0");	  
	  }
	  | token_menos token_num_float {
		
		int *tipo = malloc(sizeof(int));
		*tipo = T_FLOAT;
		_toList(testList,tipo);	  

		printf("Tem um float negativo\n");
		fteste = allocateFator();
		printf("Numero float: %f\n",atof(num_float));
		float *f = malloc(sizeof(float));
		*f = -1 * atof(num_float);
		
		setFator(fteste,T_FLOAT,f,NULL);
		
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);

	  }
	  | token_menos VAR {
		
		//s_variavel *auxv = hashSearchVar(HashVar,ident,currentFunction);
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  exit(2);
		}		

		int *tipo = malloc(sizeof(int));
		//*tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;
		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber --\n",lines,ident);
		  exit(2);
		}
		
		_toList(testList,tipo);
		
		strcpy(atrib,"\0");	  
	  }
	  | token_menos token_num_inteiro {
		
        
		int *tipo = malloc(sizeof(int));
		*tipo = T_INT;
		
		_toList(testList,tipo);
		
		printf("Tem um int negativo\n");
		fteste = allocateFator();
		printf("Numero inteiro: %d\n",atoi(num_inteiro));
		int *inteiro = malloc(sizeof(int));
		*inteiro = -1 * atoi(num_inteiro);
		
		setFator(fteste,T_INT,inteiro,NULL);
		
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);
	  }
;


/* ATRIBUICAO */
ATRIBUICAO: VAR token_igual {strcpy(atrib,"\0"); strcpy(lident,ident);} TO_ATRIB {


			
			char *varname = strtok(atrib," ");

			if ( strlen(varname) > 1 && varname[0] == '('){
				int i;
				for (i=0;i<strlen(varname);i++) varname[i] = varname[i+1];
				varname[i] = '\0';
			}
			
			/*s_variavel *v = hashSearchVar(HashVar,varname,currentFunction);
			s_variavel *vglob = 
			printf("%s %s\n",varname, currentFunction);*/
			
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				exit(1);
			}
			
			
			
			hashVarUpdateUse(HashVar,varname,currentFunction,USING);
			hashVarUpdateUse(HashVar,lident,currentFunction,USING);
			
			
			
			int *tipo_var = malloc(sizeof(int));
			
			
			if(varExists(HashVar,lident,currentFunction)) 
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,lident,currentFunction)))->tipo;
			else  
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,lident,"global")))->tipo;
			
			//printf("var: %s, tipo_var: %d, eval: %d\n",lident,*tipo_var,eval);
			//int tipo_var = v->tipo;

				if ( (*tipo_var == T_INT || *tipo_var == T_FLOAT || *tipo_var == T_CHAR) && eval == T_INT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_FLOAT && eval == T_FLOAT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_CHAR && eval == T_CHAR) {
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_BOOLEAN && eval == T_BOOLEAN){
					//printf("Ok! Tipo permitido!\n");
				}
				else if ( *tipo_var == T_STRING && eval == T_STRING){
					//printf("Ok! Tipo permitido!\n");
				}
				else{
					
					printf("Erro semantico na linha %d: Atribuicao nao permitida\n",lines);
					exit(2);
				}
				eval = 0;

	  }		
	  | VAR token_maisigual TO_ATRIB {
	  
	  char *varname = strtok(atrib," ");
			
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				exit(1);
			}
			hashVarUpdateUse(HashVar,varname,currentFunction,USING);
			hashVarUpdateUse(HashVar,ident,currentFunction,USING);
			
			int *tipo_var = malloc(sizeof(int));
			if(varExists(HashVar,ident,currentFunction)) 
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
			else  
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;

	  
	  if ( (*tipo_var == T_INT || *tipo_var == T_FLOAT || *tipo_var == T_CHAR) && eval == T_INT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_FLOAT && eval == T_FLOAT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_CHAR && eval == T_CHAR) {
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_BOOLEAN && eval == T_BOOLEAN){
					//printf("Ok! Tipo permitido!\n");
				}else{
					printf("Erro semantico na linha %d: Atribuicao nao permitida\n",lines);
					exit(2);
				}
	  }
	  
	  | VAR token_menosigual TO_ATRIB {
		char *varname = strtok(atrib," ");
			
						if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				exit(1);
			}
			hashVarUpdateUse(HashVar,varname,currentFunction,USING);
			hashVarUpdateUse(HashVar,ident,currentFunction,USING);
			int *tipo_var = malloc(sizeof(int));
			if(varExists(HashVar,ident,currentFunction)) 
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
			else  
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;

	  
	  if ( (*tipo_var == T_INT || *tipo_var == T_FLOAT || *tipo_var == T_CHAR) && eval == T_INT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_FLOAT && eval == T_FLOAT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_CHAR && eval == T_CHAR) {
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_BOOLEAN && eval == T_BOOLEAN){
					//printf("Ok! Tipo permitido!\n");
				}else{
					printf("Erro semantico na linha %d: Atribuicao nao permitida\n",lines);
					exit(2);
				}
		}	  
	  | VAR token_vezesigual TO_ATRIB {
		char *varname = strtok(atrib," ");
			
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				exit(1);
			}
			hashVarUpdateUse(HashVar,varname,currentFunction,USING);
			hashVarUpdateUse(HashVar,ident,currentFunction,USING);
			int *tipo_var = malloc(sizeof(int));
			if(varExists(HashVar,ident,currentFunction)) 
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
			else  
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;

	  
	  if ( (*tipo_var == T_INT || *tipo_var == T_FLOAT || *tipo_var == T_CHAR) && eval == T_INT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_FLOAT && eval == T_FLOAT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_CHAR && eval == T_CHAR) {
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_BOOLEAN && eval == T_BOOLEAN){
					//printf("Ok! Tipo permitido!\n");
				}else{
					printf("Erro semantico na linha %d: Atribuicao nao permitida\n",lines);
					exit(2);
				}
		}	  
	  | VAR token_divisaoigual TO_ATRIB{
		char *varname = strtok(atrib," ");
			
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				exit(1);
			}
			hashVarUpdateUse(HashVar,varname,currentFunction,USING);
			hashVarUpdateUse(HashVar,ident,currentFunction,USING);
			int *tipo_var = malloc(sizeof(int));
			if(varExists(HashVar,ident,currentFunction)) 
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
			else  
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;

	  
	  if ( (*tipo_var == T_INT || *tipo_var == T_FLOAT || *tipo_var == T_CHAR) && eval == T_INT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_FLOAT && eval == T_FLOAT){
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_CHAR && eval == T_CHAR) {
					//printf("Ok! Tipo permitido!\n");
				}else if ( *tipo_var == T_BOOLEAN && eval == T_BOOLEAN){
					//printf("Ok! Tipo permitido!\n");
				}else{
					printf("Erro semantico na linha %d: Atribuicao nao permitida\n",lines);
					exit(2);
				}
		}	  
	  | VAR token_ecomigual TO_ATRIB	
	  | VAR token_xnorigual TO_ATRIB
	  | VAR token_ouigual TO_ATRIB
	  | VAR token_shiftdireitaigual TO_ATRIB
	  | VAR token_shiftesquerdaigual TO_ATRIB
;

TO_ATRIB:  U_EXP_LIST {
	  list _last = getNode(exprList,exprList->nElem-1);
	int j;
	//if(_last && _last->head) printf("Last ok\n");
	  if(_last->nElem > 1) {
	    if(*(int*)getNode(_last,1) != FLAG_FUNC) {		
		  list concatList = initList();
		  for(j=0;j<exprList->nElem;j++) {
		  
		      list _last = getNode(exprList,j);	  
		      int i = 0;
		      for(i = 0; i<_last->nElem; i++) {
			_toList(concatList,getNode(_last,i));
		      }
				
		  }
		  
		  
		  int i;
		  
		  eval = returnTypeExprList(concatList);    
		  

		  if(returnTypeExprList(concatList) < 0) {
				  printf("Erro na linha %d: Expressao incompativel\n",lines);
				  exit(2);
			  }
		
		  
		  //if(_fcalled) printf("funcao %s\n",_fcalled->nome);
		  destroyList(concatList);
	    }
	    else {
		  // remove flagFunc
		  
		  int j;
		 // printf("aqui\n");
		  
		  list fRet = getNode(exprList,exprList->nElem-1);
		  
		  eval = *(int*)getNode(fRet,0);
		  
		  
		  removeFromList(exprList,exprList->nElem-1);
		  
		  
		  // Check one by one
		  for(j=0;j<exprList->nElem;j++) {
			  
			  if(returnTypeExprList(getNode(exprList,j)) < 0) {
				  printf("Erro na linha %d: Expressao incompativel\n",lines);
				  exit(2);
			  }
		  
		  }
		  
	    }
	  }
	  else {
		  if(returnTypeExprList(_last) < 0) {
				  printf("Erro na linha %d: Expressao incompativel\n",lines);
				  exit(2);
			  }
		eval = returnTypeExprList(_last);
	  
	  }
	  
	  cleanExprList(exprList);
	  }
	  | token_string;

CHAMADA_FUNCAO : token_ident token_abrep {
			char *funcname;
			funcname = strtok(atrib,"(");
			strcpy(funcCalled,funcname);
			
			//printf("atrib: %s\n");
			
			}
			
			PARAMETROS token_fechap {
			
				
				char *funcname,*parlist,*tmpparlist;
				
				int nParam=1;


				int i=0;
				//printf("tmpparlist: %s\n",tmpparlist);
				for(i=0; atrib[i] != '\0'; i++) {
					//printf("tmpparlist[%d]: %c\n",i,'a');
					if(atrib[i]==',') nParam++;
				}
			
			
			// Verifica existencia e aridade da funcao
			if(!funcExists(HashFunc,funcCalled)) {
				printf("Erro na linha %d: Funcao nao definida\n",lines);
				exit(2);
			}
			else {
				s_funcao *aux = hashSearchFunction(HashFunc,funcCalled);
				if(checkArity(aux,nParam) != 1) {
					printf("Erro na linha %d: Funcao sendo chamada com numero incorreto de parametros\n",lines);
					exit(2);
				}
				// Verifica se a lista de parametros esta com os tipos corretos
				else {
					// Casos especiais: printf, scanf, max, min - nao verificar os parametros
					if(strcmp(funcCalled,"printf")!=0 && strcmp(funcCalled,"scanf")!=0 && strcmp(funcCalled,"max")!=0 && strcmp(funcCalled,"min")!=0) {
					
					list pList = aux->parametros;
					int i=0;
					for(i=0; i<aux->parametros->nElem; i++) {
					
						int piOriginal,piPassado;
						
						piOriginal = *(int*)(getNode(pList,i));
						//pList = pList->next;
						
						list t = getNode(exprList,i);
						int j;
						
						
						piPassado = returnTypeExprList(t);
						
						switch(piOriginal) {
							case T_INT:
								if(piPassado != T_CHAR && piPassado != T_INT && piPassado != T_FLOAT) {
									printf("Erro semantico na linha %d: Tipo de parametro incorreto!\n",lines);
									exit(2);
								}
								
								break;
								
							case T_CHAR:
								if(piPassado != T_CHAR && piPassado != T_INT && piPassado != T_FLOAT) {
									printf("Erro semantico na linha %d: Tipo de parametro incorreto!\n",lines);
									exit(2);
								}
								break;
							
							case T_FLOAT:
								if(piPassado != T_CHAR && piPassado != T_INT && piPassado != T_FLOAT) {
									printf("Erro semantico na linha %d: Tipo de parametro incorreto!\n",lines);
									exit(2);
								}
								break;
							case T_BOOLEAN:
								if(piPassado != T_BOOLEAN) {
									printf("Erro semantico na linha %d: Tipo de parametro incorreto!\n",lines);
									exit(2);
								}
						}
						
					}
					}
				}
			}
			  
			  strcpy(atrib,"\0");
		}
		


		  | token_ident token_abrep token_fechap {
			strcpy(funcCalled,ident);						
			
			//char *funcname;
			//funcname = strtok(atrib,"(");
			
			if(!funcExists(HashFunc,funcCalled)) {
				printf("Erro na linha %d: Funcao nao definida\n",lines);
				exit(2);
			}
			else {
				s_funcao *aux = hashSearchFunction(HashFunc,funcCalled);
				if(checkArity(aux,0) != 1) {
					printf("Erro na linha %d: Funcao com parametros sendo chamada sem parametros\n",lines);
					exit(2);
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

SWITCH: token_switch token_abrep VAR {

			s_variavel *v = hashSearchVar(HashVar,ident,currentFunction);

			if (v == NULL){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				exit(1);
			}
			hashVarUpdateUse(HashVar,ident,currentFunction,USING);
			
			strcpy(ident,"\0");

		}token_fechap token_abrec SWITCH_BLOCK token_fechac;

SWITCH_BLOCK : token_default token_doispontos {strcpy(atrib,"\0");} BLOCO 
		| token_case token_num_inteiro token_doispontos {strcpy(atrib,"\0");} BLOCO SWITCH_BLOCK2 token_default token_doispontos {strcpy(atrib,"\0");} BLOCO
		| token_case token_letra token_doispontos {strcpy(atrib,"\0");} BLOCO SWITCH_BLOCK2 token_default token_doispontos {strcpy(atrib,"\0");} BLOCO
;
SWITCH_BLOCK2 : 
		| token_case token_num_inteiro token_doispontos {strcpy(atrib,"\0");} BLOCO SWITCH_BLOCK2
		| token_case token_letra token_doispontos {strcpy(atrib,"\0");} BLOCO SWITCH_BLOCK2 
;

/* LOOP */

LOOP : FOR_LOOP | DO_WHILE_LOOP | WHILE_LOOP ;

WHILE_LOOP: token_while token_abrep U_EXP_LIST token_fechap {strcpy(atrib,"\0"); cleanExprList(exprList);} COMANDAO
	    | token_while token_abrep U_EXP_LIST token_fechap token_abrec {strcpy(atrib,"\0"); cleanExprList(exprList);}  BLOCO token_fechac
;

DO_WHILE_LOOP : token_do COMANDAO token_while {strcpy(atrib,"\0"); cleanExprList(exprList);} token_abrep U_EXP_LIST token_fechap token_ptevirgula
		| token_do token_abrec BLOCO token_fechac {strcpy(atrib,"\0"); cleanExprList(exprList);} token_while token_abrep U_EXP_LIST token_fechap token_ptevirgula
;

FOR_LOOP : token_for token_abrep ATRIBUICAO_LIST token_ptevirgula U_EXP_LIST token_ptevirgula COMMAND_LIST token_fechap {cleanExprList(exprList);} COMANDAO {strcpy(atrib,"\0");}
	   | token_for token_abrep ATRIBUICAO_LIST token_ptevirgula U_EXP_LIST token_ptevirgula COMMAND_LIST token_fechap token_abrec {strcpy(atrib,"\0"); cleanExprList(exprList);} BLOCO token_fechac
	   | token_for token_abrep ATRIBUICAO_LIST token_ptevirgula token_ptevirgula COMMAND_LIST token_fechap {strcpy(atrib,"\0"); cleanExprList(exprList);} COMANDAO 
	   | token_for token_abrep ATRIBUICAO_LIST token_ptevirgula token_ptevirgula COMMAND_LIST token_fechap token_abrec {strcpy(atrib,"\0"); cleanExprList(exprList);} BLOCO token_fechac
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
	bigTree = initTree();

	initHash(HashVar,MAX_HASH_SIZE);
	initHash(HashFunc,MAX_HASH_SIZE);
	
	exprList = initList();
	testList = initList();
	fatorList = initList();
	termoList = initList();
	auxlist = initList();
	
	

	s_funcao* print = allocateFunction();
	setFunction(print,"printf",2,T_VOID,NULL);

	s_funcao* scan = allocateFunction();
	setFunction(scan,"scanf",2,T_INT,NULL);

	s_funcao* max = allocateFunction();
	setFunction(max,"max",2,T_INT,NULL);

	s_funcao* min = allocateFunction();
	setFunction(min,"min",2,T_INT,NULL);

	s_funcao* _main = allocateFunction();
	setFunction(_main,"main",0,T_INT,NULL);

	hashInsertFunction(HashFunc,print);
	hashInsertFunction(HashFunc,scan);
	hashInsertFunction(HashFunc,max);
	hashInsertFunction(HashFunc,min);
	hashInsertFunction(HashFunc,_main);
	
	strcpy(atrib,"\0");
	strcpy(num_float,"\0");
	strcpy(num_inteiro,"\0");
	strcpy(num_char,"\0");
	strcpy(num_boolean,"\0");
	strcpy(num_string,"\0");

	in_for = 0;

	yyparse();

 //   s_variavel* s = allocateVar();

       
 //   setVar(s,"a",1,T_INT,"main",5);
 //   hashInsertVar(HashVar,s);

    float* valor = malloc(sizeof(int));
    *valor = 2.5;
    hashVarUpdateValue(HashVar,"a","main",valor);
    hashVarUpdateUse(HashVar,"a","main", USING);
    
	checkVariables(HashVar);	
	
	// Testando Fator
//	printf("Fator: %d, %d\n",fteste->tipo,*(int*)executaFator(fteste));
	
	//printf("Fator: %d\n",*(int*)(executeNodeTree(getNode((list)(nodeTree->children->head->element),0))));
/*	printf("Fator2: %d\n",*(int*)(executeNodeTree(getNode((list)(nodeTree->children->head->element),1))));
	printf("Fator3: %d\n",((list)(nodeTree->children->head->element))->nElem);
*/	

	  
//	printf("Fator: %f\n",*(float*)((s_fator*)(executeNodeTree(expTree)))->valor);
	debug();
	printf("Fator: %d\n",*(int*)((s_fator*)(executeNodeTree(nodeTree)))->valor);
	
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){
	printf("Erro na Linha: %d\n", lines);
}
