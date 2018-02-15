# This is a program that takes the initial stack pointer and prints it as a 
# hex value in two different ways, one using printf(), the other which explicitly
# converts a value to characters and uses the write() syscall (0x04)

# Lessons learned the hard way:
# Syscalls in 32-bit vs 64-bit linux are different.  In 32-bit mode you use the 'int 0x80'
# instruction to do a syscall (with particular calling conventions), whereas in 64-bit you
# use the explicit 'syscall' instruction.  Along with this is a difference in the syscall numbers.  
# 'Write' in 32-bit mode is syscall 0x04, whereas in 64 bit it's 0x01.  These number can be found
# for x86(-64) in the linux kernel source, arch/x86/entry/syscalls/syscalltbl_{32,64}.tbl
# or alternatively at INCLUDEDIR/asm/unistd_32.h or INCLUDEDIR/asm/unistd_64.h
#
# Interesting error result: the first implementation of this program erroneously used int 0x80
# call to perform write from a buffer in stack memory.  Since the stack is >4GB limit this 
# lead to an error for the 32-bit instruction.  Changing the stack memory to a .data buffer
# fixed this issue.  However, switching to 64-bit 'syscall' messed this up, but that was because
# the syscall number was not changed to reflect the 64-bit conventions.  This took like 2 hours
# to figure the hell out after reading a number of documents and stack overflow threads.
# tl;dr - make sure ALL of your calling conventions are correct!

.global _start # Uncomment if you don't want to use glibc
#.global main

.section .data
tv: .asciz "test\n"

.section .text
_start:
  movq %rsp, %rdi
  callq print_val
  movq %rax,%rdi
  # 64 bit calling convention
  movq $60,%rax
  syscall
  #movq %rax,%rbx
  #movq $0x01,%rax
  #int $0x80

#######
# Convert an integer value into a base 16 printable string
# This places the characters in $buf (.bss)
#######
print_val:
  pushq %rbp
  movq %rsp,%rbp

  movq %rdi,%rax # move passed value to rax

  pushq %rbx # save rbx since this is defined in the abi
  #movq $buf,%rbx # 
  leaq -0x1(%rsp),%rbx # First byte after current rsp, should be start of buffer
  subq $0x20,%rsp # space for buffer and then round to next 8 bytes for stack alignment on function call
  movb $0,(%rbx) # Null pointer at the "end" of the buffer
  decq %rbx # move to next char
  movb $'\n',(%rbx) # newline before the null
  decq %rbx # next char

  movq $2,%rcx # two characters in current buffer

char_loop: # loop beginning
  movq %rax,%rdx # Move the current value to rdx
  andq $0x0F,%rdx # Strip out all but the last four bits for character value
  cmp $10,%rdx # determine if value is greater than 10, will change the offset we need
  jl lt10
  #jmp lt10
#gt10:
  #subq $10,%rbx
  #addq $'A',%rbx
  addq $55,%rdx # skips the non-alnum characters between '9' and 'A', same as '7'
  jmp endchar 
lt10:
  addq $'0',%rdx
endchar:
  movb %dl,(%rbx) # add the value to the stack
  incq %rcx # increase char count 
  decq %rbx # move to next char
  shrq $4,%rax # shift %rax 4 to the right to get rid of last char
  cmp $0,%rax # Test if %rax is zero
  jg char_loop # do this until our number is zero

# add a '0x' prefix to our hex number
  movb $'x',(%rbx)
  decq %rbx
  movb $'0',(%rbx) # don't need a decq after this since it's the last char
  addq $2,%rcx # should be 16 for stack pointers (12 nums + 0x + \n\0)
    
  movq %rcx,%r12 # Save our character count, we'll need it for return value
  
  #movq $0x04,%rax # write syscall, but only in 32 bit mode!  These are not the same in 64-bit linux
  movq $0x01,%rax # 64-bit write
  movq %rcx,%rdx # move char count to rdx for syscall
  movq %rbx,%rsi # move buffer address to rcx 
  movq $0x01,%rdi # stdout
  syscall # 64-bit does not require int $0x80 but now has syscall instruction
  #int $0x80 # execute syscall

  # end of function
  addq $0x20,%rsp # Get rid of temp buffer
  popq %rbx # restore rbx
  #movq %r12,%rax # return value is number of characters
  leaveq
  ret

do_null:
  pushq %rbp
  movq %rsp,%rbp
  popq %rbp
  ret

########
# converts the passed numerical value to characters, then prints them
########
#print_val:
#  pushq %rbp
#  movq %rsp,%rbp
#  # rdi already contains the value to be used, pass directly to conv_val
#  call conv_val
#  movq %rax,%rdx # the number of characters converted
#  # Call write syscall on stdout
#  movq $0x04,%rax # Write syscall
#  pushq %rbx
#  movq $0x01,%rbx # stdout
#  movq $buf,%rcx # buffer
#  #movq $64,%rdx # length
#  int $0x80
#  popq %rbx
#  xorq %rax,%rax
#  leave
#  ret
.section .bss
.lcomm buf, 32 # 32 bytes to hold number string
