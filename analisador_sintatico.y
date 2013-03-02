%{
#include <stdio.h>
int Nlinha=1;
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


PROG:	BLOCO_GLOBAL token_int_main token_abrep token_fechap token_abrec BLOCO token_fechac
      | token_int_main token_abrep token_fechap token_abrec BLOCO token_fechac
;
/* Lembrar de permutar decfunc varglob e struct */

DECFUNC : TIPO token_ident token_abrep PARAMETROS_TIPO token_fechap token_abrec BLOCO token_fechac
	| TIPO token_ident token_abrep token_fechap token_abrec BLOCO token_fechac
;

DEC_VAR_GLOBAL: TIPO VAR DEC_VAR_GLOBAL2 token_ptevirgula
;

DEC_VAR_GLOBAL2: | token_virgula VAR DEC_VAR_GLOBAL2
;

//DEC_STRUCT: token_struct 
//DECFUNC2: | TIPO token_ident token_abrep PARAMETROS_TIPO token_fechap token_abrec BLOCO token_fechac DECFUNC2
//	  | TIPO token_ident token_abrep token_fechap token_abrec BLOCO token_fechac DECFUNC2;

PARAMETROS_TIPO: TIPO token_ident PARAMETROS_TIPO2;

PARAMETROS_TIPO2: | token_virgula TIPO token_ident PARAMETROS_TIPO2;
	  
COMANDAO:   DEC_VAR token_ptevirgula
	| U_EXP token_ptevirgula
	| ATRIBUICAO token_ptevirgula
	//| CHAMADA_FUNCAO token_ptevirgula
	| token_string token_ptevirgula
	| token_return U_EXP token_ptevirgula
	| token_return token_ptevirgula
	| token_ptevirgula
	| token_if token_abrep U_EXP token_fechap COMANDAO token_else COMANDAO
	| token_if token_abrep U_EXP token_fechap token_else COMANDAO
	| token_if token_abrep U_EXP token_fechap token_abrec BLOCO token_fechac token_else token_abrec BLOCO token_fechac
	| token_if token_abrep U_EXP token_fechap token_abrec BLOCO token_fechac token_else COMANDAO
	| token_if token_abrep U_EXP token_fechap COMANDAO token_else token_abrec BLOCO token_fechac
	| token_if token_abrep U_EXP token_fechap token_else token_abrec BLOCO token_fechac
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

COLCHETE : token_abrecol U_EXP token_fechacol COLCHETE2
;

COLCHETE2: /**/
      | token_abrecol U_EXP token_fechacol COLCHETE2
      ;



TIPO: token_int | token_char | token_double | token_float | token_void
;


/* EXPRESSAO */
U_EXP: EXP token_igualigual EXP
      | EXP token_maior EXP
      | EXP token_menor EXP
      | EXP token_maiorigual EXP
      | EXP token_menorigual EXP
      | EXP token_diferente EXP
      | EXP

;

EXP: EXP token_mais TERMO
    | EXP token_menos TERMO
    | TERMO
;

TERMO: TERMO token_vezes FATOR
      | TERMO token_divisao FATOR
      | TERMO token_mod FATOR
      | FATOR
;

FATOR: token_num_float | token_num_inteiro | VAR | token_abrep U_EXP token_fechap | token_letra | CHAMADA_FUNCAO
      	  | VAR token_maismais
	  | token_maismais VAR
	  | token_menosmenos VAR
	  | VAR token_menosmenos
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

TO_ATRIB:  token_menos token_num_inteiro | token_menos token_num_float | U_EXP | token_string;

CHAMADA_FUNCAO : token_ident token_abrep PARAMETROS token_fechap
		  | token_ident token_abrep token_fechap
;

PARAMETROS: U_EXP PAR2 | token_string PAR2;

PAR2: | token_virgula U_EXP PAR2 | token_virgula token_string PAR2;



COMANDO: CMD_NAO_ASSOC | CMD_NAO_ASSOC_CHAVE
;

CMD_NAO_ASSOC_CHAVE : token_if token_abrep U_EXP token_fechap token_abrec BLOCO token_fechac
;

CMD_NAO_ASSOC : token_if token_abrep U_EXP token_fechap COMANDAO
		| token_if token_abrep U_EXP token_fechap COMANDAO token_else CMD_NAO_ASSOC
;

/* SWITCH */

SWITCH: token_switch token_abrep VAR token_fechap token_abrec SWITCH_BLOCK token_fechac;

SWITCH_BLOCK : token_default token_doispontos BLOCO 
		| token_case token_num_inteiro token_doispontos BLOCO SWITCH_BLOCK2 token_default token_doispontos BLOCO
;
SWITCH_BLOCK2 : 
		| token_case token_num_inteiro token_doispontos BLOCO SWITCH_BLOCK2
;

/* LOOP */

LOOP : FOR_LOOP | DO_WHILE_LOOP | WHILE_LOOP ;

WHILE_LOOP: token_while token_abrep U_EXP token_fechap COMANDAO
	    | token_while token_abrep U_EXP token_fechap token_abrec BLOCO token_fechac
;

DO_WHILE_LOOP : token_do COMANDAO token_while token_abrep U_EXP token_fechap token_ptevirgula
		| token_do token_abrec BLOCO token_fechac token_while token_abrep U_EXP token_fechap token_ptevirgula
;

FOR_LOOP : token_for token_abrep ATRIBUICAO_LIST token_ptevirgula U_EXP token_ptevirgula COMMAND_LIST token_fechap COMANDAO
	   | token_for token_abrep ATRIBUICAO_LIST token_ptevirgula U_EXP token_ptevirgula COMMAND_LIST token_fechap token_abrec BLOCO token_fechac
	   | token_for token_abrep ATRIBUICAO_LIST token_ptevirgula token_ptevirgula COMMAND_LIST token_fechap COMANDAO
	   | token_for token_abrep ATRIBUICAO_LIST token_ptevirgula token_ptevirgula COMMAND_LIST token_fechap token_abrec BLOCO token_fechac
;

ATRIBUICAO_LIST : | ATRIBUICAO ATRIBUICAO_LIST2
;

ATRIBUICAO_LIST2 : | token_virgula ATRIBUICAO ATRIBUICAO_LIST2
;

//U_EXP2 : | U_EXP;

COMMAND_LIST : | EXP COMMAND_LIST2
;

COMMAND_LIST2 : | token_virgula  EXP COMMAND_LIST2
;
%%

#include "lex.yy.c"

main(){
	yyparse();
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){
	printf("Erro na Linha: %d\n", lines);
}

