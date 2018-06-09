#! /bin/bash

S3_BUCKET_ORIGINAL_NAME="hoge-xxxxx"
S3_BUCKET_TARGET_NAME="fuga-xxxx"
S3_BUCKET_DIR="test/"
RETRY_LIMIT=5
RETRY_COUNT=0
RETRY_SLEEP=2
SLEEP_TIME=3

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

# Sync S3 Bucket data
while :
  do
    # aws s3 sync {同期元のローカルパスまたは S3 URI} {同期先のローカルパスまたは S3 URI}
    aws s3 sync s3://${S3_BUCKET_ORIGINAL_NAME}/${S3_BUCKET_DIR} s3://${S3_BUCKET_TARGET_NAME}/${S3_BUCKET_DIR}
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
