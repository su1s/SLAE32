#include <stdio.h>
#include <string.h>

unsigned char code[] = \
 "\x31\xc0"                    /* xor    %eax,%eax */
 "\xb0\x01"                    /* mov    $0x1,%al */
 "\x31\xdb"                    /* xor    %ebx,%ebx */
 "\xcd\x80";                   /* int    $0x80 */

int
main() {

       printf("Shellcode Length:  %d\n", strlen(code));
       int (*ret)() = (int(*)())code;
       ret();

return 0;
}




