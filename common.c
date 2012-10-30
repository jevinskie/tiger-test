#include "common.h"

void hexdump(uint8_t *buf, uint64_t len) {
	while (len--)
		printf("%02X", *(buf++));
}

uint8_t *create_random_buffer(uint64_t len) {
	uint8_t *b;
	uint64_t i;
	int *p;

	b = malloc(len);

	srand(243);

	p = (int *)b;
	for (i = 0; i < len / sizeof(int); i++) {
		p[i] = rand();
	}
}

