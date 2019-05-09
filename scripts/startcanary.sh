#!/bin/bash
#exec tail -f /data/opencanary.log &

HOSTNAME=${HOSTNAME:-$(hostname -f)}

sed -i "s/device\.node_id.*/device\.node_id\": \"$HOSTNAME\",/" /root/.opencanary.conf

source /opt/opencanary/virtualenv/bin/activate && opencanaryd --dev
