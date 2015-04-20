
KEY_TYPES=`find $KEY_PATH_ROOT/ -mindepth 1 -maxdepth 1 -type d`

for keytype in $KEY_TYPES; do
	
	keytype=${keytype/$KEY_PATH_ROOT\//}
	keytypepath="$KEY_PATH_ROOT/$keytype"

	keytype="${keytype^^}"
	
	KEY_DOMAINS=`find $keytypepath/ -mindepth 1 -maxdepth 1 -type d`
	
	for keydomain in $KEY_DOMAINS; do
		
		keydomain=${keydomain/$keytypepath\//}
		keydomainpath="$keytypepath/$keydomain"
	
		KEY_USERS=`find $keydomainpath/ -mindepth 1 -maxdepth 1 -type f ! -name \*.pub`
		for keyuser in $KEY_USERS; do

			keyuser=${keyuser/$keydomainpath\//}
			
			# Get Key length
			keylength=$(openssl rsa -in "$keydomainpath/$keyuser" -text -noout | grep -oE "[0-9]+ bit")
				
			echo "$keytype: $keyuser@$keydomain [$keylength]"
		done
	done
done

