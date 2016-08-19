# knife-ec2


### knife-ec2(動作環境のメモ)
```
# gem list | grep knife
knife-ec2 (0.13.0)
knife-solo (0.6.0)
knife-windows (1.5.0)
```

```
Rubyはrvmでインストール

# ruby -v
ruby 2.2.4p230 (2015-12-16 revision 53155) [x86_64-linux]

# which ruby
/usr/local/rvm/rubies/ruby-2.2.4/bin/ruby

# which gem
/usr/local/rvm/rubies/ruby-2.2.4/bin/gem
```

```
# knife configure
-> 全てデフォルトでファイルを作成してから下記の通りに編集した。

->ChefのendpointはChef
# pwd
/root/.chef

# cat knife.rb
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/root/.chef/admin.pem'
validation_client_name   'dev-validator'
validation_key           '/root/.chef/dev-validator.pem'
chef_server_url          'https://ip-10-0-0-168.ap-northeast-1.compute.internal/organizations/dev'
syntax_check_cache_path  '/root/.chef/syntax_check_cache'
knife[:aws_access_key_id] = "Access-key"
knife[:aws_secret_access_key] = "Secret-key"
```


`# knife ec2 server list --region ap-northeast-1`
```
Instance ID  Name                                    Public IP       Private IP  Flavor    Image         SSH Key        Security Groups  IAM Profile  State
```

`# knife ec2 server create --region ap-northeast-1 --availability-zone <AZ> --flavor <instance-type> --image <iam-id> --subnet <subnet-id> --security-group-ids <SG-id> --ssh-key <key-name>`

