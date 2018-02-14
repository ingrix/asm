#include <asm/unistd.h>
#include <asm/types.h>

#include "syscall_x86-64.h"


_syscall1(long, exit, int, status);
_syscall3(long, read, int, fd, void *, buf, int, len);
_syscall3(long, write, int, fd, void *, buf, int, len);

extern void _start() {
  char buf[64];
  long n = syscall_read(0, buf, 64);
  syscall_write(1, buf, n);
  syscall_exit(42);
}
