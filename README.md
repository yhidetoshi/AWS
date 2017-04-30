## AWSについて

### AWSのコードベース管理
#### CI連携部分
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/terrafom-ci-slack.png)

※内容については、別途かきます。
https://github.com/yhidetoshi/AWS/blob/master/Terraform/README.md

### サーバレスアーキテクチャ(IoT)　実施した構成図
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-iot-fig2.png)


### 検証内容
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-fig990.png)



### VPC
→ https://github.com/yhidetoshi/AWS/tree/master/VPC#vpcnatゲートウェイ
- VPC作成
 - subnet(public/private)
- IG/NAT-GW/NATインスタンス

### インスタンスのメタ情報の取得 
→ https://github.com/yhidetoshi/AWS/blob/master/AWS-CLI/README.md#curlでインスタンスのメタ情報取得

### FluentdによるS3へのログ転送
→ https://github.com/yhidetoshi/AWS/tree/master/Fluentd-s3#nginxのaccessログをfluentdでs3に格納する

### Chef12によるインスタンス管理
→ https://github.com/yhidetoshi/AWS/tree/master/Chef#chef12

- userdataからchef-serverに対してクライアント登録とrecipeの実行

  → https://github.com/yhidetoshi/AWS/blob/master/Chef/README.md#userdataからchefクライアントに登録してレシピを自動実行

(ServerSpecとか)→ https://github.com/yhidetoshi/chef_mac



### Ansible(@Docker)
→ https://github.com/yhidetoshi/Ansible-Dev

### CloudWatch SNS
→ https://github.com/yhidetoshi/AWS/tree/master/CloudWatch#cloudwatch-︎-sns

### CloudTrail
→ https://github.com/yhidetoshi/AWS/tree/master/CloudTrail#cloudtrail

### JenkinsからAWS-CLIの実行(Github連携)
→ https://github.com/yhidetoshi/AWS/tree/master/Script-For-Jenkins#jenkins-github連携aws-cli実行用

### AWS-CLI((aws-shell)
→ https://github.com/yhidetoshi/AWS/blob/master/AWS-CLI/README.md#aws-cliaws-shell

### userdataの利用
→ https://github.com/yhidetoshi/AWS/tree/master/User-Data#user-data

### Glacierについて
→ https://github.com/yhidetoshi/AWS/tree/master/Glacier#glacierについて

### VM Import/Export機能
→ https://github.com/yhidetoshi/AWS/tree/master/VM-Import-Export#vm-importexport
