require 'rubygems'
require 'yaml'
#require 'aws-sdk'
require 'aws-sdk-v1'

AWS.config(
  :access_key_id => 'xxxx',
    :secret_access_key => 'yyyyy')

s3 = AWS::S3.new

### bucketを作成 ###
 bucket_name = '<bucket_name>'
 s3.buckets.create bucket_name unless s3.buckets[bucket_name].exists?

### show list bucket ###
 s3.buckets.each do |bucket|
 puts bucket.name
 end

