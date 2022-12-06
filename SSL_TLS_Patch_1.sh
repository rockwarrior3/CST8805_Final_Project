#!/bin/bash 

#create and write to file
touch /home/student/ssl-paramas.conf
printf 'SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH\nSSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1\nSSLHonorCipherOrder On\n# Disable preloading HSTS for now.  You can use the commented out header line that includes\n# the "preload" directive if you understand the implications.\n# Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"\nHeader always set X-Frame-Options DENY\nHeader always set X-Content-Type-Options nosniff\n# Requires Apache >= 2.4\nSSLCompression off\nSSLUseStapling on\nSSLStaplingCache "shmcb:logs/stapling-cache(150000)"\n# Requires Apache >= 2.4.11\nSSLSessionTickets Off' >> /home/student/ssl-paramas.conf

#change permisions 
sudo chmod 644 /home/student/ssl-paramas.conf
sudo chown root:root /home/student/ssl-paramas.conf

#move conf file to apache2 directory 
sudo cp /home/student/ssl-paramas.conf /etc/apache2/sites-available/ssl-paramas.conf
sudo mv /home/student/ssl-paramas.conf /etc/apache2/conf-available/ssl-paramas.conf

#modify default-ssl.conf
touch /home/student/default-ssl.conf
#use file
sudo chmod 644 /home/student/default-ssl.conf
sudo chown root:root /home/student/default-ssl.conf
sudo rm /etc/apache2/sites-available/default-ssl.conf
sudo mv /home/student/default-ssl.conf /etc/apache2/sites-available
#modify 000-default.conf
touch /home/student/000-default.conf
echo "<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html
	ServerName www.heistsless
	ServerAlias	www.heistsless.com
	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn
	Redirect "/" "https://www.heistsless/"
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>
# vim: syntax=apache ts=4 sw=4 sts=4 sr noet" >> /home/student/000-default.conf
sudo chmod 644 /home/student/000-default.conf
sudo chown root:root /home/student/000-default.conf
sudo rm /etc/apache2/sites-available/000-default.conf
sudo mv /home/student/000-default.conf /etc/apache2/sites-available
sudo a2enmod ssl
sudo a2enmod headers
sudo a2enconf ssl-paramas.conf
sudo a2ensite default-ssl
sudo systemctl restart apache2
