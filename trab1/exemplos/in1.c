#include<stdio.h>

int main(){
	int a;
	int b;
	a = 10;
	b = 5;
	
	if ( a > b){
		a = a + b;
	}
	else{
		a = a-b;
	}

	if ( a % 2 == 1|| a % 3 == 2){
		a = a-2;
	}
	
	
	return 0;
}
