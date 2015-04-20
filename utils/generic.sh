command_exists () {
    if [ -x "$1" ]; then
    	return 1
	else
		return 0
	fi
}
