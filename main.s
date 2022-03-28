; @TODO add documentation here ;
global _start
section .data
LF			equ		10 ; new line character
NULL		equ		0
EXIT_SUCCESS		equ		0	
SYS_read	equ		0
SYS_write	equ		1
SYS_exit	equ		60

; @TODO add documentation here ;
section .text
_start:
	call readInputFile ; @TODO add body of function
	call writeOutputFile ; @TODO add body of function
exit:
	mov rax, SYS_exit
	mov rdi, EXIT_SUCCESS
	syscall