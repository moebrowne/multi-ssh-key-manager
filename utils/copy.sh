
# Check if the copy function is avaliable
command_exists_exit "$EXEC_COPY"

# Check the public key exists
if [ -f "$KEY_PATH_PUB" ]; then
	# Copy the public key to the clipboard

	xclip -selection c -i "$KEY_PATH_PUB"

	echo "$KEY_USER@$KEY_HOSTNAME: The public key is now on your clipboard"

else
	# Tell the user the public key cant be found
	echo "$KEY_USER@$KEY_HOSTNAME: No public key found"
fi
