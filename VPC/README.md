### VPC

##### VPCを作成してpublic/privateセグメントをきりNATゲートウェイを利用する手順

0. VMデプロイ時に設置する鍵を作成する
 - <Key_name>

1. VPCを作成する
 - 10.0.0.0/16 (VPC)
   - 10.0.0.0/24 (sub-pub)
   - 10.0.1.0/24 (sub-pri)

2. Security-Groupを作成する
 - sub-pub-hy (10.0.0.0/24)
 - sub-pri-hy (10.0.1.0/24)

3. Internet-Gatewayを作成する
  - <Gateway_name>

4. VPCにアタッチする
 - vpc-2a22354f (10.0.0.0/16) | dev_yajima

5. Route Tableを設定する
 - デフォルトで作成されているルートテーブルをプライベートサブネット用に利用
  - 10.0.1.0/24 (sub-pri)
 - Create Route Table
  - for-subpub-hy
   - 0.0.0.0/0 <igw-id>
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
