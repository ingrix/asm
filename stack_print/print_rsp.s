	.file	"print_rsp.c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movb	$97, -16(%rbp)
	movb	$98, -15(%rbp)
	movb	$99, -14(%rbp)
	movb	$49, -13(%rbp)
	movb	$50, -12(%rbp)
	movb	$51, -11(%rbp)
	movb	$10, -10(%rbp)
	leaq	-16(%rbp), %rax
	movl	$7, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	write
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 6.1.1 20160602"
	.section	.note.GNU-stack,"",@progbits
