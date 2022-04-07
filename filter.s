section .text
; argument: rdi is string for processing
; return: rax = 0, r12 is fitered string
getFilteredData:
	mov rbp, rdi ; set rbp to memory of original string
	mov rbx, 0 ; set len = 0
	mov r12, rsi ; value to copy to
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
	mov dx, byte[rbp]
	mov byte[r12+rbx], dx; move character to r12
	inc rbp
	inc rbx
	jmp filterCountLoop
next:
	inc rbp
	jmp filterCountLoop
filterDone:
	mov rax, 0
	pop rbp
	ret ; return result string to rax



	
