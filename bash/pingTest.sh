#!/bin/bash

for ip in `echo {100..200}`
do
  ping 192.168.0."$ip" -c 3 > /dev/null
  host = 192.168.0."$ip"
  if [ $? -eq 0 ]; then
    echo "...........Host $host is up"
  else
    echo "...........Host $host is down"
  fi
done
