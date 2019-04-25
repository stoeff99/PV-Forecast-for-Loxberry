#!/bin/bash

while [ 0 -le 1 ]
do

curstate2=$curstate

url=https://meteo.netitservices.com/api/v0/devices/MAC_ADDRESS/poll?hwtypeId=ID

curstate=$(curl -sb -H "Accept: application/json" ${url} | cut -c 2-17)
echo $curstate

if [ "$curstate2" != "$curstate" ];then
echo -n "value=$curstate" >/dev/udp/192.168.20.2/7008
fi

if [ "$curstate" = '"currentState":0' ] && [ "$curstate2" != '"currentState":0' ];then
echo -n "There is no Hail storm warning" >/dev/udp/192.168.20.2/7008
echo "There is no Hail storm warning"
fi
if [ "$curstate" != '"currentState":0' ];then
echo -n "Warning, there is a Hail storm warning" >/dev/udp/192.168.20.2/7008
echo "Warning, there is a Hail storm warning"
fi

sleep 120

done
