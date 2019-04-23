#!/bin/bash

while [ 0 -le 1 ]
do

url=https://meteo.netitservices.com/api/v0/devices/MAC_ADDRESS/poll?hwtypeId=ID

curstate=$(curl -sb -H "Accept: application/json" ${url} | cut -c 2-17)
echo $curstate

if [ "$curstate" != '"currentState":0' ];then
echo -n "value=$curstate" >/dev/udp/192.168.20.2/7009
echo "Pull up the blinds! There is a hail storm approaching."
else
echo "There seems to be no Hail Storm"
fi

sleep 120

done

