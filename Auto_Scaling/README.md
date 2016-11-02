# Auto_Scaling


## AWS-CLI


**作成済みのASを確認する**

`$ aws autoscaling describe-auto-scaling-groups`


**作成済みのASを作成して発動**
```
$ aws autoscaling create-auto-scaling-group \
        --launch-configuration-name ${AS_LAUNCH_CONFIG_NAME} \
        --auto-scaling-group-name ${AS_GROUP_NAME} \
        --min-size ${AS_GROUP_MIN} \
        --max-size ${AS_GROUP_MAX} \
        --vpc-zone-identifier "${VPC_SUBNET_ID}"
```

**AutoScalingのアクティビティ履歴を参照**

- `--max-items`：いくつまでさかのぼって表示するか(valueは1,2....) 
```
aws autoscaling describe-scaling-activities \
        --auto-scaling-group-name ${AS_GROUP_NAME} \
        --max-items ${MAX_ITEMS}
```



