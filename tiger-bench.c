#include "common.h"

#define BUF_SIZE (16*1024*1024)

int main(int argc, char **argv) {
	uint8_t *rand_buf;
	rand_buf = create_random_buffer(BUF_SIZE);

	free(rand_buf);
	return 0;
}

