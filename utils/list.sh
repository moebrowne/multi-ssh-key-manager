
# Check if openssl is avaliable
if ! command_exists "$EXEC_OPENSSL"; then
	echo "ERROR: openssl can't be found [$EXEC_OPENSSL]"
	exit
fi

# Get all the key types
KEY_TYPES=`find $KEY_PATH_ROOT/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n"`

# Loop through all the key types
for keytype in $KEY_TYPES; do

	# Set the path to this type of key
	keytypepath="$KEY_PATH_ROOT/$keytype"

	# Find all the domains with a key of this type
	KEY_DOMAINS=`find $keytypepath/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n"`

	# Loop through each domain
	for keydomain in $KEY_DOMAINS; do

		# Set the path to the key files for this domain
		keydomainpath="$keytypepath/$keydomain"

		# Get all the keys for this domain
		KEY_USERS=`find $keydomainpath/ -mindepth 1 -maxdepth 1 -type f ! -name \*.pub -printf "%f\n"`

		# Loop through each key file we could find
		for keyuser in $KEY_USERS; do

			# Get the comment from the key
			regexKeyComment="^ssh-rsa .+ (.+)$"
			[[ `cat "$KEY_PATH_ROOT/$keytype/$keydomain/$keyuser.pub"` =~ $regexKeyComment ]]
			keycomment="${BASH_REMATCH[1]}"

			# If the key has a comment enclose it in brackets
			if [ "$keycomment" != "" ]; then
				keycomment=" ($keycomment)"
			fi

			# Get Key length
			keylength=$($EXEC_OPENSSL rsa -in "$keydomainpath/$keyuser" -text -noout | grep -oE "[0-9]+ bit")

			# Show the information
			echo "${keytype^^} [$keylength]: $keyuser@$keydomain$keycomment"
		done
	done
done

