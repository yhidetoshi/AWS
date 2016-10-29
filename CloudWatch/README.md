### CloudWatch
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/cloudwatch-logo999.png)
```
(ex)
CPUUtilization <instance_id>
NetworkIn <instance_id>
DiskReadOps <instance_id>
```
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-cloudwatch-metorics.png)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/cloudwatch-log.png)



- **AWS-CLIでCloudwatchのメトリックスを取得する**
```
aws cloudwatch get-metric-statistics --metric-name CPUUtilization --start-time 2016-10-27T21:00:00 --end-time 2016-10-28T22:00:00 --period 3600 --namespace AWS/EC2 --statistics Maximum --dimensions Name=InstanceId,Value=<instance-id>
{
    "Datapoints": [
        {
            "Timestamp": "2016-10-28T12:00:00Z",
            "Maximum": 1.33,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2016-10-28T11:00:00Z",
            "Maximum": 0.68,
            "Unit": "Percent"
        },
        {
            "Timestamp": "2016-10-28T13:00:00Z",
            "Maximum": 0.68,
            "Unit": "Percent"
        }
    ],
    "Label": "CPUUtilization"
}
```


# カスタムログ

- TimeZoneを変更する
 - `cp /usr/share/zoneinfo/Japan /etc/localtime`
 - `/etc/sysconfig/clock`
```
ZONE="Asia/Tokyo"
UTC=true
```

```
# yum -y update
# yum install -y awslogs
# service awslogs start
```
## NginxのAccessログをCloudWatchに登録してみる
  - /etc/awslogs/awslogs.conf

```
region = ap-northeast-1
aws_access_key_id = ${aws_access_key_id}
aws_secret_access_key = ${aws_secret_access_key


[/var/log/nginx/access.log]
datetime_format = %b %d %H:%M:%S 
file = /var/log/nginx/access.log*
buffer_duration = 5000
log_stream_name = {instance_id}
initial_position = start_of_file
log_group_name = Nginx_Access_Log
time_zone = LOCAL
```
- **実際に登録されているかを確認する**

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/cloudwatch-custom-log.png)
