## Terraform + Ansible + Git + CIを用いてAWSをInfrastructure as Codeで管理する

![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/terraform-small2-icon.jpg)
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/gitlab/gitlab-logo2.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Jenkins/jenkins-icon2.jpeg)
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Ansible_dev/ansible-small-logo.png)


※ 社内でちょっと使うために下の説明を書いてみました...
## 今、取り組んでいる事を説明するために...

### まず、Cloud環境について
- Cloud Infrastructureは仮想化されており、ソフトウェアで実装されている。
- 基本的にはRESTFull(POST,PUT,DELETE,GET)のインタフェースが用意されており、APIベースで操作可能。
- パブリッククラウドのAWS/Azure/GCP...etcもあてはまり
- プライベートクラウドで代表的なOpenStack/CloudStackも同様
  
 **(課題)**
- システム規模、利用ユーザが増えるにつれ運用コスト、構築コストを下げる事が課題となる
- 同じ設定やオペレーションも繰り返す事が多々ある

-> インフラがソフトウェアで、APIのインタフェースが用意されているので、コードで扱う事が可能！

-> 個人的にはインフラ(特にクラウド)エンジニアとしては、DevOpsを導入してコードを書いたりして自動化をするのは醍醐味だと思う。

### Infrastructure as Codeを実践するためにいくつかのOSSを活用する
- **Cloudインフラをオーケストレーションで管理することが可能**
  - Terraform
    - AWSをコードで管理する
      - EC2/VPC/IAM/Kinesis/SNS/Cloudwatch/...etc

- **Instanceの構築・設定・保守の自動化**
  - Ansible
    - Cloudwatch-カスタムメトリクス
      - Memory使用率の取得可能に
      - 特定のプロセス監視を可能に
      - OSSインストール
        - Nginx/Fluentd/Mongo/...etc 
       
- **継続的インテグレーション(CI)の連動**
  - Infrastructure as Codeのワークフローに乗るために
   - Jenkins/GitLabとの連携
     - ブランチにPushしてdry-run
     - MasterブランチにMergeしてapply 

## Infrastructure as Codeとは
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/infra-as-code-icon2.jpg)
```
Infrastructure as Codeは自動化、バージョン管理、テスト、継続的インテグレーションといった、ソフトウェア開発のプラクティスを
システム管理に応用するための方法論のこと。
```

## Terraformとは
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/terraform_overview-icon.png)
※画像引用元：https://goo.gl/OR9WgP

```
Terraform は、Vagrant などで有名な HashiCorp が作っているコードからインフラリソースを作成する・コードで
インフラを管理するためのツール。AWS, GCP, Azureなどにも対応。 
```

### Terraformチュートリアル_AWS
https://www.terraform.io/docs/providers/aws/index.html

### 現在の構成(CI連携部分)
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/terraform-icon-slack2.png)

#### AWSのリソース追加はこんな感じに。
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/code-terraform2.PNG)

### 現在の管理方法
- マネジメントコンソールでポチポチする。

　　　　　→　ブラウザでポチポチしている裏ではAPIがコールされて操作が行われている。
- 作業履歴が残らない (CloudTrailを利用するとユーザ名とコールしたAPIは残る...)
- 不要なリソースの判断が難しい(何の為につくられたものなのか)
- マネジメントコンソールの操作ミスを防ぎたい

### 特徴
   - OSSとして利用ができ、プロダクト自体も活発に活動しているため機能が次々とリリースされている
   - Infrastructure as Codeとしてクラウドインフラを設定、運用が可能
   - PullRequestとReviewのレールにのることができる
   - APIの側面からサービスの理解が深まる。
   
   - リソース用途の目的もコメントで残すことが可能
   
   - 環境を一気にデプロイすることができる
   → `テンプレート化してモジュールとして使いまわすことができ、マルチクラウド環境(Azure/GCP)で利用することができるようになる`


## 利用しているリソースの一覧

|サービス      |resource     |
|:-----------|:------------|
| EC2-instance | aws_instance|
| EC2-SecurityGroup | aws_security_group |
| S3         | aws_s3_bucket|
| IAM-User   | aws_iam_user|
| IAM-User   | aws_iam_access_key|
| IAM-Group  | aws_iam_group|
| IAM-Policy | aws_iam_policy| 
| SNS        | aws_sns_topic|
| SNS        | aws_sns_topic_subscription|
| ELB        | aws_elb|
| VPC        | aws_vpc|
| VPC        | aws_internet_gateway|
| VPC        | aws_route_table|
| VPC        | aws_route|
| VPC        | aws_route_table|
| VPC        | aws_subnet|
| VPC        | aws_eip|
| VPC        | aws_nat_gateway|
| VPC        | aws_route_table_association|
| Cloudwatch | aws_cloudwatch_metric_alarm|
|Kinesis_Stream|aws_kinesis_stream|
|EC2 AMI|aws_ami|
|EC2 AMI|aws_ami_from_instance|
|Route53|aws_route53_zone|
|Route53|aws_route53_record|
|EC2 EBS|aws_ebs_volume|
|EC2 EBS|aws_ebs_snapshot|
|RDS|aws_db_parameter_group|
|RDS|aws_db_instance|
|RDS|aws_db_subnet_group|


