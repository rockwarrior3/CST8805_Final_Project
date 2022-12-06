#!/bin/bash
#private key creation/certificate creation
mkdir CST8805_files
openssl genpkey -outform pem -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -aes-256-cbc -pass pass:CyB@ter123 -out CA_Priv.key
clear
echo CA stuff
echo CA
echo ON
echo Ottawa
echo bankca.co
echo bankcasigners
echo www.wesignstuffforyou.com
echo notapplicable@realemailservice.com
openssl req -new -x509 -outform pem -sha3-256 -set_serial 0xA -key CA_Priv.key -days 1095 -out CA_Root.cer

#generate CRL
openssl ca -config openssl.cnf -gencrl -keyfile CA_Priv.key -cert CA_Root.cer -out CA_CRL.crl.pem

#generate Web servers keys and cert
openssl genpkey -outform pem -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -aes-256-cbc -pass pass:CyB@ter123 -out Web_Priv.key
clear
echo web server stuff
echo CA
echo ON
echo Ottawa
echo heistless
echo heistlessbank
echo www.heistless.com
echo pleasedontrobus@verysecureemail.com
openssl req -new -outform pem -key Web_Priv.key -out Web.csr
openssl x509 -req -in Web.csr -CA CA_Root.cer -set_serial 0x200 -sha3-256 -CAkey CA_Priv.key -days 365 -extfile WebSrv.txt -out Web.cer
openssl x509 -inform pem -in Web.cer -pubkey -out Web_Pub.key

# transfer Web server's stuff into folder

mkdir PleaseDontHackMe
mv Web_Priv.key PleaseDontHackMe
mv Web.csr PleaseDontHackMe
mv Web.cer PleaseDontHackMe
mv Web_Pub.key PleaseDontHackMe
mv PleaseDontHackMe CST8805_files

#generate Clients keys and cert
openssl genpkey -outform pem -algorithm rsa -pkeyopt rsa_keygen_bits:2048 -aes-256-cbc -pass pass:CyB@ter123 -out Client_Priv.key
openssl req -new -outform pem -key Client_Priv.key -out Client.csr
openssl x509 -req -in Client.csr -CA CA_Root.cer -set_serial 0x300 -sha3-256 -CAkey CA_Priv.key -days 365 -extfile UserSign.txt -out Client.cer
openssl x509 -inform pem -in Client.cer -pubkey -out Client_Pub.key

# transfer client's stuff into folder
mkdir clienttemp 
mv Client_Priv.key clienttemp 
mv Client.csr clienttemp 
mv Client.cer clienttemp 
mv Client_Pub.key clienttemp 

#transfer pki's stuff into folder
mkdir notpkiserver
mv CA_Priv.key notpkiserver
mv CA_Root.cer notpkiserver
mv CA_CRL.crl.pem notpkiserver
