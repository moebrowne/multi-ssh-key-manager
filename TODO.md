
Improvements:

- Add an optional logfile output
- Add a revoke method to delete keys
	- Optionally remove from server
- Add a renew method
- Add check for password protected keys when trying to list keys
- Add a check/repair method with 2 modes:
	- Check: See if permissions & ownership are correct
	- Repair: Reset permissions & ownership where incorrect
- Add a numeric index to each key in list and allow the other commands to accept `#<INDEX>` rather than having to write out the full address each time
