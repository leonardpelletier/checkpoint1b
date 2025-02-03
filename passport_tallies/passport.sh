#!/bin/bash
# This script will log into the Passport server with one command so I
# don't have to keep copying and pasting the IP and password into the
# terminal

# Define server IP address, username, and password
SERVER_IP="159.203.38.132"
USERNAME="root"
PASSWORD="BkaUiHXTNidy9ADC3uPp\$ggumaZ7CHMrWrm86jesZgdo9VLf9yvVybCxzcrm"

# SSH into the server and execute commands
sshpass -p "$PASSWORD" ssh -t "$USERNAME"@"$SERVER_IP" << EOF
echo "Connected to server at $SERVER_IP"
