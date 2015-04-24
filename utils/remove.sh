
# Check the private key exists
if [ -f "$KEY_PATH_PRIV" ]; then
	# Remove the keys
	shred -zu "$KEY_PATH_PRIV"

	# Tell the user the private key has been removed
	echo "$KEY_USER@$KEY_DOMAIN: Removed the private key"
else
	# Tell the user the private key cant be removed
	echo "$KEY_USER@$KEY_DOMAIN: No private key found"
fi

# Check the public key exists
if [ -f "$KEY_PATH_PUB" ]; then
	# Remove the key
	shred -zu "$KEY_PATH_PUB"

	# Tell the user the private key has been removed
	echo "$KEY_USER@$KEY_DOMAIN: Removed the public key"
else
	# Tell the user the private key cant be removed
	echo "$KEY_USER@$KEY_DOMAIN: No public key found"
fi