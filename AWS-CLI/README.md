### AWS-CLI(aws-shell) + jq

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-cli-image.png)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/jq1.png)

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

- Route53にAレコードをセットする
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


**▪️【インスタンスを1台作成する】**
```
- run-instances
  - image-id
  - count
  - region
  - instance-type
  - key-name
  - security-group-ids
  - subnet

aws> ec2 run-instances --image-id ami-374db956 --instance-type t2.nano --count 1 --key-name <key-name> --security-group-ids <sg-id> --subnet-id <subnet-id>
```

**▪️【インスタンスを停止/起動/破棄する】**
``` 
- stop-instances
  - instance-ids
aws> ec2 [stop|start|terminate]-instances --instance-ids <instance-id>
{
    "StoppingInstances": [
        {
            "InstanceId": "<instance-id>",
            "CurrentState": {
                "Code": 64,
                "Name": "stopping"
            },
            "PreviousState": {
                "Code": 16,
                "Name": "running"
            }
        }
    ]
}
```

▪️VPCの作成
```
- create-vpc
 - cider-block
 
aws> ec2 create-vpc --cidr-block 10.0.0.0/16
{
    "Vpc": {
        "VpcId": "<vpc-id>",
        "InstanceTenancy": "default",
        "State": "pending",
        "DhcpOptionsId": "dopt-381b085a",
        "CidrBlock": "10.0.0.0/16",
        "IsDefault": false
    }
}
```


▪️ Subnetの作成
```
- create-subnet
 - vac-id
 - cider-block

aws> ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.0.0/24
{
    "Subnet": {
        "VpcId": "<vpc-id>",
        "CidrBlock": "10.0.0.0/24",
        "State": "pending",
        "AvailabilityZone": "ap-northeast-1c",
        "SubnetId": "<subnet-id>",
        "AvailableIpAddressCount": 251
    }
}

aws> ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24
{
    "Subnet": {
        "VpcId": "<vpc-id>",
        "CidrBlock": "10.0.1.0/24",
        "State": "pending",
        "AvailabilityZone": "ap-northeast-1c",
        "SubnetId": "<subnet-id>",
        "AvailableIpAddressCount": 251
    }
}
```

▪️ サブネットを削除
```
- delete-subnet
  - subnet-id

aws> ec2 delete-subnet --subnet-id <subnet-id>
```

▪️インターネットゲートウェイを作成
```
- create-internet-gateway
 - region(not require)

aws> ec2 create-internet-gateway --region ap-northeast-1
{
    "InternetGateway": {
        "Tags": [],
        "InternetGatewayId": "<igw-id>",
        "Attachments": []
    }
}
```


▪️インターネットゲートウェイをVPCにアタッチする
```
- attach-internet-gateway
  - internet-gateway-id
  - vac-id

aws> ec2 attach-internet-gateway --internet-gateway-id <igw-id> --vpc-id <vpc-id>
```


▪️ルートテーブルを追加する
```
- create-route
  - route-table-id
  - destination-cidd-block
  - gateway-id

aws> ec2 create-route --route-table-id <rtb-id> --destination-cidr-block 0.0.0.0/0 --gateway-id <igw-id>
{
    "Return": true
}
```

▪️セキュリティグループのグループを作成
```
- create-security-group
  - group-name
  - description

aws> ec2 create-security-group --group-name SSH --description "for-ssh-g"
{
    "GroupId": "<sg-id>"
}
```


▪️　セキュリティグループのグループにポリシーを追加(Ingress)
```
- authorize-security-group-ingress
 - group-id
 - protocol
 - cidr

aws> ec2 authorize-security-group-ingress --group-id <sg-id> --protocol tcp --port 22 --cidr <ip-address/32>
```

▪️セキュリティグループの削除
```
- delete-security-group
  - group-id
aws> ec2 delete-security-group --group-id <sg-id>
```

▪️Elastic-IPの発行
```
- allocate-address
  - region

aws> ec2 allocate-address --region ap-northeast-1
{
    "PublicIp": "<Elastic-IP>",
    "Domain": "vpc",
    "AllocationId": "eipalloc-0c2e6b69"
}
```

▪️Elastic-IPを割り当てる
```
- associate-address
  - instance-id
  - public-ip
  - region

aws> ec2 associate-address --instance-id <instance-id> --public-ip <Elastic-ip> --region ap-northeast-1
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
