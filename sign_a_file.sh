#!/bin/bash
read -p 'private key:  ' priv_key
read -p 'public key:  ' pub_key
read -p 'file to encrypt:  ' fencrypt
read -p 'output file name:  ' signed
openssl dgst -sha256 -sign $priv_key -out $signed $fencrypt
openssl dgst -sha256 -verify $pub_key -signature $signed $fencrypt
