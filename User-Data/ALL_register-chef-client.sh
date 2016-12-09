#!/bin/bash

#!/bin/bash
mkdir /root/.aws
echo '[default]' >> /root/.aws/config
echo 'output = json' >> /root/.aws/config
echo 'region = ap-northeast-1' >> /root/.aws/config
echo '[default]' >> /root/.aws/credentials
echo 'aws_access_key_id = <aws_access_key_id>' >> /root/.aws/credentials
echo 'aws_secret_access_key = <aws_secret_access_key>' >> /root/.aws/credentials


RETRY_LIMIT=10
RETRY_COUNT=0
RETRY_SLEEP=2
DOMAIN="dev.yajima"

# yum install jq


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

# Get-Private-IP
IPV4=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/local-ipv4`

# Get-Hostname
HOSTNAME=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/hostname`
SHORT_HOSTNAME=`expr ${HOSTNAME} | sed -e 's/ap-northeast-1.compute.internal//i'`



# Get-Hosted-Zone-ID
while :
 do
     HOSTED_ZONE_ID=`aws route53 list-hosted-zones | jq --arg zone_name ${DOMAIN} -r '.HostedZones[]|select(.Name |contains($zone_name))|.Id' | sed 's/\/hostedzone\///'`

   if [ $? -eq 0 ]; then
       echo ${HOSTED_ZONE_ID}
       msg success
       break

   elif [ ${RETRY_COUNT} -lt ${RETRY_LIMIT} ]; then
       RETRY_COUNT=`expr ${RETRY_COUNT} + 1`
       sleep ${RETRY_SLEEP};
   else
      msg failed
       break
   fi
 done

# Output Jsonfile for A-record
cat <<EOF > /tmp/Arecord-set.json
{
     "Changes": [
      {
        "Action": "CREATE",
        "ResourceRecordSet": {
           "Name": "${SHORT_HOSTNAME}${DOMAIN}",
           "ResourceRecords": [
              {
                  "Value": "${IPV4}"
              }
           ],
           "Type": "A",
           "TTL": 60
           }
         }
       ]
}
EOF
cat /tmp/Arecord-set.json

# Route53にAレコードを追加する
while :
 do
     aws route53 change-resource-record-sets --hosted-zone-id ${HOSTED_ZONE_ID} --change-batch file:///tmp/Arecord-set.json

   if [ $? -eq 0 ]; then
       msg success
       break

   elif [ ${RETRY_COUNT} -lt ${RETRY_LIMIT} ]; then
       RETRY_COUNT=`expr ${RETRY_COUNT} + 1`
       sleep ${RETRY_SLEEP};
   else
      msg failed
       break
   fi
 done

curl -L https://www.opscode.com/chef/install.sh | sudo bash
mkdir /etc/chef
mkdir /etc/chef/trusted_certs


aws s3api get-object --bucket <BUCKET_NAME> --key validation.pem /etc/chef/validation.pem
aws s3api get-object --bucket <BUCKET_NAME> --key ip-10-0-0-168_ap-northeast-1_compute_internal.crt /etc/chef/trusted_certs/ip-10-0-0-168_ap-northeast-1_compute_internal.crt


hostname ${INSTANCE_TAGS}.ap-northeast-1.compute.internal
echo 10.0.0.168  ip-10-0-0-168.ap-northeast-1.compute.internal >> /etc/hosts

cat <<EOE > /etc/chef/client.rb
log_location STDOUT
node_name "${INSTANCE_TAGS}"
chef_server_url "https://ip-10-0-0-168.ap-northeast-1.compute.internal/organizations/dev"
validation_client_name "dev-validator"
EOE

chef-client -c /etc/chef/client.rb
