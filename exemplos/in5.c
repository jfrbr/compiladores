int main(){

	int b,c;
	b = 0;

	do{
		b++;
	}while ( b < 10);

	scanf("%d",&c);	

	printf("%d",c);

	if (b == 10 && c < 10) printf("bla bla %d",1);
	else printf("bombastic %d",2);
	
	return 0;
}
