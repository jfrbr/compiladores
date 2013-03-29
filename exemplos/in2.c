int d;

void print(int var){
	int c;
	c = var;
	printf("%d",var);
}

int e;

void execute(){
	d = max(d,e);
}

int main(){

	int a;

	for (a=0;a<10;a++){
		print(a);
	}	
	
	return 0;
}
