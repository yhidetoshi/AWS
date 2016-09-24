#!/bin/bash

RETRY_LIMIT=10
RETRY_COUNT=0
RETRY_SLEEP=2

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

while :
  do
       aws ec2 run-instances --image-id ami-374db956 --count 1 --region ap-northeast-1 --instance-type t2.nano
       echo \n
    if [ $? -eq 0 ]; then
         msg success
         break

    elif [ ${RETRY_COUNT} -lt ${RETRY_LIMIT} ]; then
          RETRY_COUNT=`expr ${RETRY_COUNT} + 1`
          echo ${RETRY_LIMIT}
          echo ${RETRY_COUNT}
          sleep ${RETRY_SLEEP};
    else
          msg failed
          break
    fi
  done
