import boto3

region = 'ap-northeast-1'
instances = 'DB-NAME'

def lambda_handler(event, context):
    rds = boto3.client('rds', region_name=region)
    rds.start_db_instance(DBInstanceIdentifier=instances)
