### NginxのAccessログをFluentdでS3に格納する

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/fluentd2-s3.png)

![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/s3-fluentd-pic2.png)

#### 環境 VPC
- 流れ: [public-subnetのVM(fluentd)] -> [private-subnetのVM(fluentd)]-> s3
- https://github.com/yhidetoshi/AWS/tree/master/VPC
- Public-subnet
  - td-agent2(送信側)
    - config : https://github.com/yhidetoshi/AWS/blob/master/Fluentd-s3/td-agent.conf_public-sub 
    - nginxのAccess_log 
      - ltsv　 
- Private-subnet
  - td-agent2(収集側/中継)
    - config : https://github.com/yhidetoshi/AWS/blob/master/Fluentd-s3/td-agent.conf_private-sub
  - s3のBucketに送信
