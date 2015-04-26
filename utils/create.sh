
# Check if ssh-keygen is avaliable
command_exists_exit "ssh-keygen"

# Prompt for a password if required
if [ $KEY_PASS_PROMPT = true ]; then
	read -s -p "Enter password: " KEY_PASS
	echo
	read -s -p "Enter password again: " KEY_PASS_CONFIRM
	echo

	if [ $KEY_PASS != $KEY_PASS_CONFIRM ]; then
		echo "ERROR: Passwords don't match"
		exit
	fi

fi

# Create the directory to store the key in if it doesn't already
if [ ! -d "$KEY_PATH_DIR" ]; then
	echo "Creating key directory: $KEY_PATH_DIR"
	mkdir -p "$KEY_PATH_DIR"
fi

# Set the permissions of the key directory
chmod 0700 "$KEY_PATH_DIR"

# Write the key
echo "Writing a $KEY_BITS bit $KEY_TYPE key to: $KEY_PATH_PRIV"
$EXEC_KEYGEN -t "$KEY_TYPE" -b "$KEY_BITS" -C "$KEY_COMMENT" -f "$KEY_PATH_PRIV" -N "$KEY_PASS"

# Set the permissions of the key
chmod 0600 "$KEY_PATH_PRIV"
chmod 0644 "$KEY_PATH_PUB"

# Check the key was created
if [ ! -f "$KEY_PATH_PRIV" ]; then
	echo "ERROR: Something went wrong, key not created"
else
	echo "Key written successfully"
fi