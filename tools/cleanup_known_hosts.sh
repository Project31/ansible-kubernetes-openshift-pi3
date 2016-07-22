#!/bin/sh

for i in 0 1 2 3
do
  echo "Cleaning up n${i}"
  ssh-keygen -R n${i}
  ssh-keygen -R 192.168.23.20${i}
  ssh-keyscan -H n${i} >> ~/.ssh/known_hosts
  ssh-keyscan -H 192.168.23.20${i} >> ~/.ssh/known_hosts
done
