#!/bin/bash

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
