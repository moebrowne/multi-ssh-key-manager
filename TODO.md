
Improvements:

- Show a warning if the requested key length is <= 1024
- Add an optional logfile output
- Add a revoke method to delete keys
	- Use `shred`, if available
	- Optionally remove from server
- Add an authorise method
	- Copy keys to a server using `ssh-copy-id`
- Add a renew method
- Add check for password protected keys when trying to list keys
