#!/bin/bash
#exec tail -f /data/opencanary.log &

OPENCANARY_NODE_ID=${OPENCANARY_NODE_ID:-$(hostname -f)}

sed -i "s/device\.node_id.*/device\.node_id\": \"$OPENCANARY_NODE_ID\",/" /root/.opencanary.conf

source /opt/opencanary/virtualenv/bin/activate && opencanaryd --start

exec bash -c 'while true; do sleep 5; done'
