# Multi SSH Key Manager

This tool intends to simplify creation, storage, removal and instillation of per user per domain SSH keys.

## Create

Create a new key or replace an existing one.

#### Example

    ./ssh-manager.sh create foo@bar.com

#### Parameters

The following optional parameters are available
The parameter defaults are in the []:

    -p|--password	Whether the key should use a pass phrase, it will be prompted for [false]
    -c|--comment	A plain text comment to be included in the key []
    -b|--bits		The bit size of the key [4096]
    -t|--type		The type of key to create [rsa]

## List

List all the current keys

#### Example

    ./ssh-manager.sh list

#### Parameters

The following optional parameters are available
The parameter defaults are in the []:

    --paths		Show the paths of the key files [false]


## Remove

Remove a users key files

#### Example

    ./ssh-manager.sh remove foo@bar.com
