### VM Import/Export


#### ec2のインスタンスをvmdkファイルで取り出すことについてのまとめ

- (利用条件)
  - rootディスク以外にディスクをアタッチしているとExportできない
  - VM Import/ExportはAWSのこの機能を使ってImportしたものしかExportできない。
```
(実際のエラーコード)
→Client.UnsupportedOperation: This instance has multiple volumes attached. Please remove additional volumes. (Service: AmazonEC2; Status Code: 400; Error Code: UnsupportedOperation; Request ID: 38582afe-6723-43e5-a562-d6d2ff85e33d)
```
```
(実際エラーコード)
→Client.NotExportable: Only imported instances can be exported. (Service: AmazonEC2; Status Code: 400; Error Code: NotExportable; Request ID: 84cba107-da4d-4eb0-8c7e-09d43f1edb4a)
```

【実行方法】
exportするインスタンスにログインして下記のコマンドを実行する。
```
ec2-create-instance-export-task --region <region> <instance_id> -e vmware -f vmdk -c OVA -b <bucket_name> --s3-prefix vmexport -O <Access_ID> -W <Secret_Key>
```

【S3の設定】
- S3でバケットを作成して権限を付与する。
- 被付与者に「vm-import-export@amazon.com」と入力し、「リスト」「アップロード/削除」「アクセス許可の表示」にチェックをつける
