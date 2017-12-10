#!/bin/bash
# Only used for 1080p BDMV screenshots

black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3); blue=$(tput setaf 4)
magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7); bold=$(tput bold); normal=$(tput sgr0)
mediapath=`echo "$1"`

if [[ "$mediapath" == "" ]]; then
    echo; echo "${red}${bold}WARNING${white} You must input the path to your file with double quotes"; echo
    exit 1
fi

if [[ -d "$mediapath" ]]; then
    echo; echo "${red}${bold}WARNING${white} You should input a video file, not a dictionary"; echo
    exit 1
fi

fenbianlv=`echo "$2"`
file_title=`basename "$mediapath"`
file_title_clean="$(echo "$file_title" | tr '[:space:]' '.')"
file_title_clean="$(echo "$file_title_clean" | sed s'/[.]$//')"
file_title_clean="$(echo "$file_title_clean" | tr -d '(')"
file_title_clean="$(echo "$file_title_clean" | tr -d ')')"

mkdir -p "/etc/inexistence/07.Screenshots"
outputpath="/etc/inexistence/07.Screenshots"

# 截图
for c in {01..10}
    do
    i=`expr $i + 66`
    timestamp=`date -u -d @$i +%H:%M:%S`
    ffmpeg -y -ss $timestamp -i "$mediapath" -vframes 1 -s $fenbianlv "${outputpath}/${file_title_clean}.scr${c}.png" >> /dev/null 2>&1
    echo "Writing ${cyan}${file_title_clean}.scr${c}.png${white} from timestamp ${cyan}${timestamp}${white}"
done

# mediainfo；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；；
mediainfo "$mediapath" > "${outputpath}/${file_title_clean}.mediainfo.txt"
sed -i '/${outputpath}\//'d "${outputpath}/${file_title_clean}.mediainfo.txt"
echo "Writing ${cyan}${file_title_clean}.mediainfo.txt${white} ..."

echo
echo -e "${bold}Done. The results are stored in ${yellow}\"${outputpath}\"${normal}"
echo
