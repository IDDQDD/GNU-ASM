.section .data
str:
.ascii  "Hello World!\n\0"
filename:
.asciz "asm.txt"
.section .bss
.comm buffer, 15
.section .text
.globl _start
_start:

call  _createfile
call  _openfile
call  _writetofile
call  _closefile
call  _readfile
call  _closefile
call  _output
call  _exit


_createfile:
	movq $2, %rax                                # system call number(SYS_OPEN)
	movq $filename, %rdi                         # filename
	movq $64, %rsi                               # O_CREAT flag
	movq $0644, %rdx                             # file settings with four octal values
	syscall
	

_openfile:
	movq $2, %rax                                # system call number(SYS_OPEN)
	movq $filename, %rdi                         # filename string with non terminated symbol
	movq $1, %rsi                                # O_WRONLY flag
	syscall


_writetofile:
	pushq %rax                                  # filedescriptor info
	movq $1, %rax                               # system call number(SYS_WRITE)
	popq %rdi                                   # open file information(returned values)
	movq $str, %rsi                             # string with zero terminated symbol
	movq $13, %rdx                              # string size
	syscall


_readfile:
	movq $2, %rax                               # system call number(SYS_READ)
	movq $filename, %rdi                        # filename with non terminated symbol
	movq $0, %rsi                               # O_READ flag
	syscall


	pushq %rax                                 # file descriptor info
	movq $0, %rax                              # system call number(SYS_READ)
	popq %rdi                                  # file descriptor info to %rdi
	movq $buffer, %rsi                         # buffer for string 
	movq $14, %rdx                             # string size
	syscall


_output:
	movq $1, %rax                              # system call number(SYS_WRITE)
	movq $1, %rdi                              # file descriptor flag (O_WRITE)
	movq $buffer, %rsi                         # string
	movq $13, %rdx                             # string size
	syscall

_closefile:
	movq $3, %rax                             # system call number(SYS_CLOSE), in the %rdi register find 
	syscall                                   # file descriptor info 

_exit:
	movq $0, %rdi
	movq $60, %rax
	syscall





