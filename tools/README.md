
## setup_nat_on_osx.sh

This is a small script for setting up NAT in order to let  an OS X machine forward traffic from the cluster. It expects
two arguments, the first is your external interface to the the internet (e.g. `en0`), the other the WiFi interface used to connect to the cluster.

The steps in details, shamelessly stolen from this [StackExchange answer](http://apple.stackexchange.com/a/192183):

* Enable IP forwarding:

        sudo sysctl -w net.inet.ip.forwarding=1
        sudo sysctl -w net.inet.ip.fw.enable=1

* Create a pfctl rule in a file `nat-rules` with (en0: Interface with your connected IP, en5: WiFi connected to WiFi route):

        nat on en0 from en5 to any -> (en0)

* Apply the rule:

        sudo pfctl -d #disables pfctl
        sudo pfctl -F all #flushes all pfctl rules
        sudo pfctl -f ./nat-rules -e #starts pfctl and loads the rules from the nat-rules file

* Ensure in your WiFi Router that the nodes get the OS-X's IP 192.168.23.100 as router (either via DHCP or in the static routing)

## Cleanup known_host

Use `cleanup_known_hosts.sh` for removing all keys and readding the new host keys to `~/.ssh/known_hoss`
 
