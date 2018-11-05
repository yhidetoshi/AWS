# Roadworkerとは
- rubyで作成されたRoute53をコマンドラインで管理することができるツール。
- Route53のGitHub
  - https://github.com/codenize-tools/roadworker 

# セットアップ
- IAMロールで権限を付与 or  IAMキーを実行環境にセットする

# Roadworkerを使う
- `-e(export)`
- `-o(output)` 
- `-a(apply)`
- `--dry-run`


- `Route53dev`
  - 作りたいもの
      - vpc internal dns( Route53 )
      - ローカルドメイン: hide.internal.local  
      - subnet ( 10.0.1.0/24 ) 
      - 1aと1cでそれぞれループを回してAレコードを作成する
      - az-1a ( 10.0.1.5 〜 10.0.1.126 ) 
      - az-1c ( 10.0.1.127 〜 10.0.1.254 )
         - `「%03d」`を指定した場合は対応する値を「10進数の数値で幅を3桁にし0詰めにする」


- Route53dev

```
internal_zone = "hide.internal.local"
cidr_prefix = "10.0"
vpc_id = "vpc-xxxxx"
aws_region = "ap-northeast-1"

hosted_zone internal_zone do
  vpc "#{aws_region}", "#{vpc_id}"

  rrset "bastion.#{internal_zone}", "A" do
    ttl 300
    resource_records(
    	"#{cidr_prefix}.1.4"
    )
  end

  (5..126).each do |num|
    rrset "web#{sprintf('%03d', num)}.#{internal_zone}", "A" do
      ttl 300
      resource_records(
      	"#{cidr_prefix}.1.#{num}"
      )
    end
  end
  (126..254).each do |num|
    rrset "web#{num}.#{internal_zone}", "A" do
      ttl 300
      resource_records(
      	"#{cidr_prefix}.1.#{num}"
      )
    end
  end
end
```

- 実行結果(抜粋)
  - `$ roadwork -a -f Route53dev`

```
Apply `Route53dev` to Route53
Create ResourceRecordSet: bastion.hide.internal.local A
Create ResourceRecordSet: web005.hide.internal.local A
Create ResourceRecordSet: web006.hide.internal.local A
Create ResourceRecordSet: web007.hide.internal.local A
(省略)
Create ResourceRecordSet: web251.hide.internal.local A
Create ResourceRecordSet: web252.hide.internal.local A
Create ResourceRecordSet: web253.hide.internal.local A
Create ResourceRecordSet: web254.hide.internal.local A
```


