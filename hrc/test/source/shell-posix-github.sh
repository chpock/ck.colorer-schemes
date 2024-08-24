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