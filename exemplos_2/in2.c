int a,b;

void func1(int a, char teste[20]){
	
	if (a < 2 && a < 10){
		return;
	}else{
		a++;	
	}

	return;


}

void print(int i){
	printf("DEBUG = %d\n",i);
}

int main(){

	int d;

	func1(d,"boladao");

	for (d = 0; d < 10; d+=2){
		printf("Eh nois!");
		debug(i);
	}

	return 0;


}
