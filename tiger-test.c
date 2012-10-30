#include <stdio.h>

extern int has_sse2();
int sbox1, sbox2, sbox3, sbox4;

int main() {
	printf("has_sse: %d\n", has_sse2());
	return 0;
}

