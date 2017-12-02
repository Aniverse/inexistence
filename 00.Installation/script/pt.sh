#!/bin/sh
mktorrent -v -p -l 24 -a http://XXX/announce -o "/etc/BBQ/005.Torrents/$1.torrent" "$2"
