#!/bin/sh
yellow=$(tput setaf 3); cyan=$(tput setaf 6); normal=$(tput sgr0)
red=$(tput setaf 1); green=$(tput setaf 2); bold=$(tput bold)

${yellow}
cat /etc/inexistence/004.BDinfo/*
${normal}

echo "${cyan}Would you like to delete the output BDinfo report file?${normal} [${red}Y${normal}]es or [N]o: "; read responce
case $responce in
  [yY] | [yY][Ee][Ss] | "" ) delete=Yes ;;
  [nN] | [nN][Oo]) delete=No ;;
  *) delete=Yes ;;
esac
if [ $delete == "Yes" ]; then
  echo "${bold}The output BDinfo report file has been deleted${normal}"
  rm -rf /etc/inexistence/004.BDinfo/*
else 
  echo "${bold}You will need to delete the last output BDinfo report before run this script the next time${normal}"
fi