# Multi SSH Key Manager

This tool intends to simplify creation, storage, removal and installation of per user per hostname SSH keys.

The only setup required is to add the following to the top of your SSH config `~/.ssh/config`

    Host *
    IdentityFile ~/.ssh/rsa/%h/%r

## Create A New Key

To create a new key or replace an existing one use the following:

    ./ssh-manager.sh create foo@bar.com

There are a couple of additional parameters create can take:

    -p|--password	Whether the key should use a pass phrase, it will be prompted for (default: false)
    -c|--comment	A plain text comment to be included in the key
    -b|--bits		The bit size of the key (default: 4096)
    -t|--type		The type of key to create (default: rsa)


## List All Your Keys

To list all the keys we're currently tracking use:

    ./ssh-manager.sh list

If you want to also see the absolute paths to the keys use `--paths`

## Remove A Key

To remove a key you can use:

    ./ssh-manager.sh remove foo@bar.com

There are a couple of options for how to remove the key.
The default is to use `shred` that will securely delete the key but there are other options, use the `-d` or `--remove-with` flag with one of the following values:

- `rm`
- `shred`
- `shred100`


## Authorise A Key

Use authorise to copy one of your public keys to the server:

    ./ssh-manager.sh authorise foo@bar.com

## Fingerprint

Get the finger print of a public key by using:

    ./ssh-manager.sh fingerprint foo@bar.com

## Copy

Copies a users public key to the XClipboard so it can be easily pasted somewhere, for example GitHub.

    ./ssh-manager.sh copy foo@bar.com
