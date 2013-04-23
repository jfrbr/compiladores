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
int find_ok;
extern list HashVar[MAX_HASH_SIZE];
extern list HashFunc[MAX_HASH_SIZE];
char _num_inteiro[50];
char _num_char[50];

list _size;
list exprList;
list testList;
list parList;

int *sizeBlock;

s_fator *fteste;

NODETREEPTR nodeTree;
NODETREEPTR atribTree;
NODETREEPTR expTree;
NODETREEPTR u_expTree;
NODETREEPTR u_exp_listTree;
NODETREEPTR conditionTree;
NODETREEPTR _cond;
NODETREEPTR _loop;
NODETREEPTR _switch;

list fatorList;
list termoList;
list auxlist;
tree bigTree;
list exList;
list elseList;
list sizeBlockList;
list incList;
list atribList;

list cmdList;
s_atrib *atribTeste;
s_conditional *condition;
s_loop *loop;
s_funcao *function;
s_switch *sw;

s_fator *retValue;

list parnames;
list parametrosPassados;
list functionStack;

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
	parnames = initList();
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

			function = allocateFunction();
			setFunction(function,funcname,parameters->nElem,returnType,parameters,NULL);
		
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
			printf("--\n\nparnames size: %d\n",parnames->nElem);
			setFunctionParNames(function,parnames);
			

			} token_abrec BLOCO token_fechac {
			    strcpy(currentFunction,"global");
			    printf("Funcao sem parametros é nós!\n");
			    printf("cmdList size: %d\n",cmdList->nElem);
			    setFunctionCmdList(function,cmdList);
			    cmdList = initList();
			    fatorList = initList();
			    _size = initList();
			    *sizeBlock = 0;
			    sizeBlockList = initList();
			    
			    
			}
	| TIPO token_ident token_abrep token_fechap {
		
			char *tipo, *funcname,*varlist,*var;
			tipo = strtok(atrib," ");
		
			int returnType = converType(tipo);
			
			funcname = strtok(NULL,"(");	
		
			strcpy(currentFunction,funcname);

	
		int type = converType(tipo);
		
		function = allocateFunction();
		setFunction(function,funcname,0,type,NULL,NULL);
		
		if(!funcExists(HashFunc,function->nome)) {
			hashInsertFunction(HashFunc,function);
		}
		else {
			printf("Erro semantico na linha %d: Funcao %s sendo redeclarada\n",lines,function->nome);
			exit(2);
		}
			
		strcpy(atrib,"\0");
	} token_abrec BLOCO token_fechac {
		printf("Funcao sem parametros é nós!\n");
		printf("cmdList size: %d\n",cmdList->nElem);
		setFunctionCmdList(function,cmdList);
		cmdList = initList();
		fatorList = initList();
		_size = initList();
		*sizeBlock = 0;
		sizeBlockList = initList();
	}
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

		char *varname = malloc(50*sizeof(char));
		printf("VarTipo: %d\n",tipoVar);
		printf("currentFunction: %s\n",currentFunction);
		printf("--\nIdent: %s\n\n",ident);
		
		strcpy(varname,ident);
		_toList(parnames,varname);
		
		s_variavel *var = allocateVar();		
		setVar(var,ident,NULL,tipoVar,currentFunction,lines);
		hashInsertVar(HashVar,var);
		
} PARAMETROS_TIPO2
;

