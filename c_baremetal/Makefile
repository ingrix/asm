nolib: nolib.o
	$(CC) -g -o $@ -nostdlib -nostartfiles -nodefaultlibs $<

%.o: %.c
	$(CC) -g -c -o $@ -nostdlib -nostartfiles -nodefaultlibs $<
