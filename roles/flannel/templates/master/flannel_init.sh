#!/bin/sh
[[ -f /var/lib/flannel/subnet.env ]] && rm /var/lib/flannel/subnet.env
etcd_url="http://{{ master_ip }}:{{ etcd.port}}"
pod_subnet="{{ network.pod_subnet }}"
while [ $(curl -fs "${etcd_url}/v2/machines" 2>&1 1>/dev/null; echo $?) != 0 ]
do
  sleep 1
done

network_config=$(cat <<EOT
{
  "Network": "${pod_subnet}",
  "Backend": {
     "Type": "host-gw"
  }
}
EOT
)
echo "Setting network config for flannel: "
/usr/bin/etcdctl \
   --endpoint ${etcd_url} \
  set /coreos.com/network/config "${network_config}"
