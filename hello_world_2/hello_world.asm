; Written for assembly with NASM
section .data
  hello: db 'Hello, world!',10 ; string to print
  hellolen: equ $-hello ; length of 'hello' line

section .text
  global _start

_start:
  call _stack
  push hellolen
  push hello
  call _print
  add rsp,16
  mov rax,0x01 ; syscall for exit()
  mov rbx,0x00 ; exit status 0
  int 0x80 ; software interrupt

_stack:
  mov rax,rsp
  add rsp,8
  sub rsp,8
  ret

_print:
  push rbp ; keep track of base pointer
  mov rbp,rsp ; move stack pointer to base now
; at this point the stack should look like
; +24 buffer length
; +16 buffer pointer
; +8 return address
; 0 old ebp/current esp
  mov rax,0x04 ; write()
  mov rbx,0x01 ; stdout
  mov rcx,[rbp+16]
  mov rdx,[rbp+24]
  int 0x80 ; execute syscall
  pop rbp
  ret ; caller should clean up stack
