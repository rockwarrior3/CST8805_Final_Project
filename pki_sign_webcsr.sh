#!/bin/bash

read -p 'CA Root Certificate: ' caroot
read -p 'CA Private Key: ' capriv
read -p 'Web Cert Signing Request: ' webcsr
read -p 'Web Server Certificate: ' webcert

#sign web certificate
openssl x509 -req -in $webcsr -CA $caroot -set_serial 0x002 -sha256 -CAkey $capriv -days 365 -extfile WebSign.txt -out $webcert

exit