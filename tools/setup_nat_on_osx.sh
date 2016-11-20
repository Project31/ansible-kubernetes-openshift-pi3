#!/bin/sh

if [[ "$#" -ne 2 ]]; then
  cat <<EOT
Usage: setup_os_on.sh <external interface> <internal interface>

external-interface: The interface with which your Mac is
                    connected to the internet (e.g. "en3")
internal-interface: The interface used to connect to your cluster
                    (e.g. "en0")

Check the interfaces with "ifconfig -a"
EOT
exit 1
fi

nat_rules=/tmp/nat_rules_$$.txt

sudo sysctl -w net.inet.ip.forwarding=1
sudo sysctl -w net.inet.ip.fw.enable=1

echo "nat on ${1} from ${2}/24 to any -> (${1})" >> ${nat_rules}

sudo pfctl -d #disables pfctl
sudo pfctl -F all #flushes all pfctl rules
sudo pfctl -f ${nat_rules} -e #starts pfctl and loads the rules from the nat-rules file

#rm ${nat_rules}
