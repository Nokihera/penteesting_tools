#!/bin/bash
cat << "EOF"
 ___________________
 | _______________ |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 | |XXXXXXXXXXXXX| |
 |_________________|
     _[_______]_
 ___[___________]___
|         [_____] []|__
|         [_____] []|  \__
L___________________J     \ \___\/
 ___________________      /\
/###################\    (__)

EOF
video_path="/home/touchme/Videos/"
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
echo "***** Movie Downloader *****"
echo "Please paste your movie download link:"
read url
echo "Please type the name of the video:"
read name
if [[ $url == "" || $name == "" ]]; then 
    echo  -e "$RED You need to insert url and movie name !$NC"
    exit 1
fi
wget -c "$url" -O "$video_path$name.mp4" --show-progress
notify-send "Downloader" "Download finished: $name" --icon=video-x-generic
