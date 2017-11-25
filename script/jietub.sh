#!/bin/sh
ffmpeg -ss $1 -y  -i $2 -s $3  -vframes 1 /etc/inexistence/003.Screenshots/Screenshots01.png
