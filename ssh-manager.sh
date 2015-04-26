#!/bin/bash

# Get the source directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Set the library root path
LIBRARY_PATH_ROOT="$DIR/utils"

# Include the generic libraries
. "$LIBRARY_PATH_ROOT/generic.sh"
. "$LIBRARY_PATH_ROOT/colours.sh"

# Show the banner
echo -e "-----------------------------------------"
echo -e "$COLOUR_GRN  Multi SSH Key Manager v1.2$COLOUR_RST"
echo -e "-----------------------------------------"
echo

#Get the current users name
USERNAME=`id -un`

# Setup the global variables
KEY_MIN_LENGH=1024
KEY_MIN_RECOM=2048
KEY_MIN_DEFAULT=4096

# Set the key base root
KEY_PATH_ROOT="/home/$USERNAME/.ssh"

# Define the executables to use
EXEC_KEYGEN="ssh-keygen"
EXEC_OPENSSL="openssl"

args=" $@ "

regexArgAction='^ ([^ -]*) ?([^ -]*) '
[[ $args =~ $regexArgAction ]]
ACTION="${BASH_REMATCH[1]}"
CONNECTION_STRING="${BASH_REMATCH[2]}"

regexArgComment=' -(-comment|c) ([^ ]+) '
[[ $args =~ $regexArgComment ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	KEY_COMMENT="${BASH_REMATCH[2]}"
else
	KEY_COMMENT=""
fi

regexArgType=' -(-type|t) ([^ ]+) '
[[ $args =~ $regexArgType ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	KEY_TYPE="${BASH_REMATCH[2]}"
else
	KEY_TYPE="rsa"
fi

regexArgBits=' -(-bits|b) ([0-9]+) '
[[ $args =~ $regexArgBits ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	KEY_BITS="${BASH_REMATCH[2]}"
else
	KEY_BITS=$KEY_MIN_DEFAULT
fi

regexArgPasswd=' -(-passwd|p) '
[[ $args =~ $regexArgPasswd ]]
if [ "${BASH_REMATCH[1]}" != "" ]; then
	KEY_PASS_PROMPT=true
else
	KEY_PASS_PROMPT=false
fi

regexArgPaths=' -(-paths) '
[[ $args =~ $regexArgPaths ]]
if [ "${BASH_REMATCH[1]}" != "" ]; then
	KEY_PATH_SHOW=true
else
	KEY_PATH_SHOW=false
fi

regexArgRemovalProgram=' -(-remove-with|d) ([^ ]+) '
[[ $args =~ $regexArgRemovalProgram ]]
if [ "${BASH_REMATCH[2]}" != "" ]; then
	KEY_REMOVAL_PROG="${BASH_REMATCH[2]}"
else
	KEY_REMOVAL_PROG="shred"
fi

# If no parameters were passed show the usage
if [ $# = 0 ]; then
	usage
	exit 1
fi

#echo "ACTION			$ACTION"
#echo "CONNECTION_STRING	$CONNECTION_STRING"
#echo "KEY_PASS_PROMPT		$KEY_PASS_PROMPT"
#echo "KEY_COMMENT		$KEY_COMMENT"
#echo "KEY_BITS		$KEY_BITS"
#echo "KEY_TYPE		$KEY_TYPE"
#echo "KEY_PATH_SHOW		$KEY_PATH_SHOW"


# Warn if the requested key length is <= the minimum
if [ $KEY_BITS -lt $KEY_MIN_LENGH ]; then
	echo -e "$COLOUR_RED""WARNING:$COLOUR_RST Requested key length is short! Please use key lengths greater than $KEY_MIN_RECOM bits"
fi

# Split the connection string into the domain and the username
IFS='@' read KEY_USER KEY_DOMAIN <<< "$CONNECTION_STRING"

# Only throw an error if the connection string is missing for actions that require them
if [ "$ACTION" = "create" ] || [ "$ACTION" = "remove" ]; then

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

	# Set the path of the keys
	KEY_PATH_PRIV="$KEY_PATH_DIR/$KEY_USER"
	KEY_PATH_PUB="$KEY_PATH_DIR/$KEY_USER.pub"

fi

# Set the library path
LIBRARY_PATH="$LIBRARY_PATH_ROOT/$ACTION.sh"

# Check the library exists
if [ ! -f "$LIBRARY_PATH" ]; then
	echo "ERROR: Unknown action '$ACTION'"
	exit
fi

# Include the library for handling this action
. "$LIBRARY_PATH"

echo