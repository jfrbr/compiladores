#include "parser.h"


int converType(char* type){

	if (!type) return -1;

	switch(type[0]) {
		case 'i':
			return 1;
		case 'f':
			return 2;
		case 'c':
			return 3;
		case 's':
			return 4;
		case 'b':
			return 5;
		case 'v':
			return 6;
		default:
			return -2;
	}
	return 0;
}

