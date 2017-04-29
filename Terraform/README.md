## Terraform + Ansible + Git + CIを用いてAWSをInfrastructure as Codeで管理する

![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/terraform-small2-icon.jpg)
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Ansible_dev/ansible-small-logo.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Jenkins/jenkins-icon2.jpeg)
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/gitlab/gitlab-logo2.png)


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

### 現在の構成(CI連携部分)
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/terraform-ci-jenkins.png)

#### AWSのリソース追加はこんな感じに。
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/code-terraform2.PNG)

#### 現在の管理方法
- マネジメントコンソールでポチポチする。
- 作業履歴が残らない (CloudTrailを利用するとユーザ名とコールしたAPIは残る...)
- 不要なリソースの判断が難しい(何の為につくられたものなのか)
- マネジメントコンソールの操作ミスを防ぎたい

#### 特徴
   - OSSとして利用ができる
   - プロダクト自体が活発に活動している。機能が次々とリリースされている
   - Infrastructure as Codeとしてクラウドインフラを設定、運用できる
   - PullRequestとReviewのレールにのることができる
   
   - リソース用途の目的もコメントで残すことが可能
   
   - 環境を一気にデプロイすることができる
   → `テンプレート化してモジュールとして使いまわすことができ、マルチクラウド環境(Azure/GCP)で利用することができるようになる`
  
  
#### Terraform 現在のディレクトリ構成(今後変更しますがとりあえず。)
```
.
├── README.md
├── main.tf
├── modules
│   ├── cloudwatch-alarm
│   │   ├── external
│   │   │   └── get-instance.sh
│   │   ├── external.tf
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── elb-http
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── iam
│   │   ├── aws_iam_group_memberships.tf.back
│   │   ├── aws_iam_group_policies
│   │   │   ├── group1_policy.json
│   │   │   └── group2_policy.json
│   │   ├── aws_iam_group_policies.tf.back
│   │   ├── aws_iam_groups.tf
│   │   ├── group
│   │   │   ├── iam_group.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── policy
│   │   │   ├── aws_iam_policy.tf
│   │   │   ├── group1_policy.json
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── user
│   │       ├── aws_iam_user.tf
│   │       ├── outputs.tf.back
│   │       └── variables.tf
│   ├── s3
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── sample
│   │   ├── ec2.tf.back
│   │   ├── main.tf
│   │   └── variables.tf
│   └── security-group
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── run-apply-terraform.sh
├── run-plan-terraform.sh
├── terraform.tf
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
