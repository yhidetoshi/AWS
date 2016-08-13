# Chef

- 環境
  - Chef-Server 
    - `# cat /etc/system-release`
    - Amazon Linux AMI release 2016.03
    - t2.microだとメモリ不足で死んだ...
    - t2.samll
  - Workstation
    - Mac OS
  - Chef-Client
    - Amazon Linux AMI release 2016.03

### Chef-Serverのインストール(きれいにまとめなおします....)

- Chefの公式サイトからダウンロードする：https://downloads.chef.io/
```
# wget https://packages.chef.io/stable/el/6/chef-server-core-12.8.0-1.el6.x86_64.rpm

# rpm -ivh <rpm_name>.rpm
```

- 名前解決の周りを設定する
- `/etc/hosts`にec2のprivate_ipとPublic_dns名を登録。
  - `<private_dns>.ap-northeast-1.compute.internal`
- `hostname`を登録
  - `# hostname <private_dns>.ap-northeast-1.compute.interna` 


- Chef-serverのセットアップ
```
# chef-server-ctl reconfigure
# chef-server-ctl test
```

