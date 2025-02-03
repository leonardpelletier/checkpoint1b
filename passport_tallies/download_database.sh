#!/bin/bash
# This script will connect to the Passport server and download
# the relevant database tables as json files for the purpose
# of running a passport tally.

# Define server IP address, username, and password
SERVER_IP="159.203.38.132"
USERNAME="root"
PASSWORD="BkaUiHXTNidy9ADC3uPp\$ggumaZ7CHMrWrm86jesZgdo9VLf9yvVybCxzcrm"

# SSH into the server and execute commands
sshpass -p "$PASSWORD" ssh -t "$USERNAME"@"$SERVER_IP" << EOF
  echo "Connected to server at $SERVER_IP"
  
  echo "Fetching users..."
  mongoexport -d mean -c users --out "users.json" --pretty
  
  echo "Fetching badges..."
  mongoexport -d mean -c badges --out "badges.json" --pretty

  echo "Fetching badge rewards..."
  mongoexport -d mean -c userbadges --out "userbadges.json" --pretty
EOF

# Additional commands after SSH session ends
echo "Transfering files to local machine..."

sshpass -p "$PASSWORD" scp root@159.203.38.132:"users.json" .
sshpass -p "$PASSWORD" scp root@159.203.38.132:"badges.json" .
sshpass -p "$PASSWORD" scp root@159.203.38.132:"userbadges.json" .

echo "Appending theEnd to the end of the json files because I'm an idiot :D ..."
echo "theEnd" >> users.json
echo "theEnd" >> badges.json
echo "theEnd" >> userbadges.json
echo "Done!"

EOF