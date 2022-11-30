#!/bin/bash

read -sp 'Password: ' password
read -p 'CA Root Certificate: ' caroot
read -p 'CA Private Key: ' capriv

#private key creation/certificate creation
openssl genpkey -outform pem -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -aes-128-cbc -pass pass:$password -out $capriv
openssl req -new -x509 -outform pem -sha256 -set_serial 0xA -key $capriv -days 365 -out $caroot

exit
