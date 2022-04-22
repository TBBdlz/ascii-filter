;##############################################
;
;Member:
;	633040174-2 Metee Yingyongwatthanakit
;	633040423-7 Watsharapat Ritthisoonthorn
;	633040603-5 Thanawit Tapabud
;
;##############################################

; @TODO add documentation here ;
section .data
LF			equ	10 ; line feed
NULL		equ	0
TRUE		equ	1
FALSE		equ	0
EXIT_SUCCESS	equ	0
STDIN		equ	0
STDOUT		equ	1
STDERR		equ	2	
SYS_read	equ	0
SYS_write	equ	1
SYS_open	equ	2
SYS_close	equ	3
SYS_fork	equ	57
SYS_exit	equ	60
SYS_create	equ	85
SYS_time	equ	201
O_CREATE	equ	0x40
O_TRUNC		equ	0x200
O_APPEND	equ	0x400
O_RDONLY	equ	000000q ; read only
O_WRONLY	equ	000001q ; write only
O_RDWR		equ	000002q ; read and write
S_IRUSR		equ	00400q
S_IWUSR		equ	00200q
S_IXUSR		equ	00100q
newLine		db	LF, NULL
inputFile	db	"test_input.dat", NULL
outputFile	db	"output.dat", NULL
fileDescriptor	dq	0
errMsgOpen	db	"Error on opening file.", LF, NULL
errMsgRead	db	"Error on reading file.", LF, NULL
errMsgWrite	db	"Error on writing file.", LF, NULL
errMsgArgs	db	"Invalid Args.", LF, "you should ./execNameFile inputFile outputFile", NULL
msgFinish	db	"Finish!!!!", LF, NULL
lenRes		db	0
BUFF_SIZE	equ	2000

section .bss
readBuffer		resb	BUFF_SIZE
filteredData	resb	BUFF_SIZE

extern printString

; @TODO add documentation here ;
section .text
global main
main:

	;check count args
	cmp rdi, 3
	jne errorOnArgs

	;get input file and output file
	mov r8, qword[rsi + 8]
	mov qword[inputFile], r8
	mov r8, qword[rsi + 16]
	mov qword[outputFile], r8

; Attempt to open input file - Use system service for opening file
openInputFile:
	mov rax, SYS_open 			; file open
	mov rdi, qword[inputFile]	; move input file name to rdi
	mov rsi, O_RDONLY 			; read only access
	syscall 					; call system service for opening file
	cmp rax, 0
	jl errorOnOpen
	mov qword[fileDescriptor], rax ; save file descriptor

readInputFile:
	mov rax, SYS_read
	mov rdi, qword[fileDescriptor]
	mov rsi, readBuffer ; content of input file goes here
	mov rdx, BUFF_SIZE
	syscall
	cmp rax, 0
	jl errorOnRead

closeInputFile:
	mov rax, SYS_close
	mov rdi, qword[fileDescriptor]
	syscall
	
processInputData:
	mov rdi, readBuffer
	mov rsi, filteredData
	call getFilteredData ; rax is filtered data from the function
	mov qword[lenRes], rbx

createOutputFile:
	mov rax, SYS_create
	mov rdi, qword[outputFile]
	mov rsi, S_IWUSR | S_IRUSR; allow write and read
	syscall ; call the kernel
	cmp rax, 0
	jl errorOnOpen
	mov qword[fileDescriptor], rax ; save descriptor

writeOutputFile:
	mov rax, SYS_write
	mov rdi, qword[fileDescriptor]
	mov rsi, filteredData 
	mov rdx, qword[lenRes]
	syscall
	cmp rax, 0
	jl errorOnWrite

closeOutputFile: ; @TODO duplicate code should create function to close file
	mov rax, SYS_close
	mov rdi, qword[fileDescriptor]
	syscall

	mov rdi, msgFinish
	call printString
	jmp exit ; done running main program

errorOnOpen:
	mov rdi, errMsgOpen
	call printString
	jmp exit	

errorOnRead:
	mov rdi, errMsgRead
	call printString
	jmp exit
	
errorOnWrite:
	mov rdi, errMsgWrite
	call printString
	jmp exit

errorOnArgs:
	mov rdi, errMsgArgs
	call printString
	jmp exit

exit:
	mov rax, SYS_exit
	mov rdi, EXIT_SUCCESS
	syscall

getFilteredData:
        mov rcx, rdi ; set rcx to memory of original string
        mov rbx, 0 ; set len = 0
filterCountLoop:
        cmp byte[rcx], 0 ; compare to null
        je filterDone
        cmp byte[rcx], 32
        jge upLwrCase
        jmp next ; else continue the loop
upLwrCase:
        cmp byte[rcx], 126
        jle validAscii ; if in range it is valid character
        jmp next ; continue iteration
validAscii:
	mov al, byte[rcx]
        mov byte[filteredData+rbx], al; move character to r8
        inc rcx
        inc rbx
        jmp filterCountLoop
next:
        inc rcx
        jmp filterCountLoop
filterDone:
        mov rax, 0
        ret ; return result string to rax
