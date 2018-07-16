#!/bin/bash

rm -rf /var/www/srv/sessions/*

MYSQL_CONFIG="etc/my.cnf"

if [ -f "$MYSQL_CONFIG" ]
then
	echo "Link my.cnf..."
	ln -s /var/www/srv/etc/my.cnf /etc/mysql/conf.d/my.cnf
fi

chown -R mysql:mysql /var/lib/mysql
service mysql start

PHP_CONFIG="etc/php.ini"

if [ -f "$PHP_CONFIG" ]
then
	echo "Link php.ini..."
	ln -s /var/www/srv/etc/php.ini /etc/php/7.0/apache2/conf.d/90-my.ini
fi

APACHE2_CONFIG="etc/apache2.conf"

if [ -f "$APACHE2_CONFIG" ]
then
	echo "Link apache2..."
	ln -s /var/www/srv/etc/apache2.conf /etc/apache2/sites-enabled/custom.conf
fi

service apache2 start

DB_CONFIG="db/db.txt"

if [ -f "$DB_CONFIG" ]
then
	echo "Import database..."
	IFS="="
	while read name value
	do
		# Check value for sanity?  Name too?
		eval $name="$value";
	done < $DB_CONFIG

	mysql -e "DROP DATABASE IF EXISTS $dbname"
	mysql -e "CREATE DATABASE $dbname; CREATE USER '$login'@'%' IDENTIFIED BY '$password'; GRANT ALL PRIVILEGES ON $dbname . * TO '$login'@'%';"
	{ echo "SET FOREIGN_KEY_CHECKS=0; USE $dbname;" ; cat db/db.sql ; echo "SET FOREIGN_KEY_CHECKS=1;" ; } | mysql
fi

/usr/bin/env $(which mailcatcher) --ip=0.0.0.0

MSMTP_CONFIG="etc/msmtprc"

if [ -f "$MSMTP_CONFIG" ]
then
	echo "Link msmtprc..."
	ln -s /var/www/srv/etc/msmtprc /etc/msmtprc
fi
