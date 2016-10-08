![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/chef-aws.png)

# Chef12



![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-infra-config.png)

- 環境(AWS-VPC)
  - Chef-Server/Workstation
    - `# cat /etc/system-release`
    - Amazon Linux AMI release 2016.03
    - t2.microだとメモリ不足で死んだ...
    - t2.samll
    - 10.0.0.39
  - Chef-Client
    - t2.micro 
    - Amazon Linux AMI release 2016.03
  - Nginx
    - t2.micro
    - CentOS6.8
  - Ops-Server(Jenkins...etc)
    - t2.micro
    - CentOS6.8

### Chef-Server12/knife

- Chefの公式サイトからダウンロードする：https://downloads.chef.io/
```
# wget https://packages.chef.io/stable/el/6/chef-server-core-12.8.0-1.el6.x86_64.rpm

# rpm -ivh chef-server-core-12.8.0-1.el6.x86_64.rpm
```

- 名前解決の周りを設定する
  - `/etc/hosts`にec2のprivate_ipとPublic_dns名を登録。
  - `ip-10-0-0-39.ap-northeast-1.compute.internal`
  - `hostname`を登録
    - `# hostname ip-10-0-0-39.ap-northeast-1.compute.internal` 
    - `/etc/sysconfig/network`
      - HOSTNAME=ip-10-0-0-39.ap-northeast-1.compute.internal 


- Chef-serverのセットアップ
```
# chef-server-ctl reconfigure
```

- testを実行して動作確認する
  - # chef-server-ctl test
```
Starting Pedant Run: 2016-08-16 03:02:08 UTC
 _______  _______  _______  _______  _______  ______   _______
|       ||       ||       ||       ||       ||      | |       |
|   _   ||    _  ||  _____||       ||   _   ||  _    ||    ___|
|  | |  ||   |_| || |_____ |       ||  | |  || | |   ||   |___
|  |_|  ||    ___||_____  ||      _||  |_|  || |_|   ||    ___|
|       ||   |     _____| ||     |_ |       ||       ||   |___
|_______||___|    |_______||_______||_______||______| |_______|

     _______  _______  ______   _______  __    _  _______
    |       ||       ||      | |   _   ||  |  | ||       |
    |    _  ||    ___||  _    ||  |_|  ||   |_| ||_     _|
    |   |_| ||   |___ | | |   ||       ||       |  |   |
    |    ___||    ___|| |_|   ||       ||  _    |  |   |
    |   |    |   |___ |       ||   _   || | |   |  |   |
    |___|    |_______||______| |__| |__||_|  |__|  |___|

                    "Accuracy Over Tact"

                  === Testing Environment ===
                 Config File: /var/opt/opscode/oc-chef-pedant/etc/pedant_config.rb
       HTTP Traffic Log File: /var/log/opscode/oc-chef-pedant/http-traffic.log
```
-> faild 0と出ていれば問題なし


Chef12ではchef-server-ctlコマンドで鍵を生成する。マルチテナントに対応している
```
# chef-server-ctl user-create admin hidetoshi yajima <E-mail> '<password>' --filename /root/.chef/admin.pem

# chef-server-ctl org-create dev developer --association_user admin --filename /etc/chef/dev-validator.pem

* chef-server-ctlコマンドは別途、調べる
```

- knifeコマンドを使えるように下記を実行する
  - `# curl -L https://www.opscode.com/chef/install.sh | bash`

- knife.rbとclient.rbの設定
  - # knife configure
    - `/root/.chef`配下に二つを設置

【client.rb】
```
log_level              :info
log_location           /var/log/chef-client.log
chef_server_url 'https://ip-10-0-0-39.ap-northeast-1.compute.internal/organizations/prod'
validation_client_name 'prod-validator'
validation_key         '/etc/chef/validator.pem'
#ssl_verify_mode        :verify_none
```



【knife.rb】
```
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/root/.chef/admin.pem'
validation_client_name   'dev-validator'
validation_key           '/etc/chef/dev-validator.pem'
chef_server_url          'https://ip-10-0-0-168.ap-northeast-1.compute.internal/organizations/dev'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
```


**[ユーザ確認]**
```
# knife user list
admin
```

**[Chef-Serverに対するNodeを追加]**
```
# knife bootstrap <target_ip> -x <user> -P <password>

※ Clinet側でchef-server-urlが引けないとconnectionエラーになる
```


**[Node(Client)の確認]**
```
# knife node list
ip-10-0-1-150
```

**[knifeコマンドでノード情報を確認できる]**
```
# knife node show ip-10-0-1-150
- - -
Node Name:   ip-10-0-1-150
Environment: _default
FQDN:
IP:          10.0.1.150
Run List:    recipe[wget]
Roles:
Recipes:     wget, wget::default
Platform:    amazon 2016.03
Tags:
- - -
```

#### Chef-serverのレシピをClientに配布してcookbookを実行する
```
(Chef-Server側)
# export EDITOR=vim
# knife cookbook upload httpd -o /root/chef-repo/cookbooks
```


```
# knife node edit ip-10-0-1-32
- - - 
{
  "name": "ip-10-0-1-32",
  "chef_environment": "_default",
  "normal": {
    "tags": [

    ]
  },
  "policy_name": null,
  "policy_group": null,
  "run_list": [
  "recipe[httpd]"
]
- - - 
```

#### Client側でapacheをインストールするcookbookを実行
```
# chef-client
- - - 
Starting Chef Client, version 12.13.37
resolving cookbooks for run list: ["httpd"]
Synchronizing Cookbooks:
  - httpd (0.1.0)
Installing Cookbook Gems:
Compiling Cookbooks...
Converging 2 resources
Recipe: httpd::default
  * yum_package[httpd] action install
    - install version 2.2.31-1.8.amzn1 of package httpd
  * service[httpd] action enable
    - enable service service[httpd]
  * service[httpd] action start
    - start service service[httpd]

Running handlers:
Running handlers complete
Chef Client finished, 3/3 resources updated in 03 seconds
- - - 
```

#### Web-UIをインストール/ログイン
-> runlistにwgetを追加した。
```
# chef-server-ctl install opscode-manage
# opscode-manage-ctl reconfigure
```
-　ログイン情報前にアカウントを作った時に指定したユーザ名とパスワードを利用する。
```
# chef-server-ctl user-create USER_NAME FIRST_NAME LAST_NAME EMAIL 'PASSWORD' --filename FILE_NAME
# chef-server-ctl org-create short_name 'full_organization_name' --association_user USER_NAME --filename
```

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/chef-login.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/chef-webui-node.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/chef-webui-runlist.png)

- Nginx + Jenkinsのレシピを追加してみた(ChefのWebコンパネを利用して)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/chef-jenkins.png)
