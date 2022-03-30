; @TODO add documentation here ;
global _start
section .data
LF		equ	10 ; line feed
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

; @TODO add documentation here ;
section .text
_start:
	call readInputFile ; @TODO add body of function
	call writeOutputFile ; @TODO add body of function
exit:
	mov rax, SYS_exit
	mov rdi, EXIT_SUCCESS
	syscall
