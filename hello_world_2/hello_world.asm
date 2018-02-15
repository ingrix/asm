; Written for assembly with NASM
; this program was written for x86-64 assembly on a linux system
section .data
  hello: db 'Hello, world!',10 ; string to print
  hellolen: equ $-hello ; length of 'hello' line

section .text
  global _start

_start:
; we will use right-to-left parameter pushing
; the _print call uses the write (2) system call so check the manpage for more info
  push hellolen ; push buffer length onto stack
  push hello ; push buffer address onto stack
  call _print ; call the print function

; pop rax
; pop rax
  add rsp,16 ; get rid of the parameters we passed to _print

  mov rax,0x01 ; syscall for exit()
  mov rbx,0x00 ; exit status 0
  int 0x80 ; software interrupt

_print: ; print a buffer to stdout, cdecl calling convention

; set up stack frame just because
  push rbp ; keep track of base pointer
  mov rbp,rsp ; move stack pointer to base now

; at this point the stack should look like:
; rsp+24 buffer length
; rsp+16 buffer pointer
; rsp+8 return instruction address 
; rsp+0 old ebp/current esp

  mov rax,0x04 ; write()
  mov rbx,0x01 ; stdout, arg 1 of write (2)
  mov rcx,[rbp+16] ; buffer to write, arg 2
  mov rdx,[rbp+24] ; buffer length, arg 3
  int 0x80 ; execute syscall

; remove rbp that we pushed so that rsp will point to the return address
  pop rbp ; 
  ret ; return to calling function, caller should clean up stack
