## AWSについて

### AWSのコードベース管理

#### 自作CLIツール(AWS)
- Go言語版(aws-sdk-go)
  - https://github.com/yhidetoshi/go-awscli-tool
- Python版(boto3)
  - https://github.com/yhidetoshi/python-awscli-tool
- Node.js版(sdk-for-javascript)
  - https://github.com/yhidetoshi/js-awscli-tool


#### Jenkins連携
- aws-sdk-goで作った自作CLIツールで、(ビルドパイプライン)
  - AWS-AutoScalingに自動デプロイ
  - Jenkins経由のオペレーション
    - ELBにインスタンスをでアタッチ・デタッチ
    - EC2/RDSインスタンスの停止・起動・削除
    - AMI焼き・削除・ステータス取得
    - S3のバケットサイズの合計取得/publicバケットの検知など、以下の自作コマンドを使って
    - https://github.com/yhidetoshi/go-awscli-toolのコマンド活用


#### CI連携部分
![Alt Text](https://github.com/yhidetoshi/Pictures/blob/master/Terraform/terrafom-ci-slack.png)

※Terraform　やCI
https://github.com/yhidetoshi/AWS/blob/master/Terraform/README.md

### 検証内容(結構前から更新していません...)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-fig990.png)

