#include <asm/unistd.h>

#define _syscall1(ret_type, name, arg_type, arg_name) \
  ret_type syscall_##name(arg_type arg_name) {          \
    ret_type r;                                       \
    __asm__ volatile (                                \
        "movl %1, %%eax\n\t"                            \
        "movl %2, %%edi\n\t"                            \
        "syscall\n\t"                                 \
        "movq %%rax, %0\n\t"                            \
        : "=r" (r)                                    \
        : "r" (__NR_##name), "r" (arg_name)           \
        : "%rax", "%rdi" );                           \
        return r; \
  }

_syscall1(long, exit, int, status);

extern void _start() {
  syscall_exit(42);
}
