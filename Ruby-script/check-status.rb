#response = system('aws ec2 describe-instances | jq \'.Reservations[].Instances[].Tags[]\'')
response = system('knife ec2 server list --region ap-northeast-1')

puts response