PARAMETROS_TIPO2: | token_virgula TIPO VAR  {
		/*printf("VarTipo: %d\n",tipoVar);
		printf("currentFunction: %s\n",currentFunction);
		*/
		char *varname = malloc(50*sizeof(char));
		printf("--\nIdent: %s\n\n",ident);
		strcpy(varname,ident);
		_toList(parnames,varname);
		
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
	  
	  
	  // Inserindo node dummy na lista cmdList
//	  printf("Inserindo node dummy na lista cmdList\n");
	  NODETREEPTR dummy = allocateTreeNode();
	  setTreeNode(dummy,NULL,F_DEC);
	  _toList(cmdList,dummy);
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
		 
		removeWithoutFreeFromList(exprList,exprList->nElem-1);		
		// Check one by one
		printf("UEXP_LIST2\n");
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
	  
	  if(nodeTree) {
	    //printf("\n\nNodeTree %d!\n\n",cmdList->nElem);
	    _toList(cmdList,nodeTree);
	    //printf("\n\nNodeTree %d!\n\n",cmdList->nElem);
	    
	    nodeTree = NULL;
	    fatorList = initList();
	    //NODETREEPTR _teste = getNode(exList,0);
	    //printf("_teste: %d\n",*(int*)(executeNodeTree(_teste))->valor);
	    //exit(1);
	  }
	}
	
	| ATRIBUICAO token_ptevirgula {
			
			strcpy(num_float,"\0");
			strcpy(num_inteiro,"\0");
			strcpy(num_boolean,"\0");
			strcpy(num_char,"\0");
			strcpy(num_string,"\0");
			strcpy(atrib,"\0");


			//executeNodeTree((NODETREEPTR)cmdList->head->element);
			
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
		removeWithoutFreeFromList(exprList,exprList->nElem-1);		
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
	  if(nodeTree) {
	    /*printf("\n\nNodeTree %d!\n\n",cmdList->nElem);
	    _toList(cmdList,nodeTree);
	    printf("\n\nNodeTree %d!\n\n",cmdList->nElem);
	    */
	    NODETREEPTR dummy = allocateTreeNode();
	    setTreeNode(dummy,nodeTree,F_RETURN);
	    _toList(cmdList,dummy);
	    
	    nodeTree = NULL;
	    fatorList = initList();
	    //NODETREEPTR _teste = getNode(exList,0);
	    //printf("_teste: %d\n",*(int*)(executeNodeTree(_teste))->valor);
	    //exit(1);
	  }
		//cleanExprList(exprList);
		
	}  token_ptevirgula
	
	| token_return {
		
		strcpy(atrib,"\0");
		//cleanExprList(exprList);
		
	} token_ptevirgula {
	  
	  printf("\n\n\nPassei por aqui!\n\n\n");
	  NODETREEPTR dummy = allocateTreeNode();
	  setTreeNode(dummy,NULL,F_RETURN);
	  _toList(cmdList,dummy);
		
	}
	
	| token_ptevirgula {
		strcpy(atrib,"\0");
		cleanExprList(exprList);
		strcpy(num_float,"\0");
		strcpy(num_inteiro,"\0");
		
	}
	| token_if token_abrep IF_EXP token_fechap COMANDAO token_else COMANDAO {
	
			printf("If associado %d\n",cmdList->nElem);
		
		// Else
		
		  NODELISTPTR _tracker = cmdList->head;
		  int u=0;
		  for(u=0; u < cmdList->nElem-2; u++) {
		    
		    _tracker = _tracker->next;	    
		  }
		  elseList = initList();
		  elseList->head = _tracker->next;
		  elseList->nElem = 1;
		  
		  _tracker->next = NULL;
		  cmdList->tail = _tracker;
		  cmdList->nElem = cmdList->nElem-1;
		  
		  // IF
		  _tracker = cmdList->head;
		  u=0;
		  for(u=0; u < cmdList->nElem-2; u++) {
		    
		    _tracker = _tracker->next;	    
		  }
		  auxlist = initList();
		  auxlist->head = _tracker->next;
		  auxlist->nElem = 1;
		  
		  _tracker->next = NULL;
		  cmdList->tail = _tracker;
		  cmdList->nElem = cmdList->nElem-1;
		  
		  
		  
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,elseList);
	      
		  
		  
		  //condition->commandList = ;

		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  printf("Numero de Elementos em exList: %d\n",exList->nElem);
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  
		  _toList(cmdList,_cond);
	
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_else COMANDAO  {
					printf("If associado %d\n",cmdList->nElem);
		
		// Else
		
		  NODELISTPTR _tracker = cmdList->head;
		  int u=0;
		  for(u=0; u < cmdList->nElem-2; u++) {
		    
		    _tracker = _tracker->next;	    
		  }
		  elseList = initList();
		  elseList->head = _tracker->next;
		  elseList->nElem = 1;
		  
		  _tracker->next = NULL;
		  cmdList->tail = _tracker;
		  cmdList->nElem = cmdList->nElem-1;
		  		  
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),NULL,elseList);

		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  printf("Numero de Elementos em exList: %d\n",exList->nElem);
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  printf("Numero de Elementos em exList: %d\n",exList->nElem);
		  _toList(cmdList,_cond);

	
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else token_abrec BLOCO token_fechac  {
		
		printf("If com else com blocos, sizeBlockList tem %d elementos\n",sizeBlockList->nElem);
		
		printf("O If tem %d comandos e o else, %d\n",*(int*)getNode(sizeBlockList,sizeBlockList->nElem-2),*(int*)getNode(sizeBlockList,sizeBlockList->nElem-1));
		printf("A cmdList tem %d comandos\n",cmdList->nElem);
		int ifsize,elsesize;
		ifsize = *(int*)getNode(sizeBlockList,sizeBlockList->nElem-2);
		elsesize = *(int*)getNode(sizeBlockList,sizeBlockList->nElem-1);
		
		//destroyList(sizeBlockList);		
		//sizeBlockList = initList();


		NODELISTPTR _tracker = sizeBlockList->head;
		if(sizeBlockList->nElem <= 2) {
		  //printf("Aqui---------------------------\n");
		  sizeBlockList = initList();
		}
		else {
		  //sizeBlockList->head = sizeBlockList->head->next->next;
		  int i=0;
		  for(i = 0; i < sizeBlockList->nElem-3; i++) _tracker = _tracker->next;
		  _tracker->next = NULL;
		  
		  sizeBlockList->nElem -= 2;
		}
		
		
		_tracker = cmdList->head;
		if(elsesize == 0) {
			printf("Else ta vazio\n");
			elseList = NULL;
		}
		else {
		  _tracker = cmdList->head;
		    int u=0;
		    for(u=0; u < cmdList->nElem-elsesize-1; u++) {		      
		      _tracker = _tracker->next;	    
		    }
		    elseList = initList();
		    elseList->head = _tracker->next;
		    elseList->nElem = elsesize;
		    
		    _tracker->next = NULL;
		    cmdList->tail = _tracker;
		    cmdList->nElem = cmdList->nElem-elsesize;
		}
		
		_tracker = cmdList->head;
		// If
		if(ifsize == 0) {
			printf("If ta vazio\n");
			auxlist = NULL;
		}
		else {
			_tracker = cmdList->head;
		    int u=0;
		    for(u=0; u < cmdList->nElem-ifsize-1; u++) {
		      
		      _tracker = _tracker->next;	    
		    }
		    auxlist = initList();
		    auxlist->head = _tracker->next;
		    auxlist->nElem = ifsize;
		    
		    _tracker->next = NULL;
		    cmdList->tail = _tracker;
		    cmdList->nElem = cmdList->nElem-ifsize;
		}
		int i;	
		    NODELISTPTR _temp = auxlist->head;
		    for(i=1;_temp;i++) {
		      printf("%d\n",i);
		      _temp = _temp->next;
		    }
		    
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,elseList);
		  
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  
		  _toList(cmdList,_cond);
		
		// Popping the value of sizeBlock
		*sizeBlock = *(int*)getNode(_size,_size->nElem-3);	
		printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
		
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else COMANDAO  {
		
		
		int ifsize;
		ifsize = *(int*)getNode(sizeBlockList,sizeBlockList->nElem-1);
		//elsesize = *(int*)sizeBlockList->head->next->element;
		NODELISTPTR _tracker = cmdList->head;
		//destroyList(sizeBlockList);		
		//sizeBlockList = initList();
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  //sizeBlockList->head = sizeBlockList->head->next;
		  int i=0;
		  for(i = 0; i < sizeBlockList->nElem-2; i++) _tracker = _tracker->next;
		  _tracker->next = NULL;
		  
		  sizeBlockList->nElem -= 1;
		}
		
		printf("---\nEntrou aqui Ifsize: %d!\n---\n",ifsize);
		_tracker = cmdList->head;
		  _tracker = cmdList->head;
		    int u=0;
		    for(u=0; u < cmdList->nElem-2; u++) {
		      
		      _tracker = _tracker->next;	    
		    }
		    elseList = initList();
		    elseList->head = _tracker->next;
		    elseList->nElem = 1;
		    
		    _tracker->next = NULL;
		    cmdList->tail = _tracker;
		    cmdList->nElem = cmdList->nElem-1;
		
		
		_tracker = cmdList->head;
		// If
		if(ifsize == 0) {
			printf("If ta vazio\n");
			auxlist = NULL;
		}
		else {
			_tracker = cmdList->head;
		    int u=0;
		    for(u=0; u < cmdList->nElem-ifsize-1; u++) {
		      
		      _tracker = _tracker->next;	    
		    }
		    auxlist = initList();
		    auxlist->head = _tracker->next;
		    auxlist->nElem = ifsize;
		    
		    _tracker->next = NULL;
		    cmdList->tail = _tracker;
		    cmdList->nElem = cmdList->nElem-ifsize;
		}
		
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,elseList);
		  
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  
		  _toList(cmdList,_cond);
		
		// Popping the value of sizeBlock
		*sizeBlock = *(int*)getNode(_size,_size->nElem-2);
		printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
	
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap COMANDAO token_else token_abrec BLOCO token_fechac  {
		printf("Entrou aqui!\n");
		int elsesize;
		//ifsize = *(int*)sizeBlockList->head->element;
		elsesize = *(int*)sizeBlockList->tail->element;
		
		//destroyList(sizeBlockList);		
		//sizeBlockList = initList();
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  NODELISTPTR _tmp = sizeBlockList->head;
		  int i=0;
		  for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		  //sizeBlockList->head = sizeBlockList->head->next;
		  _tmp->next = NULL;
		  sizeBlockList->tail = _tmp;
		  sizeBlockList->nElem -= 1;
		}
		
		
		
		if(elsesize == 0) {
			printf("Else ta vazio\n");
			elseList = NULL;
		}
		else {
		  NODELISTPTR _tracker = cmdList->head;
		    int u=0;
		    for(u=0; u < cmdList->nElem-elsesize-1; u++) {
		      
		      _tracker = _tracker->next;	    
		    }
		    elseList = initList();
		    elseList->head = _tracker->next;
		    elseList->nElem = elsesize;
		    
		    _tracker->next = NULL;
		    cmdList->tail = _tracker;
		    cmdList->nElem = cmdList->nElem-elsesize;
		}
		
		// IF
		  NODELISTPTR _tracker = cmdList->head;
		  int u=0;
		  for(u=0; u < cmdList->nElem-2; u++) {
		    
		    _tracker = _tracker->next;	    
		  }
		  auxlist = initList();
		  auxlist->head = _tracker->next;
		  auxlist->nElem = 1;
		  
		  _tracker->next = NULL;
		  cmdList->tail = _tracker;
		  cmdList->nElem = cmdList->nElem-1;

		
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,elseList);
		  
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  
		  _toList(cmdList,_cond);
		
		// Popping the value of sizeBlock
		*sizeBlock = *(int*)getNode(_size,_size->nElem-2);
		printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
	
	
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_else token_abrec BLOCO token_fechac {
			printf("Entrou aqui!\n");
		int elsesize;
		//ifsize = *(int*)sizeBlockList->head->element;
		elsesize = *(int*)sizeBlockList->tail->element;
		
		//destroyList(sizeBlockList);		
		//sizeBlockList = initList();
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  //sizeBlockList->head = sizeBlockList->head->next;
		  NODELISTPTR _tmp = sizeBlockList->head;
		  int i=0;
		  for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		  //sizeBlockList->head = sizeBlockList->head->next;
		  _tmp->next = NULL;
		  sizeBlockList->tail = _tmp;
		  sizeBlockList->nElem -= 1;
		}
		
		
		
		if(elsesize == 0) {
			printf("Else ta vazio\n");
			elseList = NULL;
		}
		else {
		  NODELISTPTR _tracker = cmdList->head;
		    int u=0;
		    for(u=0; u < cmdList->nElem-elsesize-1; u++) {
		      
		      _tracker = _tracker->next;	    
		    }
		    elseList = initList();
		    elseList->head = _tracker->next;
		    elseList->nElem = elsesize;
		    
		    _tracker->next = NULL;
		    cmdList->tail = _tracker;
		    cmdList->nElem = cmdList->nElem-elsesize;
		}
		
		
		
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),NULL,elseList);
		  
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  
		  _toList(cmdList,_cond);
		
		// Popping the value of sizeBlock
		*sizeBlock = *(int*)getNode(_size,_size->nElem-2);
		printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
	
		cleanExprList(exprList);
	}
	| SWITCH  {
	    if (_switch){
		     printf("Inserindo switch na cmdList...\n");
		     printf("ELEMENTOS EM CMD LIST = %d\n",cmdList->nElem);
		    _toList(cmdList,_switch);	    
		}
		else{
		    printf("LOOP NULO\nAbortando...");
		    exit(1);
		}
		
		strcpy(atrib,"\0");
		cleanExprList(exprList);
	}
	| token_break token_ptevirgula {
		NODETREEPTR dummy = allocateTreeNode();
		setTreeNode(dummy,NULL,F_BREAK);
		_toList(cmdList,dummy);
	}
	| token_continue token_ptevirgula {
	      NODETREEPTR dummy = allocateTreeNode();
		setTreeNode(dummy,NULL,F_CONTINUE);
		_toList(cmdList,dummy);
	}
	| LOOP	 {

		if (_loop){
		     printf("Inserindo loop na cmdList...\n");
		     printf("ELEMENTOS EM CMD LIST = %d\n",cmdList->nElem);
		    _toList(cmdList,_loop);	    
		}
		else{
		    printf("LOOP NULO\nAbortando...");
		    exit(1);
		}
		
		strcpy(atrib,"\0");
		cleanExprList(exprList);
	}
