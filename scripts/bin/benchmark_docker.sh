#!/usr/bin/env bash

logfile=docker-benchmark.txt
touch $logfile
for i in `seq 1 10`;
do
    (time docker run --rm --net=none alpine:latest echo 'hello') &>> $logfile
done
