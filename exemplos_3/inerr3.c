int fazContinha(int a,int b){
	return a+b;
}


int main(){

	int a,b;
	
	for (a=0; a <= 10; a++){
		printf("%d",a);
	}
	b = a;

	char c;
	c = 'c';

	string s;
	
	s = fazContinha(a,b); // retorno da funcao nao compativel com o tipo
	
	return 0;
}
