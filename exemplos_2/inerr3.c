int main(){


	int a;
	a = 1;
	a--;a++;

	return 0;
}
// Erro
void func1(){

	int b=2;
	printf("TO INDO PRA PONTE\n");
	while (b--)
	{
		func1();
	}
	return;
}
