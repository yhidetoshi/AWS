### IAM


#### カスタムポリシー
- s3

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::{BUCKET_NAME}",
                "arn:aws:s3:::{BUCKET_NAME}/*"
            ]
        }
    ]
}
```


```
"Resource": [
                "arn:aws:s3:::{BUCKET_NAME}",   ---> バケットに対する権限付与
                "arn:aws:s3:::{BUCKET_NAME}/*"  ---> オブジェクトに対する権限付与
```
