#ifndef U_EXP_LIST_H_
#define U_EXP_LIST_H_

struct {
	char op[2];
	//void *valor;
	//list parametros;
} typedef s_u_exp_list;

s_u_exp_list *allocateU_Exp_List();
void *executeU_Exp_List(s_u_exp_list *toExecute,list operands);
void setU_Exp_List(s_u_exp_list *t, char *op);
void imprimeU_Exp_List(s_u_exp_list *t, list operands);

#endif /* U_EXP_LIST_H_ */
