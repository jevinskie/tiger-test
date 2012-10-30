#ifndef __common_h__
#define __common_h__

#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <string.h>

void tiger(uint8_t *buf, uint64_t len, uint64_t digest[3]);
void tigertree(uint8_t *buf, uint64_t len, uint64_t digest[3]);
void hexdump(uint8_t *buf, uint64_t len);
uint8_t *create_random_buffer(uint64_t len);

#endif

