#!/bin/bash

i="0"

while [ $i -lt 10 ]; do

if echo `netstat -lnt4` | grep 27017; then
  i="10"
else
  i=$[$i+1]
  sleep 3s
fi

done

if echo `netstat -lnt4` | grep 27017; then
    mongo --eval "rs.initiate()"
else
    echo "server not listenning."
fi