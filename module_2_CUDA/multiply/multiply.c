#include <stdio.h>

void multiply(int a, int b, int *c) {
	*c = a * b;
}


int main() {

	int c;

	multiply(3, 9, &c);

	printf("%d * %d = %d", 3, 9,c);	

	return 0;
}
