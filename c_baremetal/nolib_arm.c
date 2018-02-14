#include <asm/unistd.h>
#include <asm/types.h>

#include "syscall_arm32_eabi.h"

_syscall1(long, exit, int, status);

extern void _start() {
  syscall_exit(42);
}
