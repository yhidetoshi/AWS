import boto3

region = 'ap-northeast-1'
instances = 'BD-NAME'

def lambda_handler(event, context):
    rds = boto3.client('rds', region_name=region)
    rds.stop_db_instance(DBInstanceIdentifier=instances)
