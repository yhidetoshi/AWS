### AWS-CLI + jq + UserData



![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/jq1.png)


### aws-CLIのインストール(CentOS6)
- インストール
```
# yum -y install python python-devel --enablerepo=epel
# yum -y install python-setuptools
# easy_install pip
# pip install awscli
```
- 鍵をセット
```
# export AWS_ACCESS_KEY_ID="access key"
# export AWS_SECRET_ACCESS_KEY="secret access key"
# source $HOME/.bash_profile
```

#### 複数のアカウントを使用するときは下記のように設定する
**[.aws/config]**
```
[default]
output = json
[profile new_name]
output = json
region = ap-northeast-1
```

**[.aws/credentials]**
```
[default]
aws_access_key_id = AWS_ACCESS_KEY_ID
aws_secret_access_key = AWS_SECRET_ACCESS_KEY
[new_name]
aws_access_key_id = AWS_ACCESS_KEY_ID
aws_secret_access_key = AWS_SECRET_ACCESS_KEY
```
**コマンドを実行するときの引数( --profile setting_name)**
```
$ aws ec2 describe-instances --profile new_name
```



### jqをインストール
```
【CentOSの場合】
$ yum -y install jq

【Macの場合】
$ brew install jq
```

- jqのインストール方法
https://www.linkedin.com/pulse/how-install-jq-centos-7-artur-todeschini

▪ インスタンス一覧の取得
```
$ aws ec2 describe-instances --region ap-northeast-1
```

▪ S3へBucketを指定してファイルをGETする。
aws s3api get-object --bucket <BUCKET_NAME> --key validation.pem /etc/chef/validation.pem

▪ EIPを紐付ける
```
$ aws ec2 associate-address --instance-id <instance-id> --public-ip <Elastic-ip> --region ap-northeast-1
{
    "AssociationId": "eipassoc-7ce1f918"
}
```


 `$ aws ec2 describe-instances | jq '.Reservations[].Instances[].Tags[]'`                         
 ```
{
  "Value": "Chef-Solo-server",
  "Key": "Name"
}
{
  "Value": "Chef12-Server&WebUI",
  "Key": "Name"
}
{
  "Value": "Ops-Server(Jenkis, chef-knife)",
  "Key": "Name"
}
{
  "Value": "Nginx-RP",
  "Key": "Name"
}
{
  "Value": "test-drbd",
  "Key": "Name"
}
```

▪️ Valueだけ表示

`$ aws ec2 describe-instances | jq '.Reservations[].Instances[].Tags[].Value'`
```
"Chef-Solo-server"
"Chef12-Server&WebUI"
"Ops-Server(Jenkis, chef-knife)"
"Nginx-RP"
"test-drbd"
```

### Curlでインスタンスのメタ情報取得

- コマンド
  - `$ curl http://169.254.169.254/latest/meta-data/<下記のメタ情報を指定>`
  - コマンドを発行するのは、インスタンス自身
```
ami-id
ami-launch-index
ami-manifest-path
block-device-mapping/
hostname
instance-action
instance-id
instance-type
local-hostname
local-ipv4
mac
metrics/
network/
placement/
product-codes
profile
public-keys/
reservation-id
security-groups
services/
```
- インスタンスタイプの取得例
```
$ curl http://169.254.169.254/latest/meta-data/instance-type
t2.micro
```

### AWS-CLIでユーザデータを読み込む
```
$ aws ec2 run-instances --image-id ami-374db956 --instance-type t2.micro --key-name ${EC2_KEY_NAME} --subnet-id ${SUBNET_ID} --region ap-northeast-1 --security-group-ids ${SECURITY_GROUP_ID} --user-data file:///var/lib/jenkins/workspace/Create-Instance-Nogithub/aws-cli_inputTag.sh
```

- `aws-cli_inputTag.sh`
  - https://github.com/yhidetoshi/AWS/blob/master/User-Data/aws-cli_inputTag.sh


### LBにインスタンスを登録する

`$ aws elb register-instances-with-load-balancer --load-balancer-name <lb_name> --instances <instance_id>`
```
❯❯❯ aws elb register-instances-with-load-balancer --load-balancer-name lb_namexxxx --instances i-xxxxxxxxx
{
    "Instances": [
        {
            "InstanceId": "i-xxxxxxxxx"
        }
    ]
}
```

