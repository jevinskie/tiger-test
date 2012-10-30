#include "common.h"

int main(void)
{
    struct tt_context tth;
    char *buf = "[ABCDEFGHIJKLMNOPQRSTYVWXYZabcdefghijklmnopqrstuvqzyx1234567890]\n";

    tt_init(&tth, 0);
    tt_update(&tth, (unsigned char *)buf, strlen(buf));
    tt_digest(&tth, NULL);

    char *hash_base32 = tt_base32(&tth);
    fail_unless(strcmp(hash_base32, "UUP2CKMGSUCSKXBQKSK7U76YVYFPUDXFNCYEOFI") == 0);

    return 0;
}


