#!/bin/sh
etcd_url="http://{{ master_ip }}:{{ etcd.port}}"
pod_subnet="{{ network.pod_subnet }}"
while [ $(curl -fs "${etcd_url}/v2/machines" 2>&1 1>/dev/null; echo $?) != 0 ]
do
  sleep 1
done
