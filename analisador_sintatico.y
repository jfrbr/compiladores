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
extern list *HashVar;
extern list *HashFunc;
char _num_inteiro[50];
char _num_char[50];

list _size;
list exprList;
list testList;
list parList;
list programList;

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
			while (var){
				int *b = malloc(sizeof(int));
				*b = converType(var);
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
				return 1;
			}
			strcpy(atrib,"\0");
			strcpy(ident,"\0");
			setFunctionParNames(function,parnames);
			} token_abrec BLOCO token_fechac {
			    strcpy(currentFunction,"global");
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
			return 1;
		}
			
		strcpy(atrib,"\0");
	} token_abrec BLOCO token_fechac {
		
		setFunctionCmdList(function,cmdList);
		cmdList = initList();
		fatorList = initList();
		_size = initList();
		*sizeBlock = 0;
		sizeBlockList = initList();
	}
;

DEC_VAR_GLOBAL: TIPO VAR DEC_VAR_GLOBAL2 token_ptevirgula {
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
			return 1;
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
		strcpy(varname,ident);
		_toList(parnames,varname);
		s_variavel *var = allocateVar();		
		setVar(var,ident,NULL,tipoVar,currentFunction,lines);
		hashInsertVar(HashVar,var);
} PARAMETROS_TIPO2
;

PARAMETROS_TIPO2: | token_virgula TIPO VAR  {
		char *varname = malloc(50*sizeof(char));
		strcpy(varname,ident);
		_toList(parnames,varname);		
		s_variavel *var = allocateVar();		
		setVar(var,ident,NULL,tipoVar,currentFunction,lines);
		hashInsertVar(HashVar,var);
} PARAMETROS_TIPO2
;
	  
