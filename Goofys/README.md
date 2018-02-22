# S3について

# goofys

### goofysを使ってサーバからs3へマウントする

```
# yum install golang fuse -y
# export GOPATH=$HOME/go
# go get github.com/kahing/goofys
# go install github.com/kahing/goofys
# mkdir test-mount
```

ここでAWS-CLIでs3にデータ配置できるように設定を行う
→ config / credentials

```  
# $GOPATH/bin/goofys <BUCKET_NAME> <LOCAL_MOUNT-Path>
```


.bash_profileに下記の1行を追加

```
GOPATH=$HOME/go
```


- (ex) `# cat /etc/fstab`
```
LABEL=/     /           ext4    defaults,noatime  1   1
tmpfs       /dev/shm    tmpfs   defaults        0   0
devpts      /dev/pts    devpts  gid=5,mode=620  0   0
sysfs       /sys        sysfs   defaults        0   0
proc        /proc       proc    defaults        0   0
/root/go/bin/goofys#aq-apiserver-mount /home/ec2-user/api/resource fuse _netdev,allow_other,--dir-mode=0775,--file-mode=0664,--uid=1000,--gid=1000 0 0
```

### マウントされているかを確認
`# df -h`

```
$ df -h
ファイルシス       サイズ  使用  残り 使用% マウント位置
devtmpfs             484M     0  484M    0% /dev
tmpfs                497M     0  497M    0% /dev/shm
tmpfs                497M   13M  484M    3% /run
tmpfs                497M     0  497M    0% /sys/fs/cgroup
/dev/xvda1            50G  2.2G   48G    5% /
aq-apiserver-mount   1.0P     0  1.0P    0% /home/ec2-user/api/resource
tmpfs                100M     0  100M    0% /run/user/1000
```
