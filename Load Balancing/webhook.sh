#!/bin/bash
now=$(date +'%Y-%m-%dT03')
dir_log="/home/lapdao/Downloads"
url="https://hooks.slack.com/services/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"
records=`grep "$now" $dir_log/orderbook-out.log | grep 'Imported to ES # records:\s*[0-9]\{1,9\}\s*of\s*day\s*' | wc -l`
result=`grep "$now" $dir_log/orderbook-out.log | grep 'Import data completed:*' | wc -l`
echo "$records, $result"
if [ $records -ge 1 ] && [ $result -ge 1 ];
then   
      
	records=`grep "$now" $dir_log/orderbook-out.log | grep 'Imported to ES # records:\s*[0-9]\{1,9\}\s*of\s*day\s*'`
	result=`grep "$now" $dir_log/orderbook-out.log | grep 'Import data completed:*'`
       	curl -X POST -H 'Content-type: application/json' --data '{"text":"'$records' '$result'"}' $url		
elif [ $records -eq 0 ] && [ $result -ge 1 ]
then

	records=`grep "$now" $dir_log/orderbook-out.log | grep 'Imported to ES # records:\s*[0-9]\{1,9\}\s*of\s*day\s*'`
	result=`grep "$now" $dir_log/orderbook-out.log | grep 'Import data completed:*'`
       	curl -X POST -H 'Content-type: application/json' --data '{"text":"Imported to ES # records: NOT FOUND IN LOG \n '"$result"' ==> Please check job!"}' $url		
elif [ $records -eq 1 ] && [ $result -ge 0 ]
then

	records=`grep "$now" $dir_log/orderbook-out.log | grep 'Imported to ES # records:\s*[0-9]\{1,9\}\s*of\s*day\s*'`
	result=`grep "$now" $dir_log/orderbook-out.log | grep 'Import data completed:*'`
       	curl -X POST -H 'Content-type: application/json' --data '{"text":"'"$records"'\n Import data completed: NOT FOUND IN LOG ==> Please check job!"}' $url		
else

	records=`grep "$now" $dir_log/orderbook-out.log | grep 'Imported to ES # records:\s*[0-9]\{1,9\}\s*of\s*day\s*'`
	result=`grep "$now" $dir_log/orderbook-out.log | grep 'Import data completed:*'`
       	curl -X POST -H 'Content-type: application/json' --data '{"text":"Imported to ES # records: NOT FOUND IN LOG \n Import data completed: NOT FOUND IN LOG ==> Please check job!"}' $url		
fi
