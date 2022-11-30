#!/bin/bash

read -p 'Client Cert to Revoke: ' clientcert
read -p 'CA Priv Key: ' capriv
read -p 'CA Cert: ' cacert
read -p 'CA Crl: ' cacrl

openssl ca -config openssl.cnf -revoke $clientcert -keyfile $capriv -cert $cacert
openssl ca -config openssl.cnf -gencrl -keyfile $capriv -cert $cacert -out $cacrl

exit