;



BLOCO:	/**/ {
		printf("Acabou um Bloco Vazio\n");
		sizeBlock = malloc(sizeof(int));
		*sizeBlock = 0;
		_toList(sizeBlockList,sizeBlock);
		
	} | COMANDAO {
		printf("Comecou um bloco com um comando\n");
		if(sizeBlock) {
		  printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
		  if(!_size) _size = initList();
		  _toList(_size,sizeBlock);
		  }
		
		sizeBlock = malloc(sizeof(int));
		*sizeBlock = 1;
	} BLOCO2 | COMANDO {

	
	if(sizeBlock) {
		  printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
		  if(!_size) _size = initList();
		  _toList(_size,sizeBlock);
		  }
		
	
	sizeBlock = malloc(sizeof(int));
	*sizeBlock = 1;
	_toList(cmdList,_cond);
	} BLOCO2
;

BLOCO2: /**/ {
		printf("\n\nAcabou um Bloco de tamanho %d---\n\n",*sizeBlock);
		_toList(sizeBlockList,sizeBlock);
				
		
	} | COMANDAO {
	  *sizeBlock = *sizeBlock + 1;
	  printf("Um comandao aqui pahnois %d\n",*sizeBlock);
	  printf("cmdList: %d\n",cmdList->nElem);
	  
	} BLOCO2 | COMANDO{
	  *sizeBlock = *sizeBlock + 1;
	  printf("Achei um comando %d\n",*sizeBlock);
	  _toList(cmdList,_cond);
	  
	} BLOCO2
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
      } EXP{
            //printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
	//printf("Debug Tipo de B: %d\n",((NODETREEPTR)(fatorList->head->next)->element)->tipoNodeTree);
	nodeTree = allocateTreeNode();
	
	s_u_exp *u_exp = allocateU_Exp();
	setU_Exp(u_exp,"==");	
	
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);


      }
      | EXP token_maior {
		char *op = malloc(sizeof(char));
		strcpy(op,">");
		_toList(testList,op);
      } EXP {
      //printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);

      
      }
      | EXP token_menor {
		char *op = malloc(sizeof(char));
		strcpy(op,"<");
		_toList(testList,op);
      } EXP {
      //printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);

      
      }
      | EXP token_maiorigual {
		char *op = malloc(2*sizeof(char));
		strcpy(op,">=");
		_toList(testList,op);
      } EXP {
      //printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
	//printf("Debug Tipo de B: %d\n",((NODETREEPTR)(fatorList->head->next)->element)->tipoNodeTree);
	nodeTree = allocateTreeNode();
	
	s_u_exp *u_exp = allocateU_Exp();
	setU_Exp(u_exp,">=");	
	
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);


      }
      | EXP token_menorigual {
		char *op = malloc(2*sizeof(char));
		strcpy(op,"<=");
		_toList(testList,op);
      } EXP{
      //printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
	//printf("Debug Tipo de B: %d\n",((NODETREEPTR)(fatorList->head->next)->element)->tipoNodeTree);
	nodeTree = allocateTreeNode();
	
	s_u_exp *u_exp = allocateU_Exp();
	setU_Exp(u_exp,"<=");	
	
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);


      }
      | EXP token_diferente {
		char *op = malloc(2*sizeof(char));
		strcpy(op,"!=");
		_toList(testList,op);
      } EXP{
      //printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
	//printf("Debug Tipo de B: %d\n",((NODETREEPTR)(fatorList->head->next)->element)->tipoNodeTree);
	nodeTree = allocateTreeNode();
	
	s_u_exp *u_exp = allocateU_Exp();
	setU_Exp(u_exp,"!=");	
	
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);


      }
      | EXP {
    
	
	printf("EXP %d\n",fatorList->nElem);
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
      U_EXP_LIST {
      //printf("If nao associado %d\n",*(int*)executeNodeTree(nodeTree)->valor);
      
      conditionTree = nodeTree;
      printf("Inserindo condicao na exList\n");
      _toList(exList,nodeTree);
      
      strcpy(atrib,"\0"); 
      cleanExprList(exprList);
      
      fatorList = initList();
      nodeTree = NULL;
      }
;

U_EXP_LIST : U_EXP {
	    // Append current expression on expression list and reset testList
	    if(testList->head) {
	      NODELISTPTR apList = allocateNode();
	      apList->element = testList;
	      addNode(exprList,apList);
	      testList = initList();
	      
	     
	      }
	      
	      
	      
      //	fatorList = initList();

	      /*u_exp_listTree = allocateTreeNode();
	      
	      setTreeNode(u_exp_listTree,u_exp_list,F_U_EXP_LIST);
		
	      appendToTreeNode(u_exp_listTree,fatorList);	      //fatorList = initList();*/
		//printf("Passou\n");    
		//printf("AAAchou! Lista fatorList tem %d elementos %d\n",fatorList->nElem,nodeTree->tipoNodeTree);
	      // Achou uma U_EXP
	      //'('
	    } U_EXP_LIST2
;

U_EXP_LIST2 : {
	      
	      printf("UEXP_LIST_ACABOU\n");
	      nodeTree = allocateTreeNode();
	      
	      s_u_exp_list *u_exp_list = allocateU_Exp_List();
	      setU_Exp_List(u_exp_list,"(");	
	      
	      setTreeNode(nodeTree,u_exp_list,F_U_EXP_LIST);
	      //int i=0;
	      /*NODELISTPTR
	      for(i=0; i<fatorList->nElem; i++) {
		      
	      }*/
	      
	      printf("Fator List: %d\n",fatorList->nElem);
	      appendToTreeNode(nodeTree,fatorList);
	      // Aqui precisa retirar o ultimo elemento, nao necessariamente zerar a lista
	      if(fatorList->nElem == 1) {
		fatorList = initList();
	      }
	      else {
		NODELISTPTR _tracker = fatorList->head;
		int u=0;
		for(u = 0; u < fatorList->nElem-1; u++) _tracker = _tracker->next;
		_tracker->next = NULL;
		fatorList->nElem--;
	      }
	      _toList(fatorList,nodeTree);
	      
	      } 
	      
	      | token_ecomecom {
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
		  //printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
		  
		  //printf("Debug Tipo de B: %d\n",((NODETREEPTR)(fatorList->head->next)->element)->tipoNodeTree);
		  nodeTree = allocateTreeNode();
		  
		  s_u_exp_list *u_exp_list = allocateU_Exp_List();
		  setU_Exp_List(u_exp_list,"&&");	
		  
		  setTreeNode(nodeTree,u_exp_list,F_U_EXP_LIST);
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
		  //printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
			  
		  _toList(fatorList,nodeTree);

		  
		  // Achou outra
		  
		  
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
		  
		  // Achou outra
	      }
	    U_EXP_LIST2
;


EXP: EXP token_mais {
		
		char *op = malloc(sizeof(char));
		*op = '+';
		_toList(testList,op);
		
		//printf("Encontrei soma\n");
		
      } TERMO {
      
	//printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);

      }
    | EXP token_menos {

	  //  printf("Encontrei menos\n");
		char *op = malloc(sizeof(char));
		*op = '-';		
		_toList(testList,op);

      } TERMO {
	//printf("Achou! Lista fatorList tem %d elementos, exptree tem %d\n",fatorList->nElem,expTree->children->nElem);
	
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);
      
      }

    | TERMO {
    
	//printf("Termo\n");
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
	
		
	_toList(fatorList,nodeTree);
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",fatorList->nElem,nodeTree->tipoNodeTree);
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
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
	//printf("AAchou! Lista fatorList tem %d elementos %d\n",auxlist->nElem,nodeTree->tipoNodeTree);
		
	_toList(fatorList,nodeTree);
     
      }
      | FATOR {
	//printf("Fator\n");
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
		//printf("Tem um float\n");
		fteste = allocateFator();
		//printf("Numero inteiro: %f\n",atof(num_float));
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
		
		//printf("Tem um int\n");
		fteste = allocateFator();
		//printf("Numero inteiro: %d\n",atoi(num_inteiro));
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
		
		printf("UEXPPAR\n");
		printf("Aqui %d!\n",fatorList->nElem);
	      //nodeTree = allocateTreeNode();
	      
	      //s_u_exp_list *u_exp_list = allocateU_Exp_List();
	      //setU_Exp_List(u_exp_list,"(");	
	      
	      //setTreeNode(nodeTree,u_exp_list,F_U_EXP_LIST);
	      //appendToTreeNode(nodeTree,fatorList);
	      //_toList(fatorList,nodeTree);
	      
	      //fteste = (s_fator*)(executeNodeTree(nodeTree));
	      
	      /*if(fatorList->nElem > 1) {
		int u=0;
		NODELISTPTR _tracker = fatorList->head;
		for(u=0; u < fatorList->nElem-2; u++) {
		  _tracker = _tracker->next;	    
		}
		auxlist = initList();
		auxlist->head = _tracker->next;
		auxlist->nElem = 2;
		
		_tracker->next = NULL;
		fatorList->tail = _tracker;
		fatorList->nElem = fatorList->nElem-2;
		//appendToTreeNode(nodeTree,auxlist);
	      }
	      else {		
		printf("Aqui!\n");
		//appendToTreeNode(nodeTree,fatorList);
		fatorList = initList();	
	      }*/
		//_toList(fatorList,nodeTree);
	      
	      //printf("fteste->valor %d %d %d\n",*(int*)fteste->valor,fatorList->nElem,((NODETREEPTR)(fatorList->head->element))->tipoNodeTree);
	      //nodeTree = allocateTreeNode();
	      //setTreeNode(nodeTree,fteste,F_FATOR);		
	      //_toList(fatorList,nodeTree);
		
	  }	
	  | token_letra {
		
		int *tipo = malloc(sizeof(int));
		*tipo = T_CHAR;
		
		_toList(testList,tipo);
		
		fteste = allocateFator();
		//printf("Numero inteiro: %d\n",atoi(num_inteiro));
		char *letra = malloc(sizeof(char));
		if ( strlen(num_char) == 3){
		    *letra = num_char[1];
		}else{
		    printf("token_letra # Erro no tamanho\n");
		}
		
		setFator(fteste,T_CHAR,letra,NULL);
		
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);

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
		
		printf("Tem uma variavel com ++anterior\n");
		fteste = allocateFator();
		printf("Variavel: %s\n",ident);
		char *variavel = malloc(strlen(ident)*sizeof(char));
		strcpy(variavel,ident);
        
       		auxlist = initList();
       		int *_aux = (int*) malloc(sizeof(int));
       		*_aux = P_MAISMAISAFT;
		_toList(auxlist,_aux);		
		printf("Aqui: %d\n",*(int*)(auxlist->head->element));
		
		setFator(fteste,T_VAR,variavel,auxlist);
		
		
		auxlist=NULL;
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);
		
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
		
		// trab4
		
		printf("Tem uma variavel com ++anterior\n");
		fteste = allocateFator();
		printf("Variavel: %s\n",ident);
		char *variavel = malloc(strlen(ident)*sizeof(char));
		strcpy(variavel,ident);
        
       		auxlist = initList();
       		int *_aux = (int*) malloc(sizeof(int));
       		*_aux = P_MAISMAISANT;
		_toList(auxlist,_aux);		
		printf("Aqui: %d\n",*(int*)(auxlist->head->element));
		
		setFator(fteste,T_VAR,variavel,auxlist);
		
		
		auxlist=NULL;
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);
		
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
		
		// Trab 4
		printf("Tem uma variavel com ++anterior\n");
		fteste = allocateFator();
		printf("Variavel: %s\n",ident);
		char *variavel = malloc(strlen(ident)*sizeof(char));
		strcpy(variavel,ident);
        
       		auxlist = initList();
       		int *_aux = (int*) malloc(sizeof(int));
       		*_aux = P_MENOSMENOSANT;
		_toList(auxlist,_aux);		
		printf("Aqui: %d\n",*(int*)(auxlist->head->element));
		
		setFator(fteste,T_VAR,variavel,auxlist);
		
		
		auxlist=NULL;
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);
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
		
		printf("Tem uma variavel com ++anterior\n");
		fteste = allocateFator();
		printf("Variavel: %s\n",ident);
		char *variavel = malloc(strlen(ident)*sizeof(char));
		strcpy(variavel,ident);
        
       		auxlist = initList();
       		int *_aux = (int*) malloc(sizeof(int));
       		*_aux = P_MENOSMENOSAFT;
		_toList(auxlist,_aux);		
		printf("Aqui: %d\n",*(int*)(auxlist->head->element));
		
		setFator(fteste,T_VAR,variavel,auxlist);
		
		
		auxlist=NULL;
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);
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

		printf("Achei variavel com valor negativo...\n");
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
		
		fteste = allocateFator();
		printf("Variavel: %s\n",ident);
		char *variavel = malloc(strlen(ident)*sizeof(char));
        strcpy(variavel,ident);
        
		list par = initList();

		int* p = malloc(sizeof(int));
		*p = NEGATIVE_VALUE;
		
		_toList(par,p);		
		
		setFator(fteste,T_VAR,variavel,par);
		
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		
		_toList(fatorList,nodeTree);
		
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
		  
			printf("atrib: %s\n",lident);
			char *varname = strtok(ident," ");
			/*if ( strlen(varname) > 1 && varname[0] == '('){
				int i;
				for (i=0;i<strlen(varname);i++) varname[i] = varname[i+1];
				varname[i] = '\0';
			}*/
			
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				exit(1);
			}
			//printf("Passei\n");
			
			hashVarUpdateUse(HashVar,varname,currentFunction,USING);
			hashVarUpdateUse(HashVar,lident,currentFunction,USING);
			
			int *tipo_var = malloc(sizeof(int));
			
			if(varExists(HashVar,lident,currentFunction)) 
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,lident,currentFunction)))->tipo;
			else  
			    *tipo_var = ((s_variavel*)(hashSearchVar(HashVar,lident,"global")))->tipo;
			
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
		
		
		atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();
		setAtrib(atribTeste,"=",lident,nodeTree,NULL);

	    printf("SETEI O F_ATRIB PARA IGUAL\n");
		setTreeNode(atribTree,atribTeste,F_ATRIB);

		printf("Inserindo atribTree na cmdList\n");
			
	    _toList(cmdList,atribTree);		

		fatorList = initList();
		nodeTree = NULL;
		
		
		//void setAtrib(s_atrib *t, char *op, char *varname, /*char *escopo,*/ s_u_exp_list *toatrib, char *stringToAtrib);	
	  }		
	  | VAR token_maisigual {strcpy(atrib,"\0"); strcpy(lident,ident);} TO_ATRIB {
	  
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

	    atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();

		setAtrib(atribTeste,"+=",lident,nodeTree,NULL);
		printf("SETEI O F_ATRIB PARA MAIS IGUAL\n");
		setTreeNode(atribTree,atribTeste,F_ATRIB);

		printf("Inserindo atribTree na cmdList\n");
			
		_toList(cmdList,atribTree);		

		fatorList = initList();
		nodeTree = NULL;

	  }

	  
	  | VAR token_menosigual {strcpy(atrib,"\0"); strcpy(lident,ident);} TO_ATRIB {
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
		atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();

		setAtrib(atribTeste,"-=",lident,nodeTree,NULL);
	
		setTreeNode(atribTree,atribTeste,F_ATRIB);

		printf("Inserindo atribTree na cmdList\n");
			
		_toList(cmdList,atribTree);		

		fatorList = initList();
		nodeTree = NULL;
		}	  
	  | VAR token_vezesigual {strcpy(atrib,"\0"); strcpy(lident,ident);} TO_ATRIB {
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
		atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();

		setAtrib(atribTeste,"*=",lident,nodeTree,NULL);
	
		setTreeNode(atribTree,atribTeste,F_ATRIB);

					printf("Inserindo atribTree na cmdList\n");
			
			_toList(cmdList,atribTree);		

			fatorList = initList();
			nodeTree = NULL;
		}	  
	  | VAR token_divisaoigual {strcpy(atrib,"\0"); strcpy(lident,ident);} TO_ATRIB{
	  
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
		atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();

		setAtrib(atribTeste,"/=",lident,nodeTree,NULL);
	
		setTreeNode(atribTree,atribTeste,F_ATRIB);

					printf("Inserindo atribTree na cmdList\n");
			
			_toList(cmdList,atribTree);		

			fatorList = initList();
			nodeTree = NULL;
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
		  
		  
		  removeWithoutFreeFromList(exprList,exprList->nElem-1);
		  
		  
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
			
				debug();
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
					printf("Entrei!\n");
				}
			}
			  
			  strcpy(atrib,"\0");
			  
			  printf("Chamando uma funcao com %d parametros!\n",parametrosPassados->nElem);
			
			fteste = allocateFator();
			printf("Funcao: %s\n",funcCalled);
			
			
			//exit(1);
			//float *f = malloc(sizeof(float));
			//*f = -1 * atof(num_float);
			char *_funcName = malloc(50*sizeof(char));
			strcpy(_funcName,funcCalled);
			
			if(parametrosPassados) printf("PARAMETROS: %d\n\n",parametrosPassados->nElem);
			setFator(fteste,F_FUNCAO,_funcName,parametrosPassados);
			
			nodeTree = allocateTreeNode();
			setTreeNode(nodeTree,fteste,F_FATOR);
			
			_toList(fatorList,nodeTree);
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
			
			printf("Chamando uma funcao sem parametros!\n");
			
			fteste = allocateFator();
			printf("Funcao: %s\n",funcCalled);
			
			
			//exit(1);
			//float *f = malloc(sizeof(float));
			//*f = -1 * atof(num_float);
			char *_funcName = malloc(50*sizeof(char));
			strcpy(_funcName,funcCalled);
			
			setFator(fteste,F_FUNCAO,_funcName,NULL);
			
			nodeTree = allocateTreeNode();
			setTreeNode(nodeTree,fteste,F_FATOR);
			
			_toList(fatorList,nodeTree);
			
			
		  }
