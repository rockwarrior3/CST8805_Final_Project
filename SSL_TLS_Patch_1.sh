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
echo "<IfModule mod_ssl.c>
	<VirtualHost _default_:443>
		ServerAdmin webmaster@localhost

		DocumentRoot /var/www/html
		ServerName www.heistsless
		ServerAlias www.heistsless.com

		# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
		# error, crit, alert, emerg.
		# It is also possible to configure the loglevel for particular
		# modules, e.g.
		#LogLevel info ssl:warn

		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined

		# For most configuration files from conf-available/, which are
		# enabled or disabled at a global level, it is possible to
		# include a line for only one particular virtual host. For example the
		# following line enables the CGI configuration for this host only
		# after it has been globally disabled with "a2disconf".
		#Include conf-available/serve-cgi-bin.conf

		#   SSL Engine Switch:
		#   Enable/Disable SSL for this virtual host.
		SSLEngine on

		#   A self-signed (snakeoil) certificate can be created by installing
		#   the ssl-cert package. See
		#   /usr/share/doc/apache2/README.Debian.gz for more info.
		#   If both key and certificate are stored in the same file, only the
		#   SSLCertificateFile directive is needed.
		SSLCertificateFile	/home/student/CST8805_Final_Project-main/CST8805_files/PleaseDontHackMe/WebServer.cer
		SSLCertificateKeyFile /home/student/CST8805_Final_Project-main/CST8805_files/PleaseDontHackMe/WebServer-Priv.key

		#   Server Certificate Chain:
		#   Point SSLCertificateChainFile at a file containing the
		#   concatenation of PEM encoded CA certificates which form the
		#   certificate chain for the server certificate. Alternatively
		#   the referenced file can be the same as SSLCertificateFile
		#   when the CA certificates are directly appended to the server
		#   certificate for convinience.
		#SSLCertificateChainFile /etc/apache2/ssl.crt/server-ca.crt

		#   Certificate Authority (CA):
		#   Set the CA certificate verification path where to find CA
		#   certificates for client authentication or alternatively one
		#   huge file containing all of them (file must be PEM encoded)
		#   Note: Inside SSLCACertificatePath you need hash symlinks
		#		 to point to the certificate files. Use the provided
		#		 Makefile to update the hash symlinks after changes.
		#SSLCACertificatePath /etc/ssl/certs/
		#SSLCACertificateFile /etc/apache2/ssl.crt/ca-bundle.crt

		#   Certificate Revocation Lists (CRL):
		#   Set the CA revocation path where to find CA CRLs for client
		#   authentication or alternatively one huge file containing all
		#   of them (file must be PEM encoded)
		#   Note: Inside SSLCARevocationPath you need hash symlinks
		#		 to point to the certificate files. Use the provided
		#		 Makefile to update the hash symlinks after changes.
		#SSLCARevocationPath /etc/apache2/ssl.crl/
		#SSLCARevocationFile /etc/apache2/ssl.crl/ca-bundle.crl

		#   Client Authentication (Type):
		#   Client certificate verification type and depth.  Types are
		#   none, optional, require and optional_no_ca.  Depth is a
		#   number which specifies how deeply to verify the certificate
		#   issuer chain before deciding the certificate is not valid.
		#SSLVerifyClient require
		#SSLVerifyDepth  10

		#   SSL Engine Options:
		#   Set various options for the SSL engine.
		#   o FakeBasicAuth:
		#	 Translate the client X.509 into a Basic Authorisation.  This means that
		#	 the standard Auth/DBMAuth methods can be used for access control.  The
		#	 user name is the `one line' version of the client's X.509 certificate.
		#	 Note that no password is obtained from the user. Every entry in the user
		#	 file needs this password: `xxj31ZMTZzkVA'.
		#   o ExportCertData:
		#	 This exports two additional environment variables: SSL_CLIENT_CERT and
		#	 SSL_SERVER_CERT. These contain the PEM-encoded certificates of the
		#	 server (always existing) and the client (only existing when client
		#	 authentication is used). This can be used to import the certificates
		#	 into CGI scripts.
		#   o StdEnvVars:
		#	 This exports the standard SSL/TLS related `SSL_*' environment variables.
		#	 Per default this exportation is switched off for performance reasons,
		#	 because the extraction step is an expensive operation and is usually
		#	 useless for serving static content. So one usually enables the
		#	 exportation for CGI and SSI requests only.
		#   o OptRenegotiate:
		#	 This enables optimized SSL connection renegotiation handling when SSL
		#	 directives are used in per-directory context.
		#SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
		<FilesMatch "\.(cgi|shtml|phtml|php)$">
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>

		#   SSL Protocol Adjustments:
		#   The safe and default but still SSL/TLS standard compliant shutdown
		#   approach is that mod_ssl sends the close notify alert but doesn't wait for
		#   the close notify alert from client. When you need a different shutdown
		#   approach you can use one of the following variables:
		#   o ssl-unclean-shutdown:
		#	 This forces an unclean shutdown when the connection is closed, i.e. no
		#	 SSL close notify alert is send or allowed to received.  This violates
		#	 the SSL/TLS standard but is needed for some brain-dead browsers. Use
		#	 this when you receive I/O errors because of the standard approach where
		#	 mod_ssl sends the close notify alert.
		#   o ssl-accurate-shutdown:
		#	 This forces an accurate shutdown when the connection is closed, i.e. a
		#	 SSL close notify alert is send and mod_ssl waits for the close notify
		#	 alert of the client. This is 100% SSL/TLS standard compliant, but in
		#	 practice often causes hanging connections with brain-dead browsers. Use
		#	 this only for browsers where you know that their SSL implementation
		#	 works correctly.
		#   Notice: Most problems of broken clients are also related to the HTTP
		#   keep-alive facility, so you usually additionally want to disable
		#   keep-alive for those clients, too. Use variable "nokeepalive" for this.
		#   Similarly, one has to force some clients to use HTTP/1.0 to workaround
		#   their broken HTTP/1.1 implementation. Use variables "downgrade-1.0" and
		#   "force-response-1.0" for this.
		# BrowserMatch "MSIE [2-6]" \
		#		nokeepalive ssl-unclean-shutdown \
		#		downgrade-1.0 force-response-1.0

	</VirtualHost>
</IfModule>

syntax=apache ts=4 sw=4 sts=4 sr noet" >> /home/student/default-ssl.conf

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

syntax=apache ts=4 sw=4 sts=4 sr noet" >> /home/student/000-default.conf

sudo chmod 644 /home/student/000-default.conf
sudo chown root:root /home/student/000-default.conf
sudo rm /etc/apache2/sites-available/000-default.conf
sudo mv /home/student/000-default.conf /etc/apache2/sites-available

sudo a2enmod ssl
sudo a2enmod headers
sudo a2enconf ssl-paramas.conf
sudo a2ensite default-ssl
sudo systemctl restart apache2
