
# Check the key exists
if [ -f "$KEY_PATH_KEY" ]; then
	# Remove the key
	rm "$KEY_PATH_KEY"

	# Tell the user the key has been removed
	echo "The key for $KEY_USER@$KEY_DOMAIN has been removed"
else
	# Tell the user the key cant be removed
	echo "$KEY_USER@$KEY_DOMAIN doesn't have a key..."
fi