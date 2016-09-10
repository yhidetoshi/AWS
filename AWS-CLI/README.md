### AWS-CLI + jq



![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/jq1.png)


#### aws-CLIのインストール(CentOS6)
```
# yum -y install python python-devel --enablerepo=epel
# yum -y install python-setuptools
# easy_install pip
# pip install awscli
```



#### jqをインストール
```
$brew install jq
```

▪ インスタンス一覧の取得
```
$ aws ec2 describe-instances --region ap-northeast-1
```

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
