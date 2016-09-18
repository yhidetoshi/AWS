## Jenkins Github連携(AWS-CLI実行用)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/github-jenkins-icon.png)

(画像URL:https://goo.gl/P3rhcy)

## Github連携(サブディレクトリの指定)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/Jenkins-Github-config-pic.png)

### Jenkinsのworkspaceを変更

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/Jenkins-change-workspace.png)



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
