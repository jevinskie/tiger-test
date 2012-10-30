CC=gcc
CFLAGS=-g -Wall -Wextra -O3

32_TARGETS= libtiger32.a            libtiger32-unrolled.a \
		    libtigertree32.a        libtigertree32-unrolled.a

64_TARGETS= libtiger64-32wide.a     libtiger64-32wide-unrolled.a \
		    libtigertree64-32wide.a libtigertree64-32wide-unrolled.a \
		    libtiger64-64wide.a     libtiger64-64wide-unrolled.a \
            libtigertree64-64wide.a libtigertree64-64wide-unrolled.a



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

sboxes32.o: sboxes.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m32 -c -o $@ $<

tiger32.o: tiger.c tiger.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -m32 -c -o $@ $<

tiger32-unrolled.o: tiger.c tiger.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -DUNROLL -m32 -c -o $@ $<

tigertree32.o: tigertree.c tigertree.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -m32 -c -o $@ $<

libtiger32.a: libtiger32.a(sboxes32.o) libtiger32.a(tiger32.o)
	ranlib $@

libtiger32-unrolled.a: libtiger32-unrolled.a(sboxes32.o) libtiger32-unrolled.a(tiger32-unrolled.o)
	ranlib $@

libtigertree32.a: libtigertree32.a(sboxes32.o) libtigertree32.a(tiger32.o) libtigertree32.a(tigertree32.o)
	ranlib $@

libtigertree32-unrolled.a: libtigertree32-unrolled.a(sboxes32.o) libtigertree32-unrolled.a(tiger32-unrolled.o) libtigertree32-unrolled.a(tigertree32.o)
	ranlib $@

sboxes64.o: sboxes.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -m64 -c -o $@ $<

tiger64-32wide.o: tiger.c tiger.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -m64 -c -o $@ $<

tiger64-32wide-unrolled.o: tiger.c tiger.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -DUNROLL -m64 -c -o $@ $<

tiger64-64wide.o: tiger.c tiger.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -DOPTIMIZE_FOR_64BIT -m64 -c -o $@ $<

tiger64-64wide-unrolled.o: tiger.c tiger.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -DUNROLL -DOPTIMIZE_FOR_64BIT -m64 -c -o $@ $<

tigertree64.o: tigertree.c tigertree.h
	$(CC) $(CPPFLAGS) $(CFLAGS) -m64 -c -o $@ $<

libtiger64-32wide.a: libtiger64-32wide.a(sboxes64.o) libtiger64-32wide.a(tiger64-32wide.o)
	ranlib $@

libtiger64-32wide-unrolled.a: libtiger64-32wide-unrolled.a(sboxes64.o) libtiger64-32wide-unrolled.a(tiger64-32wide-unrolled.o)
	ranlib $@

libtigertree64-32wide.a: libtigertree64-32wide.a(sboxes64.o) libtigertree64-32wide.a(tiger64-32wide.o) libtigertree64-32wide.a(tigertree64.o)
	ranlib $@

libtigertree64-32wide-unrolled.a: libtigertree64-32wide-unrolled.a(sboxes64.o) libtigertree64-32wide-unrolled.a(tiger64-32wide-unrolled.o) libtigertree64-32wide-unrolled.a(tigertree64.o)
	ranlib $@

libtiger64-64wide.a: libtiger64-64wide.a(sboxes64.o) libtiger64-64wide.a(tiger64-64wide.o)
	ranlib $@

libtiger64-64wide-unrolled.a: libtiger64-64wide-unrolled.a(sboxes64.o) libtiger64-64wide-unrolled.a(tiger64-64wide-unrolled.o)
	ranlib $@

libtigertree64-64wide.a: libtigertree64-64wide.a(sboxes64.o) libtigertree64-64wide.a(tiger64-64wide.o) libtigertree64-64wide.a(tigertree64.o)
	ranlib $@

libtigertree64-64wide-unrolled.a: libtigertree64-64wide-unrolled.a(sboxes64.o) libtigertree64-64wide-unrolled.a(tiger64-64wide-unrolled.o) libtigertree64-64wide-unrolled.a(tigertree64.o)
	ranlib $@

