#!/bin/bash 

sudo rm /etc/apache2/conf-available/ssl-params.conf
sudo chmod 644 ssl-paramas.conf
sudo chown root:root ssl-paramas.conf
sudo mv ssl-params.conf /etc/apache2/conf-available

sudo chmod 644 /home/student/default-ssl.conf
sudo chown root:root /home/student/default-ssl.conf
sudo rm /etc/apache2/sites-available/default-ssl.conf
sudo mv default-ssl.conf /etc/apache2/sites-available

sudo a2enmod ssl
sudo a2enmod headers
sudo a2enconf ssl-params
sudo a2ensite default-ssl
sudo systemctl restart apache2
