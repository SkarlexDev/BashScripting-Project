#!/bin/sh
echo "starting db backup"
date=$(date '+%Y-%m-%d')
hour=$(date '+%T')

if ! [ -d "backup" ]
then
        mkdir backup
fi
dbbackup="backup/mydb${date}${hour}.sql"

mysqldump -u root verticalDB > ${dbbackup}
echo "db backup complete"
dumpsize=$(stat -c%s "$dbbackup")
if ! [ -e history.csv ]
then
        printf '%s\n' DATA ORA DumpSize | paste -sd ' ' >> history.csv
fi
        printf '%s\n' $date $hour ${dumpsize} bytes | paste -sd ' ' >> history.csv

aws s3 cp "$dbbackup" s3://vertical05302022/backup/

