#!/bin/sh
echo "starting db backup"
date=$(date '+%Y-%m-%d')
hour=$(date '+%T')

if ! [ -d "backup" ]
then
        sudo mkdir -m777 backup
fi
dbbackup="backup/mydb${date}${hour}.sql"

sudo mysqldump -u admin -p verticalDB --no-tablespaces > ${dbbackup}
echo "db backup complete"
dumpsize=$(stat -c%s "$dbbackup")

if [ -e history.csv ]
then
        #printf '%s\n' $date $hour ${dumpsize} bytes | paste -sd ',' >> history.csv
        sudo sh -c "echo '$date','$hour','${dumpsize}' bytes >> history.csv"
else
        sudo sh -c "echo DATA,ORA,DumpSize >> history.csv"
        sudo sh -c "echo '$date','$hour','${dumpsize}' bytes >> history.csv"
        #printf '%s\n' DATA ORA DumpSize | paste -sd ',' >> history.csv
        #printf '%s\n' $date $hour ${dumpsize} bytes | paste -sd ',' >> history.csv
fi
aws s3 cp "$dbbackup" s3://vertical05302022/backup/
