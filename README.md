# Multi SSH Key Manager

This tool intends to simplify creation, storage, removal and instillation of per user per domain SSH keys

## Usage

The SSH Key Manager is called in the following way

    ./ssh-manager.sh {ACTION} username@domain

## Actions

The following actions are available

### Create

Create a new key or replace an existing one

#### Parameters

The following optional parameters are available
The parameter defaults are in the []:

    -p|--password	Whether the key should use a pass phrase, it will be prompted for [false]
    -c|--comment	A plain text comment to be included in the key []
    -b|--bits)		The bit size of the key [4096]
    -t|--type)		The type of key to create [rsa]