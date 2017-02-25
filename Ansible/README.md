# Ansible

### AnsibleをAWS環境で使う

- 環境
 - Amazon Linux AMI release 2016.09
 - ansible 2.2.1.0

- ssh-keyの登録
- ユーザ作成

- Route53の設定
- s3の設定
- CloudWatchの設定
 - RDSの監視
- zabbixとcloudwatchメトリクスの連携をAnsibleで 



- Amazon Linux AMI release 2016.09
- Ansible:  2.2.1.0

**ansible-galaxyでロールを生成**
```
$ tree .
.
├── roles
│   └── zabbix-agent
│       ├── README.md
│       ├── defaults
│       │   └── main.yml
│       ├── files
│       ├── handlers
│       │   └── main.yml
│       ├── meta
│       │   └── main.yml
│       ├── roles
│       ├── tasks
│       │   └── main.yml
│       ├── templates
│       │   └── zabbix_agentd.conf.j2
│       ├── tests
│       │   ├── inventory
│       │   └── test.yml
│       └── vars
│           └── main.yml
├── za-client.yml
└── za-hosts
```

**対象のサーバへsshできる環境を準備する**
```
Host <ip_address>
  HostName <host_name>
  User ec2-user
  IdentityFile ~/.ssh/<key_name>

Host <hostname>
  HostName <hostname>
  User ec2-user
  IdentityFile ~/.ssh/<key_name>
```


**実行結果**
```
]$ ansible-playbook za-client.yml -i za-hosts

PLAY [install zabbix-agent] ****************************************************

TASK [setup] *******************************************************************
ok: [172.31.14.124]

TASK [zabbix-agent : install zabbix-agent] *************************************
ok: [172.31.14.124]

TASK [zabbix-agent : set config and restart] ***********************************
ok: [172.31.14.124]

TASK [zabbix-agent : auto-on] **************************************************
changed: [172.31.14.124]

PLAY RECAP *********************************************************************
172.31.14.124              : ok=4    changed=1    unreachable=0    failed=0
```

**OSの違いを判定して処理する**
```
   #when: "ansible_os_family == 'Debian'"
   when: "ansible_distribution == 'Amazon'"
```