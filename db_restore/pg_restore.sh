DB_USER='root'
#DB_USER='root'
#DB_PASS=''
DB_HOST='localhost'

BACKUP_PATH='/backup/postgres'
DATETIME=`date '+%Y%m%d-%H:%M:%S'`
FILENAME=pg_$DATETIME.dump.gz

if [ $# != 1 ]; then
  echo "wrong number of arguments"
  echo "pass the target file name"
  exit 1
fi

cd $BACKUP_PATH

if [ -f $1 ]; then
  echo "starting restore..."
  zcat $1 | psql -U $DB_USER -d postgres -h $DB_HOST -f -
  echo "ended restore"
else
  echo "cannot find the target file"
  exit 1
fi
