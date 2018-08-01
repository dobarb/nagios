#!/bin/bash
# Author: Dorin Barboiu
# Email: dorinbarboiu@gmail.com

#Install fependecies 
echo "Installing dependencies ...."
yum install httpd php  gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel xinetd unzip -y
sts=$?
if [ $sts -ne 0 ]; then
	echo "ERROR: Cannot install dependencies. Exiting ..."
	exit 1
else
	echo "Dependencies were installed."
fi
#Adding Nagios user
echo "Creating Nagios user and groupe "
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios

#Install Nagios Core 4.3.1
echo "Install Nagios Core 4.3.1"
curl -L -O https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.1.tar.gz
sts=$?
if [ $sts -ne 0 ]; then
        echo "ERROR: Cannot download Nagios Core. Exiting ..."
        exit 1
else
        echo "Nagios Core was downloaded. Installing it ..."
	tar xvf nagios-*.tar.gz
	cd nagios-*
	./configure --with-command-group=nagcmd
	make all && make install 
	make install-commandmode
	make install-init
	make install-config	
	make install-webconf
	cd ~
fi
sudo usermod -G nagcmd apache
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
echo "Nagios is up and running.You shoud install Nagios plugins to be able to monitor the remote hosts"
