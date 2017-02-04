# -*- coding: utf-8 -*-
import boto3
import json
import logging
import datetime
from base64 import b64decode

TOPIC_ARN = 'arn:aws:sns:us-east-1:XXXXXXXX:push-billing'

def lambda_handler(event, context):
    try:  
        
        client = boto3.client('cloudwatch')
        startDate = datetime.datetime.today() - datetime.timedelta(days = 1)

        response = client.get_metric_statistics (
            MetricName = 'EstimatedCharges',
            Namespace  = 'AWS/Billing',
            Period     = 86400,
            StartTime  = startDate,
            EndTime    = datetime.datetime.today(),
            Statistics = ['Maximum'],
            Dimensions = [
                 {
                    'Name': 'Currency',
                    'Value': 'USD'
                 }
            ]
        )

        maximum = response['Datapoints'][0]['Maximum']
        date    = response['Datapoints'][0]['Timestamp'].strftime('%Y年%m月%d日')

        mail_message = {
            "%sまでのAWSの料金は、$%sです。" % (date, maximum)
        }
        send_subject = "[Billing] Check-Billing by Lambda"           
    
        sns = boto3.resource('sns', 'us-east-1')
        sns_response = sns.Topic(TOPIC_ARN).publish(
            Subject = send_subject,
            Message = "\n".join(mail_message), 
        )
  
        return 0
        
    except Exception, e:
        print e, 'error occurred'    
