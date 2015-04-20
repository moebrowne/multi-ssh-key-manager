# Defaults!
KEY_TYPE="rsa"
KEY_BITS="4096"
KEY_PASS=""
KEY_COMMENT=""
KEY_PASS_PROMPT=false

# Get any params defined
for i in "$@"
do
case $i in
        -p|--passwd)	KEY_PASS_PROMPT=true	;;
		-c|--comment)	KEY_COMMENT="${i#*=}"	;;
		-b|--bits)		KEY_BITS="${i#*=}"		;;
		-t|--type)		KEY_TYPE="${i#*=}"		;;
esac
done

# Prompt for a password if required
if [ $KEY_PASS_PROMPT = true ]; then
	read -s -p "Enter password: " KEY_PASS
	echo
fi

# Set the path the key should be written to
KEY_PATH_DIR="/home/$USERNAME/.ssh/$KEY_TYPE/$KEY_DOMAIN" #Must be an absolute path!

# Set the path of the key its self
KEY_PATH_KEY="$KEY_PATH_DIR/$KEY_USER"

# Create the directory to store the key in if it doesn't already
if [ ! -d "$KEY_PATH_DIR" ]; then
	echo "Creating key directory: $KEY_PATH_DIR"
	mkdir -p "$KEY_PATH_DIR"
fi

# Set the permissions of the key directory
chmod 0700 "$KEY_PATH_DIR"

# Write the key
echo "Writing a $KEY_BITS bit $KEY_TYPE key to: $KEY_PATH_KEY"
ssh-keygen -t "$KEY_TYPE" -b "$KEY_BITS" -C "$KEY_COMMENT" -f "$KEY_PATH_KEY" -N "$KEY_PASS"

# Set the permissions of the key
chmod 0600 "$KEY_PATH_KEY"

# Check the key was created
if [ ! -f "$KEY_PATH_KEY" ]; then
	echo "ERROR: Something went wrong, key not created"
else
	echo "Key written successfully"
fi