### LBにインスタンスを解除する

`$ aws elb deregister-instances-from-load-balancer --load-balancer-name <lb_name> --instances <instance_id>`
```
❯❯❯ aws elb deregister-instances-from-load-balancer --load-balancer-name LB-xxxxx --instances i-xxxxxxx
{
    "Instances": [
        {
            "InstanceId": "i-xxxxxxxxxx"
        },
        {
            "InstanceId": "i-xxxxxxxxxx"
        }
    ]
}
```
## AutoScaling

**作成済みのASを確認する**

`$ aws autoscaling describe-auto-scaling-groups`


**作成済みのASを作成して発動**
```
$ aws autoscaling create-auto-scaling-group \
        --launch-configuration-name ${AS_LAUNCH_CONFIG_NAME} \
        --auto-scaling-group-name ${AS_GROUP_NAME} \
        --min-size ${AS_GROUP_MIN} \
        --max-size ${AS_GROUP_MAX} \
        --vpc-zone-identifier "${VPC_SUBNET_ID}"
```

**AutoScalingのアクティビティ履歴を参照**

- `--max-items`：いくつまでさかのぼって表示するか(valueは1,2....) 
```
aws autoscaling describe-scaling-activities \
        --auto-scaling-group-name ${AS_GROUP_NAME} \
        --max-items ${MAX_ITEMS}
```

### ELBにインスタンスが関連付けされているかの確認
`aws elb describe-instance-health --load-balancer-name <LB_Name> --region ap-northeast-1 --instances <instance-id>`
```
{
    "InstanceStates": [
        {
            "InstanceId": "i-xxxxxxxxxxxxx",
            "ReasonCode": "Instance",
            "State": "OutOfService",
            "Description": "Instance is not currently registered with the LoadBalancer."
        }
    ]
}
```

### サーバ側とs3側で同期をとる(ディレクトリも問題なし)

`$ aws s3 sync Local_dir s3://Bucket_Name --profile yajima`

--deleteオプションを付けるとローカル側でデータを削除するとs3側でも削除される。


### jq

- DBインスタン情報を取得する

`$ aws rds describe-db-instances | jq '.DBInstances[]'`

- DB-instanceの名前を取得する

`$ aws rds describe-db-instances | jq '.DBInstances[].DBInstanceIdentifier'`

- Version

`$ aws rds describe-db-instances | jq '.DBInstances[].EngineVersion'`

#### インスタンスID/PIP/インスタンス名を取得する場合
`$ aws ec2 describe-instances | jq '.Reservations[].Instances[] | {InstanceId, PrivateIpAddress, InstanceName: (.Tags[] | select(.Key=="Name").Value)}'`

### 作成途中のAMIがあるか確認する
`$ aws ec2 describe-images --owners self | jq '.Images[] | {InstanceName: (.Tags[] | select(.Key=="Name").Value) ,ImageId,State} | select(.State == "available")'`

### Cloudwatch-Alerm
```
aws cloudwatch put-metric-alarm --alarm-name "Hoge_CPUUtilization" --namespace AWS/EC2 --metric-name CPUUtilization --dimensions "Name=InstanceId,Value={INSTANCE_ID}" --period 300 --statistic Average --threshold 80 --comparison-operator GreaterThanOrEqualToThreshold --evaluation-periods 2 --alarm-actions arn:aws:sns:ap-northeast-1:XXXXXXX:YYYYY --ok-actions arn:aws:sns:ap-northeast-1:XXXXXXX:YYYYY
```
- インスタンスの情報を一部抽出する。
  - `$ aws ec2 describe-instances | jq '.Reservations[].Instances[] | {InstanceName: (.Tags[] | select(.Key=="Name").Value) ,InstanceId, PrivateIpAddress,PublicIpAddress,InstanceType, State}'`

```
{
  "InstanceName": "Instance-Name",
  "InstanceId": "i-xxxxxxxxxxxxx",
  "PrivateIpAddress": "172.31.2.13",
  "PublicIpAddress": "X.X.X.X",
  "InstanceType": "t2.small",
  "State": {
    "Code": 16,
    "Name": "running"
  }
}
```

- Kinesis-streamの情報を抽出する
  - `aws kinesis describe-stream --stream-name <STREAM-NAME> |jq '.StreamDescription |{StreamName,StreamStatus,StreamARN,RetentionPeriodHours}'`