;

PARAMETROS: U_EXP_LIST  {
		parametrosPassados = initList();
		printf("Chamando uma funcao com parametro\n");
		if(nodeTree) printf("Tem nodeTree\n");
		printf("Inserindo parametros na pPassados\n");
		_toList(parametrosPassados,nodeTree);		
		
		fatorList = initList();
		nodeTree = NULL;
		
	} PAR2 | token_string {
	parametrosPassados = initList();
	printf("A string e: %s %d\n",num_string,strlen(num_string));
	
	// Criando uma string pra inserir na pPassados
	char *parString = calloc(strlen(num_string)+1,sizeof(char));
	strcpy(parString,num_string);
	printf("A string e: %s %d\n",parString,strlen(parString));
	//s_fator *f_string = allocateFator();
	//setFator(f_string,T_STRING,parString,NULL);
	_toList(parametrosPassados,parString);
	//fatorList = initList();
	//	nodeTree = NULL;
	//	debug();
	
	} PAR2;

PAR2: {printf("\n\nFim dos parametros\n\n");}| token_virgula U_EXP_LIST {
	  
	  printf("Inserindo parametros na pPassados\n");
	  _toList(parametrosPassados,nodeTree);		
	  fatorList = initList();
	  nodeTree = NULL;
	  
} PAR2 | token_virgula token_string PAR2;



