# CloudWatch Zabbix

Cloudwatchのメトリクス値をzabbixに取り込む
AWSのマネージドサービスをZabbixで監視するため

- jqのインストールが必要

- Scriptの場所
 - /usr/lib/zabbix/externalscripts

- zabbixユーザのホームdirにaws のkey/credentialを配置

```
# getent passwd | grep zabbix
zabbix:x:498:497:Zabbix Monitoring System:/var/lib/zabbix:/sbin/nologin
```

- zabbixユーザがaws-cliを叩ける必要があるので配置

```
# pwd
/var/lib/zabbix
[root@zabbix-dev zabbix]# ls -alt
合計 12
drwxr-xr-x  3 zabbix zabbix 4096  2月 27 18:35 .
drwxr-xr-x 23 root   root   4096  2月 27 18:34 ..
drwxrwxr-x  2 zabbix zabbix 4096  2月 25 16:07 .aws
```

- Zabbixにスクリプトとして配置
- type：スクリプト
- コマンド / Zabbixサーバで実行
```
./cloudwatch.sh -n AWS/RDS -d Name=DBInstanceIdentifier,Value=beaconnect-db1-rsver -m CPUUtilization -s Maximum
```

- テンプレート -> アイテム
 - タイプ: 外部チェック
 - キー: `cloudwatch.sh["-n AWS/RDS","-d Name=DBInstanceIdentifier,Value=beaconnect-db1-rsver","-m CPUUtilization","-s Maximum"]`
 - データ型: 数値(不動少数点)
 - 更新間隔: 300
