#!/bin/bash

black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3); blue=$(tput setaf 4)
magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7); bold=$(tput bold); normal=$(tput sgr0)

if [[ $1 == ""  ]]; then
    echo; echo "${bold}${red}警告 ${white}你必须输入一个路径。如果路径里带空格的话还需要加上双引号${normal}"; echo
    exit 1
fi

starttime=$(date +%s)
outputpath="/etc/inexistence/09.Torrents"
mkdir -p $outputpath

filepath=`echo "$1"`
file_title=$(basename "$filepath")
file_title_clean="$(echo "$file_title" | tr '[:space:]' '.')"
file_title_clean="$(echo "$file_title_clean" | sed s'/[.]$//')"
file_title_clean="$(echo "$file_title_clean" | tr -d '(')"
file_title_clean="$(echo "$file_title_clean" | tr -d ')')"

mktorrent -v -p -l 24 -a "" -o "${outputpath}/$file_title_clean.torrent" "$filepath"
if [ ! $? -eq 0 ];then exit 1; else

endtime=$(date +%s) 
timeused=$(( $endtime - $starttime ))

clear
echo -e "${bold}完成。生成的种子存放在 ${yellow}\"${outputpath}\"${normal}"
if [[ $timeused -gt 60 && $timeused -lt 3600 ]]; then
    timeusedmin=$(expr $timeused / 60)
    timeusedsec=$(expr $timeused % 60)
    echo -e "${bold}用时：${timeusedmin} min ${timeusedsec} sec${normal}"
elif [[ $timeused -ge 3600 ]]; then
    timeusedhour=$(expr $timeused / 3600)
    timeusedmin=$(expr $(expr $timeused % 3600) / 60)
    timeusedsec=$(expr $timeused % 60)
    echo -e "${bold}用时：${timeusedhour} hour ${timeusedmin} min ${timeusedsec} sec${normal}"
else
   echo -e "${bold}用时：${timeused} sec${normal}"
fi

echo

fi
