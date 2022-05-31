#!/bin/bash
##############Variables#############
DB="verticalDB"
echo "#######################################"
echo "Checking for updates..."
sudo apt-get update
echo "#######################################"
echo "Install mysql-server"
sudo apt-get install mysql-server -y
echo "#######################################"
MYSQLSERVICE=`systemctl is-active mysql`
echo "Mysql service is: $MYSQLSERVICE"
echo "#######################################"
mysql < createDB.sql

if [ $(echo "SELECT COUNT(*) FROM mysql.user WHERE user = 'admin'" | mysql | tail -n1) -gt 0 ]
then
        echo "User exists"
else
        echo "Creating new user"
        mysql < createuser.sql
fi

echo "#######################################"
mysql -e "show databases;use $DB; show tables;"
mysql -e "SELECT User, Host FROM mysql.user;"
echo "Installing awscli..."
sudo apt-get install awscli -y

#echo "Creating cronjob to run every hour"

#cat <(crontab -l) <(echo "*/1 * * * * su ubuntu -c /etc/scripts/backup.sh") | crontab -
#crontab -l
