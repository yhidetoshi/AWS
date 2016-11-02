# Auto_Scaling


## AWS-CLI


**作成済みのASを確認する**

`$ aws autoscaling describe-auto-scaling-groups`


**作成済みのASを作成して発動**
```
aws autoscaling create-auto-scaling-group \
        --launch-configuration-name ${AS_LAUNCH_CONFIG_NAME} \
        --auto-scaling-group-name ${AS_GROUP_NAME} \
        --min-size ${AS_GROUP_MIN} \
        --max-size ${AS_GROUP_MAX} \
        --vpc-zone-identifier "${VPC_SUBNET_ID}"
```



![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as1.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as2.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as3.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as4.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as5.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as6.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as7.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as8.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as9.png)
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as10.png)

- **【Auto_Scalingの値を1にしたのでインスタンスが作成される】**
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as11.png)

- **【Auto_Scalingの値を0にしたのでインスタンスが削除される】**
![Alt Text](https://github.com/yhidetoshi/Pictures/raw/master/aws/as12.png)

