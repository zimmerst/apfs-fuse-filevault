#!/bin/bash

startdate=${1}
enddate=${2}
d=
n=0
until [ "$d" = "$enddate" ]
do  
    ((n++))
    d=$(date -d "$startdate + $n days" +%Y%m%d)
    echo $d
done