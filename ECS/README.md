# README

ALBの配下をコンテナ化するために検証したメモです。


## 構成図(ECSを利用したALB配下のコンテナ環境)
- AWSリソース
  - AutoScaling
  - 起動設定
  - ALB
  - TargetGroup
  - ECR
  - ECS

## ECS-CLI(ecs-cli)インストール
- `$ sudo curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-darwin-amd64-latest`
- `$ sudo chmod +x /usr/local/bin/ecs-cli`
- `$ ecs-cli help`

## ecs-cliをセットアップ&クラスタとタスクをデプロイ

- Profileと鍵をセットする
  - `$ ecs-cli configure profile --profile-name plus-stg --access-key xxxxx --secret-key xxxx`
- `${HOME/.ecs`
- `ls`
```
config      credentials
```

- config
```
version: v1
default: default
clusters:
  default:
    cluster: test-cluseter
    region: ap-northeast-1
    default_launch_type: ""
```

- credentials

```
version: v1
default: test-cluster
ecs_profiles:
  plus-stg:
    aws_access_key_id: XXXXXXXXXXXXX
    aws_secret_access_key: ZZZZZZZZZZZZZZZZZZZZZZZZ
```

-

## ecs-cliを使ってECSにタスク(コンテナ)をデプロイする
- ※ 以下のコマンドはMacのローカルで実施

- `test-cluster` クラスタを作成
    - `ecs-cli up --capability-iam --cluster test-cluster --keypair mykey --instance-type t2.micro --vpc vpc-xxxx --subnets subnet-yyyy,subnet-zzzz --security-group sg-yyy`

- Task(コンテナ)をデプロイ
    - `$ ecs-cli compose up`

```
INFO[0000] Using ECS task definition                     TaskDefinition="xxxx"
INFO[0000] Starting container...                         container=9979c268-feb4-47b1-bce0-4ab8a5882618/frontend-web-dev
INFO[0000] Starting container...                         container=9979c268-feb4-47b1-bce0-4ab8a5882618/backend-api-dev
INFO[0000] Starting container...                         container=9979c268-feb4-47b1-bce0-4ab8a5882618/test-nginx
INFO[0000] Describe ECS container status                 container=9979c268-feb4-47b1-bce0-4ab8a5882618/frontend-web-dev desiredStatus=RUNNING lastStatus=PENDING taskDefinition="xxxx"
INFO[0000] Describe ECS container status                 container=9979c268-feb4-47b1-bce0-4ab8a5882618/test-nginx desiredStatus=RUNNING lastStatus=PENDING taskDefinition="xxxx"
INFO[0000] Describe ECS container status                 container=9979c268-feb4-47b1-bce0-4ab8a5882618/backend-api-dev desiredStatus=RUNNING lastStatus=PENDING taskDefinition="xxxx"
INFO[0006] Started container...                          container=9979c268-feb4-47b1-bce0-4ab8a5882618/frontend-web-dev desiredStatus=RUNNING lastStatus=RUNNING taskDefinition="xxxx"
INFO[0006] Started container...                          container=9979c268-feb4-47b1-bce0-4ab8a5882618/test-nginx desiredStatus=RUNNING lastStatus=RUNNING taskDefinition="xxxx"
INFO[0006] Started container...                          container=9979c268-feb4-47b1-bce0-4ab8a5882618/backend-api-dev desiredStatus=RUNNING lastStatus=RUNNING taskDefinition="xxxx"
```



- コンテナとDocker NWの確認(defaultを利用)
    - `docker network inspect <NETWORK-ID>`

```
[
    {
        "Name": "bridge",
        "Id": "9c2be9f90ab6b51512ac8df13ad66f2573ec100d7c594303233460bfc367c46e",
        "Created": "2018-04-27T08:28:31.196076839Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "411df3c436d1faba2aa1d8ac7d8084e342262e936696fc34cc6ef9f3282750a0": {
                "Name": "xxx-backend-api-dev-dec49483f2dce7ea9501",
                "EndpointID": "f8f85f7a8139dccebdd2041f17dade6c4f9741614998bbd11bef27eb2d0ee9b2",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            },
            "440b14547b20e4df6fe204761ab18da65fc5bc4b8a0dba8ed3cf18f4c5ddaf68": {
                "Name": "xxx-frontend-web-dev-d4f7bcd3ac8af98acb01",
                "EndpointID": "02a60804a782c4fbdd12e6b77f676e168d66019acdd0f09e04d6e844f4f0fa4d",
                "MacAddress": "02:42:ac:11:00:03",
                "IPv4Address": "172.17.0.3/16",
                "IPv6Address": ""
            },
            "61d04a2d21ee51dc2df5e1b19f9b7e2d3a622e27ebf2d25ca2604965db888525": {
                "Name": "xxx-test-nginx-98958dbc97c981e63f00",
                "EndpointID": "12b1c3ebbe230537f545fb6df0a00d748f09c76aed015dd69f6deb254975f462",
                "MacAddress": "02:42:ac:11:00:04",
                "IPv4Address": "172.17.0.4/16",
                "IPv6Address": ""
            }
        },
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
```
