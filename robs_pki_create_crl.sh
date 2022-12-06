
#!/bin/bash
#generate CRL
openssl ca -config openssl.cnf -gencrl -keyfile capriv.key -cert caroot.cer  -out CACRL.crl.pem

exit