COMANDAO:   DEC_VAR token_ptevirgula {
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
			return 2;
		}
		var = strtok (NULL, " ,;");
	  }
	  strcpy(tipo,"\0");
	  strcpy(atrib,"\0");
	  // Inserindo node dummy na lista cmdList
	  NODETREEPTR dummy = allocateTreeNode();
	  setTreeNode(dummy,NULL,F_DEC);
	  _toList(cmdList,dummy);
	}
		
	| U_EXP_LIST token_ptevirgula 	{
	  strcpy(atrib,"\0");
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
		destroyList(concatList);
	  }
	  }
	  else {
		int j;		 
		removeWithoutFreeFromList(exprList,exprList->nElem-1);		
		// Check one by one
		for(j=0;j<exprList->nElem;j++) {
			if(returnTypeExprList(getNode(exprList,j)) < 0) {				
				printf("Erro na linha %d: Expressao incompativel---\n",lines);
				return 2;
			}
			
		}
		
	  }
	  }
	  else {
		eval = returnTypeExprList(_last);
	  }
	  cleanExprList(exprList);
	  if(nodeTree) {
	    _toList(cmdList,nodeTree);
	    nodeTree = NULL;
	    fatorList = initList();
	  }
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
				return 2;
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
				return 2;
			}
			
		}
	  }
	  }
	  else {
		eval = returnTypeExprList(_last);
		if(eval < 0) {
				printf("Erro na linha %d: Expressao incompativel\n",lines);
				return 2;
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
	    NODETREEPTR dummy = allocateTreeNode();
	    setTreeNode(dummy,nodeTree,F_RETURN);
	    _toList(cmdList,dummy);
	    nodeTree = NULL;
	    fatorList = initList();
	  }
	}  token_ptevirgula
	
	| token_return {
		strcpy(atrib,"\0");
	} token_ptevirgula {
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
	      
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);		  
		  _toList(cmdList,_cond);
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_else COMANDAO  {					
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
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  _toList(cmdList,_cond);
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else token_abrec BLOCO token_fechac  {
		int ifsize,elsesize;
		ifsize = *(int*)getNode(sizeBlockList,sizeBlockList->nElem-2);
		elsesize = *(int*)getNode(sizeBlockList,sizeBlockList->nElem-1);

		NODELISTPTR _tracker = sizeBlockList->head;
		if(sizeBlockList->nElem <= 2) {
		  sizeBlockList = initList();
		}
		else {
		  int i=0;
		  for(i = 0; i < sizeBlockList->nElem-3; i++) _tracker = _tracker->next;
		  _tracker->next = NULL;
		  sizeBlockList->nElem -= 2;
		}
		_tracker = cmdList->head;
		if(elsesize == 0) {
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
		      _temp = _temp->next;
		    }
		    
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,elseList);
		  
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		  
		  removeWithoutFreeFromList(exList,exList->nElem-1);
		  _toList(cmdList,_cond);
		// Popping the value of sizeBlock
		*sizeBlock = *(int*)getNode(_size,_size->nElem-2);			
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else COMANDAO  {
		int ifsize;
		ifsize = *(int*)getNode(sizeBlockList,sizeBlockList->nElem-1);
		NODELISTPTR _tracker = cmdList->head;
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  int i=0;
		  for(i = 0; i < sizeBlockList->nElem-2; i++) _tracker = _tracker->next;
		  _tracker->next = NULL;
		  sizeBlockList->nElem -= 1;
		}
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
		*sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap COMANDAO token_else token_abrec BLOCO token_fechac  {		
		int elsesize;
		elsesize = *(int*)sizeBlockList->tail->element;
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  NODELISTPTR _tmp = sizeBlockList->head;
		  int i=0;
		  for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		  _tmp->next = NULL;
		  sizeBlockList->tail = _tmp;
		  sizeBlockList->nElem -= 1;
		}
		if(elsesize == 0) {
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
		*sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		cleanExprList(exprList);
	}
	| token_if token_abrep IF_EXP token_fechap token_else token_abrec BLOCO token_fechac {
		int elsesize;
		elsesize = *(int*)sizeBlockList->tail->element;
		
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  NODELISTPTR _tmp = sizeBlockList->head;
		  int i=0;
		  for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		  _tmp->next = NULL;
		  sizeBlockList->tail = _tmp;
		  sizeBlockList->nElem -= 1;
		}
		if(elsesize == 0) {
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
		*sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		cleanExprList(exprList);
	}
	| SWITCH  {
	    if (_switch){
		    _toList(cmdList,_switch);	    
		}
		else{
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
		sizeBlock = malloc(sizeof(int));
		*sizeBlock = 0;
		_toList(sizeBlockList,sizeBlock);
		
	} | COMANDAO {
		if(sizeBlock) {		  
		  if(!_size) _size = initList();
		  _toList(_size,sizeBlock);
		  }
		sizeBlock = malloc(sizeof(int));
		*sizeBlock = 1;
	} BLOCO2 | COMANDO {
	if(sizeBlock) {		  
		  if(!_size) _size = initList();
		  _toList(_size,sizeBlock);
		  }
	sizeBlock = malloc(sizeof(int));
	*sizeBlock = 1;
	_toList(cmdList,_cond);
	} BLOCO2
;

BLOCO2: /**/ {
		_toList(sizeBlockList,sizeBlock);
	} | COMANDAO {
	  *sizeBlock = *sizeBlock + 1; 
	} BLOCO2 | COMANDO{
	  *sizeBlock = *sizeBlock + 1;
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
	_toList(fatorList,nodeTree);
      }
      | EXP token_maior {
		char *op = malloc(sizeof(char));
		strcpy(op,">");
		_toList(testList,op);
      } EXP {
	
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
	_toList(fatorList,nodeTree);
      }
      | EXP token_menor {
		char *op = malloc(sizeof(char));
		strcpy(op,"<");
		_toList(testList,op);
      } EXP {
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
	_toList(fatorList,nodeTree);
      }
      | EXP token_maiorigual {
		char *op = malloc(2*sizeof(char));
		strcpy(op,">=");
		_toList(testList,op);
      } EXP {
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
	_toList(fatorList,nodeTree);
      }
      | EXP token_menorigual {
		char *op = malloc(2*sizeof(char));
		strcpy(op,"<=");
		_toList(testList,op);
      } EXP{
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
	_toList(fatorList,nodeTree);
      }
      | EXP token_diferente {
		char *op = malloc(2*sizeof(char));
		strcpy(op,"!=");
		_toList(testList,op);
      } EXP{
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
	_toList(fatorList,nodeTree);
      }
      | EXP {
	nodeTree = allocateTreeNode();
	s_u_exp *u_exp = allocateU_Exp();
	setU_Exp(u_exp,"(");	
	setTreeNode(nodeTree,u_exp,F_U_EXP);
	appendToTreeNode(nodeTree,fatorList);
	u_expTree = allocateTreeNode();
	setTreeNode(u_expTree,u_exp,F_U_EXP);
	appendToTreeNode(u_expTree,fatorList);
    }
  
;

IF_EXP :
      U_EXP_LIST {
      conditionTree = nodeTree;
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
	    } U_EXP_LIST2
;

U_EXP_LIST2 : {
	      nodeTree = allocateTreeNode();
	      
	      s_u_exp_list *u_exp_list = allocateU_Exp_List();
	      setU_Exp_List(u_exp_list,"(");      
	      setTreeNode(nodeTree,u_exp_list,F_U_EXP_LIST);
	      appendToTreeNode(nodeTree,fatorList);	     
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
		  _toList(fatorList,nodeTree);
	      }	      
	      U_EXP_LIST2 
	      | token_ou {
			char *ouou = malloc(2*sizeof(char));
			strcpy(ouou,"||");
			_toList(testList,ouou);
	      }
	      U_EXP {
		  if(testList->head) {
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
      } TERMO {
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
	_toList(fatorList,nodeTree);
      }
    | EXP token_menos {
		char *op = malloc(sizeof(char));
		*op = '-';		
		_toList(testList,op);
      } TERMO {
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
	_toList(fatorList,nodeTree);
      }

    | TERMO {
	nodeTree = allocateTreeNode();
	s_exp *exp = allocateExp();
	setExp(exp,'(');	
	setTreeNode(nodeTree,exp,F_EXP);
	int i=0;
	appendToTreeNode(nodeTree,fatorList);
	expTree = allocateTreeNode();
	setTreeNode(expTree,exp,F_EXP);
	appendToTreeNode(expTree,fatorList);
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
	_toList(fatorList,nodeTree);
      }
      | FATOR {
	nodeTree = allocateTreeNode();
	s_termo *termo = allocateTermo();
	setTermo(termo,'(');	
	setTreeNode(nodeTree,termo,F_TERMO);
	int i=0;
	appendToTreeNode(nodeTree,fatorList);
      }
;

FATOR: token_num_float {
		int *tipo = malloc(sizeof(int));
		*tipo = T_FLOAT;
		_toList(testList,tipo);
		fteste = allocateFator();
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
		fteste = allocateFator();
		int *inteiro = malloc(sizeof(int));
		*inteiro = atoi(num_inteiro);
		setFator(fteste,T_INT,inteiro,NULL);
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		_toList(fatorList,nodeTree);
	  }	  

	  | VAR {
		// Check if var exists
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  return 2;
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
		
        
		fteste = allocateFator();
		char *variavel = malloc(strlen(ident)*sizeof(char));
		strcpy(variavel,ident);
		setFator(fteste,T_VAR,variavel,NULL);
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		_toList(fatorList,nodeTree);
	  }	  
	  | token_abrep {
	    NODELISTPTR apList = allocateNode();
	    apList->element = testList;
	    addNode(exprList,apList);	    	
	    testList = initList();	    	    
	  } U_EXP_LIST token_fechap {
		// Evaluate
		list _last = getNode(exprList,exprList->nElem-1);		
		int i;
		int *eval_aux = malloc(sizeof(int));
		eval = returnTypeExprList(_last);
		*eval_aux = eval;
		if(eval < 0) {
			printf("Erro na linha %d: Tipos incompativeis numa expressao\n",lines);
			return 2;
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
		fteste = allocateFator();
		char *letra = malloc(sizeof(char));
		if ( strlen(num_char) == 3){
		    *letra = num_char[1];
		}else{
		    printf("token_letra # Erro no tamanho\n");
		    exit(1);
		}
		setFator(fteste,T_CHAR,letra,NULL);
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		_toList(fatorList,nodeTree);
	  }
	  | CHAMADA_FUNCAO {
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
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  return 2;
		}
		int *tipo = malloc(sizeof(int));
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber ++\n",lines,ident);
		  return 2;
		}
		_toList(testList,tipo);
		strcpy(atrib,"\0");		
		fteste = allocateFator();
		char *variavel = malloc(strlen(ident)*sizeof(char));
		strcpy(variavel,ident);
       		auxlist = initList();
       		int *_aux = (int*) malloc(sizeof(int));
       		*_aux = P_MAISMAISAFT;
		_toList(auxlist,_aux);		
		setFator(fteste,T_VAR,variavel,auxlist);
		auxlist=NULL;
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		_toList(fatorList,nodeTree);		
      	  }
	  | token_maismais VAR {
		// Check if var exists		
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  return 2;
		}
		int *tipo = malloc(sizeof(int));
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber ++\n",lines,ident);
		  return 2;
		}
		_toList(testList,tipo);
		strcpy(atrib,"\0");	  
		fteste = allocateFator();
		char *variavel = malloc(strlen(ident)*sizeof(char));
		strcpy(variavel,ident);
       		auxlist = initList();
       		int *_aux = (int*) malloc(sizeof(int));
       		*_aux = P_MAISMAISANT;
		_toList(auxlist,_aux);		
		setFator(fteste,T_VAR,variavel,auxlist);
		auxlist=NULL;
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		_toList(fatorList,nodeTree);
	  }
	  
	  | token_menosmenos VAR {
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  return 2;
		}
		int *tipo = malloc(sizeof(int));
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;		
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber --\n",lines,ident);
		  return 2;
		}
		_toList(testList,tipo);
		strcpy(atrib,"\0");
		fteste = allocateFator();
		char *variavel = malloc(strlen(ident)*sizeof(char));
		strcpy(variavel,ident);
       		auxlist = initList();
       		int *_aux = (int*) malloc(sizeof(int));
       		*_aux = P_MENOSMENOSANT;
		_toList(auxlist,_aux);		
		setFator(fteste,T_VAR,variavel,auxlist);
		auxlist=NULL;
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		_toList(fatorList,nodeTree);
	  }
	  | VAR token_menosmenos {
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  return 2;
		}		
		int *tipo = malloc(sizeof(int));
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber --\n",lines,ident);
		  return 2;
		}
		_toList(testList,tipo);
		strcpy(atrib,"\0");
		fteste = allocateFator();
		char *variavel = malloc(strlen(ident)*sizeof(char));
		strcpy(variavel,ident);
       		auxlist = initList();
       		int *_aux = (int*) malloc(sizeof(int));
       		*_aux = P_MENOSMENOSAFT;
		_toList(auxlist,_aux);		
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
		fteste = allocateFator();
		float *f = malloc(sizeof(float));
		*f = -1 * atof(num_float);
		setFator(fteste,T_FLOAT,f,NULL);
		nodeTree = allocateTreeNode();
		setTreeNode(nodeTree,fteste,F_FATOR);
		_toList(fatorList,nodeTree);
	  }
	  | token_menos VAR {
		if(!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")) {
		  printf("Erro na linha %d: Variavel %s nao declarada\n",lines,ident);
		  return 2;
		}		
		int *tipo = malloc(sizeof(int));
		if(varExists(HashVar,ident,currentFunction)) 
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,currentFunction)))->tipo;
		else  
		  *tipo = ((s_variavel*)(hashSearchVar(HashVar,ident,"global")))->tipo;
		if(*tipo == T_VOID || *tipo == T_STRING || *tipo == T_BOOLEAN) {
		  printf("Erro na linha %d: Variavel %s nao pode receber --\n",lines,ident);
		  return 2;
		}
		_toList(testList,tipo);
		fteste = allocateFator();
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
		fteste = allocateFator();
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
			char *varname = strtok(ident," ");
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				return 1;
			}
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
					return 2;
				}
				eval = 0;
		atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();
		setAtrib(atribTeste,"=",lident,nodeTree,NULL);
		setTreeNode(atribTree,atribTeste,F_ATRIB);		
		_toList(cmdList,atribTree);		
		fatorList = initList();
		nodeTree = NULL;
	  }		
	  | VAR token_maisigual {strcpy(atrib,"\0"); strcpy(lident,ident);} TO_ATRIB {
			char *varname = strtok(atrib," ");
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				return 1;
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
			return 2;
		}
	    atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();
		setAtrib(atribTeste,"+=",lident,nodeTree,NULL);
		setTreeNode(atribTree,atribTeste,F_ATRIB);
		_toList(cmdList,atribTree);		
		fatorList = initList();
		nodeTree = NULL;
	  }
	  | VAR token_menosigual {strcpy(atrib,"\0"); strcpy(lident,ident);} TO_ATRIB {
		char *varname = strtok(atrib," ");
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				return 1;
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
					return 2;
				}
		atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();
		setAtrib(atribTeste,"-=",lident,nodeTree,NULL);
		setTreeNode(atribTree,atribTeste,F_ATRIB);
		_toList(cmdList,atribTree);		
		fatorList = initList();
		nodeTree = NULL;
		}	  
	  | VAR token_vezesigual {strcpy(atrib,"\0"); strcpy(lident,ident);} TO_ATRIB {
		char *varname = strtok(atrib," ");
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				return 1;
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
					return 2;
				}
		atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();
		setAtrib(atribTeste,"*=",lident,nodeTree,NULL);
		setTreeNode(atribTree,atribTeste,F_ATRIB);
			_toList(cmdList,atribTree);		
			fatorList = initList();
			nodeTree = NULL;
		}	  
	  | VAR token_divisaoigual {strcpy(atrib,"\0"); strcpy(lident,ident);} TO_ATRIB{
		char *varname = strtok(atrib," ");
			if (!varExists(HashVar,ident,currentFunction) && !varExists(HashVar,ident,"global")){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				return 1;
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
					return 2;
				}
		atribTree=allocateTreeNode();
		atribTeste=allocateAtrib();
		setAtrib(atribTeste,"/=",lident,nodeTree,NULL);
		setTreeNode(atribTree,atribTeste,F_ATRIB);
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
				  return 2;
			  }
		  destroyList(concatList);
	    }
	    else {
		  int j;
		  list fRet = getNode(exprList,exprList->nElem-1);
		  eval = *(int*)getNode(fRet,0);
		  removeWithoutFreeFromList(exprList,exprList->nElem-1);
		  for(j=0;j<exprList->nElem;j++) {
			  if(returnTypeExprList(getNode(exprList,j)) < 0) {
				  printf("Erro na linha %d: Expressao incompativel\n",lines);
				  return 2;
			  }
		  }
	    }
	  }
	  else {
		  if(returnTypeExprList(_last) < 0) {
				  printf("Erro na linha %d: Expressao incompativel\n",lines);
				  return 2;
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
			}
			PARAMETROS token_fechap {
				char *funcname,*parlist,*tmpparlist;
				int nParam=1;
				int i=0;
				for(i=0; atrib[i] != '\0'; i++) {
					if(atrib[i]==',') nParam++;
				}
			// Verifica existencia e aridade da funcao
			if(!funcExists(HashFunc,funcCalled)) {
				printf("Erro na linha %d: Funcao nao definida\n",lines);
				return 2;
			}
			else {
				s_funcao *aux = hashSearchFunction(HashFunc,funcCalled);
				if(checkArity(aux,nParam) != 1) {
					printf("Erro na linha %d: Funcao sendo chamada com numero incorreto de parametros\n",lines);
					return 2;
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
						list t = getNode(exprList,i);
						int j;
						piPassado = returnTypeExprList(t);
						switch(piOriginal) {
							case T_INT:
								if(piPassado != T_CHAR && piPassado != T_INT && piPassado != T_FLOAT) {
									printf("Erro semantico na linha %d: Tipo de parametro incorreto!\n",lines);
									  return 2;
								}
								break;
							case T_CHAR:
								if(piPassado != T_CHAR && piPassado != T_INT && piPassado != T_FLOAT) {
									printf("Erro semantico na linha %d: Tipo de parametro incorreto!\n",lines);
									return(2);
								}
								break;
							case T_FLOAT:
								if(piPassado != T_CHAR && piPassado != T_INT && piPassado != T_FLOAT) {
									printf("Erro semantico na linha %d: Tipo de parametro incorreto!\n",lines);
									return(2);
								}
								break;
							case T_BOOLEAN:
								if(piPassado != T_BOOLEAN) {
									printf("Erro semantico na linha %d: Tipo de parametro incorreto!\n",lines);
									return(2);
								}
						}
						
					}
					}
				}
			}
			  strcpy(atrib,"\0"); 
			fteste = allocateFator();
			char *_funcName = malloc(50*sizeof(char));
			strcpy(_funcName,funcCalled);
			setFator(fteste,F_FUNCAO,_funcName,parametrosPassados);
			nodeTree = allocateTreeNode();
			setTreeNode(nodeTree,fteste,F_FATOR);
			_toList(fatorList,nodeTree);
		}
		  | token_ident token_abrep token_fechap {
			strcpy(funcCalled,ident);						
			if(!funcExists(HashFunc,funcCalled)) {
				printf("Erro na linha %d: Funcao nao definida\n",lines);
				return(2);
			}
			else {
				s_funcao *aux = hashSearchFunction(HashFunc,funcCalled);
				if(checkArity(aux,0) != 1) {
					printf("Erro na linha %d: Funcao com parametros sendo chamada sem parametros\n",lines);
					return(2);
				}
			}
			strcpy(atrib,"\0");
			fteste = allocateFator();
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
		_toList(parametrosPassados,nodeTree);		
		fatorList = initList();
		nodeTree = NULL;
		
	} PAR2 | token_string {
	parametrosPassados = initList();
	// Criando uma string pra inserir na pPassados
	char *parString = calloc(strlen(num_string)+1,sizeof(char));
	strcpy(parString,num_string);
	_toList(parametrosPassados,parString);	
	} PAR2;

