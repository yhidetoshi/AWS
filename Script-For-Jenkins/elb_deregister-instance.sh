EC2_ID="$2"
aws elb deregister-instances-from-load-balancer --load-balancer-name name-of-lb --instances ${EC2_ID}
