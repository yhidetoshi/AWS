## Jenkins Github連携(AWS-CLI実行用)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/github-jenkins-icon.png)

(画像URL:https://goo.gl/P3rhcy)

## Github連携(サブディレクトリの指定)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/Jenkins-Github-config-pic.png)

### Jenkinsのworkspaceを変更

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/Jenkins-change-workspace.png)



## Instanceを作成する
```
(Jenkinsビルド)-->(githubからgit cloneして)-->(AWS-CLIをキック)-->インスタンス作成
```
- ビルド(シェルの実行)の設定
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/Jenkins-change-workspace.png)

**`create-instance.sh`**
```
aws ec2 run-instances --image-id ami-374db956 --count 1 --region ap-northeast-1 --instance-type t2.nano
```


## パラメータビルドでinstance-idを指定して停止させる
(流れ)
```
(Jenkinsビルド)-->(githubからgit cloneして)-->(AWS-CLIをキック(id指定))-->インスタンス停止
```
- ビルドパラメータの設定
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-jenkins-buildparameter.png)

- ビルド(シェルの実行)の設定
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-jenkins-stop-build.png)

- シェルスクリプトの中身

**`stop-instance.sh`**
```
EC2_ID="$2"
aws ec2 stop-instances --region ap-northeast-1 --instance-ids ${EC2_ID}
```

- Jenkins(コンソール出力結果)
```
Started by user yajima
Building in workspace /var/lib/jenkins/workspace/Stop-Instance
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/yhidetoshi/AWS # timeout=10
Fetching upstream changes from https://github.com/yhidetoshi/AWS
 > git --version # timeout=10
 > git fetch --tags --progress https://github.com/yhidetoshi/AWS +refs/heads/*:refs/remotes/origin/*
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 7f6096eb86870ae5aed3f2dc4d838f6d5a477ec6 (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 7f6096eb86870ae5aed3f2dc4d838f6d5a477ec6
 > git rev-list 8f36634d3158537c3030fed258c6a82775dd6c59 # timeout=10
[Stop-Instance] $ /bin/sh -xe /tmp/hudson2899307456381419966.sh
+ export WORKSPACE
+ sudo sh -x /var/lib/jenkins/workspace/Stop-Instance/Script-For-Jenkins/stop-instance.sh --instance-ids i-xxxxxxx
+ EC2_ID=i-xxxxxxx
+ aws ec2 stop-instances --region ap-northeast-1 --instance-ids i-xxxxxxx
{
    "StoppingInstances": [
        {
            "InstanceId": "i-xxxxxxx",
            "CurrentState": {
                "Code": 64,
                "Name": "stopping"
            },
            "PreviousState": {
                "Code": 16,
                "Name": "running"
            }
        }
    ]
}
Finished: SUCCESS
```

## パラメータビルドでinstance-idを指定して開始させる

(流れ)
```
(Jenkinsビルド)-->(githubからgit cloneして)-->(AWS-CLIをキック(id指定))-->インスタンス開始
```

- ビルドパラメータの設定
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-jenkins-buildparameter.png)

- Githubの設定
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/jenkins-start-cli.png)

- ビルド(シェルの実行)の設定
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/jenkins-start-build.png)

- **start-instance.sh**

```
EC2_ID="$2"
aws ec2 start-instances --region ap-northeast-1 --instance-ids ${EC2_ID}
```


- Jenkins(コンソール出力結果)
```
Started by user yajima
Building in workspace /var/lib/jenkins/workspace/Start-Instance
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/yhidetoshi/AWS # timeout=10
Fetching upstream changes from https://github.com/yhidetoshi/AWS
 > git --version # timeout=10
 > git fetch --tags --progress https://github.com/yhidetoshi/AWS +refs/heads/*:refs/remotes/origin/*
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 1b5fc91d1ea6f4a4c42ecbd0bef9564bbca2057b (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 1b5fc91d1ea6f4a4c42ecbd0bef9564bbca2057b
 > git rev-list 1b5fc91d1ea6f4a4c42ecbd0bef9564bbca2057b # timeout=10
[Start-Instance] $ /bin/sh -xe /tmp/hudson2908850958915652826.sh
+ export WORKSPACE
+ sudo sh -x /var/lib/jenkins/workspace/Start-Instance/Script-For-Jenkins/start-instance.sh --instance-ids i-xxxxxxx
+ EC2_ID=i-xxxxxxx
+ aws ec2 start-instances --region ap-northeast-1 --instance-ids i-xxxxxxx
{
    "StartingInstances": [
        {
            "InstanceId": "i-xxxxxxx",
            "CurrentState": {
                "Code": 0,
                "Name": "pending"
            },
            "PreviousState": {
                "Code": 80,
                "Name": "stopped"
            }
        }
    ]
}
Finished: SUCCESS
```

## パラメータビルドでinstance-idを指定して削除させる
※ 設定は他と同じ
(流れ)
```
(Jenkinsビルド)-->(githubからgit cloneして)-->(AWS-CLIをキック(id指定))-->インスタンス削除
```

- Jenkins(コンソール出力結果)
```
Started by user yajima
Building in workspace /var/lib/jenkins/workspace/Terminate-Instance
Cloning the remote Git repository
Cloning repository https://github.com/yhidetoshi/AWS
 > git init /var/lib/jenkins/workspace/Terminate-Instance # timeout=10
Fetching upstream changes from https://github.com/yhidetoshi/AWS
 > git --version # timeout=10
 > git fetch --tags --progress https://github.com/yhidetoshi/AWS +refs/heads/*:refs/remotes/origin/*
 > git config remote.origin.url https://github.com/yhidetoshi/AWS # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config remote.origin.url https://github.com/yhidetoshi/AWS # timeout=10
Fetching upstream changes from https://github.com/yhidetoshi/AWS
 > git fetch --tags --progress https://github.com/yhidetoshi/AWS +refs/heads/*:refs/remotes/origin/*
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 1db0c95da337847e6ce9b65cec20476c0bce75d3 (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 1db0c95da337847e6ce9b65cec20476c0bce75d3
First time build. Skipping changelog.
[Terminate-Instance] $ /bin/sh -xe /tmp/hudson7271717192559596842.sh
+ export WORKSPACE
+ sudo sh -x /var/lib/jenkins/workspace/Terminate-Instance/Script-For-Jenkins/terminate-instance.sh --instance-ids i-d7534248
+ EC2_ID=i-d7534248
+ aws ec2 terminate-instances --region ap-northeast-1 --instance-ids i-d7534248
{
    "TerminatingInstances": [
        {
            "InstanceId": "i-d7534248",
            "CurrentState": {
                "Code": 32,
                "Name": "shutting-down"
            },
            "PreviousState": {
                "Code": 16,
                "Name": "running"
            }
        }
    ]
}
Finished: SUCCESS
```

## Jenkins APIを外部からコールしてビルドする
-  Jenkinsのリポジトリでも少しまとめてる
  - https://github.com/yhidetoshi/Jenkins#jenkinsのapiを使って見る

- ビルド
 - `$ curl -X POST --user <アカウント>:<トークン> http://<jenkins-name>/job/<job-name>/build`

- パラメータ付きビルド
 - `$ curl -X POST --user <アカウント>:<トークン> http://<jenkins-name>/job/<job-name>/buildWithParameters?<parameter_name>=<instance_id>`
