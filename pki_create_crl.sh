#!/bin/bash

read -p 'CA Private Key: ' capriv
read -p 'CA Root Certificate: ' caroot
read -p 'CA crl: ' cacrl

#generate CRL
openssl ca -config openssl.cnf -gencrl -keyfile $capriv -cert $caroot -out $cacrl

exit