#puts ARGV[0]

image_id = ARGV[0]

system('aws ec2 run-instances --image-id image_id --count 1 --region ap-northeast-1 --instance-type t2.nano')

