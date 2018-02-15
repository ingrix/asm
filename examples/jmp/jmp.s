.section .text
.global main
main:
  pushq %rbp
  movq %rsp,%rbp
  movq $0x10, %rdi
  subq $0x10,%rsp
  movq $print,(%rsp)
  callq *(%rsp)
  addq $0x10,%rsp
  xorq %rax,%rax
  popq %rbp
  retq

print :
  pushq %rbp
  movq %rsp, %rbp
  movq %rdi, %rsi # transfer the first parameter, a value, to rsi
  movq $msg, %rdi # move message into the thing
  callq printf  
  popq %rbp
  retq


msg: .ascii "Value: 0x%x\n\0"
