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
