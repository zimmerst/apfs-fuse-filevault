#!/bin/bash

startdate=${1}
enddate=${2}
d=
n=0
until [ "$d" = "$enddate" ]
do  
    ((n++))
    d=$(date -d "$startdate + $n days" +%Y%m%d)
    d_en=${d}
    # german format: DD-MM-YYYY
    d_de=$(date -d "$startdate + $n days" +%d%m%Y)
    # change to $d_de in line below to switch output format from YYYY-MM-DD to DD-MM-YYYY
    echo $d_en
done