nolib: nolib.o
	$(CC) $@ -nostdlib -nostartfiles -nodefaultlibs $<

%.o: %.c
	$(CC) -c -S -o $@.S -nostdlib -nostartfiles -nodefaultlibs $<
	$(CC) -c -o $@ -nostdlib -nostartfiles -nodefaultlibs $<
