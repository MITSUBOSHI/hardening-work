#!/bin/bash

DB_USER='root'
#DB_PASS=''
DB_HOST='localhost'

PERIOD=7

BACKUP_PATH='/backup/mysql'
DATETIME=`date '+%Y%m%d-%H:%M:%S'`
FILENAME=mysql_$DATETIME.dump.gz

if [ -d $BACKUP_PATH ]; then
  echo "${BACKUP_PATH} is present"
else
  echo "${BACKUP_PATH} is not present"
  mkdir -p $BACKUP_PATH
  chmod -R 700 $BACKUP_PATH 
  chown -R root $BACKUP_PATH
fi

#mysqldump -u$DB_USER -p $DB_PASS -h $DB_HOST --all-databases | gzip > mysql_$(date '+%Y%m%d-%H:%M:%S').dump.gz
echo 'starting backup...'
cd $BACKUP_PATH
mysqldump -u$DB_USER -h $DB_HOST --all-databases | gzip > $FILENAME
chmod 700 $FILENAME
chown root $FILENAME
echo 'ended backup'

if [ `ls -lt $BACKUP_PATH | wc -l` -gt $PERIOD ]; then
  echo 'starting cleanup...'
  find $BACKUP_PATH -name 'mysql_*.dump.gz' | sort -nr | tail -n+7 | xargs -IFILE rm FILE
  echo 'ended cleanup'
fi
