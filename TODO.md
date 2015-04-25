
Improvements:

- Add an optional logfile output
- Add a revoke method to delete keys
	- Optionally remove from server
- Add an authorise method
	- Copy keys to a server using `ssh-copy-id`
- Add a renew method
- Add check for password protected keys when trying to list keys
- Add a check/repair method with 2 modes:
	- Check: See if permissions & ownership are correct
	- Repair: Reset permissions & ownership where incorrect
- Add a finger print action
- Add a confirm password
