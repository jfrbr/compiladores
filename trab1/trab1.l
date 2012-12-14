%{
	#include <stdio.h>
%}

PALAVRA_RESERVADA auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while


OPERADOR_ARITMETICO "+"|"-"|"/"|"*"|"%"|"+""+"|"-""-"
ATRIBUICAO "="



%%

{PALAVRA_RESERVADA} {printf("%s -> PALAVRARESERVADA",yytext);}
{ATRIBUICAO} {printf("%s -> ATRIBUICAO",yytext);}
{OPERADOR_ARITMETICO} {printf("%s -> OPERADORARITMETICO",yytext);}


[ \t\n]
. {printf("DESCONHECIDO\n");}

%%

main()
{

	yylex();
	
}