COMANDO: CMD_NAO_ASSOC | CMD_NAO_ASSOC_CHAVE
;

CMD_NAO_ASSOC_CHAVE : token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac {
		printf("If SEM else com blocos, sizeBlockList tem %d elementos\n",sizeBlockList->nElem);
		//printf("O If tem %d comandos\n",*(int*)sizeBlockList->head->element);
		printf("A cmdList tem %d comandos\n",cmdList->nElem);
		int ifsize;
		ifsize = *(int*)sizeBlockList->tail->element;
		//elsesize = *(int*)sizeBlockList->head->next->element;
		
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  //sizeBlockList->head = sizeBlockList->head->next;
		  NODELISTPTR _tmp = sizeBlockList->head;
		  int i=0;
		  for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		  //sizeBlockList->head = sizeBlockList->head->next;
		  _tmp->next = NULL;
		  sizeBlockList->tail = _tmp;
		  sizeBlockList->nElem -= 1;
		}
		
		
		NODELISTPTR _tracker = cmdList->head;
		// If
		if(ifsize == 0) {
			printf("If ta vazio\n");
			auxlist = NULL;
		}
		else {
			_tracker = cmdList->head;
		    int u=0;
		    for(u=0; u < cmdList->nElem-ifsize-1; u++) {
		      
		      _tracker = _tracker->next;	    
		    }
		    auxlist = initList();
		    auxlist->head = _tracker->next;
		    auxlist->nElem = ifsize;
		    
		    _tracker->next = NULL;
		    cmdList->tail = _tracker;
		    cmdList->nElem = cmdList->nElem-ifsize;
		}
		
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,NULL);
		  
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  
		  //_toList(cmdList,_cond);
		  
		  // Popping the value of sizeBlock
		  *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		  printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
		      }
		| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else COMANDO {
				printf("\n\n\n\nIf nao associado com Else // %d\n\n\n\n",cmdList->nElem);
				
				
				//NODELISTPTR _tracker = cmdList->head;
				  int u=0;
				  
				  elseList = initList();
				  _toList(elseList,_cond);
				  
				  int ifsize;
				  ifsize = *(int*)sizeBlockList->tail->element;
				  printf("-%d\n",ifsize);
				  //elsesize = *(int*)sizeBlockList->head->next->element;
				  
				  if(sizeBlockList->nElem <= 1) {
				    sizeBlockList = initList();
				  }
				  else {
				    //sizeBlockList->head = sizeBlockList->head->next;
				    NODELISTPTR _tmp = sizeBlockList->head;
				    int i=0;
				    for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
				    //sizeBlockList->head = sizeBlockList->head->next;
				    _tmp->next = NULL;
				    sizeBlockList->tail = _tmp;
				    sizeBlockList->nElem -= 1;
				  }
				  
				  
				  NODELISTPTR _tracker = cmdList->head;
				  // If
				  if(ifsize == 0) {
					  printf("If ta vazio\n");
					  auxlist = NULL;
				  }
				  else {
					  _tracker = cmdList->head;
				      int u=0;
				      for(u=0; u < cmdList->nElem-ifsize-1; u++) {
					
					_tracker = _tracker->next;	    
				      }
				      auxlist = initList();
				      auxlist->head = _tracker->next;
				      auxlist->nElem = ifsize;
				      
				      _tracker->next = NULL;
				      cmdList->tail = _tracker;
				      cmdList->nElem = cmdList->nElem-ifsize;
				  }
				  
				  
				  condition = allocateConditional();
				  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,elseList);
			      
				  _cond = allocateTreeNode();
				  setTreeNode(_cond,condition,F_CONDITIONAL);
				  
				  printf("Numero de Elementos em exList: %d\n",exList->nElem);
				  removeWithoutFreeFromList(exList,exList->nElem-1);
				
				  // Popping the value of sizeBlock
		*sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
		      
		      }
;

CMD_NAO_ASSOC : token_if token_abrep IF_EXP token_fechap COMANDAO {
			printf("If nao associado ||||%d\n",cmdList->nElem);
	 NODELISTPTR _tracker = cmdList->head;
	  int u=0;
	  for(u=0; u < cmdList->nElem-2; u++) {
	    
	    _tracker = _tracker->next;	    
	  }
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 1;
	  
	  
	  
	  _tracker->next = NULL;
	  cmdList->tail = _tracker;
	  cmdList->nElem = cmdList->nElem-1;
	  //appendToTreeNode(nodeTree,auxlist);
	  
	  //list ltracker = initList();
	  //_toList(ltracker,_tracker);
	  
	  condition = allocateConditional();
	  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,NULL);
      
	  
	  
	  //condition->commandList = ;

	  _cond = allocateTreeNode();
	  setTreeNode(_cond,condition,F_CONDITIONAL);
	  
	  //printf("Numero de Elementos em exList: %d\n",exList->nElem);
	  removeWithoutFreeFromList(exList,exList->nElem-1);			
	  //printf("Numero de Elementos em exList: %d\n",exList->nElem);
			
		}
		
		| token_if token_abrep IF_EXP token_fechap COMANDO {
		
		
			printf("If aninhado!\n");
			printf("ANumero de Elementos em exList: %d\n",exList->nElem);
			//NODETREEPTR _aux = _cond;
			auxlist = initList();
			_toList(auxlist,_cond);
			
			condition = allocateConditional();
			setConditional(condition,getNode(exList,exList->nElem-1),auxlist,NULL);
			
			_cond = allocateTreeNode();
			setTreeNode(_cond,condition,F_CONDITIONAL);
		
		}
		| token_if token_abrep IF_EXP token_fechap COMANDAO token_else COMANDO {
		printf("If nao associado com Else%d\n",cmdList->nElem);
		NODELISTPTR _tracker = cmdList->head;
		  int u=0;
		  
		  elseList = initList();
		  _toList(elseList,_cond);
		  
		  // If
		  _tracker = cmdList->head;
		  for(u=0; u < cmdList->nElem-2; u++) {
		    
		    _tracker = _tracker->next;	    
		  }
		  auxlist = initList();
		  auxlist->head = _tracker->next;
		  auxlist->nElem = 1;
		  
		  _tracker->next = NULL;
		  cmdList->tail = _tracker;
		  cmdList->nElem = cmdList->nElem-1;
		  
		  
		  
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,elseList);
	      
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  printf("Numero de Elementos em exList: %d\n",exList->nElem);
		  //removeWithoutFreeFromList(exList,exList->nElem-1);
		
		}
		| token_if token_abrep IF_EXP token_fechap token_else COMANDO {
		  printf("If nao associado com Else%d\n",cmdList->nElem);
		
		  
		  elseList = initList();
		  _toList(elseList,_cond);
		  
		  
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),NULL,elseList);
	      
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  printf("Numero de Elementos em exList: %d\n",exList->nElem);
		  //removeWithoutFreeFromList(exList,exList->nElem-1);
		}
