from __future__ import print_function

import urllib
import boto3
import json
import logging
import os

from base64 import b64decode
from urllib2 import Request, urlopen, URLError, HTTPError

ENCRYPTED_HOOK_URL = '{kmsで暗号化した文字列}'
SLACK_CHANNEL = '{#CHANEL_NAME}'  # Enter the Slack channel to send a message to
HOOK_URL = "https://" + boto3.client('kms').decrypt(CiphertextBlob=b64decode(ENCRYPTED_HOOK_URL))['Plaintext']

#logger = logging.getLogger()
#logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    #logger.info("Event: " + str(event))
    #logger = logging.getLoger()
    #logger.setLevel(logging.INFO)
    s3 = boto3.client('s3')

    record = event['Records'][0]
    bucket_name = record['s3']['bucket']['name']
    key = record['s3']['object']['key']
    object = s3.get_object(Bucket = bucket_name, Key = key)

    slack_message = {
        'channel': SLACK_CHANNEL,
        'text': "%s is uploaded %s" % (bucket_name, object)
    }
    req = Request(HOOK_URL, json.dumps(slack_message))
    try:
        response = urlopen(req)
        response.read()
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
