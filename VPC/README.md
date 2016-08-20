## VPC/NATゲートウェイ/NATインスタンス

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/nat-gateway-diagram.png)

(画像参考：http://goo.gl/g8Ypxq)

##### VPCを作成してpublic/privateセグメントをきりNATゲートウェイを利用する手順メモ

0. VMデプロイ時に設置する鍵を作成する

1. VPCを作成する
 - 10.0.0.0/16 (VPC)
    - 10.0.0.0/24 (sub-pub)
    - 10.0.1.0/24 (sub-pri)

2. Security-Groupを作成する
 - sub-pub-hy (10.0.0.0/24)
 - sub-pri-hy (10.0.1.0/24)

3. Internet-Gatewayを作成する
  - [Gateway_name]

4. VPCにアタッチする
 - [vpc-id] (10.0.0.0/16) | [vpc_name]

5. Route Tableを設定する
 - デフォルトで作成されているルートテーブルをプライベートサブネット用に利用
   - 10.0.1.0/24 (sub-pri)
 - Create Route Table
   - for-subpub-hy
     - 0.0.0.0/0 [igw-id]
   - ※ igwからインターネットに抜ける
 - サブネットの関連付けでsub-put-hyをにチェックを入れて保存する


6. VMをそれぞれのサブネットに1台ずつ作成する
 - Dev_Server_hy
   - 10.0.0.232
   - sub-pub-hy
   - Public Adressは使用しない
  
 - Dev_Client_hy
   - 10.0.1.29
   - sub-pri-hy

7. VMにElastic-IPを付与する
 - Dev_Server_hy

8. NATゲートウェイを作成する
 - sub-pub-hy(publicのサブネットを指定)
   - EIPをセット

### NATインスタンス設定
```
- 「インスタンスの選択」 -> 「ネットワーキング」-> 「送信元/送信先の変更チェック」 を 
「Disable」に設定。

- 「ルートテーブル」-> 「ルート」-> (編集) -> 『送信元 : 0.0.0.0/0』『ターゲット:NATインスタンスID』

# diff /etc/sysctl.conf.default /etc/sysctl.conf
< net.ipv4.ip_forward = 0
> net.ipv4.ip_forward = 1

# sysctl -p

# /sbin/iptables -t nat -A POSTROUTING -o eth0 -s 10.0.1.0/24 -j MASQUERADE
# /etc/init.d/iptables save

- Private-subnetのVMから [ping 8.8.8.8] で確認
```
