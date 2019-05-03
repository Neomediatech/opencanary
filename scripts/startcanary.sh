#!/bin/bash
#exec tail -f /data/opencanary.log &

source /opt/opencanary/virtualenv/bin/activate && opencanaryd --dev
