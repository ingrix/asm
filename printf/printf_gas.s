.global main
.text
main:
  pushq %rbp # save stack base pointer
  movq %rsp, %rbp
  subq $0x10,%rsp # Decrease stack pointer by 16 to obey alignment
  movq $4,(%rsp) # Put the value 4 where rsp currently is
  movq $messagep, %rdi # rdi is the first parameter passed
  movq %rsp,%rsi # rsi is the second parameter passed
  movq (%rsp),%rdx # third parameter holds the value 4 now
  call printf # print message
  addq $16,%rsp # Get rid of extra info
  popq %rbp # replace base pointer
  xorq %rax,%rax # Exit status of zero
  ret
messagep:  .asciz "Top of stack: %p, value: %d\n"
message1:  .asciz "less than 3\n"
message2:  .asciz "greater than 3\n"
