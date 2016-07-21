#!/bin/sh
# Wait for flannel starting up
sleep 2
while [ ! -f "/var/lib/flannel/subnet.env" ]
do
  sleep 1
done
