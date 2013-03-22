#include <string.h>
#include "list.h"

int converType(char* type);
void cleanExprList(list l);



extern char num_inteiro[50];
extern char num_float[50];
extern char num_char[50];
extern char num_string[300];
extern char num_boolean[10];

int converType(char* type);
int returnAtualVarType();
