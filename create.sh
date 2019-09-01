#!/bin/bash

CONFIG=happy/settings.py
SITE=$1
DB="happy_$SITE"
USER="happy_$SITE"
PASSWORD=$( pwgen -s 16 )

if [ -z $SITE ];then
    echo "enter site name"
    exit
fi

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

function runmysql
{
    mysql --defaults-file=/etc/mysql/debian.cnf -e "$1"
}

echo "Create instance name $SITE"
runmysql "CREATE DATABASE $DB CHARACTER SET utf8 COLLATE utf8_general_ci;"
runmysql "CREATE USER '$USER'@'localhost' IDENTIFIED BY '$PASSWORD';"
runmysql "GRANT ALL PRIVILEGES ON $DB.* TO '$USER'@'localhost';"

echo "Setup config to $CONFIG"
sed -i "s/__DB_NAME__/$DB/" $CONFIG
sed -i "s/__DB_USER__/$USER/" $CONFIG
sed -i "s/__DB_PASSWORD__/$PASSWORD/" $CONFIG

echo "Finish"
