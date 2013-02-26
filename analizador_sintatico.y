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

%start PROG

%%

PROG:	token_int_main token_abrep token_fechap token_abrec BLOCO token_return token_num_inteiro token_ptevirgula token_fechac
;
/* Lembrar de permutar decfunc varglob e struct */
BLOCO:	/**/
	| DEC_VAR
	| EXP
/*	| ATRIBUICAO
/*	| COMANDO
	| COMANDO_SELECAO
	| CHAMADA_FUNCAO	*/
;

/* Declaração de Variáveis */
DEC_VAR: TIPO VAR DEC_VAR2 REDO_DECVAR
;

REDO_DECVAR: /**/ token_ptevirgula
	| token_ptevirgula TIPO VAR DEC_VAR2 REDO_DECVAR
;
VAR: token_vezes token_ident
	| token_ident
	| token_vezes token_ident token_abrecol token_num_inteiro token_fechacol
	| token_ident token_abrecol token_num_inteiro token_fechacol
;

DEC_VAR2: /**/ 
	| token_virgula VAR DEC_VAR2
;
TIPO: token_int | token_char | token_double | token_float | token_void
;


/* ATRIBUICAO */
EXP: EXP token_mais TERMO
    | EXP token_menos TERMO
    | TERMO
;

TERMO: TERMO token_vezes FATOR
      | TERMO token_divisao FATOR
      | FATOR
;

FATOR: token_num_float | token_num_inteiro | token_ident ;

%%

#include "lex.yy.c"

main(){
	yyparse();
}

/* rotina chamada por yyparse quando encontra erro */
yyerror (void){
	printf("Erro na Linha: %d\n", lines);
}

