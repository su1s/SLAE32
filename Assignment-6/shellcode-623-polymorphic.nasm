section .text
global _start

_start: 
xor ebx,ebx
mov eax,ebx
inc eax
int  0x80

