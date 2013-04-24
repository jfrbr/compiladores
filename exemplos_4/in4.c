float montante(float inicial, float taxaaomes, int numeromeses) {
	int i;
	float m;
	m = 1 + taxaaomes;
	for(i=0; i<numeromeses; i++)
	  m *= m;
	return m*inicial;
}

int main() {
  float mont,ini,tx,nm;
  printf("Insira a Quantia Inicial\n",0);
  scanf("%f",ini);
  printf("Insira a Taxa ao mes\n",0);
  scanf("%f",tx);
  printf("Insira o Numero de Meses\n",0);
  scanf("%d",nm);

  mont = montante(ini,tx,nm);
  printf("O montante: %f\n",mont);
  return 0;
}