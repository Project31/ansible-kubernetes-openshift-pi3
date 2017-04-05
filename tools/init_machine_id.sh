#!/bin/sh

ansible pis -k -u pirate -i ../hosts --become -m shell --args "dbus-uuidgen > /etc/machine-id"
