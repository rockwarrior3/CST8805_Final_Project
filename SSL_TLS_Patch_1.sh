#!/bin/bash 
echo moding files
sudo rm /etc/apache2/conf-available/ssl-params.conf
sudo chmod 644 ssl-params.conf
sudo chown root:root ssl-params.conf
sudo mv ssl-params.conf /etc/apache2/conf-available

sudo chmod 644 default-ssl.conf
sudo chown root:root default-ssl.conf
sudo rm /etc/apache2/sites-available/default-ssl.conf
sudo mv default-ssl.conf /etc/apache2/sites-available

sudo chmod 644 000-default.conf
sudo chown root:root 000-default.conf
sudo rm /etc/apache2/sites-available/000-default.conf
sudo mv 000-default.conf /etc/apache2/sites-available

sudo chmod 644 ssl.conf
sudo chown root:root ssl.conf
sudo rm /etc/apache2/mods-enabled/ssl.conf
sudo mv ssl.conf /etc/apache2/mods-enabled/
echo done now starting services

sudo a2enmod ssl
sudo a2enmod headers
sudo a2enconf ssl-params
sudo a2ensite default-ssl
sudo systemctl restart apache2
