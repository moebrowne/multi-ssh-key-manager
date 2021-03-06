command_exists () {
    if [ `which "$1"` ]; then
    	return 0
	else
		return 1
	fi
}

command_exists_exit () {
	if ! command_exists $1; then
		echo "ERROR: $1 can't be found"
		exit
	fi
}
usage () {
  echo "Usage: $0 [create|list|remove|authorise|fingerprint|copy] user@hostname [-p|--paths] [-c|--comment [key_comment]] [-d|--remove-with [delete_function]] [-t [key_type]] [-b|--bits [key_length]]" >&2
  exit 0
}
