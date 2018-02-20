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


`# cat /etc/fstab`

```
LABEL=/     /           ext4    defaults,noatime  1   1
tmpfs       /dev/shm    tmpfs   defaults        0   0
devpts      /dev/pts    devpts  gid=5,mode=620  0   0
sysfs       /sys        sysfs   defaults        0   0
proc        /proc       proc    defaults        0   0
/root/go/bin/goofys#aq-test-mount /root/test-mount fuse defaults 0  0
```

### マウントされているかを確認
`# df -h`

```
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        488M   56K  488M   1% /dev
tmpfs           498M     0  498M   0% /dev/shm
/dev/xvda1      7.8G  1.5G  6.2G  20% /
aq-test-mount   1.0P     0  1.0P   0% /root/test-mount
```

