#!/bin/bash

#Get the current users name
USERNAME=`id -un`

CONNECTION_STRING=$1

# Defaults!
KEY_TYPE="rsa"
KEY_BITS="4096"
KEY_PASS=""
KEY_COMMENT="oliver@freshleafmedia.co.uk"
KEY_PASS_PROMPT=false

# Get any params defined
for i in "$@"
do
case $i in
        -p|--passwd)	KEY_PASS_PROMPT=true	;;
		-c|--comment)	KEY_COMMENT="${i#*=}"	;;
esac
done

# Split the connection string into the domain and the username
IFS='@' read KEY_USER KEY_DOMAIN <<< "$CONNECTION_STRING"

# Check both the username and domain have been found correctly
if [ -z "${KEY_USER+x}" ]; then
	echo "ERROR: Please specify a username"
	exit
fi
if [ -z "${KEY_DOMAIN+x}" ]; then
	echo "ERROR: Please specify a domain"
	exit
fi

# Prompt for a password if required
if [ $KEY_PASS_PROMPT ]; then
	read -s -p "Enter password: " KEY_PASS
	echo
fi

# Set the path the key should be written to
KEY_PATH="/home/$USERNAME/.ssh/$KEY_TYPE/$KEY_DOMAIN" #Must be an absolute path!

# Create and set the ownership of the directory to store the key in
mkdir -p "$KEY_PATH"
chmod 0700 "$KEY_PATH"

# Write the key
ssh-keygen -t "$KEY_TYPE" -b "$KEY_BITS" -C oliver@freshleafmedia.co.uk -f "$KEY_PATH/$KEY_USER" -N "$KEY_PASS"

