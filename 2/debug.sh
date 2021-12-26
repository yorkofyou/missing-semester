#!/usr/bin/env bash
count=1

while true
do
    if ! ./script.sh 2> out.log ; then
        echo "failed after $count times"
        cat out.log
        break
    fi
    ((count++))

done

