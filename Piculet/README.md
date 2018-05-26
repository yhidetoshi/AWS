# Piculet

- rubyのDSLで記述して、SecurityGroupを管理できる

## piculetをインストール
- `$ gem install piculet --no-ri --no-rdoc`

## 使い方
- vpc単位でエクスポート
  - `$ piculet -e --ec2s vpc-12345678 -o ファイル名`
- Dryrun(vpcを指定して実行する場合 指定しない場合は書かない)
  - `$ piculet -a --dry-run -r ap-northeast-1 -f ファイル名 --ec2s vpc-12345678`
-  実行
  - $ piculet -a -r ap-northeast-1 -f ファイル名 --ec2s vpc-12345678`

- exportできる(すべてのVPCを含む)
  - `$ piculet -e -r ap-northeast-1 > Groupfile`
  - `$ piculet --apply -r ap-northeast-1  --dry-run --file dev`

### コマンドオプション
```
-r(--region) リージョン名
--> リージョンを指定します

-e(--export)
セキュリティグループの設定を標準出力にエクスポート
--> -o(--output) ファイル名

エクスポートするファイル名を指定
--> -a(--apply)

Groupfileの設定をAWSに適用
--> --dry-run
AWSへの適用は行わず、適用内容のみ出力
```
