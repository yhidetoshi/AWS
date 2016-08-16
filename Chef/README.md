# Chef12

- 環境
  - Chef-Server/Workstation 
    - `# cat /etc/system-release`
    - Amazon Linux AMI release 2016.03
    - t2.microだとメモリ不足で死んだ...
    - t2.samll
  - Chef-Client
    - Amazon Linux AMI release 2016.03
    - t2.micro

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
# chef-server-ctl user-create admin <First_Name> <Last_name> <E-mail> password --filename /root/.chef/admin.pem
# chef-server-ctl org-create <Org_name> production --association_user admin --filename /etc/chef/<Org_name>-validator.pem
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
client_key               '/etc/chef/admin.pem'
validation_client_name   'prod-validator'
validation_key           '/etc/chef/prod-validator.pem'
chef_server_url          'https://ip-10-0-0-39.ap-northeast-1.compute.internal/organizations/prod'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
#ssl_verify_mode          :verify_none
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
ip-10-0-1-32
```
