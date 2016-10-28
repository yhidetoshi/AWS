### CloudWatch
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/cloudwatch-logo999.png)
```
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
