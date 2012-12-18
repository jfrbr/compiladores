%{
	#include <stdio.h>
	#include <string.h>
	int lines=0;
	char comment[1000];
	int i=0;
%}


digitos [0-9]+ 
expoente [eE]-?{digitos}
expoente_positivo [eE]{digitos}

inteiro {digitos}+{expoente_positivo}?
fracao "."{digitos}
float {digitos}{fracao}?{expoente}?
comentario_linha "//"[^\n]*
comentario_bloco "/""*"+([^*/][^*]*"*"+)*"/"



%%

auto {printf("%s -> PALAVRARESERVADA\n",yytext);}
break {printf("%s -> PALAVRARESERVADA\n",yytext);}
case {printf("%s -> PALAVRARESERVADA\n",yytext);}
char {printf("%s -> PALAVRARESERVADA\n",yytext);}
const {printf("%s -> PALAVRARESERVADA\n",yytext);}
continue {printf("%s -> PALAVRARESERVADA\n",yytext);}
default {printf("%s -> PALAVRARESERVADA\n",yytext);}
do {printf("%s -> PALAVRARESERVADA\n",yytext);}
double {printf("%s -> PALAVRARESERVADA\n",yytext);}
else {printf("%s -> PALAVRARESERVADA\n",yytext);}
enum {printf("%s -> PALAVRARESERVADA\n",yytext);}
extern {printf("%s -> PALAVRARESERVADA\n",yytext);}
float {printf("%s -> PALAVRARESERVADA\n",yytext);}
for {printf("%s -> PALAVRARESERVADA\n",yytext);}
goto {printf("%s -> PALAVRARESERVADA\n",yytext);}
if {printf("%s -> PALAVRARESERVADA\n",yytext);}
int {printf("%s -> PALAVRARESERVADA\n",yytext);}
include {printf("%s -> PALAVRARESERVADA\n",yytext);}
long {printf("%s -> PALAVRARESERVADA\n",yytext);}
register {printf("%s -> PALAVRARESERVADA\n",yytext);}
return {printf("%s -> PALAVRARESERVADA\n",yytext);}
short {printf("%s -> PALAVRARESERVADA\n",yytext);}
signed {printf("%s -> PALAVRARESERVADA\n",yytext);}
sizeof {printf("%s -> PALAVRARESERVADA\n",yytext);}
static {printf("%s -> PALAVRARESERVADA\n",yytext);}
struct {printf("%s -> PALAVRARESERVADA\n",yytext);}
switch {printf("%s -> PALAVRARESERVADA\n",yytext);}
typedef {printf("%s -> PALAVRARESERVADA\n",yytext);}
union {printf("%s -> PALAVRARESERVADA\n",yytext);}
unsigned {printf("%s -> PALAVRARESERVADA\n",yytext);}
void {printf("%s -> PALAVRARESERVADA\n",yytext);}
volatile {printf("%s -> PALAVRARESERVADA\n",yytext);}
while {printf("%s -> PALAVRARESERVADA\n",yytext);}

{comentario_linha} 
{comentario_bloco} {
	strcpy(comment,yytext);	
	for(i=0; i<strlen(comment); i++) {
		if(comment[i] == '\n') lines++;
	}
}

{inteiro} {printf("%s -> INTEIRO\n",yytext);}
{float} {printf("%s -> FLOAT\n",yytext);}

"+" {printf("%s -> OPERADORARITMETICO\n",yytext);}
"-" {printf("%s -> OPERADORARITMETICO\n",yytext);}
"*" {printf("%s -> OPERADORARITMETICO\n",yytext);}
"/" {printf("%s -> OPERADORARITMETICO\n",yytext);}
"%" {printf("%s -> OPERADORARITMETICO\n",yytext);}
"++" {printf("%s -> OPERADORARITMETICO\n",yytext);}
"--" {printf("%s -> OPERADORARITMETICO\n",yytext);}


">" {printf("%s -> OPERADORRELACIONAL\n",yytext);}
"<" {printf("%s -> OPERADORRELACIONAL\n",yytext);}
">=" {printf("%s -> OPERADORRELACIONAL\n",yytext);}
"<=" {printf("%s -> OPERADORRELACIONAL\n",yytext);}
"==" {printf("%s -> OPERADORRELACIONAL\n",yytext);}
"!=" {printf("%s -> OPERADORRELACIONAL\n",yytext);}

"=" {printf("%s -> ATRIBUICAO\n",yytext);}

"(" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
")" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
"," {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
";" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
":" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
"{" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
"}" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
"#" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
"'" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
"\"" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
"\\" {printf("%s -> SIMBOLOESPECIAL\n",yytext);}
"." {printf("%s -> SIMBOLOESPECIAL\n",yytext);}

"&&" {printf("%s -> OPERADORLOGICO\n",yytext);}
"||" {printf("%s -> OPERADORLOGICO\n",yytext);}
"!" {printf("%s -> OPERADORLOGICO\n",yytext);}

[_a-zA-Z][_a-zA-Z0-9]*	{ printf("%s -> IDENTIFICADOR\n",yytext);}

\n {lines++;}
[ \t] 
. {printf("%s -> DESCONHECIDO\n",yytext);}

%%

main()
{
	
	yylex();
}
