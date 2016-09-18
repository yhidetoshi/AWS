### AWS-CLI + jq



![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/jq1.png)


#### aws-CLIのインストール(CentOS6)
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


#### jqをインストール
```
【CentOSの場合】
$ yum -y install jq

【Macの場合】
$ brew install jq
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
