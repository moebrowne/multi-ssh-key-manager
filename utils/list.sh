
# Check if openssl is avaliable
if ! command_exists "$EXEC_OPENSSL"; then
	echo "ERROR: openssl can't be found [$EXEC_OPENSSL]"
	exit
fi

# Define an array of users to make sure we can separate pub and private keys
declare -A userArray

#Define regex rules
regexKeyComment="^ssh-rsa .+ (.+)$"
regexKeyLength="([0-9]+) bit"
regexKeyFile='^([^\.]+)(.pub)?$'

# Get all the key types
KEY_TYPES=`find $KEY_PATH_ROOT/ -mindepth 1 -maxdepth 1 -type d -printf "%f\n"`

# Output the table headers
echo -e "Type\033[10GLength\033[24GUser\033[40GDomain\033[66GFlags\033[79GComment"

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
		KEY_USERS=`find $keydomainpath/ -mindepth 1 -maxdepth 1 -type f -printf "%f\n"`

		# Loop through each key file we could finds
		for keyfile in $KEY_USERS; do

			# Get the user name from this key
			[[ $keyfile =~ $regexKeyFile ]]
			keyUsername="${BASH_REMATCH[1]}"

			# Check if we have already displayed the key for this user
			if [ "${userArray[$keyUsername]}" = true ]; then
				continue
			fi

			# Add this user to the array of users weve already proccessed
			userArray[$keyUsername]=true

			# Set the paths for the pub and private keys
			keyPathPub="$keydomainpath/$keyUsername.pub"
			keyPathPriv="$keydomainpath/$keyUsername"

			# Resets
			keylength="????"
			keyflags=""
			keycomment=""

			# Check if the public key can be found
			if [ -f "$keyPathPub" ]; then

				# Get the comment from the key
				[[ `cat "$keyPathPub"` =~ $regexKeyComment ]]
				keycomment="${BASH_REMATCH[1]}"

				keyflags="$keyflags[PUB] "
			else
				keyflags="$keyflags[$COLOUR_RED""NO PUB$COLOUR_RST] "
			fi

			# Check if the private key can be found
			if [ -f "$keyPathPriv" ]; then

				# Get Key length
				[[ `$EXEC_OPENSSL $keytype -in "$keyPathPriv" -text -noout` =~ $regexKeyLength ]]
				keylength="${BASH_REMATCH[1]}"

				# Check if the key is of a proper length
				if [[ $keylength -lt "$KEY_MIN_LENGH" ]] || [[ $keylength -eq "$KEY_MIN_LENGH" ]]; then
					keylength="$COLOUR_RED_BAK$keylength bit$COLOUR_RST"
				else
					keylength="$COLOUR_YEL$keylength bit$COLOUR_RST"
				fi

				keyflags="$keyflags[PRIV] "
			else
				keyflags="$keyflags[$COLOUR_RED""NO PRIV$COLOUR_RST] "
			fi

			# Check if we should show the keys path
			if [ $KEY_PATH_SHOW = true ]; then
				keypathcomment=" => $keyPathPriv"
			fi

			# Show the information
			echo -e "${keytype^^}\033[10G$keylength\033[24G$COLOUR_CYN$keyUsername$COLOUR_RST\033[40G$COLOUR_PUR$keydomain$COLOUR_RST\033[66G$keyflags\033[79G$COLOUR_GRY$keycomment$COLOUR_RST	$keypathcomment"
		done
	done
done

