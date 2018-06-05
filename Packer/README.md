# Packer

1. Instanceを起動させて、setup.ymlの内容を実行
1. setup.ymlの設定を入れたインスタンスをAMI焼きする
1. AMI焼き様にデプロイされたインスタンスはTerminateされる

- `$ packer build web.json`

- 実行結果の最後部分
```
==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs: AMIs were created:
ap-northeast-1: ami-56d81e29
```
