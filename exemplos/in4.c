int main(){

	
	int a;
	
	a = 2;

	if (a < 5 && a > 10) a += 5;
	else a -= 5;

	switch(a){
		case 1:
			printf("lala\n",a);
			break;
		case 2:
			printf("lele\n",a);
			break;
		default:
			printf("lololo\n",a);
			break;
	}

	return 1+2;
}
