EC2_ID="$2"
aws ec2 terminate-instances --region ap-northeast-1 --instance-ids ${EC2_ID}
