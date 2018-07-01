# Ansible

### AnsibleをAWS環境で使う

- 環境
 - Amazon Linux AMI release 2016.09
 - ansible 2.2.1.0

- python3のインスタンスに対して実行する場合 
 - /usr/bin/python がないとerrorになる
 - ansible-playbook -i inventory/dev bastion.yml -C -e 'ansible_python_interpreter=/usr/bin/python3'
 
 
 
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


### 検証メモ(グローバル変数とenv変数使う場合) 
あとできれいにまとめなおします...
```
# グローバル変数の参照を検証する

- Macローカル
ssh vagrant@192.168.33.10

## ディレクトリ構成
.
├── group_vars
│   ├── all
│   │   └── mian.yml
│   ├── env_dev
│   │   └── main.yml
│   └── env_stg
│       └── main.yml
├── inventory
│   └── dev
├── roles
│   ├── test-server_all-var
│   │   ├── README.md
│   │   ├── defaults
│   │   │   └── main.yml
│   │   ├── handlers
│   │   │   └── main.yml
│   │   ├── meta
│   │   │   └── main.yml
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   └── tests
│   │       ├── inventory
│   │       └── test.yml
│   └── test-server_var-child
│       ├── README.md
│       ├── defaults
│       │   └── main.yml
│       ├── handlers
│       │   └── main.yml
│       ├── meta
│       │   └── main.yml
│       ├── tasks
│       │   └── main.yml
│       ├── templates
│       └── tests
│           ├── inventory
│           └── test.yml
├── sampleserver-child.yml
├── sampleserver.retry
└── sampleserver.yml


#################################
## group_vars/allの変数を使う場合 ##
#################################

# allで定義した変数
- `group_vars/all/main.yml`
---
hello: hello


# 実行時に指定するインベントリファイル
- `❯❯❯ inventory/dev`
[dev_sample-server]
192.168.33.10

[env_dev:children]
dev_sample-server


# 実行タスクを指定
- `❯❯❯ cat sampleserver.yml`
- hosts: dev_sample-server
  user: vagrant
  become_method: sudo
  gather_facts: yes
  roles:
    - test-server_all-var

# playbook roleで定義したタスク
- `roles/test-server_all-var/tasks `
- `❯❯❯ cat main.yml`
---
- name: Create file
  command: touch /tmp/{{ hello }}   # -------> `all/main.ymlのhelloを参照できる`
  become: yes


#################################
## group_vars/allの変数を使う場合 ##
#################################

- `group_vars/env_dev/main.yml`
---
env: dev
hellochild: hello-child

- `cat sampleserver-child.yml`

- hosts: dev_sample-server
  user: vagrant
  become_method: sudo
  gather_facts: yes
  roles:
    - test-server_var-child


`roles/test-server_var-child/tasks/main.yml`

---
- name: Create file
  command: touch /tmp/{{ hellochild }}
  become: yes`



❯❯❯ ansible-playbook sampleserver-child.yml -i inventory/dev --ask-pass
SSH password:

PLAY [dev_sample-server] *************************************************************************************************

TASK [Gathering Facts] ***************************************************************************************************
ok: [192.168.33.10]

TASK [test-server_var-child : Create file] *******************************************************************************
 [WARNING]: Consider using the file module with state=touch rather than running touch.  If you need to use command
because file is insufficient you can add warn=False to this command task or set command_warnings=False in ansible.cfg to
get rid of this message.

changed: [192.168.33.10]

PLAY RECAP ***************************************************************************************************************
192.168.33.10              : ok=2    changed=1    unreachable=0    failed=0

~/T/Ansible ❯❯❯ ssh vagrant@192.168.33.10
vagrant@192.168.33.10's password:
Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.4.0-87-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

0 packages can be updated.
0 updates are security updates.


Last login: Thu May 31 09:16:06 2018 from 192.168.33.1
vagrant@vagrant:~$ ls /tmp/
hello  hello-child
```

- `→ /tmp配下にそれぞれ、allとenv_devに定義している変数を参照した。`

