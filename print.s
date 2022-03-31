; printString call SYSTEM WRITE
; and print string to the user
; Argument: rdi is string argument
section .data
SYS_WRITE	equ	1
STDOUT		equ	1

section .text
global printString
printString:
	push	rbx
	mov	rbx, rdi
	mov	rdx, 0
strCountLoop:
	cmp	byte[rbx], 0
	je	strCountDone
	inc	rdx
	inc	rbx
	jmp	strCountLoop
strCountDone:
	cmp	rdx, 0
	je	printDone
	mov	rax, SYS_WRITE
	mov	rsi, rdi ; Put argument ready to print out
	mov	rdi, STDOUT
	syscall
printDone
	pop	rbx
	ret
