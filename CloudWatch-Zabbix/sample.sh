#!/bin/bash

# ./cloudwatch.sh -n AWS/RDS -d Name=DBInstanceIdentifier,Value=beaconnect-db1-rsver -m CPUUtilization -s Maximum

while getopts n:d:m:s: OPT
do
  case ${OPT} in
    n) NAMESPACE=${OPTARG} ;;
    d) DIMENSIONS=${OPTARG} ;;
    m) METRIC=${OPTARG} ;;
    s) STATISTICS=${OPTARG} ;;
    *) exit 1 ;;
  esac
done

### example
# ./cloudwatch.sh -n AWS/[EC2,RDS] -d Name=[InstanceId,mydbinstance],Value=[instanceID,mydbinstance] -m CPUUtilization -s Maximum

aws cloudwatch get-metric-statistics --region ap-northeast-1 --period 300 \
 --namespace ${NAMESPACE} \
 --dimensions ${DIMENSIONS} \
 --metric-name ${METRIC} \
 --statistics ${STATISTICS} \
 --start-time `date --iso-8601=seconds --date '6 minutes ago'` \
 --end-time `date --iso-8601=seconds --date '1 minutes ago'` | jq -r ".Datapoints[].Maximum"
