#!/bin/sh
# Copyright (C) 2016 - Huyhyper ^o^

path="/opt/HyperScript/OTPSender"
sdate=`date +%Y-%m-%d`
cd $path
rm -f send.txt
touch send.txt

if [ ! -f $path/logs/$sdate.txt ]; then
    touch $path/logs/$sdate.txt
    chown logstash:logstash $path/logs/$sdate.txt
    chmod 777 $path/logs/$sdate.txt 
fi

if [ ! -f $path/logs/$sdate.temp ]; then
    touch $path/logs/$sdate.temp
fi

echo ""
new=`cat $path/logs/$sdate.txt | xargs -l echo | wc -l`
old=`cat $path/logs/$sdate.temp | wc -l`

if [ $new -gt $old ]; then
	diff $path/logs/$sdate.temp $path/logs/$sdate.txt | grep "Send access_code by email" > $path/send.txt
	cp -f $path/logs/$sdate.txt $path/logs/$sdate.temp
fi

if [ `cat $path/send.txt | wc -l` -gt 0 ]; then
	i=1
	sd=`cat send.txt | wc -l`
	sd=`expr $sd + 1`
	#for a in `cat send.txt | cut -d',' -f4`; do
		until [ $i -eq $sd ];do
			mail=`cat send.txt | head -n$i | tail -n1 | cut -d"," -f2 | cut -d'"' -f4`
			acode=`cat send.txt | head -n$i | tail -n1 | cut -d"," -f3 | cut -d'"' -f4`
			stime=`date +'%Y-%m-%d %H:%M:%S:%3N'`
			sh OTPSender.sh $acode $mail
			echo "$stime $mail" >> send_otp.log
			i=`expr $i + 1`
		done
	#done
fi
