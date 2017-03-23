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
./cloudwatch.sh -n AWS/RDS -d Name=DBInstanceIdentifier,Value=${DB_NAME} -m CPUUtilization -s Maximum
```

- テンプレート -> アイテム
 - タイプ: 外部チェック
 - キー: `cloudwatch.sh["-n AWS/RDS","-d Name=DBInstanceIdentifier,Value=${DB_NAME}","-m CPUUtilization","-s Maximum"]`
 - データ型: 数値(不動少数点)
 - 更新間隔: 300

- Kinesis
```
- cloudwatch.sh["-n","AWS/Kinesis","-d","Name=StreamName,Value={$KINESIS_STREAM_ID}","-m","GetRecords.IteratorAgeMilliseconds","-s","Average"]
- cloudwatch.sh["-n","AWS/Kinesis","-d","Name=StreamName,Value={$KINESIS_STREAM_ID}","-m","GetRecords.Latency","-s","Average"]
- cloudwatch.sh["-n","AWS/Kinesis","-d","Name=StreamName,Value={$KINESIS_STREAM_ID}","-m","PutRecords.Latency","-s","Average"]
```


#### ELB
- Latency
```
cloudwatch.sh -n AWS/ELB -d Name=LoadBalancerName,Value={$ELB_NAME} -m Latency -s Average
```

 #### Kinesis
 
 - IncomingBytes
```
$ aws cloudwatch get-metric-statistics --namespace AWS/Kinesis --dimension Name=StreamName,Value=${STREAM_NAME} --metric IncomingBytes --statistics Maximum --start-time `date -u -d '9 minutes ago' +%Y-%m-%dT%TZ`  --end-time `date -u +%Y-%m-%dT%TZ`  --period 300
```
- GetRecords.IteratorAgeMilliseconds
```
aws cloudwatch --output json get-metric-statistics --region ap-northeast-1 --period 300 --namespace AWS/Kinesis --dimensions Name=StreamName,Value=${STREAM_NAME} --metric-name GetRecords.IteratorAgeMilliseconds --statistics Maximum  --start-time `date --iso-8601=seconds --date '6 minutes ago'` --end-time `date --iso-8601=seconds --date '1 minutes ago'` | jq -r ".Datapoints[].Maximum"
```

#### ELB
- Latency
```
aws cloudwatch get-metric-statistics --namespace AWS/ELB --dimension Name=LoadBalancerName,Value={$LB_NAME} --metric Latency --statistics Average --start-time `date -u -d '5 minutes ago' +%Y-%m-%dT%TZ` --end-time `date -u +%Y-%m-%dT%TZ` --period 300
```

```
- HTTPCode_Backend_2XX
aws cloudwatch get-metric-statistics --namespace AWS/ELB --dimension Name=LoadBalancerName,Value=LB-NAME --metric HTTPCode_Backend_2XX --statistics Sum --start-time `date -u -d '5 minutes ago' +%Y-%m-%dT%TZ` --end-time `date -u +%Y-%m-%dT%TZ` --period 300

- HTTPCode_Backend_3XX
aws cloudwatch get-metric-statistics --namespace AWS/ELB --dimension Name=LoadBalancerName,Value=LB-NAME --metric HTTPCode_Backend_3XX --statistics Sum --start-time `date -u -d '5 minutes ago' +%Y-%m-%dT%TZ` --end-time `date -u +%Y-%m-%dT%TZ` --period 300

- HTTPCode_Backend_4XX
aws cloudwatch get-metric-statistics --namespace AWS/ELB --dimension Name=LoadBalancerName,Value=LB-NAME --metric HTTPCode_Backend_4XX --statistics Sum --start-time `date -u -d '5 minutes ago' +%Y-%m-%dT%TZ` --end-time `date -u +%Y-%m-%dT%TZ` --period 300

