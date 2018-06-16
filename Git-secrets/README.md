# git-secrets


## インストール
- install
  - 端末: Mac
  - 手順
    - `$ brew install git-secrets`
    - `$ curl -O https://raw.githubusercontent.com/awslabs/git-secrets/master/git-secrets`
    - `$ chmod +x ./git-secrets`
    - `$ git secrets --register-aws --global`

- .gitconfigを確認
  - `~/.gitconfig`
  - 許可するAWSの鍵が定義されている

## 動作確認1(手動スキャンでチェックする)
- `$ git secrets --scan --no-index`
```
[ERROR] Matched one or more prohibited patterns
```

## 動作確認2(commit時に自動チェックする)
- `$ git secrets --install`
```
✓ Installed commit-msg hook to .git/hooks/commit-msg
✓ Installed pre-commit hook to .git/hooks/pre-commit
✓ Installed prepare-commit-msg hook to .git/hooks/prepare-commit-msg
~/hoge ❯❯❯ ls
test-key
~/hoge ❯❯❯ git add test-key
~/hoge ❯❯❯ git commit -m "test key check"

[ERROR] Matched one or more prohibited patterns
```
