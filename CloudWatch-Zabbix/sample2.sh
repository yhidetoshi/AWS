#!/bin/sh

while getopts p:n:r:d:m:s: OPT
do
  case ${OPT} in
    p) PROFILE=${OPTARG} ;;
    n) NAMESPACE=${OPTARG} ;;
    d) DIMENSIONS=${OPTARG} ;;
    m) METRIC=${OPTARG} ;;
    s) STATISTICS=${OPTARG} ;;
    *) exit 1 ;;
  esac
done

aws --profile ${PROFILE} cloudwatch get-metric-statistics \
  --namespace ${NAMESPACE} \
  --dimensions ${DIMENSIONS} \
  --metric-name ${METRIC} \
  --statistics ${STATISTICS} \
  --start-time `date -u -d '9 minutes ago' +%Y-%m-%dT%TZ` \
  --end-time `date -u +%Y-%m-%dT%TZ` \
  --period 300 | grep ${STATISTICS} | awk '{print $2}' | cut -d',' -f1
