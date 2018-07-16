#!/bin/bash

IFS="="
while read name value
do
        # Check value for sanity?  Name too?
    eval $name="$value";
done < db/db.txt
#echo $dbname;
#echo $login;
#echo $password;

mysqldump $dbname > db/dump.sql

service mysql stop
service apache2 stop