;

/* SWITCH */

SWITCH: token_switch token_abrep VAR {

			s_variavel *v = hashSearchVar(HashVar,ident,currentFunction);

			if (v == NULL){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				exit(1);
			}
			hashVarUpdateUse(HashVar,ident,currentFunction,USING);

            sw = allocateSwitch();
            setSwitch(sw,ident,currentFunction);
            
			strcpy(ident,"\0");

		}token_fechap token_abrec SWITCH_BLOCK token_fechac;

SWITCH_BLOCK : token_default token_doispontos {strcpy(atrib,"\0");} BLOCO{
            
            int sw_size = *(int*)sizeBlockList->tail->element;

		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      //sizeBlockList->head = sizeBlockList->head->next;
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      //sizeBlockList->head = sizeBlockList->head->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
				
		    NODELISTPTR _tracker = cmdList->head;
		    // Switch
		    if(sw_size == 0) {
			    printf("Switch ta vazio\n");
			    auxlist = NULL;
		    }
		    else {
			    _tracker = cmdList->head;
		        int u=0;
		        for(u=0; u < cmdList->nElem-sw_size-1; u++) {
		          _tracker = _tracker->next;	    
		        }
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        auxlist->nElem = sw_size;
		        
		        _tracker->next = NULL;
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-sw_size;
 		    }

             ssb* _ssb = malloc(sizeof(ssb));
            
             _ssb->condition = NULL; // Default recebe NULL
             _ssb->commands = auxlist;
		
             addSsb(sw,_ssb);

		     //Como default eh obrigatorio, neste caso seta o valor de _switch 
		     _switch = allocateTreeNode();
		     setTreeNode(_switch,sw,F_SWITCH);
		      		      
		     // Popping the value of sizeBlock
		     *sizeBlock = *(int*)getNode(_size,_size->nElem-1);

        }
		| token_case token_num_inteiro token_doispontos {strcpy(atrib,"\0");strcpy(_num_inteiro,num_inteiro);} BLOCO{
		
				
		    int* n_int = malloc(sizeof(int));
		    *n_int = atoi(_num_inteiro);

            int sw_size = *(int*)sizeBlockList->tail->element;

		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      //sizeBlockList->head = sizeBlockList->head->next;
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      //sizeBlockList->head = sizeBlockList->head->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
				
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {
			    printf("Switch ta vazio\n");
			    auxlist = NULL;
		    }
		    else {
			    _tracker = cmdList->head;
		        int u=0;
		        for(u=0; u < cmdList->nElem-sw_size-1; u++) {
		          _tracker = _tracker->next;	    
		        }
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        auxlist->nElem = sw_size;
		        
		        _tracker->next = NULL;
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-sw_size;
 		    }

             ssb* _ssb = malloc(sizeof(ssb));
            
             _ssb->condition = n_int;
             _ssb->commands = auxlist;
		
             addSsb(sw,_ssb);

		     //Como default eh obrigatorio, neste caso seta o valor de _switch 
		     _switch = allocateTreeNode();
		     setTreeNode(_switch,sw,F_SWITCH);
		      		      
		     // Popping the value of sizeBlock
		     *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		     printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
		     
		}SWITCH_BLOCK2 token_default token_doispontos {strcpy(atrib,"\0");} BLOCO
		{

            int sw_size = *(int*)sizeBlockList->tail->element;

		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      //sizeBlockList->head = sizeBlockList->head->next;
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      //sizeBlockList->head = sizeBlockList->head->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
				
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {
			    printf("Switch ta vazio\n");
			    auxlist = NULL;
		    }
		    else {
			    _tracker = cmdList->head;
		        int u=0;
		        for(u=0; u < cmdList->nElem-sw_size-1; u++) {
		          _tracker = _tracker->next;	    
		        }
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        auxlist->nElem = sw_size;
		        
		        _tracker->next = NULL;
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-sw_size;
 		    }

             ssb* _ssb = malloc(sizeof(ssb));
            
             _ssb->condition = NULL; // Default recebe NULL
             _ssb->commands = auxlist;
		
             addSsb(sw,_ssb);

		     //Como default eh obrigatorio, neste caso seta o valor de _switch 
		     _switch = allocateTreeNode();
		     setTreeNode(_switch,sw,F_SWITCH);
		      		      
		     // Popping the value of sizeBlock
		     *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		     printf("Valor atual de sizeBlock: %d\n",*sizeBlock);

		   
		}
		| token_case token_letra token_doispontos {strcpy(atrib,"\0");} BLOCO SWITCH_BLOCK2 {

				    char* n_char = malloc(sizeof(char));
		    *n_char = _num_char[1];

            int sw_size = *(int*)sizeBlockList->tail->element;

		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      //sizeBlockList->head = sizeBlockList->head->next;
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      //sizeBlockList->head = sizeBlockList->head->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
				
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {
			    printf("Switch ta vazio\n");
			    auxlist = NULL;
		    }
		    else {
			    _tracker = cmdList->head;
		        int u=0;
		        for(u=0; u < cmdList->nElem-sw_size-1; u++) {
		          _tracker = _tracker->next;	    
		        }
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        auxlist->nElem = sw_size;
		        
		        _tracker->next = NULL;
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-sw_size;
 		    }

             ssb* _ssb = malloc(sizeof(ssb));
            
             _ssb->condition = n_char;
             _ssb->commands = auxlist;
		
             addSsb(sw,_ssb);

		     //Como default eh obrigatorio, neste caso seta o valor de _switch 
		     _switch = allocateTreeNode();
		     setTreeNode(_switch,sw,F_SWITCH);
		      		      
		     // Popping the value of sizeBlock
		     *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		     printf("Valor atual de sizeBlock: %d\n",*sizeBlock);


		}token_default token_doispontos {strcpy(atrib,"\0");} BLOCO{


		            int sw_size = *(int*)sizeBlockList->tail->element;

		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      //sizeBlockList->head = sizeBlockList->head->next;
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      //sizeBlockList->head = sizeBlockList->head->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
				
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {
			    printf("Switch ta vazio\n");
			    auxlist = NULL;
		    }
		    else {
			    _tracker = cmdList->head;
		        int u=0;
		        for(u=0; u < cmdList->nElem-sw_size-1; u++) {
		          _tracker = _tracker->next;	    
		        }
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        auxlist->nElem = sw_size;
		        
		        _tracker->next = NULL;
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-sw_size;
 		    }

             ssb* _ssb = malloc(sizeof(ssb));
            
             _ssb->condition = NULL; // Default recebe NULL
             _ssb->commands = auxlist;
		
             addSsb(sw,_ssb);

		     //Como default eh obrigatorio, neste caso seta o valor de _switch 
		     _switch = allocateTreeNode();
		     setTreeNode(_switch,sw,F_SWITCH);
		      		      
		     // Popping the value of sizeBlock
		     *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		     printf("Valor atual de sizeBlock: %d\n",*sizeBlock);

		}
