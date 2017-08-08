import boto3

region = 'ap-northeast-1'
instances = ['instance_id']

def lambda_handler(event, context):
     ec2 = boto3.client('ec2', region_name=region)
     ec2.stop_instances(InstanceIds=instances)

