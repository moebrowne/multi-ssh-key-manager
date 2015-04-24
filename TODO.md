
Improvements:

- Show a warning if the requested key length is <= 1024
- Add an optional logfile output
- Add a revoke method to delete keys
	- Use `shred` only if it's available or any other file deletion programs?
	- Optionally remove from server
- Add an authorise method
	- Copy keys to a server using `ssh-copy-id`
- Add a renew method
- Add check for password protected keys when trying to list keys
- In the list method give a message if there are no keys
- Add a check/repair method with 2 modes:
	- Check: See if permissions & ownership are correct
	- Repair: Reset permissions & ownership where incorrect
