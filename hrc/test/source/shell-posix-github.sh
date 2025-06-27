#!/bin/sh

# https://github.com/chpock/ck.colorer-schemes/issues/1

for i in `ls ./* 2>/dev/null`
do
    echo "$i"
done

# https://github.com/chpock/ck.colorer-schemes/issues/5

for i in ./*
do
    result=`touch ${i}`
done

# https://github.com/chpock/ck.colorer-schemes/issues/15

while read LINE; do
    echo "X-$LINE"
done \
    < /tmp/input \
    > /tmp/output

for VAR in 1 2 3 4; do
    echo "X-$VAR"
done \
    > /tmp/output
