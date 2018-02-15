# This is a program that takes the initial stack pointer and prints it as a 
# hex value in two different ways, one using printf(), the other which explicitly
# converts a value to characters and uses the write() syscall (0x04)

.global _start # Uncomment if you don't want to use glibc
#.global main

.section .data
msg: .asciz "%p\n"

.section .text
# if you don't want to use gcc/glibc, uncomment this and comment main:
_start:
  movq %rsp, %rdi
  callq print_val
  xorq %rbx,%rbx
  movq $0x01,%rax
  int $0x80
#main:
#  pushq %rbp
#  movq %rsp,%rbp
#  movq %rsp,%rbx
#  movq %rbx,%rdi
#  call print_printf
#  movq %rbx,%rdi
#  call print_val
#  popq %rbp
#  ret
  
#############
# print passed value using printf
#############
#print_printf:
#  pushq %rbp
#  movq %rsp,%rbp
#  movq %rdi,%rsi
#  movq $msg,%rdi
#  call printf 
#  popq %rbp
#  ret

#######
# Convert an integer value into a base 16 printable string
# This places the characters in $buf (.bss)
#######
conv_val:
  pushq %rbp
  movq %rsp,%rbp
  pushq %rbx # save rbx since this is defined in the abi

  movq %rdi,%rax # Move value to rax for division
  xorq %rdx,%rdx # clear rdx for division
  pushq $0 # Null character
  pushq $'\n' # Newline character
  movq $2,%rcx # one character at least must be written

char_loop: # loop beginning
  movq %rax,%rbx # Move the current value to rbx
  andq $0x0F,%rbx
  cmp $10,%rbx
  jge gt10
  jmp lt10
gt10:
  #subq $10,%rbx
  #addq $'A',%rbx
  addq $55,%rbx # skips the non-alnum characters between '9' and 'A', same as '7'
  jmp endchar 
lt10:
  addq $'0',%rbx
endchar:
  pushq %rbx # add the value to the stack
  incq %rcx # increase char count 
  shrq $4,%rax # shift %rax 4 to the right to get rid of last char
  cmp $0,%rax # Test if %rax is zero
  jg char_loop # do this until our number is zero

# add a '0x' prefix to our hex number
  pushq $'x'
  pushq $'0'
  addq $2,%rcx
    
  movq %rcx,%r10 # Save our character count, we'll need it for return value
  movq $buf,%rax
char_move: # move characters to the buffer
  popq %rbx # move the last char on stack into the rbx register - this should be at least 4 times faster than a div op
  mov %bl,(%rax) # move the character to the buffer
  incq %rax # Increase writing address
  decq %rcx # decrease char count
  jrcxz end_conv_val # wrap up conv_val if rcx is zero
  jmp char_move # if there's more to do then jump back to char_move

end_conv_val:
  # end of function
  addq %r10,%rsp # Get rid of temp buffer
  movq %r10,%rax
  popq %rbx # restore rbx
  leaveq
  ret

########
# converts the passed numerical value to characters, then prints them
########
print_val:
  pushq %rbp
  movq %rsp,%rbp
  # rdi already contains the value to be used, pass directly to conv_val
  call conv_val
  movq %rax,%rdx # the number of characters converted
  # Call write syscall on stdout
  movq $0x04,%rax # Write syscall
  pushq %rbx
  movq $0x01,%rbx # stdout
  movq $buf,%rcx # buffer
  #movq $64,%rdx # length
  int $0x80
  popq %rbx
  xorq %rax,%rax
  leave
  ret
.section .bss
.lcomm buf, 32 # 32 bytes to hold number string
