### CloudTrail

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-reinvent-2013-report-aws-cloudtrail-1-638.jpg)




- CloudTrailの情報を参照する
  - `$ aws cloudtrail describe-trails --trail-name-list ${TRAIL_NAME}`
```
{
    "trailList": [
        {
            "IncludeGlobalServiceEvents": true,
            "Name": "yajima-dev",
            "TrailARN": "arn:aws:cloudtrail:ap-northeast-1:${TRAIL_NAME}:trail/${TRAIL_NAME}",
            "LogFileValidationEnabled": true,
            "IsMultiRegionTrail": true,
            "S3BucketName": "${S3_BUCKET_NAME}",
            "HomeRegion": "ap-northeast-1"
        }
    ]
}
```
