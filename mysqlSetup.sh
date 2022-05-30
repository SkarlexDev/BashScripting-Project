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
if [ $(echo "SELECT COUNT(*) FROM mysql.user WHERE user = 'admin'" | mysql | tail -n1) -gt 0 ]
then
echo "User exists"
else
echo "Creating new user"
mysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY '1234';"
fi
mysql -e "SELECT User, Host FROM mysql.user;"
mysql < createDB.sql
echo "#######################################"
mysql -e "show databases;use $DB; show tables;"
echo "Installing awscli..."
sudo apt-get install awscli -y

echo "Creating cronjob to run every hour"
cat <(crontab -l) <(echo "0 * * * * /etc/scripts/backup.sh") | crontab -
crontab -l
