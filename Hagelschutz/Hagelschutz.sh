#!/bin/bash

while [ 0 -le 1 ]
do

curstate2=$curstate

url=https://meteo.netitservices.com/api/v0/devices/MAC_ADDRESS/poll?hwtypeId=ID

curstate=$(curl -sb -H "Accept: application/json" ${url} | cut -c 2-17)
echo $curstate

if [ "$curstate2" != "$curstate" ];then
echo -n "value=$curstate" >/dev/udp/192.168.20.2/7008
echo "The Hailstorm Value has Changed."
else
echo "The Hailstorm Value has not Changed."
fi

sleep 120

done
