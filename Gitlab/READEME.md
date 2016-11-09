### GitLab

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/gitlab-icon.png)

- installメモ
 - 環境：CentOS release 6.8 (Final)
```
# yum install curl openssh-server openssh-clients postfix cronie
# service postfix start
# chkconfig postfix on
# lokkit -s http -s ssh

# curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
# yum install gitlab-ce
```
- `/etc/gitlab/gitlab.rb`
 - 既存のNginxを利用してリバプロする
 - 接続のFQDN
 - time_zone
 - GitLab Unicorn
 - GitLab PostgreSQL
--> configは `https://github.com/yhidetoshi/AWS/blob/master/Gitlab/gitlab.rb` に設定

- 既存Nginxのリバプロ設定
  - 

- 設定をembeddedのChefが実行されて処理される
```
# gitlab-ctl reconfigure
```
