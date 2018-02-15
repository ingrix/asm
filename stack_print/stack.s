	.file	"stack.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"i=%d\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB11:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	xorl	%ebx, %ebx
.L2:
	movl	%ebx, %esi
	xorl	%eax, %eax
	movl	$.LC0, %edi
	addl	$1, %ebx
	call	printf
	cmpl	$5, %ebx
	jne	.L2
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE11:
	.size	main, .-main
	.ident	"GCC: (GNU) 6.1.1 20160501"
	.section	.note.GNU-stack,"",@progbits
