### AWS-CLI(aws-shell)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-cli-image.png)

#### aws-cliのインストール
- 下記のGithubからインストールする
  - 'https://github.com/awslabs/aws-shell'


- 起動方法
```
~ ❯❯❯ aws-shell
aws>
```

- aws-shellをいくつか叩いてみた
  - 戻り値はJSONでかえってくる

```
aws> ec2 run-instances --image-id ami-374db956 --count 1 --region ap-northeast-1 --instance-type t2.nano

aws> route53 list-hosted-zones

aws> route53 list-resource-record-sets --hosted-zone-id <hosted-zone-id>

aws> route53 create-hosted-zone --name <domain_name> --caller-reference 111

aws> s3 ls
```

- Route53にレコードをセットする
  - `aws> route53 change-resource-record-sets --hosted-zone-id <hosted-zone-id> --change-batch file://./a-record-set.json`

**[a-record-set.json]**
```
{
     "Changes": [
      {
        "Action": "CREATE",
        "ResourceRecordSet": {
           "Name": "hoge.example.xyz.",
           "ResourceRecords": [
              {
                  "Value": "192.0.2.1"
              }
           ],
           "Type": "A",
           "TTL": 300
           }
         }
       ]
}
```
