#!/bin/bash

black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3); blue=$(tput setaf 4)
magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7); bold=$(tput bold); normal=$(tput sgr0)


if [[ $1 == ""  ]]; then
    echo; echo "${bold}${red}警告 ${white}你必须输入一个到BDISO的路径。如果路径里带空格的话还需要加上双引号${normal}"; echo
    exit 1
fi

bdisopath=`echo "$1"`
bdisopathlower=$(echo "$bdisopath" | sed 's/[Ii][Ss][Oo]/iso/g')
file_title=$(basename "$bdisopathlower" .iso)
file_title_clean="$(echo "$file_title" | tr '[:space:]' '.')"
file_title_clean="$(echo "$file_title_clean" | sed s'/[.]$//')"
file_title_clean="$(echo "$file_title_clean" | tr -d '(')"
file_title_clean="$(echo "$file_title_clean" | tr -d ')')"

mkdir -p "/etc/inexistence/06.BluRay/$file_title_clean"
bdpath="/etc/inexistence/06.BluRay/$file_title_clean"
mount -o loop "$bdisopath" "$bdpath"

