#!/bin/sh

if [[ "$#" -ne 2 ]]; then
  cat <<EOT
Usage: setup_os_x.sh <external interface> <wifi interface>

external-interface: The interface with which your Mac is
                    connected to the internet (e.g. "en0")
wifi-interface:     The interface used by your WLAN adapter
                    (e.g. "en5")

Check the interfaces with "ifconfig -a"
EOT
exit 1
fi

nat_rules=/tmp/nat_rules_$$.txt

sudo sysctl -w net.inet.ip.forwarding=0
sudo sysctl -w net.inet.ip.fw.enable=0

#echo "nat off ${1} from ${2} to any -> (${1})" >> ${nat_rules}
echo "nat off ${1}" >> ${nat_rules}

sudo pfctl -d #disables pfctl
sudo pfctl -F all #flushes all pfctl rules
sudo pfctl -f ${nat_rules} -e #starts pfctl and loads the rules from the nat-rules file

#rm ${nat_rules}