```

#### S3
- BucketSizeBytes
```
aws cloudwatch get-metric-statistics --namespace AWS/S3 --dimension Name=BucketName,Value=<BUCKET_NAME> Name=StorageType,Value=StandardStorage --metric BucketSizeBytes --statistics Average --start-time `date -u -d '1440 minutes ago' +%Y-%m-%dT%TZ` --end-time `date -u +%Y-%m-%dT%TZ` --period 86400
```

- NumberOfObjects
```
$ aws cloudwatch get-metric-statistics --namespace AWS/S3 --dimension Name=BucketName,Value=<BUCKET_NAME> Name=StorageType,Value=AllStorageTypes  --metric NumberOfObjects --statistics Average --start-time `date -u -d '1440 minutes ago' +%Y-%m-%dT%TZ` --end-time `date -u +%Y-%m-%dT%TZ` --period 86400
```


### Zabbix API 
- アクセストークンを発行して、そのトークンをもとに`method`のapiの種類を書いて実行する。
- リクエスト
```
$ curl -X GET -H "Content-Type:application/json-rpc" -d '{"auth":null, "method":"user.login", "id":1, "params":{"user":"Admin", "password":"zabbix"}, "jsonrpc":"2.0"}' http://{DOMAIN}/zabbix/api_jsonrpc.php
```

- レスポンス
```
{"jsonrpc":"2.0","result":"d7a6745fb440ea497d80e14635518377","id":1}
```

- template一覧の取得
```
$ curl -X GET -H "Content-Type:application/json-rpc" -d '{"auth":"d7a6745fb440ea497d80e14635518377", "method":"template.get", "id":1, "params":{"output":"extend"}, "jsonrpc":"2.0"}' http://{DOMAIN}/zabbix/api_jsonrpc.php | jq '.'
```
- レスポンス(一部抜粋)
```
 {
      "proxy_hostid": "0",
      "host": "Template_S3",
      "status": "3",
      "disable_until": "0",
      "error": "",
      "available": "0",
      "errors_from": "0",
      "lastaccess": "0",
      "ipmi_authtype": "0",
      "ipmi_privilege": "2",
      "ipmi_username": "",
      "ipmi_password": "",
      "ipmi_disable_until": "0",
      "ipmi_available": "0",
      "snmp_disable_until": "0",
      "snmp_available": "0",
      "maintenanceid": "0",
      "maintenance_status": "0",
      "maintenance_type": "0",
      "maintenance_from": "0",
      "ipmi_errors_from": "0",
      "snmp_errors_from": "0",
      "ipmi_error": "",
      "snmp_error": "",
      "jmx_disable_until": "0",
      "jmx_available": "0",
      "jmx_errors_from": "0",
      "jmx_error": "",
      "name": "Template_S3",
      "flags": "0",
      "templateid": "10114",
      "description": "",
      "tls_connect": "1",
      "tls_accept": "1",
      "tls_issuer": "",
      "tls_subject": "",
      "tls_psk_identity": "",
      "tls_psk": ""
    }
  ],
```

- ホスト一覧の取得
```
$ curl -X GET -H "Content-Type:application/json-rpc" -d '{"auth":"d7a6745fb440ea497d80e14635518377", "method":"host.get", "id":1, "params":{"output":"extend"}, "jsonrpc":"2.0"}' http://{DOMAIN}/zabbix/api_jsonrpc.php | jq '.'
```


- レスポンス(一部抜粋)
```
{
  "jsonrpc": "2.0",
  "result": [
    {
      "hostid": "10084",
      "proxy_hostid": "0",
      "host": "Zabbix server",
      "status": "0",
      "disable_until": "0",
      "error": "",
      "available": "1",
      "errors_from": "0",
      "lastaccess": "0",
      "ipmi_authtype": "-1",
      "ipmi_privilege": "2",
      "ipmi_username": "",
      "ipmi_password": "",
      "ipmi_disable_until": "0",
      "ipmi_available": "0",
      "snmp_disable_until": "0",
      "snmp_available": "0",
      "maintenanceid": "0",
      "maintenance_status": "0",
      "maintenance_type": "0",
      "maintenance_from": "0",
      "ipmi_errors_from": "0",
      "snmp_errors_from": "0",
      "ipmi_error": "",
      "snmp_error": "",
      "jmx_disable_until": "0",
      "jmx_available": "0",
      "jmx_errors_from": "0",
      "jmx_error": "",
      "name": "Zabbix server",
      "flags": "0",
      "templateid": "0",
      "description": "",
      "tls_connect": "1",
      "tls_accept": "1",
      "tls_issuer": "",
      "tls_subject": "",
      "tls_psk_identity": "",
      "tls_psk": ""
    },
```
