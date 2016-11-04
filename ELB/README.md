# ELB

- ELBの使い方
- LetsEncryptでSSL化



### LetsEncryptでSSL証明書を利用する

- LetsEncryptでSSLを設置する
- 環境
  - Amazon Linux AMI release 2016.09
  - WebサーバはNginx
  - Python 2.7.12
  ※ Pythonのバージョンは2.7以上である必要がある
  
  
#### LetsEncryptで証明書を作成する  
```
# cd /usr/local/src/
# git clone https://github.com/letsencrypt/letsencrypt.git
```

```
- Amazon_Linuxだと--debugが必要。
# ./letsencrypt-auto --help --debug


# ./letsencrypt-auto certonly -a standalone  -d j <My-domain> --agree-tos -m <My-Email>

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/<My-domain>/fullchain.pem. Your
   cert will expire on 2017-02-02. To obtain a new or tweaked version
   of this certificate in the future, simply run letsencrypt-auto
   again. To non-interactively renew *all* of your certificates, run
   "letsencrypt-auto renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/LetsEnc-result1.png)


- 生成されたLetsEncryptのディレクトリ構成(一部省略)
```
letsencrypt/
├── accounts
│   └── 
│       
├── archive
│   └── <My-domain>
│       ├── cert1.pem
│       ├── chain1.pem
│       ├── fullchain1.pem
│       └── privkey1.pem
├── csr
│   └── 0000_csr-certbot.pem
├── keys
│   └── 0000_key-certbot.pem
├── live
│   └── jenkins.hidetoshi.xyz
│       ├── cert.pem -> ../../archive/<My-domain>/cert1.pem
│       ├── chain.pem -> ../../archive/<My-domain>/chain1.pem
│       ├── fullchain.pem -> ../../archive/<My-domain>/fullchain1.pem
│       └── privkey.pem -> ../../archive/<My-domain>/privkey1.pem
└── renewal
    └── <My-domain>.conf
```


- Nginxの設定で生成された証明書を利用するように変更する
```
isten 443 ssl;
ssl_certificate /etc/letsencrypt/live/<My-domain>/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/<My-domain>/privkey.pem;
```

- インスタンス側のSSL設定が完了したので、次にLB側のSSL設定を実施する

1. 対象のLBを選択して、「リスナー」タブを選択
2. ロードバランサのプロトコルにHTTPSを選択
3. インスタンスのプロトコルにHTTPSを選択
4. SSL証明書の変更をクリック
5. 証明書の名前は任意
6. プライベートキーは前に生成した『privkey.pem』を利用
7. パブリックキー証明書は前に生成した『cert.pem』を利用
8. あとはLBに適用しているセキュリティグループにHTTPSを許可

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-LB-fig1.png)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/aws-LB-input-key.png)



