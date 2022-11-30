#!/bin/bash

read -p 'CA Root Certificate: ' caroot
read -p 'CA Private Key: ' capriv
read -p 'Client Cert Signing Request: ' clientcsr
read -p 'Client Certificate: ' clientcert

#sign client certificate
openssl x509 -req -in $clientcsr -CA $caroot -set_serial 0x001 -sha256 -CAkey $capriv -days 365 -extfile ClientSign.txt -out $clientcert

exit