- `terraform.tfvars`　(AWSのAPIをコールするので、このファイル名に鍵情報をセットする。)
```
aws_access_key = "aws_access_key"
aws_secret_key = "aws_secret_key"
```

- `main.tf` (モジュールを呼び出すmain.tfの一部抜粋)
```
### VPC
module "vpc" {
   source = "./modules/vpc"
   name = "terraform-test-vpc"

   cidr = "192.168.0.0/16"
   private_subnets = ["192.168.1.0/24", "192.168.2.0/24"]
   public_subnets  = ["192.168.10.0/24", "192.168.11.0/24"]

   enable_nat_gateway = "true"

   azs = ["ap-northeast-1a", "ap-northeast-1c"]
   tags {
     "Terraform" = "true"
   }
}
```

## Terraformコマンドのまとめ
- moduleセットコマンド: `$ terraform get`
- dry-runコマンド: `$ terraform plan`
- 適用コマンド(apply):`$ terraform apply`
- dry-run-destroy: `$ terraform plan --destroy`
- 適用コマンド(destroy): `$ terraform destroy`
- 管理状況の確認: `$ terraform show`


### Terraformでサポートしている機能としていないのがあればメモしていきます。
#### Not Supported
- SNS
  - Emai
  
## Terraform 現在のディレクトリ構成(今後変更しますがとりあえず。)
- ソースコードは会社のGitLabにあげてます
```
.
├── README.md
├── main.tf
├── modules
│   ├── ami
│   │   ├── from-instance
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   └── from-snapshot
│   │       ├── main.tf
│   │       └── variables.tf
│   ├── cloudwatch-alarm
│   │   ├── external
│   │   │   └── get-instance.sh
│   │   ├── external.tf
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── ebs
│   │   └── create-snapshot
│   │       ├── main.tf
│   │       └── variables.tf
│   ├── elb-http
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── iam
│   │   ├── aws_iam_group_memberships.tf.back
│   │   ├── aws_iam_group_policies
│   │   │   ├── group1_policy.json
│   │   │   └── group2_policy.json
│   │   ├── aws_iam_group_policies.tf.back
│   │   ├── aws_iam_groups.tf.back
│   │   ├── group
│   │   │   ├── iam_group.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── policy
│   │   │   ├── aws_iam_policy.tf
│   │   │   ├── iam_policy.json
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── user
│   │       ├── aws_iam_user.tf
│   │       ├── outputs.tf.back
│   │       └── variables.tf
│   ├── kinesis-stream
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── public-subnet
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── rds
│   │   ├── create-instance
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   ├── subnet.tf
│   │   │   └── variables.tf
│   │   └── parameter-group
│   │       ├── main.tf
│   │       └── variables.tf
│   ├── route53
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── s3
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── sample
│   │   ├── ec2.tf.back
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── security-group
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── sns
│   │   ├── main.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       └── variables.tf
├── run-apply-terraform.sh
├── run-plan-terraform.sh
├── terraform.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
└── variables.tf
```

### Ansible playbook(ディレクトリ構成)
```
├── README.md
├── aws-api-setup.yml
├── aws_credentials
│   ├── user1
│   └── user2
├── hosts
├── roles
│   ├── aws-api-setup
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   ├── config.j2
│   │   │   └── credentials.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── cloudwatch
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   │   ├── AwsSignatureV4.pm
│   │   │   ├── CloudWatchClient.pm
│   │   │   ├── mon-get-instance-stats.pl
│   │   │   └── mon-put-instance-data.pl
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── awscreds.conf.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── cloudwatch-alarm
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── ec2
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── iam
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   │   └── hoge.json
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── save_credential.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── nginx
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── nginx.conf.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── ssh
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   │   └── config
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── td-agent2
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   └── td-agent.conf.j2
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   ├── user
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── files
│   │   │   └── hide_id_rsa
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   ├── tests
│   │   │   ├── inventory
│   │   │   └── test.yml
│   │   └── vars
│   │       └── main.yml
│   └── zabbix-agent
│       ├── README.md
│       ├── defaults
│       │   └── main.yml
│       ├── files
│       │   ├── zabbix-release-2.4-1.el6.noarch.rpm
│       │   └── zabbix.repo
│       ├── handlers
│       │   └── main.yml
│       ├── meta
│       │   └── main.yml
│       ├── roles
│       ├── tasks
│       │   ├── main.yml
│       │   └── main.yml.org
│       ├── templates
│       │   └── zabbix_agentd.conf.j2
│       ├── tests
│       │   ├── inventory
│       │   └── test.yml
│       └── vars
│           └── main.yml

```
