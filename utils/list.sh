
# Get all the key types
KEY_TYPES=`find $KEY_PATH_ROOT/ -mindepth 1 -maxdepth 1 -type d`

# Loop through all the key types
for keytype in $KEY_TYPES; do

	# Replace the path name in the key type
	keytype=${keytype/$KEY_PATH_ROOT\//}

	# Set the path to this type of key
	keytypepath="$KEY_PATH_ROOT/$keytype"

	# Set the key type to be uppercase
	keytype="${keytype^^}"

	# Find all the domains with a key of this type
	KEY_DOMAINS=`find $keytypepath/ -mindepth 1 -maxdepth 1 -type d`

	# Loop through each domain
	for keydomain in $KEY_DOMAINS; do

		# Remove the path from the domain name
		keydomain=${keydomain/$keytypepath\//}

		# Set the path to the key files for this domain
		keydomainpath="$keytypepath/$keydomain"

		# Get all the keys for this domain
		KEY_USERS=`find $keydomainpath/ -mindepth 1 -maxdepth 1 -type f ! -name \*.pub`

		# Loop through each key file we could find
		for keyuser in $KEY_USERS; do

			# Replace the path from the key name
			keyuser=${keyuser/$keydomainpath\//}
			
			# Get Key length
			keylength=$(openssl rsa -in "$keydomainpath/$keyuser" -text -noout | grep -oE "[0-9]+ bit")

			# Show the information
			echo "$keytype: $keyuser@$keydomain [$keylength]"
		done
	done
done

