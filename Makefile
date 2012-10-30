CC=gcc
CFLAGS=-g -Wall -Wextra -O3
LD=gcc
LDFLAGS=

SHAKESPEER_32_TARGETS= tiger-verify-shakespeer32 tiger-verify-shakespeer32-unrolled

SHAKESPEER_64_TARGETS= tiger-verify-shakespeer64-32wide tiger-verify-shakespeer64-32wide-unrolled \
					   tiger-verify-shakespeer64-64wide tiger-verify-shakespeer64-64wide-unrolled \
					   tiger-bench-shakespeer64-32wide

32_TARGETS= $(SHAKESPEER_32_TARGETS)
64_TARGETS= $(SHAKESPEER_64_TARGETS)


LBITS := $(shell getconf LONG_BIT)
ifeq ($(LBITS),64)
	TARGETS=$(32_TARGETS) $(64_TARGETS)
else
	TARGETS=$(32_TARGETS)
endif

all: $(TARGETS)
all32: $(32_TARGETS)
all64: $(64_TARGETS)
	
clean:
	rm -f *.o $(TARGETS)

common32.o: common.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m32 -c -o $@ $<

common64.o: common.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m64 -c -o $@ $<

tiger-verify32.o: tiger-verify.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m32 -c -o $@ $<

tiger-verify64.o: tiger-verify.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m64 -c -o $@ $<

tiger-verify-shakespeer32: tiger-verify32.o shakespeer/libtiger32.a
	$(LD) $(LDFLAGS) -m32 -o $@ $?

tiger-verify-shakespeer32-unrolled: tiger-verify32.o shakespeer/libtiger32-unrolled.a
	$(LD) $(LDFLAGS) -m32 -o $@ $?

tiger-verify-shakespeer64-32wide: tiger-verify64.o shakespeer/libtiger64-32wide.a
	$(LD) $(LDFLAGS) -m64 -o $@ $?

tiger-verify-shakespeer64-32wide-unrolled: tiger-verify64.o shakespeer/libtiger64-32wide-unrolled.a
	$(LD) $(LDFLAGS) -m64 -o $@ $?

tiger-verify-shakespeer64-64wide: tiger-verify64.o shakespeer/libtiger64-64wide.a
	$(LD) $(LDFLAGS) -m64 -o $@ $?

tiger-verify-shakespeer64-64wide-unrolled: tiger-verify64.o shakespeer/libtiger64-64wide-unrolled.a
	$(LD) $(LDFLAGS) -m64 -o $@ $?

tiger-bench32.o: tiger-bench.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m32 -c -o $@ $<

tiger-bench64.o: tiger-bench.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m64 -c -o $@ $<

tiger-bench-shakespeer64-32wide: tiger-bench64.o common64.o shakespeer/libtiger64-32wide.a
	$(LD) $(LDFLAGS) -m64 -o $@ $?

