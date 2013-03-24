int main(){

	
	int a;
	
	a = 2;

	if (a < 5 && a > 10) a += 5;
	else a -= 5;

	switch(a){
		case 1:
			printf("lala\n");
			break;
		case 2:
			printf("lele\n");
			break;
		default:
			printf("lololo\n");
			break;
	}

	return 1+2;
}
