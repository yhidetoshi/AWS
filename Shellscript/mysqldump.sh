#! /bin/bash

ENDPOINT="example-db-.xxxxxxx.ap-northeast-1.rds.amazonaws.com"
USER="user"
PASSWORD="hogehoge"
DB_NAME="hogedb"
FILE_PATH="/var/tmp/mysqldump/"
S3_BUCKET="hoge-xxxx"
S3_BUCKET_DIR="mysqldump/"
RETRY_LIMIT=5
RETRY_COUNT=0
RETRY_SLEEP=2
SLEEP_TIME=3

today="$(date '+%Y%m%d')"
OUTPUT_FILE="mysqldump_${today}.sql.gz"

# echo result messages
function msg(){
  msg_=$1
  case $msg_ in
    success)
      echo "success!"
      ;;
    failed)
      echo "failed!"
      ;;
  esac
}

# Create MySQL dump
while :
  do
    mysqldump -h ${ENDPOINT} --single-transaction --skip-triggers -u ${USER} -p${PASSWORD} ${DB_NAME} | gzip > ${FILE_PATH}${OUTPUT_FILE}

    if [ $? -eq 0 ]; then
        msg success
        break

    elif [ ${RETRY_COUNT} -lt ${RETRY_LIMIT} ]; then
       RETRY_COUNT="$(expr ${RETRY_COUNT} + 1)"
       sleep ${RETRY_SLEEP};

    else
       msg failed
       break
     fi
done


# Upload dumpfile to S3 and delete local dump file
while :
  do
    /usr/local/bin/aws s3 cp ${FILE_PATH}${OUTPUT_FILE} s3://${S3_BUCKET}/${S3_BUCKET_DIR}

    if [ $? -eq 0 ]; then
        msg success
        sleep ${SLEEP_TIME}
        rm -f ${FILE_PATH}${OUTPUT_FILE}
        break

    elif [ ${RETRY_COUNT} -lt ${RETRY_LIMIT} ]; then
       RETRY_COUNT=`expr ${RETRY_COUNT} + 1`
       sleep ${RETRY_SLEEP};

    else
       msg failed
       break
    fi
done
