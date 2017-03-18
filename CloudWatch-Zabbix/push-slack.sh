#!/bin/bash

status="$1"

if [ "$status" == 'OK' ]; then
        emoji=':smile:'
elif [ "$status" == 'PROBLEM' ]; then
        emoji=':frowning:'
else
        emoji=':ghost:'
fi

message="$2\n$3"

payload="payload={\"channel\": \"#${CHANNEL_NAME}\", \"username\": \"Zabbix\", \"text\": \"${message}\", \"icon_emoji\": \"${emoji}\"}"

curl -m 5 --data "${payload}" {$SLACK_WEBHOOKURL}
