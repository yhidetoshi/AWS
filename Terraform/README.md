# Terraform + Git + CIでAWSをコード管理
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

- 特徴
   - OSSとして利用ができる
   - プロダクト自体が活発に活動している。機能が次々とリリースされている
   - Infrastructure as Codeとしてクラウドインフラを設定、運用できる
   - PullRequestとReviewのレールにのることができる
   - リソース用途の目的もコメントで残すことが可能
   - 環境を一気にデプロイすることができる
  
