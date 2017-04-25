# Terraform + Ansible + Git + CIでAWSをコードベースで管理

![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/terraform-icon1.jpg)

## Terraformとは
```
Terraform は、Vagrant などで有名な HashiCorp が作っているコードからインフラリソースを作成する・コードで
インフラを管理するためのツールです。AWS, GCP, Azureなどにも対応。 
```

Infrastructure as Codeを体現できる


### 現在の構成
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/aws/aws-terraform-ci.png)

#### 現在の管理方法
- マネジメントコンソールでポチポチする。
- 作業履歴が残らない (CloudTrailを利用するとユーザ名とコールしたAPIは残る...)
- 不要なリソースの判断が難しい
- マネジメントコンソールの操作ミスを防ぎたい

#### 特徴
   - OSSとして利用ができる
   - プロダクト自体が活発に活動している。機能が次々とリリースされている
   - Infrastructure as Codeとしてクラウドインフラを設定、運用できる
   - PullRequestとReviewのレールにのることができる
   
   - リソース用途の目的もコメントで残すことが可能
   
   - 環境を一気にデプロイすることができる
  
  
#### Terraform 現在のディレクトリ構成(今後変更しますが)
```
.
├── main.tf
├── modules
│   ├── cloudwatch-alarm
│   │   ├── external
│   │   │   └── get-instance.sh
│   │   ├── external.tf
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── iam
│   │   ├── aws_iam_group_memberships.tf
│   │   ├── aws_iam_group_policies
│   │   │   ├── group1_policy.json
│   │   │   └── group2_policy.json
│   │   ├── aws_iam_group_policies.tf
│   │   └── aws_iam_groups.tf
│   ├── s3
│   │   ├── main.tf
│   │   └── variables.tf
│   └── sample
│       ├── ec2.tf.back
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

- dry-runコマンド: `$ terraform plan`
- 適用コマンド`$ terraform apply`


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
