#!/bin/sh
# Used for BDMV screenshots taken; more than one hour
# BDMV_Folder Resolution Output_Path

for c in {01..20}
    do
    i=`expr $i + 166`
    timestamp=`date -u -d @$i +%H:%M:%S`
    ffmpeg-bd -y -ss $timestamp -i bluray:"$1" -vframes 1 -s $2 "$3/Screenshot${c}.png" >> /dev/null 2>&1
    echo Writing $3/Screenshot$c.png from timestamp $timestamp
done
