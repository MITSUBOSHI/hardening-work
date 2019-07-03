DB_USER='root'
#DB_PASS=''
DB_HOST='localhost'

PERIOD=7

BACKUP_PATH='/backup/mysql'

if [ $# != 1 ]; then
  echo "wrong number of arguments"
  echo "pass the target file name"
  exit 1
fi

cd $BACKUP_PATH

if [ -f $1 ]; then
  echo "starting restore..."
  # zcat $1 | mysql -u$DB_USER -p $DB_PASS -h $DB_HOST
  zcat $1 | mysql -u$DB_USER -h $DB_HOST
  echo "ended restore"
else
  echo "cannot find the target file"
  exit 1
fi
