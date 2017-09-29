EC2_ID="$2"
aws elb register-instances-with-load-balancer --load-balancer-name name-of-lb --instances ${EC2_ID}
