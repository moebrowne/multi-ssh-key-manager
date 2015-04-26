
# Check if ssh-copy-id is avaliable
command_exists_exit "$EXEC_COPYID"

# Copy the key
ssh-copy-id -i "$KEY_PATH_PUB" "$KEY_USER@$KEY_HOSTNAME" 2&>1 /dev/null
