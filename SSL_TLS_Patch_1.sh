#!/bin/bash 
echo moding files
cp -r done_rob_pki_script_v1/CST8805_Final_Project/CST8805_files/ .
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

#sudo chmod 644 ssl.conf
#sudo chown root:root ssl.conf
#sudo rm /etc/apache2/mods-enabled/ssl.conf
#sudo mv ssl.conf /etc/apache2/mods-enabled/
sudo mv /home/student/CST8805_Final_Project/CST8805_files/PleaseDontHackMe /var/www/html/
sudo mv /var/www/html/PleaseDontHackMe /var/www/html/server_files

sudo chmod 644 upload.php
sudo chmod 644 upload.html
sudo rm /var/www/html/upload.html
sudo rm /var/www/html/upload.php
sudo mv upload.php /var/www/html/
sudo mv upload.html /var/www/html/

sudo cp /home/student/CST8805_Final_Project/CST8805_files/notpkiserver/CA_Root.cer /var/www/html/server_files

echo done now starting services

sudo a2enmod ssl
sudo a2enmod headers
sudo a2enconf ssl-params
sudo a2ensite default-ssl
sudo systemctl restart apache2
