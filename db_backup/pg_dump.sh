#!/bin/bash

DB_USER='mitsubosh'
#DB_PASS=''
DB_HOST='localhost'

PERIOD=7

BACKUP_PATH='/backup/postgres'
DATETIME=`date '+%Y%m%d-%H:%M:%S'`
FILENAME=pg_$DATETIME.dump.gz

if [ -d $BACKUP_PATH ]; then
  echo "${BACKUP_PATH} is present"
else
  echo "${BACKUP_PATH} is not present"
  mkdir -p $BACKUP_PATH
  chmod -R 700 $BACKUP_PATH 
  chown -R root $BACKUP_PATH
fi

echo 'starting backup...'
cd $BACKUP_PATH
pg_dumpall -U $DB_USER -h $DB_HOST --clean --if-exists | gzip > $FILENAME
chmod 700 $FILENAME
chown root $FILENAME
echo 'ended backup'

if [ `ls -lt $BACKUP_PATH | wc -l` -gt $PERIOD ]; then
  echo 'starting cleanup...'
  find $BACKUP_PATH -name 'pg_*.dump.gz' | sort -nr | tail -n+7 | xargs -IFILE rm FILE
  echo 'ended cleanup'
fi
