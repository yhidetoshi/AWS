# Piculetとは
- rubyで作成されたSecurityGroupをコマンドラインで管理することができるツール。
- PiculetのGitHub
  - https://github.com/codenize-tools/piculet 



# セットアップ
- IAMロールで権限を付与 or  IAMキーを実行環境にセットする

# piculetを使う
- 現在のSGのセットをエクスポートする
- `$ piculet -e -o devSG`
    - `-e(export)`
    - `-o(output)` 
    - `-a(apply)`
    - `--dry-run`

- セキュリティグループを作成する
  - 名前: web
  - bastionのSGから80番接続できるようにする
  - outboundはanyで解放 

```
sg_bastion = "sg-xxxxxx"

security_group "web" do
    description "web"
    tags(
      "Name" => "web"
    )
    ingress do
      permission :tcp, 80..80 do
        groups(
          "#{sg_bastion}"
        )
      end
    end

    egress do
      permission :any do
        ip_ranges(
          "0.0.0.0/0"
        )
      end
    end
  end
```
- Memo
  - groups: SecurityGroupを指定するときに使う
  - ip_ranges: IP(range)を指定するときに使う
  - `"#{sg_bastion}"`: 定数として使える `sg_bastion = "sg-xxxxx"`



- dry-run実行する
  - `piculet -a --dry-run -f SGdev`

```
Apply `SGdev` to SecurityGroup (dry-run)
Create SecurityGroup: vpc-xxxxxx > web (dry-run)
Update SecurityGroup: vpc-xxxxxx > web (dry-run)
  tags:
    -{}
    +{"Name"=>"web"} (dry-run)
Create Permission: vpc-xxxxxx > web(ingress) > tcp 80..80 (dry-run)
  authorize sg-xxxxxx (dry-run)
Create Permission: vpc-xxxxxx > web(egress) > any  (dry-run)
  authorize 0.0.0.0/0 (dry-run)
No change
```
- 適用する
  - `piculet -a -f SGdev`

```
Apply `SGdev` to SecurityGroup
Create SecurityGroup: vpc-xxxxxx > web
Update SecurityGroup: vpc-xxxxxx > web
  tags:
    -{}
    +{"Name"=>"web"}
Create Permission: vpc-xxxxxx > web(ingress) > tcp 80..80
  authorize sg-xxxxxx
```  

# まとめ
Piculetを利用すれば、AWSのSecurityGroupをコード管理できる。また、CIと連携すれば自動適用も可能。
Infrastructure as codeとして活用することができる。
