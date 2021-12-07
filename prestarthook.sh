#!/bin/bash

continuecheck=10

sleep 5

if [ $1 == "booking" ];
then
    endpoint="http://acmeair.apps-crc.testing/booking/byuser/uid0@email.com"
    contenttype="Content-Type:application/x-www-form-urlencoded"
elif [ $1 == "customer" ];
then
    endpoint="http://acmeair.apps-crc.testing/customer/byid/uid0@email.com"
    contenttype="Content-Type:application/x-www-form-urlencoded"
elif [ $1 == "flight" ];
then
    endpoint="http://acmeair.apps-crc.testing/flight/queryflights"
    contenttype="Content-Type:application/x-www-form-urlencoded"
    data="fromAirport=SYD&toAirport=HKG&fromDate=Mon%20Dec%2006%202021%2000%3A00%3A00%20GMT%2B0000%20(Coordinated%20Universal%20Time)&returnDate=Mon%20Dec%2006%202021%2000%3A00%3A00%20GMT%2B0000%20(Coordinated%20Universal%20Time)&oneWay=true"
else
    exit 1
fi

cookie=$(curl 'http://acmeair.apps-crc.testing/auth/login' -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'login=uid0%40email.com&password=password' --silent --cookie-jar -)

while [ $continuecheck -ne 0 ]
do
    if [ $1 == "customer" ];
    then
        HTTP_CODE=$(curl --write-out "%{http_code}\n" -H "$contenttype" "$endpoint" --output /dev/null --silent --cookie <(echo "$cookie"))
    elif [ $1 == "flight" ];
    then
        HTTP_CODE=$(curl --write-out "%{http_code}\n" -H "$contenttype" --data "$data" "$endpoint" --output /dev/null --silent)
    elif [ $1 == "booking" ];
    then
        HTTP_CODE=$(curl --write-out "%{http_code}\n" -H "$contenttype" "$endpoint" --output /dev/null --silent --cookie <(echo "$cookie"))
    fi    
    
    echo $HTTP_CODE

    if [ $HTTP_CODE -eq 200 ];
    then
        continuecheck=$((continuecheck-1))
    fi
    
done

exit 0
