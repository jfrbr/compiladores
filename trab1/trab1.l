%{

	#include <stdio.h>

%}

%%


.   {printf("Testando\n");}

%%

main()
{

	yylex();
	
}
