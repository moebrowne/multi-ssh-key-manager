#!/bin/bash

#Get the current users name
USERNAME=`id -un`

# Setup the global variables
ACTION=$1
CONNECTION_STRING=$2

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

# Get the source directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Include the library for handling this action
. "$DIR/utils/$ACTION.sh"