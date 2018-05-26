# Roadworker

## install 
- `gem install roadworker --no-ri --no-rdoc`

## 実行例
- dry-run
  - `❯❯❯ roadwork --dry-run -a -f Routefile`
```
 Apply `Routefile` to Route53 (dry-run)
 Create ResourceRecordSet: hoge1.fuga.local A (dry-run)
 No change
```

 - 適用
 `❯❯❯ roadwork -a -f Routefile`
```
 Apply `Routefile` to Route53
 Create ResourceRecordSet: hoge1.fuga.local A
 ```
