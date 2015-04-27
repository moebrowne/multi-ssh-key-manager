
# Check if ssh-keygen is avaliable
command_exists_exit "$EXEC_KEYGEN"

# Check the public key exists
if [ -f "$KEY_PATH_PUB" ]; then
	# Show the keys fingerprint
	regexKeyFingerprint='^[0-9]+ ([^ ]+)'
	[[ `$EXEC_KEYGEN -lf "$KEY_PATH_PUB"` =~ $regexKeyFingerprint ]]
	KEY_FINGERPRINT="${BASH_REMATCH[1]}"

	if [ ! $KEY_FINGERPRINT_SIMPLE = true ]; then
		echo "$KEY_USER@$KEY_HOSTNAME:"
	fi
	echo "$KEY_FINGERPRINT"

else
	# Tell the user the private key cant be removed
	if [ ! $KEY_FINGERPRINT_SIMPLE = true ]; then
		echo "$KEY_USER@$KEY_HOSTNAME: No public key found"
	fi
fi