;
SWITCH_BLOCK2 : 
		| token_case token_num_inteiro token_doispontos {strcpy(atrib,"\0");strcpy(_num_inteiro,num_inteiro);} BLOCO SWITCH_BLOCK2{
		    printf("NUM_INTEIRO = %s\n",_num_inteiro);
		    int* n_int = malloc(sizeof(int));
		    *n_int = atoi(_num_inteiro);

            int sw_size = *(int*)sizeBlockList->tail->element;
		    printf("Tamanho do switch = %d\n",sw_size);


		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      //sizeBlockList->head = sizeBlockList->head->next;
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      //sizeBlockList->head = sizeBlockList->head->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
				
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {
			    printf("Switch ta vazio\n");
			    auxlist = NULL;
		    }
		    else {
			    _tracker = cmdList->head;
		        int u=0;
		        for(u=0; u < cmdList->nElem-sw_size-1; u++) {
		          _tracker = _tracker->next;	    
		        }
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        auxlist->nElem = sw_size;
		        
		        _tracker->next = NULL;
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-sw_size;
 		    }

             ssb* _ssb = malloc(sizeof(ssb));
            
             _ssb->condition = n_int;
             _ssb->commands = auxlist;
		
             addSsb(sw,_ssb);

		     //Como default eh obrigatorio, neste caso seta o valor de _switch 
		     _switch = allocateTreeNode();
		     setTreeNode(_switch,sw,F_SWITCH);
		      		      
		     // Popping the value of sizeBlock
		     *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		     printf("Valor atual de sizeBlock: %d\n",*sizeBlock);

		}
		| token_case token_letra token_doispontos {strcpy(atrib,"\0");strcpy(_num_char,num_char);} BLOCO SWITCH_BLOCK2{


		    char* n_char = malloc(sizeof(char));
		    *n_char = _num_char[1];

            int sw_size = *(int*)sizeBlockList->tail->element;

		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      //sizeBlockList->head = sizeBlockList->head->next;
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      //sizeBlockList->head = sizeBlockList->head->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
				
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {
			    printf("Switch ta vazio\n");
			    auxlist = NULL;
		    }
		    else {
			    _tracker = cmdList->head;
		        int u=0;
		        for(u=0; u < cmdList->nElem-sw_size-1; u++) {
		          _tracker = _tracker->next;	    
		        }
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        auxlist->nElem = sw_size;
		        
		        _tracker->next = NULL;
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-sw_size;
 		    }

             ssb* _ssb = malloc(sizeof(ssb));
            
             _ssb->condition = n_char;
             _ssb->commands = auxlist;
		
             addSsb(sw,_ssb);

		     //Como default eh obrigatorio, neste caso seta o valor de _switch 
		     _switch = allocateTreeNode();
		     setTreeNode(_switch,sw,F_SWITCH);
		      		      
		     // Popping the value of sizeBlock
		     *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		     printf("Valor atual de sizeBlock: %d\n",*sizeBlock);

		}
;

/* LOOP */

LOOP : FOR_LOOP | DO_WHILE_LOOP | WHILE_LOOP ;

WHILE_LOOP: token_while token_abrep IF_EXP token_fechap {strcpy(atrib,"\0"); cleanExprList(exprList);} COMANDAO {

            printf("to no while\n");    

       NODELISTPTR _tracker = cmdList->head;
	  int u=0;
	  for(u=0; u < cmdList->nElem-2; u++) {
	    
	    _tracker = _tracker->next;	    
	  }
	  
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 1;
	  
	  
	  _tracker->next = NULL;
	  cmdList->tail = _tracker;
	  cmdList->nElem = cmdList->nElem-1;
	  //appendToTreeNode(nodeTree,auxlist);
	  
	  //list ltracker = initList();
	  //_toList(ltracker,_tracker);
	  
	  loop = allocateLoop();
	  setLoop(loop,getNode(exList,exList->nElem-1),auxlist,NULL,NULL,WHILE);
     
	  //condition->commandList = ;

	  _loop = allocateTreeNode();
	  setTreeNode(_loop,loop,F_LOOP);
	  
	  printf("Numero de Elementos em exList: %d\n",exList->nElem);
	  removeWithoutFreeFromList(exList,exList->nElem-1);			
	  printf("Numero de Elementos em exList: %d\n",exList->nElem);
	  
        }
	    | token_while token_abrep IF_EXP token_fechap token_abrec {strcpy(atrib,"\0"); cleanExprList(exprList);}  BLOCO token_fechac{

	            printf("while com bloco\n");
		int whilesize;
		whilesize = *(int*)sizeBlockList->head->element;
		//elsesize = *(int*)sizeBlockList->head->next->element;
		
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  sizeBlockList->head = sizeBlockList->head->next;
		  sizeBlockList->nElem -= 1;
		}
		
		
		NODELISTPTR _tracker = cmdList->head;
		// If
		if(whilesize == 0) {
			printf("While ta vazio\n");
			auxlist = NULL;
		}
		else {
			_tracker = cmdList->head;
		    int u=0;
		    for(u=0; u < cmdList->nElem-whilesize-1; u++) {
		      
		      _tracker = _tracker->next;	    
		    }
		    auxlist = initList();
		    auxlist->head = _tracker->next;
		    auxlist->nElem = whilesize;
		    
		    _tracker->next = NULL;
		    cmdList->tail = _tracker;
		    cmdList->nElem = cmdList->nElem-whilesize;
		}
		
		  loop = allocateLoop();
		  setLoop(loop,getNode(exList,exList->nElem-1),auxlist,NULL,NULL,WHILE);
		  
		  _loop = allocateTreeNode();
		  setTreeNode(_loop,loop,F_LOOP);
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  
		  //_toList(cmdList,_cond);
		  
		  // Popping the value of sizeBlock
		  *sizeBlock = *(int*)getNode(_size,_size->nElem-2);
		  printf("Valor atual de sizeBlock: %d\n",*sizeBlock);
	            
	           
	    }
;

DO_WHILE_LOOP : token_do COMANDAO token_while {strcpy(atrib,"\0"); cleanExprList(exprList);} token_abrep IF_EXP token_fechap token_ptevirgula{
            printf("to no do while loop\n");

                   NODELISTPTR _tracker = cmdList->head;
	  int u=0;
	  for(u=0; u < cmdList->nElem-2; u++) {
	    
	    _tracker = _tracker->next;	    
	  }
	  auxlist = initList();
	  auxlist->head = _tracker->next;
	  auxlist->nElem = 1;
	  
	  
	  _tracker->next = NULL;
	  cmdList->tail = _tracker;
	  cmdList->nElem = cmdList->nElem-1;
	  //appendToTreeNode(nodeTree,auxlist);
	  
	  //list ltracker = initList();
	  //_toList(ltracker,_tracker);
	  
	  loop = allocateLoop();
	  setLoop(loop,getNode(exList,exList->nElem-1),auxlist,NULL,NULL,DO_WHILE);
     
	  //condition->commandList = ;

	  _loop = allocateTreeNode();
	  setTreeNode(_loop,loop,F_LOOP);
	  
	  printf("Numero de Elementos em exList: %d\n",exList->nElem);
	  removeWithoutFreeFromList(exList,exList->nElem-1);			
	  printf("Numero de Elementos em exList: %d\n",exList->nElem);

            
        }
		| token_do token_abrec BLOCO token_fechac {strcpy(atrib,"\0"); cleanExprList(exprList);} token_while token_abrep IF_EXP token_fechap token_ptevirgula{


		int whilesize;
		whilesize = *(int*)sizeBlockList->head->element;
		//elsesize = *(int*)sizeBlockList->head->next->element;
		
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  sizeBlockList->head = sizeBlockList->head->next;
		  sizeBlockList->nElem -= 1;
		}
		
		
		NODELISTPTR _tracker = cmdList->head;
		// If
		if(whilesize == 0) {
			printf("While ta vazio\n");
			auxlist = NULL;
		}
		else {
			_tracker = cmdList->head;
		    int u=0;
		    for(u=0; u < cmdList->nElem-whilesize-1; u++) {
		      
		      _tracker = _tracker->next;	    
		    }
		    auxlist = initList();
		    auxlist->head = _tracker->next;
		    auxlist->nElem = whilesize;
		    
		    _tracker->next = NULL;
		    cmdList->tail = _tracker;
		    cmdList->nElem = cmdList->nElem-whilesize;
		}
		
		  loop = allocateLoop();
		  setLoop(loop,getNode(exList,exList->nElem-1),auxlist,NULL,NULL,DO_WHILE);
		  
		  _loop = allocateTreeNode();
		  setTreeNode(_loop,loop,F_LOOP);
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  
		  //_toList(cmdList,_cond);
		  
		  // Popping the value of sizeBlock
		  *sizeBlock = *(int*)getNode(_size,_size->nElem-2);
		  printf("Valor atual de sizeBlock: %d\n",*sizeBlock);

		}
;

