#!/bin/bash
keepalived=` ip addr show | grep inet | grep -c 'eth0\|eth1'`
if [ $keepalived == "2" ];     then
        arptables-restore < /etc/sysconfig/arptables
else
        arptables -F
fi
