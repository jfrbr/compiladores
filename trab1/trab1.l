%{
	#include <stdio.h>
%}

pr auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while

%%

{pr} {printf("%s -> PALAVRARESERVADA\n",yytext);}

. {printf("DESCONHECIDO");}

%%

main()
{

	yylex();
	
}