PAR2: | token_virgula U_EXP_LIST {
	  _toList(parametrosPassados,nodeTree);		
	  fatorList = initList();
	  nodeTree = NULL;	  
} PAR2 | token_virgula token_string PAR2;

COMANDO: CMD_NAO_ASSOC | CMD_NAO_ASSOC_CHAVE
;

CMD_NAO_ASSOC_CHAVE : token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac {
		int ifsize;
		ifsize = *(int*)sizeBlockList->tail->element;
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  NODELISTPTR _tmp = sizeBlockList->head;
		  int i=0;
		  for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		  _tmp->next = NULL;
		  sizeBlockList->tail = _tmp;
		  sizeBlockList->nElem -= 1;
		}
		NODELISTPTR _tracker = cmdList->head;
		// If
		if(ifsize == 0) {
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
		  // Popping the value of sizeBlock
		  *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		      }
		| token_if token_abrep IF_EXP token_fechap token_abrec BLOCO token_fechac token_else COMANDO {
				  int u=0;
				  elseList = initList();
				  _toList(elseList,_cond);
				  int ifsize;
				  ifsize = *(int*)sizeBlockList->tail->element;
				  if(sizeBlockList->nElem <= 1) {
				    sizeBlockList = initList();
				  }
				  else {
				    NODELISTPTR _tmp = sizeBlockList->head;
				    int i=0;
				    for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
				    _tmp->next = NULL;
				    sizeBlockList->tail = _tmp;
				    sizeBlockList->nElem -= 1;
				  }
				  NODELISTPTR _tracker = cmdList->head;
				  // If
				  if(ifsize == 0) {
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
				  // Popping the value of sizeBlock
		*sizeBlock = *(int*)getNode(_size,_size->nElem-1);		
		      }
;

CMD_NAO_ASSOC : token_if token_abrep IF_EXP token_fechap COMANDAO {
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
	  setConditional(condition,getNode(exList,exList->nElem-1),auxlist,NULL);
	  _cond = allocateTreeNode();
	  setTreeNode(_cond,condition,F_CONDITIONAL);
	  removeWithoutFreeFromList(exList,exList->nElem-1);			
		}
		| token_if token_abrep IF_EXP token_fechap COMANDO {
			auxlist = initList();
			_toList(auxlist,_cond);
			condition = allocateConditional();
			setConditional(condition,getNode(exList,exList->nElem-1),auxlist,NULL);
			_cond = allocateTreeNode();
			setTreeNode(_cond,condition,F_CONDITIONAL);
		}
		| token_if token_abrep IF_EXP token_fechap COMANDAO token_else COMANDO {
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
		}
		| token_if token_abrep IF_EXP token_fechap token_else COMANDO {
		  elseList = initList();
		  _toList(elseList,_cond);
		  condition = allocateConditional();
		  setConditional(condition,getNode(exList,exList->nElem-1),NULL,elseList);
		  _cond = allocateTreeNode();
		  setTreeNode(_cond,condition,F_CONDITIONAL);
		}
;

/* SWITCH */
SWITCH: token_switch token_abrep VAR {
			s_variavel *v = hashSearchVar(HashVar,ident,currentFunction);
			if (v == NULL){
				printf("Erro semantico na linha %d. Variavel nao declarada.\n",lines);
				return(1);
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
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;		      
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
		    NODELISTPTR _tracker = cmdList->head;
		    // Switch
		    if(sw_size == 0) {
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
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {
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
		}SWITCH_BLOCK2 token_default token_doispontos {strcpy(atrib,"\0");} BLOCO
		{
            int sw_size = *(int*)sizeBlockList->tail->element;
		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
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
		}
		| token_case token_letra token_doispontos {strcpy(atrib,"\0");} BLOCO SWITCH_BLOCK2 {
		    char* n_char = malloc(sizeof(char));
		    *n_char = _num_char[1];
		    int sw_size = *(int*)sizeBlockList->tail->element;
		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {			    
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
		}token_default token_doispontos {strcpy(atrib,"\0");} BLOCO{
		            int sw_size = *(int*)sizeBlockList->tail->element;
		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {		      
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {
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
		    int* n_int = malloc(sizeof(int));
		    *n_int = atoi(_num_inteiro);
		    int sw_size = *(int*)sizeBlockList->tail->element;
		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {		      
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {
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
		}
		| token_case token_letra token_doispontos {strcpy(atrib,"\0");strcpy(_num_char,num_char);} BLOCO SWITCH_BLOCK2{
		    char* n_char = malloc(sizeof(char));
		    *n_char = _num_char[1];
            int sw_size = *(int*)sizeBlockList->tail->element;
		    if(sizeBlockList->nElem <= 1) {
		        sizeBlockList = initList();
		    }
		    else {
		      NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		    }
		    NODELISTPTR _tracker = cmdList->head;
		    // If
		    if(sw_size == 0) {			    
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
		}
;

/* LOOP */
LOOP : FOR_LOOP | DO_WHILE_LOOP | WHILE_LOOP ;

WHILE_LOOP: token_while token_abrep IF_EXP token_fechap {strcpy(atrib,"\0"); cleanExprList(exprList);} COMANDAO {

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
	  loop = allocateLoop();
	  setLoop(loop,getNode(exList,exList->nElem-1),auxlist,NULL,NULL,WHILE);
	  _loop = allocateTreeNode();
	  setTreeNode(_loop,loop,F_LOOP);	  
	  removeWithoutFreeFromList(exList,exList->nElem-1);			
        }
	    | token_while token_abrep IF_EXP token_fechap token_abrec {strcpy(atrib,"\0"); cleanExprList(exprList);}  BLOCO token_fechac{
		int whilesize;
		whilesize = *(int*)sizeBlockList->tail->element;				
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		
		  NODELISTPTR _tmp = sizeBlockList->head;
		      int i=0;
		      for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
		      _tmp->next = NULL;
		      sizeBlockList->tail = _tmp;
		      sizeBlockList->nElem -= 1;
		}
		NODELISTPTR _tracker = cmdList->head;
		// If
		if(whilesize == 0) {
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
		  // Popping the value of sizeBlock
		  *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
	    }
;

DO_WHILE_LOOP : token_do COMANDAO token_while {strcpy(atrib,"\0"); cleanExprList(exprList);} token_abrep IF_EXP token_fechap token_ptevirgula{
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
	  loop = allocateLoop();
	  setLoop(loop,getNode(exList,exList->nElem-1),auxlist,NULL,NULL,DO_WHILE);
	  _loop = allocateTreeNode();
	  setTreeNode(_loop,loop,F_LOOP);
	  removeWithoutFreeFromList(exList,exList->nElem-1);			
        }
		| token_do token_abrec BLOCO token_fechac {strcpy(atrib,"\0"); cleanExprList(exprList);} token_while token_abrep IF_EXP token_fechap token_ptevirgula{
		int whilesize;
		whilesize = *(int*)sizeBlockList->head->element;
		if(sizeBlockList->nElem <= 1) {
		  sizeBlockList = initList();
		}
		else {
		  NODELISTPTR _tmp = sizeBlockList->head;
			int i=0;
			for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
			_tmp->next = NULL;
			sizeBlockList->tail = _tmp;
			sizeBlockList->nElem -= 1;
		}
		NODELISTPTR _tracker = cmdList->head;
		// If
		if(whilesize == 0) {
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
		  // Popping the value of sizeBlock
		  *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
		}
;

FOR_LOOP : token_for token_abrep ATRIBUICAO token_ptevirgula IF_EXP token_ptevirgula COMMAND_LIST token_fechap {cleanExprList(exprList);} COMANDAO {
              strcpy(atrib,"\0");
              
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
	          removeWithoutFreeFromList(exList,exList->nElem-1);			
           }
	   | token_for token_abrep ATRIBUICAO token_ptevirgula IF_EXP token_ptevirgula COMMAND_LIST token_fechap token_abrec {strcpy(atrib,"\0"); cleanExprList(exprList);} BLOCO token_fechac
	   {
		    int forsize;
		    forsize = *(int*)sizeBlockList->tail->element;
		    printf("Forsize: %d\n",forsize);
		    printf("CMD List: %d\n",cmdList->nElem);
		    if(sizeBlockList->nElem <= 1) {
		      sizeBlockList = initList();
		    }
		    else {
			NODELISTPTR _tmp = sizeBlockList->head;
			int i=0;
			for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
			_tmp->next = NULL;
			sizeBlockList->tail = _tmp;
			sizeBlockList->nElem -= 1;			  
		    }
		    
		    NODELISTPTR _tracker;
		    if(forsize == 0) {
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
                atribList->head->next = NULL;
                
		        // Incremento
		        incList = initList();
		        incList->head = _tracker;
                incList->nElem = 1;
		       
		       // Comandos a serem executados
		        auxlist = initList();
		        auxlist->head = _tracker->next;
		        incList->head->next = NULL;
		        auxlist->nElem = forsize;
    	        
		    _tracker = cmdList->head;
	            for (u=0; u < cmdList->nElem-forsize-3; u++){
	                _tracker = _tracker->next;
	            }
		        _tracker->next = NULL;   
		        cmdList->tail = _tracker;
		        cmdList->nElem = cmdList->nElem-forsize-2;
		    }
		      loop = allocateLoop();
	          setLoop(loop,getNode(exList,exList->nElem-1),auxlist,atribList,incList,FOR);
	          _loop = allocateTreeNode();
	          setTreeNode(_loop,loop,F_LOOP);
	          removeWithoutFreeFromList(exList,exList->nElem-1);				          
	          // Popping the value of sizeBlock
		  *sizeBlock = *(int*)getNode(_size,_size->nElem-1);
        }
	   | token_for token_abrep ATRIBUICAO token_ptevirgula token_ptevirgula COMMAND_LIST token_fechap {strcpy(atrib,"\0"); cleanExprList(exprList);} COMANDAO {
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
		    int forsize;
		    forsize = *(int*)sizeBlockList->tail->element;
		    if(sizeBlockList->nElem <= 1) {
		      sizeBlockList = initList();
		    }
		    else {
		      		NODELISTPTR _tmp = sizeBlockList->head;
			int i=0;
			for(i=0; i<sizeBlockList->nElem-2; i++) _tmp = _tmp->next;
			_tmp->next = NULL;
			sizeBlockList->tail = _tmp;
			sizeBlockList->nElem -= 1;			  
	
		    }
		    NODELISTPTR _tracker;
		    if(forsize == 0) {			    
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
		    }
		      loop = allocateLoop();
	          setLoop(loop,NULL,auxlist,atribList,incList,FOR);
	          _loop = allocateTreeNode();
	          setTreeNode(_loop,loop,F_LOOP);
	          				          
	          // Popping the value of sizeBlock
		  *sizeBlock = *(int*)getNode(_size,_size->nElem-1);	   
	   }
;

COMMAND_LIST : | ATRIBUICAO | EXP {
nodeTree = allocateTreeNode();
	s_u_exp *u_exp = allocateU_Exp();
	setU_Exp(u_exp,"(");	
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
	//_toList(fatorList,nodeTree);
	_toList(cmdList,nodeTree);
}
;

%%

#include "lex.yy.c"

main(){
	programList = initList();
	char dump;
	//scanf("%c",&dump);
	/* AQUI VAI TER QUE ENTRAR O MENU! */
		/*printf("------------------------------\n");
		printf("-------------MENU-------------\n");
		printf("------------------------------\n");
		
		printf("1 - Compilar Programa\n");
		printf("2 - Imprimir Arvore de Execucao\n");
		printf("3 - Executar Programa\n");
		printf("4 - Listar Programas Compilados\n");
		printf("5 - Listar programas no diretório corrente (que podem ser compilados)\n");
		printf("6 - Sair\n");*/
	
	while(1) {
		printf("------------------------------\n");
		printf("-------------MENU-------------\n");
		printf("------------------------------\n");
		
		printf("1 - Compilar Programa\n");
		printf("2 - Imprimir Arvore de Execucao\n");
		printf("3 - Executar Programa\n");
		printf("4 - Listar Programas Compilados\n");
		printf("5 - Listar programas no diretório corrente (que podem ser compilados)\n");
		printf("6 - Sair\n");
	
		int option,optionChosen,error=0;
		scanf("%d",&option);
		scanf("%c",&dump);
		printf("Option %d\n",option);
		switch(option) {
		    case 1:
			// COMPILANDO
			HashVar = calloc(MAX_HASH_SIZE,sizeof(list));
			initHash(HashVar,MAX_HASH_SIZE);
			
			HashFunc = calloc(MAX_HASH_SIZE,sizeof(list));
			initHash(HashFunc,MAX_HASH_SIZE);	
			
			initStdFunctions();
			
			char pName[50];
			strcpy(pName,"\0");
			scanf("%[^\n]",pName);
			
			yyin = fopen(pName, "r");
			if (yyin == NULL) {
			  printf("Arquivo Nao Encontrado\n");
			  break;
			};		
			
			error = yyparse();
			fclose(yyin);
			
			if(error == 0 && checkVariables(HashVar) == 1) {		
			    s_programa *prog = allocateProgram();
			    setPrograma(prog,pName,HashVar,HashFunc,cmdList);
			    // Incluir o prog na lista
			    _toList(programList,prog);
			}
			
			YY_FLUSH_BUFFER;
			lines=0;
	
			break;
		    case 2:
		    case 3:
			{
			//HashVar = 
			char programName[50];
			strcpy(programName,"\0");
			printf("Insira o nome do programa a ser executado: ");
			scanf("%s",programName);
			printf("\n");
			printf("Executando o Programa %s\n",programName);
			NODELISTPTR _tracker = programList->head;
			s_programa *p;
			int progFound = 0;
			int i;
			for(i=0; i<programList->nElem; i++) {
				
				p = _tracker->element;
				if(strcmp(p->progNome,programName) == 0) {
				  
				  HashVar = p->HashVar;
				  HashFunc = p->HashFunc;
				  executaPrograma(p);
				  progFound = 1;
				  
				  break;
				}
				_tracker = _tracker->next;
				
			}
			if(!progFound) {
			  printf("Programa Nao Encontrado\n");
			}
			break;
			}
		    case 4:{
			NODELISTPTR _tracker = programList->head;
			s_programa *p;
			int i;
			printf("Existem %d programas compilados\n",programList->nElem);
			
			for(i=0; i<programList->nElem; i++) {
				
				p = _tracker->element;
				printf("%s\n",p->progNome);
				_tracker = _tracker->next;
			}
		      break;
		      }
		    case 5:
		      break;
		    case 6:
		      exit(0);
		    default:
		      break;
		}
 	}
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){
	printf("Erro na Linha: %d\n", lines);
}