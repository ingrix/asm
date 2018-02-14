#ifndef __SYSCALL_X86_64_H__
#define __SYSCALL_X86_64_H__

#define _syscall1(ret_type, name, arg_type, arg_name)   \
  ret_type syscall_##name(arg_type arg_name) {          \
    __u64 r;                                            \
    register __u64 a1 asm("rdi") = (__u64)arg_name;     \
    __asm__ volatile (                                  \
        "movq %1, %%rax\n\t"                            \
        "syscall\n\t"                                   \
        "movq %%rax, %0\n\t"                            \
        : "=r" (r)                                      \
        : "r" ((__u64)__NR_##name), "r" (a1)            \
        : "%rax" );                                     \
        return (ret_type)r; \
  }

#define _syscall2(ret_type, name, \
    arg_type1, arg_name1, \
    arg_type2, arg_name2) \
  ret_type syscall_##name(arg_type1 arg_name1, arg_type2 arg_name2) {       \
    __u64 r;                                       \
    register __u64 a1 asm("rdi") = (__u64)arg_name1;        \
    register __u64 a2 asm("rsi") = (__u64)arg_name2;        \
    __asm__ volatile (                                \
        "movq %1, %%rax\n\t"                            \
        "syscall\n\t"                                 \
        "movq %%rax, %0\n\t"                            \
        : "=r" (r)                                    \
        : "r" ((__u64)__NR_##name), "r" (a1), "r" (a2) \
        : "%rax" );                           \
        return (ret_type)r; \
  }

#define _syscall3(ret_type, name, \
    arg_type1, arg_name1, \
    arg_type2, arg_name2, \
    arg_type3, arg_name3) \
  ret_type syscall_##name(arg_type1 arg_name1, \
      arg_type2 arg_name2,        \
      arg_type3 arg_name3) {       \
    __u64 r;                                       \
    register __u64 a1 asm("rdi") = (__u64)arg_name1;        \
    register __u64 a2 asm("rsi") = (__u64)arg_name2;        \
    register __u64 a3 asm("rdx") = (__u64)arg_name3;        \
    __asm__ volatile (                                \
        "movq %1, %%rax\n\t"                            \
        "syscall\n\t"                                 \
        "movq %%rax, %0\n\t"                            \
        : "=r" (r)                                    \
        : "r" ((__u64)__NR_##name), "r" (a1), "r" (a2), "r" (a3) \
        : "%rax" );                           \
        return (ret_type)r; \
  }

#endif // __SYSCALL_X86_64_H__
