section .text
; argument: rdi is string for processing
; return: rax
getFilteredData:
	push r12
	push rbp
	push rbx ; len of filtered string
	mov rbp, rdi
	mov rbx, 0 ; rbx is len of final string
	mov r12, 0 ; set initial memory at 0
filterCountLoop:
	cmp byte[rbp], 0 ; compare to null
	je filterDone
	cmp byte[rbp], 32
	jge upLwrCase
	jmp next ; else continue the loop
upLwrCase:
	cmp byte[rbp], 126
	jle validAscii ; if in range it is valid character
	jmp next ; continue iteration
validAscii:
	inc rbx
	inc rbp
	mov r12, byte[rbp] ; move character to r12
	inc r12 ; move memory up by 1
	jmp filterCountLoop
next:
	inc rbp
	jmp filterCountLoop
filterDone:
	mov rax, r12 ; move result to rax to return
	pop rbx
	pop rbp
	pop r12
	ret ; return result string to rax



	