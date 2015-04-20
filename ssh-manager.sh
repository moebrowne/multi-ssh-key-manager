#!/bin/bash

#Get the current users name
USERNAME=`id -un`

# Setup the global variables
ACTION=$1
CONNECTION_STRING=$2

# Defaults!
KEY_TYPE="rsa"

# Get any params defined
for i in "$@"
do
case $i in
		-t|--type)		KEY_TYPE="${i#*=}"		;;
esac
done

# Split the connection string into the domain and the username
IFS='@' read KEY_USER KEY_DOMAIN <<< "$CONNECTION_STRING"

# Check both the username and domain have been found correctly
if [ "$KEY_USER" = "" ]; then
	echo "ERROR: Please specify a username"
	exit
fi
if [ "$KEY_DOMAIN" = "" ]; then
	echo "ERROR: Please specify a domain"
	exit
fi

# Set the key base root
KEY_PATH_ROOT="/home/$USERNAME/.ssh"

# Set the path the key should be written to
KEY_PATH_DIR="$KEY_PATH_ROOT/$KEY_TYPE/$KEY_DOMAIN" #Must be an absolute path!

# Set the path of the key its self
KEY_PATH_KEY="$KEY_PATH_DIR/$KEY_USER"

# Get the source directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Include the library for handling this action
. "$DIR/utils/$ACTION.sh"