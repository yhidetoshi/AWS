### User-Data

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-userdata.jpg)

### AWS-CLI & userdataでやっている事

Jenkins(https://github.com/yhidetoshi/AWS/tree/master/Script-For-Jenkins)
からインスタンスを新規作成をビルドすると、AWS-CLIがキックされ、Webコンソールのインスタンスタグに名前と
VPC内容のRoute53にゾーンを指定してAレコードを作成するUserdataを作成した。
※ 機能は随時追加中。

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/set-Name-tag.png)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/set-Route53-1.png)