FOR_LOOP : token_for token_abrep ATRIBUICAO token_ptevirgula IF_EXP token_ptevirgula COMMAND_LIST token_fechap {cleanExprList(exprList);} COMANDAO {

              strcpy(atrib,"\0");
              
              printf("ELEMENTOS EM CMD LIST = %d\n",cmdList->nElem); 
              NODELISTPTR _tracker = cmdList->head;
              
	          int u;
	          
	          for(u=0; u < cmdList->nElem-3; u++) {
	            _tracker = _tracker->next;	    
	          }

              // Lista de atribuicoes
              atribList = initList();
              atribList->head = _tracker;
              atribList->nElem = 1;	 
                       
	           // Incremento
	          _tracker = _tracker->next;
	          
              incList = initList();
	          incList->head = _tracker;
	          incList->nElem = 1;

	          _tracker = _tracker->next;
	          
	          // Comando dentro do for 
	          auxlist = initList();
	          auxlist->head = _tracker;
	          auxlist->nElem = 1;

	          _tracker = cmdList->head;

	          for (u=0; u < cmdList->nElem-4; u++){
	            _tracker = _tracker->next;
	          }
	          
	          _tracker->next = NULL;
	          
	          cmdList->tail = _tracker;
	          cmdList->nElem = cmdList->nElem-3;
	           
	          loop = allocateLoop();
	          setLoop(loop,getNode(exList,exList->nElem-1),auxlist,atribList,incList,FOR);
             
	          _loop = allocateTreeNode();
	          setTreeNode(_loop,loop,F_LOOP);
	          
	          printf("Numero de Elementos em exList: %d\n",exList->nElem);
	          removeWithoutFreeFromList(exList,exList->nElem-1);			
	          printf("Numero de Elementos em exList: %d\n",exList->nElem);
                                  
           }
	   | token_for token_abrep ATRIBUICAO token_ptevirgula IF_EXP token_ptevirgula COMMAND_LIST token_fechap token_abrec {strcpy(atrib,"\0"); cleanExprList(exprList);} BLOCO token_fechac
	   {


	        printf("for com bloco\n");
	        
		    int forsize;
		    forsize = *(int*)sizeBlockList->head->element;
		    //elsesize = *(int*)sizeBlockList->head->next->element;
		
		    if(sizeBlockList->nElem <= 1) {
		      sizeBlockList = initList();
		    }
		    else {
		      sizeBlockList->head = sizeBlockList->head->next;
		      sizeBlockList->nElem -= 1;
		    }

		    printf("forsize = %d\n",forsize);


		    NODELISTPTR _tracker;

		    if(forsize == 0) {
			    printf("For ta vazio\n");
			    auxlist = NULL;
		    }
		    else {
			    _tracker = cmdList->head;
		        int u=0;
		        for(u=0; u < cmdList->nElem-forsize-2; u++) {
		          _tracker = _tracker->next;	    
		        }
		        // Atribuicoes
		        atribList = initList();
		        atribList->head = _tracker;
		        atribList->nElem = 1;

                _tracker = _tracker->next;
                
		        // Incremento
		        incList = initList();
		        incList->head = _tracker;
                incList->nElem = 1;

		        // Comandos a serem executados
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        auxlist->nElem = forsize;

    	        _tracker = cmdList->head;

	            for (u=0; u < cmdList->nElem-forsize-3; u++){
	                _tracker = _tracker->next;
	            }
	          		        
		        _tracker->next = NULL;
		        
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-forsize-2;

		        printf("CMD LIST NELEM%d\n",cmdList->nElem);
		    }

		      loop = allocateLoop();
	          setLoop(loop,getNode(exList,exList->nElem-1),auxlist,atribList,incList,FOR);
             
	          _loop = allocateTreeNode();
	          setTreeNode(_loop,loop,F_LOOP);
	          
	          printf("Numero de Elementos em exList: %d\n",exList->nElem);
	          removeWithoutFreeFromList(exList,exList->nElem-1);			
	          printf("Numero de Elementos em exList: %d\n",exList->nElem);


	      
        }
	   | token_for token_abrep ATRIBUICAO token_ptevirgula token_ptevirgula COMMAND_LIST token_fechap {strcpy(atrib,"\0"); cleanExprList(exprList);} COMANDAO {
	   
              
              printf("ELEMENTOS EM CMD LIST = %d\n",cmdList->nElem); 
              NODELISTPTR _tracker = cmdList->head;
              
	          int u;
	          
	          for(u=0; u < cmdList->nElem-3; u++) {
	            _tracker = _tracker->next;	    
	          }

              // Lista de atribuicoes
              atribList = initList();
              atribList->head = _tracker;
              atribList->nElem = 1;	 
                       
	           // Incremento
	          _tracker = _tracker->next;
	          
              incList = initList();
	          incList->head = _tracker;
	          incList->nElem = 1;

	          _tracker = _tracker->next;
	          
	          // Comando dentro do for 
	          auxlist = initList();
	          auxlist->head = _tracker;
	          auxlist->nElem = 1;

              // Tirando os elementos da cmdList
              
	          _tracker = cmdList->head;

	          for (u=0; u < cmdList->nElem-4; u++){
	            _tracker = _tracker->next;
	          }
	          
	          cmdList->tail = _tracker;
	          cmdList->nElem = cmdList->nElem-3;
	           
	          loop = allocateLoop();
	          setLoop(loop,NULL,auxlist,atribList,incList,FOR);
             
	          _loop = allocateTreeNode();
	          setTreeNode(_loop,loop,F_LOOP);
	        	          
	   }
	   | token_for token_abrep ATRIBUICAO token_ptevirgula token_ptevirgula COMMAND_LIST token_fechap token_abrec {strcpy(atrib,"\0"); cleanExprList(exprList);} BLOCO token_fechac
	   {
	   
	        printf("for com bloco\n");
	        
		    int forsize;
		    forsize = *(int*)sizeBlockList->head->element;
		    //elsesize = *(int*)sizeBlockList->head->next->element;
		
		    if(sizeBlockList->nElem <= 1) {
		      sizeBlockList = initList();
		    }
		    else {
		      sizeBlockList->head = sizeBlockList->head->next;
		      sizeBlockList->nElem -= 1;
		    }

		    printf("forsize = %d\n",forsize);


		    NODELISTPTR _tracker;

		    if(forsize == 0) {
			    printf("For ta vazio\n");
			    auxlist = NULL;
		    }
		    else {
			    _tracker = cmdList->head;
		        int u=0;
		        for(u=0; u < cmdList->nElem-forsize-2; u++) {
		          _tracker = _tracker->next;	    
		        }
		        // Atribuicoes
		        atribList = initList();
		        atribList->head = _tracker;
		        atribList->nElem = 1;

                _tracker = _tracker->next;
                
		        // Incremento
		        incList = initList();
		        incList->head = _tracker;
                incList->nElem = 1;

		        // Comandos a serem executados
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        auxlist->nElem = forsize;

    	        _tracker = cmdList->head;

	            for (u=0; u < cmdList->nElem-forsize-3; u++){
	                _tracker = _tracker->next;
	            }
	          		        
		        _tracker->next = NULL;
		        
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-forsize-2;

		        printf("CMD LIST NELEM%d\n",cmdList->nElem);
		    }

		      loop = allocateLoop();
	          setLoop(loop,NULL,auxlist,atribList,incList,FOR);
             
	          _loop = allocateTreeNode();
	          setTreeNode(_loop,loop,F_LOOP);
	   
	   }
;

COMMAND_LIST : | ATRIBUICAO | EXP
;

%%

#include "lex.yy.c"

main(){
	bigTree = initTree();

	initHash(HashVar,MAX_HASH_SIZE);
	initHash(HashFunc,MAX_HASH_SIZE);
	
	cmdList = initList();
	exprList = initList();
	testList = initList();
	fatorList = initList();
	termoList = initList();
	auxlist = initList();
	exList = initList();
	sizeBlockList = initList();
	_size = initList();
	
	functionStack = initList();
	_toList(functionStack,"main");
	
	parnames = initList();
	atribTeste = allocateAtrib();
	  
	atribTree = allocateTreeNode();

	s_funcao* print = allocateFunction();
	setFunction(print,"printf",2,T_VOID,NULL,NULL);

	s_funcao* scan = allocateFunction();
	setFunction(scan,"scanf",2,T_INT,NULL,NULL);

	s_funcao* max = allocateFunction();
	setFunction(max,"max",2,T_INT,NULL,NULL);

	s_funcao* min = allocateFunction();
	setFunction(min,"min",2,T_INT,NULL,NULL);

	s_funcao* _main = allocateFunction();
	setFunction(_main,"main",0,T_INT,NULL,NULL);

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
	find_ok = -1;

	yyparse();

 //   s_variavel* s = allocateVar();


 //   setVar(s,"a",1,T_INT,"main",5);
 //   hashInsertVar(HashVar,s);
	checkVariables(HashVar);	
		//executeNodeTree((NODETREEPTR)cmdList->head->element);
	// Testando condicionais
	s_variavel *s = hashSearchVar(HashVar,"f","main");
   
    s_variavel *s2 = hashSearchVar(HashVar,"b","main");

	
	if(s && s->valor == NULL) {
	  printf("Variavel a inicializada, mas ainda sem valor\n");
	}
	
	s_fator *result = allocateFator();
	
	result = executeTreeList(cmdList);
	
	printf("\nTerminei de executar\n");

	if(s) {
	  printf("Variavel a inicializada, mas ainda sem valor, valor :%d\n",*(int*)(s->valor));
	}
	
	if(retValue) printf("Retvalue foi setada %d\n",*(int*)retValue->valor);
	
/*	s_funcao *func = hashSearchFunction(HashFunc,"f");
	result = executeTreeList(func->cmdList);
	
	if(retValue) printf("Retvalue foi setada %d\n",*(int*)retValue->valor);

    if(s3) {
	  printf("Variavel a inicializada, mas ainda sem valor, valor :%d\n",*(int*)(s3->valor));
	}*/
	
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){
	printf("Erro na Linha: %d\n", lines);
}
