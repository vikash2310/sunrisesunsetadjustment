#!/bin/bash

# Called daily from /etc/cron.daily/sun-hours
while true; do

### "-q"= quiet, "-O-" pipe output
echo $(wget -q -O- https://www.timeanddate.com/sun/India/delhi | grep -oE 'Sunrise Today.{35}' | awk -F\> '{print $3}' | tr --delete "<") > /tmp/sunrise
echo $(wget -q -O- https://www.timeanddate.com/sun/India/delhi | grep -oE 'Sunset Today.{35}' | awk -F\> '{print $3}' | tr --delete "<") > /tmp/sunset

## If network is down files will have one byte size
size1=$(wc -c < /tmp/sunrise)
size2=$(wc -c < /tmp/sunset)

if [ $size1 -gt 1 ] && [ $size2 -gt 1 ] ; then
    cp /tmp/sunrise /usr/local/bin/sunrise
    cp /tmp/sunset  /usr/local/bin/sunset
    chmod 666 /usr/local/bin/sunrise
    chmod 666 /usr/local/bin/sunset
    rm /tmp/sunrise
    rm /tmp/sunset
    exit 0
else
    logger "/etc/cron.daily/sun-hours: Network is down. Waiting 5 minutes to try again."
    sleep 300
fi

done
