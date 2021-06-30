#include<stdio.h>
#include<string.h>
unsigned char code[] = \
"\x31\xdb\x89\xd8\x40\xcd\x80";
int main()
{
    printf("Shellcode Length:  %d\n", strlen(code));
    int (*ret)() = (int(*)())code;
    ret();
}
