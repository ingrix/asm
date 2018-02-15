#ifndef __SYSCALL_ARM32_EABI_H__
#define __SYSCALL_ARM32_EABI_H__

#include <asm/unistd.h>
#include <asm/types.h>

#define _syscall1(ret_type, name, arg_type, arg_name)   \
  ret_type syscall_##name(arg_type arg_name) {          \
    __u32 r;                                            \
    register __u32 a1 asm("r0") = (__u32)arg_name;      \
    __asm__ volatile (                                  \
        "mov r7, %1\n\t"                                \
        "svc 0\n\t"                                     \
        "mov %0, r0\n\t"                                \
        : "=r" (r)                                      \
        : "r" (__NR_##name)                             \
        : "r7" );                                       \
        return (ret_type)r;                             \
  }

#define _syscall2(ret_type, name,                       \
    arg_type1, arg_name1,                               \
    arg_type2, arg_name2)                               \
  ret_type syscall_##name(arg_type1 arg_name1,          \
      arg_type2 arg_name2) {                            \
    __u32 r;                                            \
    register __u32 a1 asm("r0") = (__u32)arg_name1;     \
    register __u32 a2 asm("r1") = (__u32)arg_name2;     \
    __asm__ volatile (                                  \
        "mov r7, %1\n\t"                                \
        "svc 0\n\t"                                     \
        "mov %0, r0\n\t"                                \
        : "=r" (r)                                      \
        : "r" (__NR_##name)                             \
        : "r7" );                                       \
        return (ret_type)r;                             \
  }

#define _syscall3(ret_type, name,                       \
    arg_type1, arg_name1,                               \
    arg_type2, arg_name2,                               \
    arg_type3, arg_name3)                               \
  ret_type syscall_##name(arg_type1 arg_name1,          \
      arg_type2 arg_name2,                              \
      arg_type3 arg_name3) {                            \
    __u32 r;                                            \
    register __u32 a1 asm("r0") = (__u32)arg_name1;     \
    register __u32 a2 asm("r1") = (__u32)arg_name2;     \
    register __u32 a3 asm("r2") = (__u32)arg_name3;     \
    __asm__ volatile (                                  \
        "mov r7, %1\n\t"                                \
        "svc 0\n\t"                                     \
        "mov %0, r0\n\t"                                \
        : "=r" (r)                                      \
        : "r" (__NR_##name)                             \
        : "r7" );                                       \
        return (ret_type)r;                             \
  }

#endif // __SYSCALL_ARM32_EABI_H__
