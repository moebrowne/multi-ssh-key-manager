#!/bin/bash

#Get the current users name
USERNAME=`id -un`

# Setup the global variables
ACTION=$1
CONNECTION_STRING=$2
KEY_MIN_LENGH=1024

#Skip the action and connection string
shift && shift

# Defaults!
KEY_TYPE="rsa"
KEY_BITS="4096"
KEY_PASS=""
KEY_COMMENT=""
KEY_PASS_PROMPT=false

# Set the key base root
KEY_PATH_ROOT="/home/$USERNAME/.ssh"

# Define the executables to use
EXEC_KEYGEN="/usr/bin/ssh-keygen"
EXEC_OPENSSL="/usr/bin/openssl"

# Get any defined params
while [[ $# > 1 ]]
do
key="$1"

case $key in
	-p|--passwd)	KEY_PASS_PROMPT=true			;;
	-c|--comment)	KEY_COMMENT="$2"				;;
	-b|--bits)		KEY_BITS="$2"					;;
	-t|--type)		KEY_TYPE="$2"					;;
    *)				echo "Unknown option $2"; exit	;;
esac
shift
done

# Split the connection string into the domain and the username
IFS='@' read KEY_USER KEY_DOMAIN <<< "$CONNECTION_STRING"

# Only throw an error if the connection string is missing for actions that require them
if [ "$ACTION" = "create" ]; then

	# Check both the username and domain have been found correctly
	if [ "$KEY_USER" = "" ]; then
		echo "ERROR: Please specify a username"
		exit
	fi
	if [ "$KEY_DOMAIN" = "" ]; then
		echo "ERROR: Please specify a domain"
		exit
	fi

	# Set the path the key should be written to
	KEY_PATH_DIR="$KEY_PATH_ROOT/$KEY_TYPE/$KEY_DOMAIN" #Must be an absolute path!

	# Set the path of the key its self
	KEY_PATH_KEY="$KEY_PATH_DIR/$KEY_USER"

fi

# Get the source directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Set the library root path
LIBRARY_PATH_ROOT="$DIR/utils"

# Include the generic functions library
. "$LIBRARY_PATH_ROOT/generic.sh"

# Set the library path
LIBRARY_PATH="$LIBRARY_PATH_ROOT/$ACTION.sh"

# Check the library exists
if [ ! -f "$LIBRARY_PATH" ]; then
	echo "ERROR: Unknown action '$ACTION'"
	exit
fi

# Include the library for handling this action
. "$LIBRARY_PATH"