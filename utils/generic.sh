command_exists () {
    if [ -x "$1" ]; then
    	return 0
	else
		return 1
	fi
}

usage () {
  echo "Usage: $0 [create|list|remove] user@hostname [-p|--paths] [-c|--comment [key_comment]] [-d|--remove-with [delete_function]] [-t [key_type]] [-b|--bits [key_length]]" >&2
  exit 1
}
