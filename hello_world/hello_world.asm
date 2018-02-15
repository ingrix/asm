; Written for assembly with NASM
section .data
  hello: db 'Hello, world!',10 ; string to print
  hellolen: equ $-hello ; length of 'hello' line

section .text
  global _start

_start:
  mov eax,0x04 ; syscall for write()
  mov ebx,0x01 ; file descriptor for stdout
  mov ecx,hello ; the buffer
  mov edx,hellolen ; length of buffer
  int 0x80 ; software interrup for system call
  mov eax,0x01 ; syscall for exit()
  mov ebx,0x00 ; exit status 0
  int 0x80 ; software interrupt
