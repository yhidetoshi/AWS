import boto3
 
TOPIC_ARN = 'arn:aws:sns:ap-northeast-1:XXXXXXXXXX:Check-Instance'


def lambda_handler(event, context):
    try:
        
        send_message=[]
        ec2 = boto3.client('ec2')

        # Check for EC2(Running)
        ec2_response = ec2.describe_instances(Filters=[{'Name':'instance-state-name','Values':['running']}] )
        ec2_count = len(ec2_response['Reservations'])
        #print ec2_count

        send_message_stoped=[]
        ec2_response_stopped = ec2.describe_instances(Filters=[{'Name':'instance-state-name','Values':['stopped']}] )
        ec2_count_stopped = len(ec2_response_stopped['Reservations'])
 
        ## Status is Running
        if not ec2_count == 0:
            send_message.append("[ EC2 is running! ]")
            for i in range(0, ec2_count):
                instance = ec2_response['Reservations'][i]['Instances'][0]['Tags'][0]['Value']
                send_message.insert(1,instance)  
            send_message.append(" ")

        ## Status is Stopped
        if not ec2_count_stopped == 0:
            send_message.append("[ EC2 is stopped! ]")
            for n in range(0, ec2_count_stopped):
                send_message.append(ec2_response_stopped['Reservations'][n]['Instances'][0]['Tags'][0]['Value'])  
            send_message.append(" ")
 
    
        # Check for ELB 
        elb = boto3.client('elb')
        elb_response = elb.describe_load_balancers()
        elb_count = len(elb_response['LoadBalancerDescriptions'])
 
        if not elb_count == 0:
            send_message.append("[ ELB is running! ]")
            for i in range(0, elb_count):
                send_message.append(elb_response['LoadBalancerDescriptions'][i]['LoadBalancerName'])
            send_message.append(" ")
 
        # Check for RDS
        rds = boto3.client('rds')
        rds_response = rds.describe_db_instances() 
        rds_count = len(rds_response['DBInstances'])
 
        if not rds_count == 0:
            send_message.append("[RDS is running!]")
            for i in range(0, rds_count):
                send_message.append(rds_response['DBInstances'][i]['DBInstanceIdentifier'])
            send_message.append(" ")
        
        # Send mail
        send_subject = "[Amazon Web Service] Check-Resource by Lambda"           
        for i in send_message:
            print(i)
 
        sns = boto3.resource('sns', 'ap-northeast-1')
        sns_response = sns.Topic(TOPIC_ARN).publish(
            Subject = send_subject,
            Message = "\n".join(send_message), 
        )
        

        return 0
        
    except Exception, e:
        print e, 'error occurred'
    
