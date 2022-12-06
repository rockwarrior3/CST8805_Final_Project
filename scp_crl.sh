#!/bin/bash

read -p 'IP address: ' ipadd

#scp crl from pki server to web server
scp CACRL.crl.pem student@$ipadd:/home/student/CST8805_Final_Project/CST8805_files/PleaseDontHackMe

exit