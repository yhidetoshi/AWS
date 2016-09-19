#!/bin/bash
mkdir /root/.aws
echo '[default]' >> /root/.aws/config
echo 'output = json' >> /root/.aws/config
echo 'region = ap-northeast-1' >> /root/.aws/config
echo '[default]' >> /root/.aws/credentials
echo 'aws_access_key_id = <aws_access_key_id>' >> /root/.aws/credentials
echo 'aws_secret_access_key = <aws_secret_access_key>' >> /root/.aws/credentials
INSTANCE_ID=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id`
INSTANCE_TAGS=`hostname`
aws ec2 create-tags --resources ${INSTANCE_ID} --tags "Key=Name,Value=${INSTANCE_TAGS}"
